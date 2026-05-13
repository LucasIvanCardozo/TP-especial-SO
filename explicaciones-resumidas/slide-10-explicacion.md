# Resumen: Administración de Memoria en MOSIX

## Concepto Central

MOSIX implementa un modelo de memoria **shared-nothing** (nada compartido): cada nodo tiene su propia memoria física independiente y la gestiona de forma autónoma. **No existe memoria compartida entre nodos**. Cuando un nodo se queda sin memoria, no hace swapping a disco sino que **migra procesos completos** a otros nodos con memoria disponible. Esto se llama **Memory Ushering**.

---

## 1. Modelo Shared-Nothing

Cada nodo MOSIX:
- Ejecuta su propia instancia de Linux
- Tiene sus propias tablas de páginas locales
- Administra su memoria con el gestor nativo de Linux
- Se comunica con otros nodos mediante mensajes por red

**Relación con NUMA**: En NUMA hay un único espacio de direcciones compartido con latencias variables. En MOSIX hay múltiples espacios de direcciones completamente independientes.

| Característica | MOSIX | NUMA |
|----------------|-------|------|
| Espacio de direcciones | Múltiples aislacos | Único compartido |
| Acceso remoto | Migración de procesos | Acceso directo (más lento) |
| Coherencia de caché | No necesaria | Necesaria |

---

## 2. Memory Ushering

Es el algoritmo central de MOSIX para administrar memoria distribuida.

**Propósito**: Cuando un nodo agota su memoria, puede usar la memoria libre de otros nodos migrando procesos en lugar de hacer swapping a disco.

**Diferencia clave con paging tradicional**:
- Paging tradicional: reacciona cuando ya hay contención (fallo de página → buscar frame libre → evictar página)
- Memory Ushering: previene la situación **antes de que ocurra** — detecta proactivamente nodos con memoria baja y migra procesos

**El nombre "ushering"** viene de "acompañar/guiar": el sistema guía proactivamente los procesos hacia nodos con recursos disponibles.

### Pasos del algoritmo:

1. **Detección**: El sistema monitorea la memoria libre de cada nodo mediante umbrales críticos
2. **Identificación**: Cuando la memoria libre está bajo el umbral, busca nodos con memoria disponible
3. **Selección**: Se elige qué proceso migrar (procesos completos, no páginas individuales)
4. **Transferencia**: El proceso entero (heap, stack, código, datos) se transfiere por red
5. **Continuación**: El proceso sigue ejecutándose en el nodo destino de forma transparente

### Características importantes:

- **Transparente**: La aplicación no necesita ser modificada ni recompilada
- **Integrado con balanceo de CPU**: Ambos mecanismos pueden actuar simultáneamente
- **Útil cuando**: La memoria no se usa de manera uniforme entre nodos, o cuando un proceso es tan grande que no cabe en un solo nodo pero podría ejecutarse combinando memorias de varios nodos

---

## 3. Tabla de Páginas Distribuida

- Cada nodo mantiene su propia tabla de páginas local (virtual → físico dentro de ese nodo)
- No existe una tabla global para todo el cluster
- Cuando un proceso migra, su tabla de páginas se actualiza para reflejar el nuevo nodo
- Las direcciones virtuales del proceso no cambian — solo la traducción a físicas ocurre en otro nodo

**Comparación con memoria virtual tradicional (§5.1)**:

| Aspecto | SO tradicional | MOSIX |
|---------|---------------|-------|
| Ilusión de más memoria | Paging a disco | Migración de procesos |
| Tabla de páginas | Una por proceso | Una por proceso, por nodo |
| Fallo de página | Cargar página de disco | Migrar proceso a otro nodo |
| Frame libre | Buscado en memoria local | Buscado en cualquier nodo |

---

## 4. Checkpoint/Restart

Mecanismo para guardar y restaurar el estado completo de un proceso.

**Durante el checkpoint (guardado)**:
1. Suspender el proceso de forma controlada
2. Serializar todo el espacio de memoria (heap, stack, datos, código)
3. Guardar registros del CPU, contador de programa, estado de threads
4. Manejar archivos abiertos mediante DFSA
5. Generar una imagen ejecutable con todo lo necesario para reiniciar

**Durante el restart (restauración)**:
1. Leer la imagen de checkpoint
2. Recrear el espacio de direcciones en el nodo destino
3. Cargar registros y contador de programa
4. Reanudar la ejecución como si nunca se hubiera detenido

**Relación con PCB (§2.3)**: El checkpoint captura todo lo que hay en un PCB (PID, estado, PC, registros, información de scheduling, descriptores de archivos, accounting) **más** la imagen completa de memoria del proceso.

