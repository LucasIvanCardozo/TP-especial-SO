# Resumen: Administración de Memoria en Zephyr OS

## 1. Contexto General

Zephyr OS es un RTOS diseñado para **microcontroladores (MCUs)** con recursos limitados: típicamente 8 KB a 512 KB de SRAM y hasta 2 MB de flash. A diferencia de Linux o Windows, Zephyr usa **MPU (Memory Protection Unit)** en lugar de MMU, priorizando la **protección** sobre la **virtualización** de memoria.

---

## 2. MPU vs MMU

### MPU (Memory Protection Unit)
- Presente en microcontroladores ARM Cortex-M y RISC-V embebido
- Define 8 a 16 regiones de memoria con permisos (R/W/X)
- **Sin traducción de direcciones**: dirección virtual = dirección física
- Hardware enforcement: accesos fuera de región generan excepciones

### MMU (Memory Management Unit)
- Presente en procesadores ARM Cortex-A, x86, RISC-V application-class
- Tablas de páginas que traducen direcciones virtuales a físicas
- Implementa memoria virtual, paginación, y aislamiento entre procesos

### ¿Por qué Zephyr usa MPU?
| Factor | MPU | MMU |
|--------|-----|-----|
| Hardware | Microcontroladores | Aplicaciones |
| Consumo energía | Muy bajo | Mayor |
| Costo | Incluido en MCU | Solo en SoCs costosos |
| Complejidad software | Baja | Alta |

Zephyr elige MPU porque para MCUs el costo, consumo de energía y determinismo temporal son críticos. No necesita ejecutar docenas de procesos con address spaces aislados, solo garantizar que un bug en una tarea no corrompa la memoria del kernel.

---

## 3. Regiones de Memoria en Zephyr

### 3.1 Región KERNEL (Modo Privilegiado)
Contiene el código del kernel de Zephyr ejecutándose en el nivel de privilegio más alto.

**Componentes**:
- `.text`: código ejecutable del kernel
- `.rodata`: datos de solo lectura (constantes)
- `.data/.bss`: variables globales
- Stack del sistema (interrupciones)

**Permisos MPU**:
- Kernel mode: lectura + escritura + ejecución
- User mode: solo lectura + ejecución (sin escritura)

### 3.2 Región APPLICATION (User Mode)
Aplicaciones que se ejecutan con privilegios restringidos, sin acceso directo a hardware ni memoria del kernel.

**Características**:
- Aislamiento por hardware mediante MPU
- **Memory Domains**: grupos de particiones que definen qué regiones puede acceder una aplicación
- **Stack protection**: páginas guard ("guard pages") detectan overflow del stack

### 3.3 Región DRAM / PERIFÉRICOS

**DRAM**: Memoria principal para heap, stacks, buffers.

**Periféricos**: Dispositivos de hardware (timers, UARTs, SPI, GPIO) accesibles vía memorias mapeadas.

**Atributos de memoria**:
| Tipo | Caché | Write Buffer |
|------|-------|--------------|
| Normal | RW | Yes |
| Device | None | No |

---

## 4. Asignación de Memoria en Zephyr

### 4.1 Heap (Asignación Dinámica)

**`k_heap`**: Allocator sincronizado multi-thread seguro. API: `k_heap_alloc()`, `k_heap_free()`.

**`sys_heap`**: Allocator de bajo nivel sin sincronización interna.
- Combina automáticamente bloques adyacentes libres (evita fragmentación externa)
- Usa buckets por tamaño (potencias de 2) para búsqueda eficiente
- **Tiempo determinístico O(1)**, entre 1-200 ciclos

**System Heap**: `k_malloc/k_free` — heap global configurado via `CONFIG_HEAP_MEM_POOL_SIZE`. Por defecto tamaño cero.

**`sys_multi_heap`**: Para sistemas con memorias no contiguas (bancos SRAM separados).

### 4.2 Memory Slabs (Bloques de Tamaño Fijo)

Allocator de bloques de tamaño idéntico predeterminado.

**Características**:
- Sin fragmentación (todos los bloques mismo tamaño)
- Asignación **O(1) determinística** (linked list de bloques libres)
- Uso típico: pools de objetos, buffers de comunicación entre threads

