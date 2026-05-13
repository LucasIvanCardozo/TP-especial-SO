# 5. Administración de Memoria

La gestión de memoria en Zephyr OS y MOSIX refleja filosofías opuestas: mientras Zephyr está diseñado para microcontroladores con recursos extremadamente limitados, MOSIX administra memoria distribuida en clusters de PCs. Esta diferencia fundamental determina las estrategias y mecanismos que cada sistema emplea.

---

## Zephyr OS

### MPU vs MMU: Protección sin Virtualización

Zephyr OS utiliza **MPU (Memory Protection Unit)** en lugar de MMU para la mayoría de sus plataformas. Esta decisión es fundamental para entender su modelo de memoria.

La **MPU** es hardware presente en microcontroladores ARM Cortex-M y RISC-V embebido que define entre 8 y 16 regiones de memoria con permisos separados de lectura, escritura y ejecución. A diferencia de una MMU, **no traduce direcciones**: la dirección virtual coincide con la dirección física. Cada acceso a memoria es verificado por hardware contra las regiones configuradas; si un acceso cae fuera de una región permitida, se genera una excepción.

La **MMU** (presente en procesadores ARM Cortex-A, x86, y RISC-V de aplicación) utiliza tablas de páginas para traducir direcciones virtuales a físicas, implementando memoria virtual, paginación y aislamiento completo entre procesos. En Zephyr, solo las plataformas con MMU soportan paginación y memoria virtual; en las más comunes (microcontroladores), no hay MMU y por lo tanto no hay memoria virtual.

| Factor | MPU | MMU |
|--------|-----|-----|
| Hardware típico | Microcontroladores | Procesadores de aplicación |
| Consumo de energía | Muy bajo | Mayor |
| Traducción de direcciones | No | Sí |
| Complejidad de software | Baja | Alta |

**¿Por qué Zephyr elige MPU?** Para microcontroladores, el costo, consumo de energía y determinismo temporal son críticos. No necesitan ejecutar decenas de procesos con espacios de direcciones aislados: solo requieren garantizar que un bug en una tarea no corrompa la memoria del kernel.

### Modelo de Memoria Plana

Zephyr utiliza un **Single Address Space**: el kernel y todas las aplicaciones comparten el mismo espacio de direcciones virtuales. No hay paginación por proceso como en Linux. El mapeo es 1:1 por defecto (direcciones virtuales del kernel = direcciones físicas).

Para el aislamiento, Zephyr implementa **Memory Domains** y **Partitions**. Un Memory Domain es una colección de particiones que define qué memoria puede acceder un thread de user mode. Cada Partition es una región de memoria contigua con atributos específicos. Esto proporciona protección suficiente sin la complejidad de tablas de páginas por proceso.

### Regiones de Memoria

Zephyr organiza la memoria en regiones configuradas estáticamente:

- **Región KERNEL (Modo Privilegiado)**: contiene el código del kernel en el nivel de privilegio más alto. Incluye `.text` (código ejecutable), `.rodata` (datos de solo lectura), `.data/.bss` (variables globales), y el stack del sistema para interrupciones. En kernel mode tiene permisos de lectura + escritura + ejecución; en user mode, solo lectura + ejecución.

- **Región APPLICATION (User Mode)**: aplicaciones que se ejecutan con privilegios restringidos. El hardware MPU proporciona aislamiento, y las "guard pages" detectan overflow del stack.

- **Región DRAM/PERIFÉRICOS**: la memoria principal para heap, stacks y buffers, y los dispositivos de hardware mapeados a memoria (timers, UARTs, SPI, GPIO). Los atributos de memoria distinguen entre tipo Normal (con caché y write buffer) y tipo Device (sin caché, sin write buffer).

### Asignación de Memoria

Zephyr proporciona múltiples mecanismos de asignación:

**Heap (k_heap y sys_heap)**: El `k_heap` es un allocator sincronizado y seguro para multi-thread. El `sys_heap` es de bajo nivel sin sincronización, combina automáticamente bloques adyacentes libres para evitar fragmentación externa, y utiliza buckets por tamaño (potencias de dos) para búsqueda eficiente con tiempo determinístico O(1) de entre 1 y 200 ciclos.

**Memory Slabs**: allocator de bloques de tamaño fijo idéntico predeterminado. Sin fragmentación (todos los bloques del mismo tamaño) y asignación O(1) determinística mediante linked list de bloques libres. Uso típico: pools de objetos y buffers de comunicación entre threads.

**System Heap**: `k_malloc/k_free` — heap global configurable via `CONFIG_HEAP_MEM_POOL_SIZE`. Por defecto tiene tamaño cero.

### Sin Swap ni Thrashing

Zephyr **no tiene swap ni memoria virtual** en el sentido clásico (sin MMU). Los recursos están definidos por hardware y conocidos en tiempo de compilación. Si los recursos no son suficientes, se reduce la carga de trabajo o se usa más hardware; no hay swapping a disco porque generalmente no hay almacenamiento secundario persistente en microcontroladores.

El **thrashing** no ocurre porque no hay paging dinámico: los recursos siempre son adecuados para la carga de trabajo diseñada. Si se habilita demand paging con MMU, podrían haber page faults, pero no thrashing clásico.

---

## MOSIX

### Modelo Shared-Nothing

MOSIX implementa un modelo de memoria **shared-nothing**: cada nodo tiene su propia memoria física independiente y la gestiona de forma autónoma. **No existe memoria compartida entre nodos**. Cuando un nodo se queda sin memoria, no hace swapping a disco sino que **migra procesos completos** a otros nodos con memoria disponible.

Cada nodo ejecuta su propia instancia de Linux, mantiene sus propias tablas de páginas locales (virtual → físico dentro de ese nodo), y se comunica con otros nodos mediante mensajes por red. No existe una tabla de páginas global para todo el cluster.

La diferencia con NUMA es conceptual: mientras NUMA tiene un único espacio de direcciones compartido con latencias variables, MOSIX tiene múltiples espacios de direcciones completamente independientes. En NUMA, el acceso remoto es más lento pero directo; en MOSIX, el acceso remoto requiere migración de procesos.

### Memory Ushering

Es el algoritmo central de MOSIX para administrar memoria distribuida. Cuando un nodo agota su memoria, puede usar la memoria libre de otros nodos migrando procesos en lugar de hacer swapping a disco.

A diferencia del paging tradicional que reacciona cuando ya hay contención (fallo de página → buscar frame libre → evictar página), **Memory Ushering previene la situación antes de que ocurra**. Detecta proactivamente nodos con memoria baja y migra procesos antes de que ocurra contención severa.

El algoritmo funciona así:

1. **Detección**: el sistema monitorea la memoria libre de cada nodo mediante umbrales críticos
2. **Identificación**: cuando la memoria libre está bajo el umbral, busca nodos con memoria disponible
3. **Selección**: se elige qué proceso migrar (procesos completos, no páginas individuales)
4. **Transferencia**: el proceso entero (heap, stack, código, datos) se transfiere por red
5. **Continuación**: el proceso sigue ejecutándose en el nodo destino de forma transparente

El nombre "ushering" viene de "acompañar/guiar": el sistema guía proactivamente los procesos hacia nodos con recursos disponibles. Es conceptualmente un algoritmo de reemplazo pero a nivel de **procesos**, no de páginas — un "process eviction" en vez de "page eviction".

### Tabla de Páginas Distribuida

Cada nodo mantiene su propia tabla de páginas local. Cuando un proceso migra, su tabla de páginas se actualiza para reflejar el nuevo nodo. Las direcciones virtuales del proceso no cambian; solo la traducción a físicas ocurre en otro nodo.