**Uso principal**: Migración de procesos y tolerancia a fallos. Si la migración falla, el proceso puede restaurarse desde el checkpoint en su nodo original.

---

## 5. Limitaciones de MOSIX

### Sin memoria compartida entre procesos
- No soporta POSIX shared memory (`shm_open`)
- No soporta memoria compartida System V (`shmget`, `shmat`)
- No tiene DSM (Distributed Shared Memory) integrada
- Aplicaciones que necesitan shared memory deben reimplementarse con MPI o sockets

### Aislamiento total por nodo
- Cada nodo funciona como sistema independiente
- Procesos que necesitan comunicarse entre nodos deben usar red explícita
- Un proceso en nodo A no puede acceder a la memoria de nodo B

### Overhead de red en migraciones grandes
- Procesos grandes (gigabytes de RAM) pueden tomar minutos para migrar
- Durante el handover hay tiempo de inactividad
- La efectividad depende del ancho de banda del cluster

### Relación con conceptos FSO:
- **Fragmentación (§4.6)**: Ocurre a nivel de cada nodo individual, no hay memoria compartida entre nodos que se fragmente
- **Compactación (§4.7)**: No necesaria — la migración de procesos no compacta memoria, solo relocaliza procesos completos
- **Thrashing (§5.6)**: Memory Ushering es la respuesta al thrashing — detecta proactivamente nodos con memoria baja y migra **antes** de que ocurra contención severa

---

## 6. Comparación: MOSIX vs Zephyr

| Aspecto | Zephyr | MOSIX |
|---------|--------|-------|
| Tipo de sistema | RTOS para microcontroladores | SO para clusters de PCs/servidores |
| Gestión de memoria | MPU estática, regiones fijas | Memoria virtual con migración proactiva |
| Memoria compartida | Limitada (regiones MPU) | No existe (shared-nothing) |
| Paginación | No existe | No existe (migración a nivel de proceso) |
| Dynamicidad | Estática (tiempo de compilación) | Dinámica (tiempo de ejecución) |
| Swap | No hay | No hay (migración de procesos) |
| Escala | Un solo núcleo/CPU | Cluster con múltiples nodos |

**Zephyr**: Memoria estática con MPU que divide en regiones fijas predefinidas en tiempo de compilación. Sin paginación, sin swap, sin migración.

**MOSIX**: Memoria virtual distribuida donde el "swap" es la migración de procesos completos a otros nodos. Modelo shared-nothing con comunicación por red.

---

## 7. Memory Ushering vs Algoritmos de Reemplazo de Páginas (§5.3)

| Etapa | Algoritmo tradicional | Memory Ushering |
|-------|----------------------|-----------------|
| Detección de presión | Page fault ocurre | Umbral de memoria local |
| Selección de víctima | Página menos usada | Proceso con mucha memoria |
| Reubicación | Página a disco | Proceso a otro nodo |
| Reemplazo real | Escritura a swap | Transferencia por red |

Memory Ushering es conceptualmente un algoritmo de reemplazo pero a nivel de **procesos**, no de páginas. Es un "process eviction" en vez de "page eviction".

---

## Glosario

- **Memory Ushering**: Algoritmo de migración proactiva que transfiere procesos completos cuando un nodo tiene presión de memoria, evitando el swapping a disco.
- **Checkpoint/Restart**: Serialización del estado completo de un proceso (memoria, registros, archivos) para poder guardarlo y restaurarlo después.
- **Shared-Nothing**: Modelo donde cada nodo tiene memoria físicamente independiente y no comparte estructuras con otros nodos.
- **DFSA (Direct File System Access)**: Permite que un proceso migrado siga accediendo a archivos del nodo original sin copiar todo el estado del sistema de archivos.
- **OOM (Out of Memory)**: Condición donde un nodo no tiene suficiente memoria. En MOSIX dispara la búsqueda de nodos con memoria disponible.
- **Working Set**: Conjunto de páginas que un proceso usa activamente. En MOSIX equivalente a la "huella de memoria" del proceso que se transfiere durante la migración.

---

## Resumen Técnico

La administración de memoria en MOSIX se basa en:
- **Modelo shared-nothing**: cada nodo es independiente con su propia memoria física
- **Memory Ushering**: detecta proactivamente presión de memoria y migra procesos completos a nodos con recursos disponibles
- **Distributed Page Table**: cada nodo mantiene sus propias tablas de páginas; cuando un proceso migra, su tabla se actualiza
- **Checkpoint/Restart**: serializa el estado completo del proceso para migración y tolerancia a fallos

**Limitaciones principales**: Sin memoria compartida nativa (requiere MPI/sockets), overhead de red en migraciones grandes, dependencia del ancho de banda del cluster.