**API ejemplo**:
```c
K_MEM_SLAB_DEFINE(my_slab, 400, 6, 8);  // 6 bloques de 400 bytes, alineación 8
k_mem_slab_alloc(&my_slab, &block_ptr, K_MSEC(100));
k_mem_slab_free(&my_slab, block_ptr);
```

### 4.3 Memory Blocks
Abstracciones de más alto nivel: `k_stack`, `k_msgq`, `k_pipe`. Internamente usan heap o slabs.

---

## 5. User Mode y Kernel Mode

### Niveles de Privilegio
| Nivel | Contexto | Acceso |
|-------|----------|--------|
| Privileged | Kernel, drivers | Total a hardware y memoria |
| Unprivileged | Applications | Restringido por MPU |

En ARM Cortex-M, el bit `CONTROL.nPRIV` indica el nivel de privilegio. Los registros MPU solo son accesibles desde modo privilegiado.

### System Calls
Puente entre user mode y kernel mode. En Zephyr se implementan como **function calls directos** (no syscall como en x86), lo que reduce la latencia.

**Mecanismo**:
1. Thread de usuario llama función API wrapper
2. Wrapper verifica punteros y parámetros
3. Wrapper transfiere control a código del kernel
4. Kernel ejecuta la operación
5. Control retorna al thread de usuario

**Resource Pools**: Threads de user mode deben asignarse un resource pool para que ciertas APIs del kernel puedan allocar memoria internamente.

### Memory Domains y Partitions

**Memory Domain**: Colección de particiones que define qué memoria puede acceder un thread de user mode.

**Partition**: Región de memoria contigua con atributos específicos (lectura, escritura, ejecución).

**Particiones predefinidas**:
- `z_malloc_partition`: pool para malloc()
- `z_libc_partition`: variables globales de la C library

---

## 6. Memoria Virtual y Demand Paging

### Soporte Limitado

Zephyr soporta memoria virtual **solo en plataformas con MMU** (ARM Cortex-A, x86, RISC-V app-class). En la mayoría de MCUs **NO hay memoria virtual**.

### Single Address Space

Zephyr usa **un único espacio de direcciones virtuales** compartido por kernel y aplicaciones (a diferencia de Linux donde cada proceso tiene su propio address space).

**Mapeo 1:1 por defecto**: direcciones virtuales del kernel = direcciones físicas.

### Demand Paging (solo con MMU)

Mecanismo para ejecutar código/datos más grandes que la memoria física. Solo disponible con MMU y almacenamiento secundario.

**Funcionamiento**:
1. Page Hit → acceso normal a RAM
2. Page Fault → página no está en RAM:
   - Hardware genera excepción
   - SO verifica dirección válida
   - Si hay frames libres → cargar página desde backing store
   - Si no hay frames → invocar algoritmo de evict
   - Escribir víctima a backing store si está "dirty"
   - Cargar página nueva
   - Actualizar tablas de páginas
   - Reanudar ejecución

**Algoritmos de evict**: NRU (Not-Recently-Used) y LRU (Least-Recently-Used). LRU es recomendado para producción.

### Limitaciones en Sistemas Embebidos
- Generalmente no hay almacenamiento secundario persistente
- Espacio virtual no puede exceder significativamente la memoria física
- Paging más útil para datos que para código (código suele ejecutarse desde flash in-place)

---

## 7. ¿Por qué Zephyr No Tiene Memoria Virtual en la Mayoría de Configs?

**Factores de hardware**:
- MPU en lugar de MMU (microcontroladores más comunes no tienen MMU)
- Ausencia de almacenamiento secundario (código ejecuta desde flash directamente)
- Memoria limitada pero predecible

**Filosofía de diseño**:
- **Determinismo en tiempo real**: paging introduce latencias no determinísticas
- **Simplicidad**: evitar复杂度 de page tables, TLB, algoritmos de reemplazo
- **Costo/beneficio**: para un MCU con 64 KB ejecutando 3 tareas, la virtualización no aporta valor

**Single Address Space como alternativa**: en lugar de dar a cada proceso su propio address space, Zephyr usa memory domains para aislamiento, proporcionando protección suficiente sin la complejidad de paginación.

---

## 8. Thrashing: Por Qué No Ocurre en Zephyr