| Aspecto | SO tradicional | MOSIX |
|---------|---------------|-------|
| Ilusión de más memoria | Paging a disco | Migración de procesos |
| Tabla de páginas | Una por proceso | Una por proceso, por nodo |
| Fallo de página | Cargar página de disco | Migrar proceso a otro nodo |
| Frame libre | Buscado en memoria local | Buscado en cualquier nodo |

### Checkpoint/Restart

Es el mecanismo para guardar y restaurar el estado completo de un proceso durante la migración:

1. **Checkpoint (guardado)**: se suspende el proceso de forma controlada, se serializa todo el espacio de memoria (heap, stack, datos, código), se guardan registros del CPU, contador de programa, estado de threads, y se manejan archivos abiertos mediante DFSA (Direct File System Access) que permite que un proceso migrado siga accediendo a archivos del nodo original sin copiar todo el estado del sistema de archivos.

2. **Restart (restauración)**: se lee la imagen de checkpoint, se recrea el espacio de direcciones en el nodo destino, se cargan registros y contador de programa, y se reanuda la ejecución como si nunca se hubiera detenido.

El checkpoint captura todo lo que hay en un PCB (PID, estado, PC, registros, información de scheduling, descriptores de archivos, accounting) **más** la imagen completa de memoria del proceso.

### Limitaciones

MOSIX no soporta memoria compartida entre procesos (ni POSIX shared memory con `shm_open`, ni memoria compartida System V con `shmget`, `shmat`). No tiene DSM (Distributed Shared Memory) integrada, por lo que aplicaciones que necesitan shared memory deben reimplementarse con MPI o sockets.

El aislamiento total por nodo significa que cada nodo funciona como sistema independiente: un proceso en nodo A no puede acceder a la memoria de nodo B. Procesos grandes (gigabytes de RAM) pueden tomar minutos para migrar, y durante el handover hay tiempo de inactividad. La efectividad depende del ancho de banda del cluster.

---

## Comparación

| Aspecto | Zephyr OS | MOSIX |
|---------|------------|-------|
| Tipo de hardware | Microcontroladores | Clusters de PCs/servidores |
| Mecanismo de protección | MPU (regiones fijas) | Aislamiento por nodo independiente |
| Memoria virtual | Solo con MMU en plataformas avanzadas | No tiene (migración de procesos) |
| Modelo de memoria | Single address space | Shared-nothing |
| Swap | No hay | No hay (migración de procesos) |
| Dynamicidad | Estática (tiempo de compilación) | Dinámica (tiempo de ejecución) |
| Fragmentación | sys_heap combina bloques adyacentes | Ocurre a nivel de cada nodo individual |
| Thrashing | No ocurre (recursos definidos en compilación) | Memory Ushering previene activamente |

Zephyr: memoria estática con MPU que divide en regiones fijas predefinidas en tiempo de compilación. Sin paginación, sin swap, sin migración.

MOSIX: memoria virtual distribuida donde el "swap" es la migración de procesos completos a otros nodos. Modelo shared-nothing con comunicación por red.

---

# 6. Administración del Procesador

La administración del procesador en ambos sistemas refleja sus objetivos arquitectónicos: Zephyr optimiza para determinismo y latencia mínima en sistemas embebidos de tiempo real, mientras que MOSIX optimiza para throughput global y utilización eficiente de recursos en clusters.

---

## Zephyr OS

### Threads como Unidad de Scheduling

En Zephyr, la unidad de scheduling es el **thread** (no proceso pesado). Cada thread tiene su propio stack y contexto, pero comparte el espacio de direcciones con el kernel y otros threads.

El `k_thread` es el equivalente simplificado del PCB clásico. Contiene stack pointer (salvado de SP/PC en context switch), prioridad, estado (READY, RUNNING, SLEEPING, TERMINATED, SUSPENDED), y área de stack propia. Sin paginación ni memoria virtual completa, pero cumpliendo la misma función.

### Estados de Thread

Zephyr implementa 5 estados equivalentes a la teoría de SO:

- **READY**: listo para ejecutar, esperando en run queue (equivale a LISTO)
- **RUNNING**: ejecutándose en CPU (equivale a EJECUTANDO)
- **SLEEPING**: bloqueado esperando evento como E/S o timer (equivale a BLOQUEADO)
- **TERMINATED**: finalizó su ejecución
- **SUSPENDED**: pausado temporalmente por otro thread

Las transiciones principales son: READY → RUNNING cuando el scheduler elige el thread de mayor prioridad; RUNNING → SLEEPING cuando el thread llama a `k_sleep()`, `k_yield()` o inicia E/S bloqueante; SLEEPING → READY cuando el evento se completa; RUNNING → READY cuando un hilo de mayor prioridad desaloja al actual (preemption).

### Políticas de Scheduling

Zephyr soporta dos políticas que pueden coexistir:

**Cooperative (hilos cooperativos)**: prioridad negativa (-1, -2, -3...). El thread retiene CPU hasta que la libere voluntariamente mediante `k_yield()`, `k_sleep()`, o esperando un mutex. No hay desalojo involuntario. Uso típico: drivers y operaciones atómicas que no pueden ser interrumpidas.

**Preemptive (hilos preemptivos)**: prioridad no negativa (0, 1, 2, 3...). Si llega un hilo de mayor prioridad, el scheduler lo pone en RUNNING inmediatamente, desalojando al actual. Uso típico: tareas de tiempo real con deadline.

### Priority-Based sin Round Robin

Zephyr usa scheduling **priority-based puro**, no Round Robin. No hay time-slicing: no existe timer que interrumpa para darle quantum a otro thread de igual prioridad. El scheduler mantiene colas FIFO por nivel de prioridad; el primero encolado es el primero en ejecutar.

El determinismo es más importante que la equidad en sistemas de tiempo real. Las consecuencias son: starvation posible (hilo de baja prioridad podría nunca ejecutarse si siempre hay de mayor prioridad), sin fair sharing entre threads de igual prioridad, y scheduler completamente determinista.

Esto contrasta con Round Robin clásico donde cada proceso recibe un quantum y se rota. Zephyr no tiene quantum clásico.

### Sin Syscalls Tradicionales

Los syscalls en Zephyr son **function calls directos**: no hay `int 0x80` ni cambio de modo usuario/kernel. El thread de usuario llama a una función API wrapper que verifica punteros y parámetros, transfiere control al código del kernel, y retorna. Esto reduce latencia significativamente.

El dispatcher cumple las mismas funciones que en sistemas tradicionales pero con overhead reducido: el context switch solo salva/restaura registros y stack pointer entre threads, sin cambio de modo kernel/user.

### Priority Inheritance

Zephyr implementa **priority inheritance** para evitar inversión de prioridad. El problema: hilo de alta prioridad (H) queda esperando un mutex que tiene un hilo de baja prioridad (L), mientras uno de prioridad media (M) ejecuta. La solución: cuando H intenta acquire un mutex que ya tiene L, el scheduler detecta esto y eleva la prioridad de L a la de H. L ejecuta rápidamente, libera el mutex, su prioridad vuelve a la original, y H puede adquirir el mutex y continuar.

---

## MOSIX

### Migración Preemptiva como Scheduler Distribuido

MOSIX extiende la administración del procesador de un único nodo/SO a un **cluster completo**. Su concepto central: la **migración preemptiva de procesos funciona como un scheduler distribuido**, donde el PCB se serializa y transfiere entre nodos, permitiendo que un proceso continúe en otro nodo como si nunca se hubiera movido.

El ciclo completo de migración:

1. **Serializa**: se crea un checkpoint con estado completo del PCB (registros CPU, contador de programa, stack pointer), espacio de memoria completo (heap, stack, código, datos), descriptores de archivos abiertos, sockets activos, y señales pendientes.

2. **Transfiere**: el estado serializado cruza la red hacia el nodo destino. El costo es proporcional al tamaño de la memoria del proceso.

