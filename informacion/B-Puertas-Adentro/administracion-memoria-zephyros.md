# Administración de Memoria en Zephyr OS

> **Trabajo Práctico Especial — Fundamentos de Sistemas Operativos**
> Sección: "Puertas Adentro" — Sub-sección: Administración de Memoria de Zephyr OS

---

## 1. Heap Memory (Asignación Dinámica)

### 1.1 Concepto General

El **heap memory** en Zephyr OS es un mecanismo de asignación dinámica de memoria que permite a los threads reservar y liberar bloques de memoria en tiempo de ejecución, de manera similar a cómo funciona `malloc()`/`free()` en C estándar. Zephyr proporciona dos implementaciones principales:

- **Synchronized Heap Allocator (`k_heap`)**: Versión con sincronización integrada para uso multi-thread.
- **Low Level Heap Allocator (`sys_heap`)**: Versión sin sincronización para contextos donde el usuario maneja la exclusión mutua.

### 1.2 Synchronized Heap Allocator

El `k_heap` es la abstracción principal. Se define estáticamente con la macro `K_HEAP_DEFINE(name, size)` o se inicializa dinámicamente con `k_heap_init()`.

**Asignación de memoria:**
```c
void *ptr = k_heap_alloc(&my_heap, num_bytes, K_FOREVER);
```

El tercer parámetro es un timeout que indica cuánto tiempo el thread puede esperar si no hay memoria disponible. Puede ser `K_NO_WAIT`, `K_FOREVER` o un tiempo en milisegundos.

**Liberación de memoria:**
```c
k_heap_free(&my_heap, ptr);
```

### 1.3 Low Level Heap Allocator (`sys_heap`)

Internamente, `k_heap` está implementado sobre `sys_heap`. Esta implementación:

- Divide la memoria en "chunks" de 8 bytes.
- Utiliza **buckets por tamaño** (potencias de 2: 3-4 chunks, 5-8 chunks, 9-16 chunks, etc.) para encontrar rápidamente bloques disponibles.
- **Combina bloques adyacentes libres** automáticamente para evitar fragmentación.
- Todas las operaciones completan en **tiempo constante** (típicamente 1-200 ciclos).
- **No es sincronizada**: el usuario debe garantizar que solo un contexto esté usando el heap a la vez.

### 1.4 System Heap

El **system heap** es un heap predefinido accesible via `k_malloc()` y `k_free()`, similar a `malloc()`/`free()` de C. Se configura con `CONFIG_HEAP_MEM_POOL_SIZE`.

```c
char *buffer = k_malloc(200);
if (buffer != NULL) {
    memset(buffer, 0, 200);
    // ...
    k_free(buffer);
}
```

Por defecto tiene tamaño cero; debe configurarse explícitamente en Kconfig.

### 1.5 Multi-Heap Wrapper (`sys_multi_heap`)

Para sistemas con **memorias no contiguas** (por ejemplo, SRAM en diferentes banks, o regiones con diferentes attributes de caché), Zephyr提供 `sys_multi_heap`. Permite manejar múltiples `sys_heap` objects como un solo heap virtual.

```c
sys_multi_heap_init(&multi_heap, callback, callback_arg);
sys_multi_heap_add_heap(&multi_heap, &heap1);
sys_multi_heap_add_heap(&multi_heap, &heap2);
```

El callback de configuración decide de cuál heap allocate是根据 la dirección física u otros criterios.

---

## 2. Memory Slabs

### 2.1 ¿Qué es un Memory Slab?

Un **memory slab** es un allocator de bloques de tamaño fijo. A diferencia del heap (que puede asignar bloques de cualquier tamaño), los memory slabs asignan bloques **idénticos en tamaño**, lo que:

- Elimina la fragmentación.
- Proporciona **tiempo de asignación determinístico** (O(1)).
- Es más eficiente en memoria para patrones de uso predecibles.

### 2.2 Estructura Interna

Un memory slab mantiene un **linked list** de bloques libres. En plataformas de 32 bits, los primeros 4 bytes de cada bloque libre almacenan los punteros de link; en 64 bits, los primeros 8 bytes.