**Thrashing**: cuando hay más páginas activas que frames disponibles, y el sistema pasa más tiempo evacuando/cargando páginas que ejecutando trabajo útil.

**Por qué Zephyr no lo sufre**:
- Recursos definidos por hardware (RAM fija, conocida en tiempo de compilación)
- Ausencia de swapping a disco
- Diseño para que los recursos siempre sean adecuados para la carga de trabajo
- Si no caben, se reduce la carga o se usa más hardware

**Escenarios donde podría haber comportamiento similar**: si se habilita demand paging con backing store limitado, podrían haber page faults frecuentes, pero no "thrashing" clásico.

---

## 9. Glosario

| Término | Definición |
|---------|------------|
| **MPU** | Unidad de hardware que protege regiones de memoria. No traduce direcciones. Común en microcontroladores. |
| **MMU** | Unidad de hardware que traduce direcciones virtuales a físicas. Típica en procesadores de aplicación. |
| **Single Address Space** | Modelo donde kernel y aplicaciones comparten el mismo espacio de direcciones virtuales. |
| **Demand Paging** | Mecanismo donde las páginas se cargan en RAM solo cuando el CPU intenta acceder a ellas. |
| **Backing Store** | Almacenamiento secundario (flash, disco) donde residen páginas no residentes en RAM. |
| **Thrashing** | Degradación de performance por page faults excesivos. |
| **Page Fault** | Excepción cuando se intenta acceder a una página no presente en RAM. |
| **Eviction** | Algoritmo que selecciona qué página será evacuada (ejemplos: NRU, LRU). |
| **Memory Domain** | Colección de particiones que define el espacio accesible para un thread de user mode. |
| **Memory Partition** | Región de memoria contigua con atributos de acceso específicos. |
| **System Call** | Mecanismo para que código de usuario solicite operaciones al kernel. En Zephyr, function call eficiente. |
| **Resource Pool** | Heap asignado a un thread de user mode para sus system calls. |
| **Guard Page** | Página que causa excepción si se accede. Usada para detectar stack overflow. |
| **Memory Slab** | Allocator de bloques de tamaño fijo, O(1), sin fragmentación. |
| **sys_heap** | Implementación de heap de bajo nivel en Zephyr, sin sincronización. |
| **k_heap** | Allocator de heap sincronizado, seguro para multi-thread. |

---

## 10. Resumen de Conceptos vs Tema FSO

| Tema FSO | Concepto | Aplicación en Zephyr |
|----------|----------|---------------------|
| §4.1 | Múltiples procesos compiten por memoria | Múltiples threads compiten por SRAM. Heap, slabs, memory domains son mecanismos. |
| §4.4 | Paginación: páginas, frames, tabla de páginas | Con MMU: páginas de 4KB, mapeo 1:1. Con MPU: no hay paginación, solo regiones. |
| §4.5 | Segmentación | Zephyr NO usa segmentación. Single address space elimina la necesidad. |
| §4.6 | Fragmentación | sys_heap combina bloques adyacentes. Memory slabs eliminan fragmentación por diseño. |
| §5.1 | Memoria virtual | Solo con MMU + demand paging. Sin MMU, no hay memoria virtual. |
| §5.2 | Fallo de página | Zephyr con demand paging: page fault → verificar → evict → load → resume. |
| §5.3 | Algoritmos de reemplazo | NRU y LRU para evict de páginas. LRU recomendado para producción. |
| §5.6 | Thrashing | No ocurre en configs sin MMU. Recursos limitados por hardware. |
| §1.5 | Modo dual: usuario/kernel | Implementado vía MPU y bit de privilegio ARM. |

---

## Conclusión

La administración de memoria en Zephyr prioriza:
1. **Protección sobre virtualización**: MPU proporciona aislamiento sin overhead de MMU
2. **Determinismo**: sin paging dinámico, tiempos de acceso predecibles
3. **Simplicidad**: single address space elimina tablas de páginas por proceso
4. **Eficiencia**: syscalls son function calls, context switches rápidos

Esto demuestra que los conceptos de administración de memoria (heap, slabs, protección por hardware, memory domains) aplican incluso en sistemas extremadamente limitados, y que la teoría debe adaptarse al contexto de implementación.