3. **Reconstruye**: el nodo destino recibe los datos y reconstruye el PCB y espacio de memoria.

4. **Continúa**: el proceso retoma ejecución exactamente desde el punto de serialización. Es transparente para la aplicación.

### Load Balancing Multi-Paramétrico

MOSIX evalúa **múltiples parámetros** simultáneamente para decidir dónde ejecutar cada proceso:

| Parámetro | Mide |
|-----------|------|
| Velocidad de CPU | MHz/GHz del procesador |
| Carga actual | Procesos ejecutándose |
| Memoria disponible | RAM libre |
| Latencia de red | Retraso entre nodos |
| Número de cores | CPUs lógicos disponibles |

No es FCFS ni Round Robin. Es un algoritmo **adaptativo** que monitorea continuamente el estado global del cluster: cada nodo monitorea su propia carga, los nodos intercambian estadísticas, se detectan desbalances, se seleccionan procesos candidatos, y se ejecutan las migraciones.

La migración es **preemptiva**: el sistema mueve procesos sin que el proceso lo solicite, sin intervención del usuario, y sin que la aplicación lo sepa.

### Scheduler de Tres Niveles

La migración combina los tres niveles clásicos de scheduling:

- **Largo plazo**: decide en qué nodo se размещает cada proceso nuevo
- **Medio plazo**: "memory ushering" — mueve procesos entre nodos por presión de memoria
- **Corto plazo**: evalúa constantemente si procesos deben migrar

### Single System Image (SSI)

MOSIX presenta el cluster como una **única máquina con N CPUs lógicas** (Single System Image). Las aplicaciones se ejecutan **sin modificaciones ni recompilación**. El usuario lanza procesos como en un sistema normal, y MOSIX decide internamente dónde ejecutarlos.

### Evitación del Efecto Convoy

El problema original: un proceso CPU-bound largo monopoliza la CPU, procesos cortos quedan esperando detrás, el throughput global cae.

MOSIX lo evita detectando procesos CPU-bound que monopolizan un nodo, migrándolos a nodos menos cargados o más rápidos, y dejando los nodos sobrecargados disponibles para procesos interactivos/I/O-bound.

Ventajas sobre soluciones tradicionales: no depende de quantum fijo (no hay trade-off quantum vs. overhead), no necesita conocer a priori la duración de los procesos (a diferencia de SJF), y opera a nivel de nodos físicos completos.

### Limitaciones

MOSIX no soporta memoria compartida entre procesos ni threads POSIX. No todas las aplicaciones serializan limpiamente durante checkpoint/restart. Procesos con mucha memoria generan tráfico significativo durante migración. El algoritmo debe evaluar si el costo de migración supera el beneficio. Soporte limitado para CPUs multinúcleo dentro de un nodo.

---

## Comparación

| Aspecto | Zephyr OS | MOSIX |
|---------|-----------|-------|
| Unidad de scheduling | Thread (contexto liviano) | Proceso completo (con PCB) |
| Niveles de scheduler | Solo corto plazo | Largo plazo + medio plazo + corto plazo |
| Algoritmo | Priority-based (sin Round Robin) | Balanceo de carga multi-paramétrico |
| Time slicing | No tiene | No tiene (pero migraciones distribuyen carga) |
| Preemption | Solo entre prioridades | Migración preemptiva entre nodos |
| Quantum | No tiene | No tiene (no es Round Robin) |
| Objetivo | Determinismo y latencia mínima | Throughput global y utilización de cluster |
| Efecto convoy | No aplica (un solo nodo) | Mitigado por migración de procesos CPU-bound |

Zephyr: scheduler de corto plazo con prioridades estáticas, sin time-slicing, diseñado para respuesta en tiempo real determinista. syscalls son function calls directos.

MOSIX: scheduler distribuido que combina largo plazo ( размещение inicial), medio plazo (memory ushering), y corto plazo (evaluación continua de migración), con balanceo de carga adaptativo multi-paramétrico.