El buffer del slab es un **array de bloques de tamaño fijo**, sin desperdicio de espacio entre bloques.

### 2.3 API de Memory Slabs

**Definición:**
```c
// Versión estática
K_MEM_SLAB_DEFINE(my_slab, 400, 6, 8);

// Versión en memoria privada
K_MEM_SLAB_DEFINE_STATIC(my_slab, 400, 6, 8);
```

**Asignación y liberación:**
```c
char *block_ptr;
int ret = k_mem_slab_alloc(&my_slab, (void **)&block_ptr, K_MSEC(100));
if (ret == 0) {
    memset(block_ptr, 0, 400);
    // ...
    k_mem_slab_free(&my_slab, block_ptr);
}
```

### 2.4 ¿Para Qué Se Usa?

Los memory slabs son ideales para:

- **Paso de datos entre threads**: Evitar copiar datos grandes; en lugar de esto, se pasa un puntero al bloque.
- **Pools de objetos**: Cuando se crean y destruyen objetos del mismo tipo repetidamente.
- **Buffers de comunicación**: Colas de mensajes que necesitan buffers de tamaño fijo.

**Fuentes:**
- [Zephyr Documentation — Memory Heaps](https://docs.zephyrproject.org/latest/kernel/memory_management/heap.html)
- [Zephyr Documentation — Memory Slabs](https://docs.zephyrproject.org/latest/kernel/memory_management/slabs.html)

---

## 3. Demand Paging (Carga Bajo Demanda)

### 3.1 Concepto

**Demand paging** es un mecanismo que permite a Zephyr ejecutar código/datos más grandes que la memoria física disponible. Las páginas de datos solo se cargan en RAM cuando el procesador intenta acceder a ellas.

### 3.2 Terminología

- **Data Page**: Página de datos que puede estar en RAM o paginada fuera a storage.
- **Page Frame**: Región de memoria física del tamaño de una página (típicamente 4KB).
- **Backing Store**: Almacenamiento secundario (flash, external storage) donde se guardan las páginas no residentes.
- **K_MEM_SCRATCH_PAGE**: Página especial usada como buffer intermedio para operaciones de paging.

### 3.3 Funcionamiento

1. **Page Hit**: El procesador accede a una página que ya está en RAM → ejecución normal.
2. **Page Fault**: El procesador accede a una página que no está en RAM:
   - Si hay page frames libres → se carga la página desde backing store.
   - Si no hay page frames libres → se invoca el **algoritmo de evict**.
   - El algoritmo selecciona una página para expulsar (puede estar "dirty" → se escribe al backing store).
   - La página solicitada se carga en la page frame liberada.
   - Se actualizan las tablas de páginas y la ejecución continúa.

### 3.4 Algoritmos de Evicción

Zephyr proporciona dos algoritmos:

| Algoritmo | Descripción |
|---|---|
| **NRU (Not-Recently-Used)** | Simple, clasifica páginas por accessed/modified. |
| **LRU (Least-Recently-Used)** | Más complejo pero eficiente. Implementado con una cola ordenada. Recomendado para producción. |

### 3.5 Backing Store

El backing store es responsable de copiar páginas entre RAM y el almacenamiento secundario. Debe implementar:

- `k_mem_paging_backing_store_init()`: Inicialización.
- `k_mem_paging_backing_store_page_in()`: Cargar página desde storage.
- `k_mem_paging_backing_store_page_out()`: Guardar página a storage.

### 3.6 API de Paging Manual

Zephyr permite hacer paging manualmente:

```c
// Pre-cargar páginas anticipadamente (reduce page faults futuros)
k_mem_page_in(addr, size);

// Liberar páginas que no se necesitarán pronto
k_mem_page_out(addr, size);
```

### 3.7 Limitaciones en Sistemas Embebidos

Sin demand paging habilitado, el espacio virtual **no puede exceder** la memoria física. Demand paging extiende el uso de memoria a través de almacenamiento secundario.

**Fuentes:**
- [Zephyr Documentation — Demand Paging](https://docs.zephyrproject.org/latest/kernel/memory_management/demand_paging.html)

---

## 4. Virtual Memory (Memoria Virtual)

### 4.1 Soporte y Filosofía

Zephyr soporta **memoria virtual** en plataformas con **MMU (Memory Management Unit)**. Sin embargo, debido a que Zephyr está orientado a microcontroladores, el soporte difiere de los sistemas operativos de escritorio:

- **No hay paginación a disco por defecto**: El espacio virtual máximo iguala a la memoria física.
- **Single address space**: Todo el código (kernel + aplicaciones) comparte un único espacio de direcciones virtuales.
- **1:1 mapping por defecto**: El kernel se mapea directamente de virtual a físico.

### 4.2 Configuración Requerida (Kconfigs)

| Kconfig | Descripción |
|---|---|
| `CONFIG_MMU` | Habilita soporte de memoria virtual |
| `CONFIG_MMU_PAGE_SIZE` | Tamaño de página (default 4KB) |
| `CONFIG_KERNEL_VM_BASE` | Dirección base virtual del kernel |
| `CONFIG_KERNEL_VM_SIZE` | Tamaño del espacio virtual (default 8MB) |
| `CONFIG_KERNEL_VM_OFFSET` | Offset del kernel dentro del espacio virtual |

### 4.3 Mapa de Memoria Virtual

```
+------------------+ <- K_MEM_VIRT_RAM_START
| Undefined VM     |
+------------------+ <- K_MEM_KERNEL_VIRT_START
| Kernel Image     | <- .text (ro), .rodata (ro), .data/.bss (rw)
| (1:1 mapped)    |
+------------------+ <- K_MEM_VM_FREE_START
| Unused VM        | <- Disponible para k_mem_map()
| (crece hacia    |
| abajo)          |
|...              |
+------------------+ <- K_MEM_VIRT_RAM_END
```

### 4.4 Mapeo de Memoria en Boot

En boot, el sistema configura:

| Sección | Permisos | Modo de acceso |
|---|---|---|
| `.text` | Read-only, Executable | Kernel + User mode |
| `.rodata` | Read-only, Non-executable | Kernel + User mode |
| `.data`, `.bss`, `.noinit` | Read-write, Non-executable | Solo Kernel mode |

### 4.5 Mapeo de Memoria under Demand

Para mapeo under demanda, se usa `k_mem_map()`:

```c
void *vaddr = k_mem_map(size, alignment);
// Usa la memoria... 
k_mem_unmap(vaddr, size);
```

Las regiones mapeadas:
- Deben ser múltiplo del tamaño de página.
- No garantizan contigüidad física.
- Incluyen **guard pages** automáticamente antes y después para detectar overflow/underflow.

### 4.6 Limitaciones vs Sistemas Desktop

- **Sin-MMU platforms**: Virtual memory no está disponible; se depende de MPU.
- **Sin-secondary storage por defecto**: Demand paging debe estar explícitamente habilitado para usar almacenamiento secundario.
- **Single address space**: No hay protección de address space entre aplicaciones como en Linux/Windows.

**Fuentes:**
- [Zephyr Documentation — Virtual Memory](https://docs.zephyrproject.org/latest/kernel/memory_management/virtual_memory.html)

---

## 5. MPU-based Memory Protection (Protección de Memoria)

### 5.1 Arquitectura de Protección

Zephyr está diseñado para microcontroladores que típicamente tienen **MPU (Memory Protection Unit)** en lugar de MMU completo. La MPU permite:

- Definir regiones de memoria con permisos específicos.
- Generar excepciones cuando un thread intenta acceder a memoria no autorizada.
- Aislar threads y proteger memoria del kernel.

> **Nota**: En plataformas con MMU (como x86), este se configura de manera similar a una MPU con una page table identidad.

### 5.2 Configuración de Memoria en Boot

Después del boot, la MPU configura:

1. **Regiones de memoria por defecto del sistema**: Configuraciones especiales de caché/write-back para hardware y drivers.
2. **Regiones de texto y rodata**: Read-only, executable, accesible para user mode.
3. **Regiones read-write para user mode**: Para features como GCOV, HEP.

### 5.3 Stack Overflow Protection

`CONFIG_HW_STACK_PROTECTION` detecta overflow del stack del system (kernel mode). Cuando está habilitado, crea una región MPU "guard" read-only inmediatamente antes/después del stack buffer. Si el stack overflow, se genera una excepción.

> Esta feature es opcional y no detecta overflow de stacks individuales de thread. Para eso se usa `CONFIG_STACK_CANARIES`.

### 5.4 Thread Stack en User Mode

Cuando un thread corre en user mode:

- La MPU programa una región dedicada para el stack del thread.
- Si el thread excede su stack buffer → excepción de acceso.
- Por defecto, threads en el mismo memory domain pueden acceder a los stacks de otros threads. Arquitecturas que soportan `CONFIG_ARCH_MEM_DOMAIN_SUPPORTS_ISOLATED_STACKS` pueden restringir esto.

### 5.5 Memory Domains

Los **memory domains** son el mecanismo principal para controlar acceso a memoria desde user mode:

- Un domain es una **colección de memory partitions**.
- Cada **partition** es una región de memoria contigua con atributos de acceso.
- Threads de user mode automáticamente tienen acceso a su propio stack + texto + rodata.
- Los memory domains otorgan acceso a partitions adicionales.

**Creación de domain:**
```c
struct k_mem_domain app_domain;
k_mem_domain_init(&app_domain, 0, NULL);
```

**Agregar partitions:**
```c
uint8_t __aligned(32) buf[32];
K_MEM_PARTITION_DEFINE(app_part0, buf, sizeof(buf),
                       K_MEM_PARTITION_P_RW_U_RW);

k_mem_domain_add_partition(&app_domain, &app_part0);
```

**Asignar thread a domain:**
```c
k_mem_domain_add_thread(&app_domain, user_thread);
```

### 5.6 Partition Attributes

Los atributos de partition dependen de la arquitectura. Ejemplos comunes:

| Attribute | Descripción |
|---|---|
| `K_MEM_PARTITION_P_RW_U_RW` | Privileged R/W, User R/W |
| `K_MEM_PARTITION_P_RW_U_RO` | Privileged R/W, User R/O |
| `K_MEM_PARTITION_P_RO_U_RO` | Todo read-only |
| `K_MEM_PARTITION_P_RO_U_X` | Privileged R/O + Exec, User R/O + Exec |

### 5.7 Automatic Memory Partitions

Zephyr puede crear partitions automáticamente en build time:

```c
K_APPMEM_PARTITION_DEFINE(my_partition);

K_APP_DMEM(my_partition) int var1 = 37;       // Inicializada
K_APP_BMEM(my_partition) int var2;             // BSS (zeroed)
```

El build system coalesce todas las variables etiquetadas en una región contigua, maneja alineación y padding.

### 5.8 Pre-defined Partitions

Zephyr define partitions predefinidas:

- `z_malloc_partition`: Pool de memoria del sistema para libc malloc().
- `z_libc_partition`: Globals de la C library.

**Fuentes:**
- [Zephyr Documentation — Memory Protection Design](https://docs.zephyrproject.org/latest/kernel/usermode/memory_domain.html)

---

## 6. User Mode (Modo Usuario vs Kernel)

### 6.1 Concepto de User Mode en Zephyr

User mode es el contexto de ejecución donde las aplicaciones corren con **privilegios limitados**. El código del kernel corre en **kernel mode (supervisor mode)** con acceso irrestricto a hardware y recursos.

### 6.2 Características de User Mode

| Feature | Descripción |
|---|---|
| **Limited Access** | Threads acceden solo a memoria y hardware esencial. |
| **Isolation** | Threads fault o comprometidos no afectan al sistema ni a otros threads. |
| **Security** | Operaciones privilegiadas requieren syscall al kernel. |

### 6.3 Privileged vs Unprivileged Execution

- **Privileged (Kernel mode)**: Código con acceso total a hardware y memoria. El kernel corre en este modo.
- **Unprivileged (User mode)**: Código con acceso restringido. Las system calls son el único puente al kernel.

### 6.4 System Calls

Las **system calls** son el mecanismo para que user mode threads soliciten operaciones privilegiadas:

```c
// Ejemplo: syscall para allocate memoria
int z_vcpus_syscal(Z_VCPUS_CALL_OP_ALLOC, ...);
```

Las syscalls se implementan como **function calls** sin cambios de contexto, lo cual es eficiente pero requiere que el kernel verifique los parámetros.

### 6.5 Resource Pools

Algunos APIs de kernel requieren heap memory. Los threads de user mode deben asignarse un **resource pool**:

```c
k_thread_heap_assign(thread_id, &my_heap);
```

Las APIs que usan resource pools incluyen `k_stack_alloc_init()`, `k_msgq_alloc_init()`, `k_poll()`, `k_queue_alloc_prepend()`/`append()`, y `k_object_alloc()`.

### 6.6 Logical Apps

Con `CONFIG_USERSPACE=y`, Zephyr permite crear **"logical apps"**: colecciones de threads de user space agrupados bajo un mismo memory domain. Esto facilita la gestión estructurada y segura de funcionalidades.

Threads en diferentes logical apps están **aislados entre sí** (no pueden acceder a variables de otros memory domains). El kernel (threads privileged) puede acceder a todas las direcciones sin permisos explícitos.

### 6.7 Beneficios de User Mode

- **Robustez**: Un bug en una aplicación no crash al sistema completo.
- **Seguridad**: Accesos no autorizados a memoria generan excepciones.
- **Aislamiento**: Memoria de aplicaciones aislada por hardware (MPU/MMU).
- **Simplifica debugging**: Fallos contenidos y diagnosticables.

### 6.8 Limitaciones

- No todas las arquitecturas soportan user mode completo.
- Requiere configuración explícita (`CONFIG_USERSPACE`).
- El número de particiones de memoria está limitado por el número de regiones MPU disponibles.

**Fuentes:**
- [Zephyr Project — User mode explained in simple words](https://www.zephyrproject.org/user-mode-explained-in-simple-words/)
- [Zephyr Documentation — Memory Protection Design](https://docs.zephyrproject.org/latest/kernel/usermode/memory_domain.html)

---

## 7. Consideraciones de Diseño: Single Address Space

### 7.1 ¿Qué es el Single Address Space?

Zephyr utiliza un **único espacio de direcciones virtuales** para kernel y todas las aplicaciones. A diferencia de sistemas como Linux donde cada proceso tiene su propio address space, en Zephyr todo comparte el mismo mapa de memoria virtual.

### 7.2 Ventajas

| Ventaja | Descripción |
|---|---|
| **Comunicación eficiente** | Threads pueden compartir datos sin overhead de copy ni IPC. |
| **Simplicidad** | No hay tablas de páginas por proceso ni costo de context switch de MMU. |
| **Menor overhead** | La syscall es simplemente un function call (no cambio de address space). |
| **Mayor velocidad** | Cambios de contexto más rápidos entre kernel y user mode. |

### 7.3 Desafíos y Soluciones

**Desafío: Aislamiento entre aplicaciones**
- **Solución**: Memory domains + MPU. Aunque compartan el address space, las particiones MPU impiden accesos no autorizados.

**Desafío: Seguridad entre threads**
- **Solución**: User mode con MPU. Thread que intenta acceder fuera de sus regiones permitidas genera excepción.

**Desafío: Fragmentación del address space**
- **Solución**: El espacio virtual se gestiona como un heap. `k_mem_map()` allocate regiones bajo demanda con guard pages.

### 7.4 Relación con Demand Paging

En un single address space con demand paging habilitado, el espacio virtual puede ser **mayor que la memoria física**. Las páginas no utilizadas se mantienen en backing store (flash, external storage), permitiendo ejecutar código más grande que la RAM disponible.

### 7.5 Comparación con Otros RTOS

| Característica | **Zephyr** | **FreeRTOS** | **NuttX** |
|---|---|---|---|
| Single Address Space | Sí | No (kernel separado) | Parcial (平坦) |
| User/Kernel Mode | Sí (MPU/MMU) | No | Sí (MMU) |
| Memory Domains | Sí | No | Sí |

### 7.6 Implicaciones para el Diseñador de Sistemas

Al diseñar un sistema sobre Zephyr:

1. **Planificar memory domains** si se necesita aislamiento entre componentes.
2. **Usar memory slabs** para buffers de tamaño fijo (más eficiente que heap).
3. **Configurar resource pools** por aplicación para evitar starvation.
4. **Considerar demand paging** si el código total excede la RAM disponible.
5. **Usar MPU regions cuidadosamente** — número limitado (típicamente 8-16).

**Fuentes:**
- [Zephyr OS — Investigación General](./investigacion.md)
- [Zephyr Documentation — Memory Management](https://docs.zephyrproject.org/latest/kernel/memory_management/index.html)

---

## 8. Resumen de Fuentes

| Tema | Fuente Principal |
|---|---|
| Heap Memory | [Zephyr Documentation — Memory Heaps](https://docs.zephyrproject.org/latest/kernel/memory_management/heap.html) |
| Memory Slabs | [Zephyr Documentation — Memory Slabs](https://docs.zephyrproject.org/latest/kernel/memory_management/slabs.html) |
| Demand Paging | [Zephyr Documentation — Demand Paging](https://docs.zephyrproject.org/latest/kernel/memory_management/demand_paging.html) |
| Virtual Memory | [Zephyr Documentation — Virtual Memory](https://docs.zephyrproject.org/latest/kernel/memory_management/virtual_memory.html) |
| Memory Protection | [Zephyr Documentation — Memory Protection Design](https://docs.zephyrproject.org/latest/kernel/usermode/memory_domain.html) |
| User Mode | [Zephyr Project Blog — User mode explained](https://www.zephyrproject.org/user-mode-explained-in-simple-words/) |

---

*Documento preparado para el Trabajo Práctico Especial de Fundamentos de Sistemas Operativos.*
*Última actualización: Mayo 2026.*

---
## Nota Académica — Fundamentos de SO

**Conceptos de la materia relacionados:**

- **§5.1 Memoria virtual y §5.2 Falla de página**: Zephyr implementa demand paging donde las páginas se cargan desde backing store solo cuando el CPU intenta acceder a ellas. Cuando una página no está en RAM, ocurre un page fault que activa el algoritmo de evict (LRU o NRU) para liberar un frame antes de cargar la página solicitada — exactamente los pasos descritos en §5.2.

- **§5.3 Algoritmos de reemplazo**: Zephyr soporta dos algoritmos de reemplazo de páginas: NRU (Not-Recently-Used) y LRU (Least-Recently-Used). El documento especifica que LRU usa "una cola ordenada" y es el recomendado para producción — alineado con el estudio de algoritmos de reemplazo en §5.3.

- **§4.4 Paginación**: Zephyr usa páginas de 4KB (CONFIG_MMU_PAGE_SIZE) con mapeo 1:1 entre memoria virtual y física por defecto. La tabla de páginas mapea páginas→frames y el documento muestra el mapa de memoria virtual con regiones de kernel y espacio libre para k_mem_map().

- **§4.5 Segmentación**: Zephyr NO usa segmentación. Utiliza un único "single address space" donde kernel y aplicaciones comparten el mismo espacio de direcciones virtuales, sin segmentos de tamaño variable con base/límite.

- **Memory Slabs (§4 concepto general de administración)**: Los memory slabs asignan bloques de tamaño fijo (definido en tiempo de compilación), eliminando fragmentación interna y proporcionando tiempo de asignación O(1) determinístico. Es similar en concepto a las particiones fijas (§4.2 MFT) pero a nivel de allocator dentro de un sistema queotherwise usa paging.

- **§4.6 Fragmentación**: El sys_heap combina bloques adyacentes libres automáticamente ("combines free adjacent blocks") para evitar fragmentación externa, mientras que los memory slabs eliminan fragmentación por diseño al usar bloques idénticos.

- **§4.1 Administración de memoria**: Zephyr proporciona múltiples mecanismos (heap dinámico, slabs, memory domains, MPU) donde múltiples threads compiten por memoria limitada con políticas de asignación configurables.

- **§5.6 Thrashing**: El demand paging en Zephyr permite que el espacio virtual exceda la memoria física — cuando hay más páginas que frames disponibles, el sistema entra en competencia por frames, concepto análogo al thrashing pero en sistemas embebidos con backing store limitado.
