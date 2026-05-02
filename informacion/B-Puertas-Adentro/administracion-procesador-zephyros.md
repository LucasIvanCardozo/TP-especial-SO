# Administración del Procesador en Zephyr OS

> **Nota:** Este documento forma parte de la sección "Puertas Adentro" del Trabajo Práctico Especial de Fundamentos de Sistemas Operativos, enfocándose en la administración del procesador y threading en Zephyr OS.

---

## 1. Evolución del Kernel: De Dual-Kernel a Kernel Monolítico Unificado

### 1.1 El Diseño Dual-Kernel (Antes de v1.6)

En sus primeras versiones, Zephyr utilizaba un diseño de **dual-kernel** heredado de su antecesor Wind River Rocket:

| Componente | Descripción |
|---|---|
| **Nanokernel** | Diseñado para dispositivos con recursos muy restringidos. Solo soportaba un único hilo de ejecución (single thread) y las funcionalidades más básicas. |
| **Microkernel** | Para dispositivos con más recursos. Soportaba múltiples hilos (fibers y tasks), pero las APIs de nanokernel y microkernel eran diferentes, requiriendo compilación separada. |

> **Problema:** Los desarrolladores necesitaban elegir entre nanokernel o microkernel antes de compilar. No era posible portar una aplicación de un perfil a otro sin reescribir código.

**Fuente:** [Wikipedia — Zephyr OS](https://en.wikipedia.org/wiki/Zephyr_(operating_system)), [Scaler — How Zephyr OS Works](https://www.scaler.com/topics/zephyr-operating-system/)

### 1.2 La Unificación en v1.6 (Diciembre 2016)

Con el lanzamiento de **Zephyr v1.6** en diciembre 2016, se introdujo el **Unified Kernel** (kernel unificado):

- Se eliminó la distinción entre nanokernel y microkernel.
- Los conceptos de **fibers** (del nanokernel) y **tasks** (del microkernel) se fusionaron en un único concepto: **thread** (hilo).
- Toda la funcionalidad se compila en un único binario estático.
- Las aplicaciones pueden configurarse para usar solo los features necesarios, permitiendo que el kernel最终的 ocupe tan solo ~4 KB.

> Esta unificación simplificó significativamente el desarrollo, ya que el mismo código fuente puede ejecutarse en dispositivos con recursos muy diferentes sin modificaciones.

**Fuente:** [Zephyr 1.6.0 Release Notes — GitLab TU Wien](https://gitlab.auto.tuwien.ac.at/auto/zephyr/-/blob/67f43119be9485844219bb38025f9e49d37da0bf/doc/releases/release-notes-1.6.rst), [Zephyr Documentation — Introduction](https://docs.zephyrproject.org/latest/introduction/index.html)

---

## 2. Políticas de Scheduling

El scheduler de Zephyr soporta **tres políticas de scheduling**, permitiendo al desarrollador elegir según las necesidades de la aplicación:

### 2.1 Cooperative Scheduling

| Aspecto | Descripción |
|---|---|
| **Prioridad** | Los hilos cooperativos tienen valores de prioridad **negativos** (ej: -1, -2). |
| **Comportamiento** | Una vez que un hilo cooperativo obtiene la CPU, **retiene el control** hasta que él mismo lo libere explícitamente (llamando a una syscall como `k_yield()`, `k_sleep()`, o esperando un recurso). |
| **Uso típico** | Tareas que no pueden ser interrumpidas, operaciones críticas que deben completarse sin preemption. |
| **Ventaja** | Sin overhead de context-switch involuntarios. |

**Fuente:** [Zephyr Documentation — Threads](https://docs.zephyrproject.org/latest/kernel/services/threads/index.html), [DigiKey — Introduction to Zephyr Part 8](https://www.digikey.nl/en/maker/tutorials/2025/introduction-to-zephyr-part-8-multithreading)

### 2.2 Preemptive Scheduling

| Aspecto | Descripción |
|---|---|
| **Prioridad** | Los hilos preemptivos tienen valores de prioridad **no negativos** (0, 1, 2...). |
| **Comportamiento** | Un hilo de mayor prioridad que el actual **puede arrebatar la CPU** en cualquier momento, incluso si el hilo actual no ha terminado. |
| **Uso típico** | Tareas de tiempo real que deben responder a eventos con latencia garantizada. |
| **Ventaja** | Latencia de respuesta mínima para hilos de alta prioridad. |

**Fuente:** [Zephyr Documentation — Scheduling](https://docs.zephyrproject.org/latest/kernel/services/scheduling/index.html)

### 2.3 Scheduling Híbrido

Zephyr permite combinar hilos cooperativos y preemptivos en la misma aplicación:

- Los hilos preemptivos (prioridad >= 0) pueden ser interrumpidos por hilos de mayor prioridad.
- Los hilos cooperativos (prioridad < 0) solo ceden la CPU voluntariamente.
- Un hilo preemptivo de baja prioridad puede coexistir con un hilo cooperativo de alta prioridad.

**Ejemplo de configuración:**
```c
// Hilo cooperativo (prioridad negativa)
K_THREAD_DEFINE(my_coop_thread_id, STACK_SIZE,
                coop_thread_entry, NULL, NULL, NULL,
                -1, 0, 0);  // prioridad = -1

// Hilo preemptivo (prioridad no negativa)
K_THREAD_DEFINE(my_preempt_thread_id, STACK_SIZE,
                preempt_thread_entry, NULL, NULL, NULL,
                0, 0, 0);  // prioridad = 0
```

**Fuente:** [Nordic Developer Academy — Scheduler In-Depth](https://academy.nordicsemi.com/courses/nrf-connect-sdk-intermediate/lessons/lesson-1-zephyr-rtos-advanced/topic/scheduler-in-depth/)

### 2.4 Herencia de Prioridad (Priority Inheritance)

Para evitar problemas de **inversión de prioridad**, Zephyr implementa **priority inheritance**:

- Cuando un hilo de baja prioridad sostiene un lock (mutex) que un hilo de alta prioridad necesita, el scheduler eleva temporalmente la prioridad del hilo de baja prioridad.
- Una vez que el hilo de baja prioridad libera el mutex, su prioridad vuelve a la original.

**Fuente:** [Hubble Network — Zephyr Thread Priorities and Scheduling](https://hubble.com/community/guides/zephyr-thread-priorities-and-scheduling-avoiding-priority-inversion-in-ble-firmware/)

---

## 3. Multi-Threading en Zephyr

### 3.1 Concepto de Thread

En Zephyr (desde v1.6), un **thread** es la unidad básica de ejecución:

| Atributo | Descripción |
|---|---|
| **Stack** | Cada thread tiene su propio stack, configurable en tamaño. |
| **Prioridad** | Entero que determina el orden de scheduling (más bajo = más prioritized). |
| **Opciones** | Flags que controlan comportamiento (cooperativo vs preemptivo, etc.). |
| **Estado** | Puede estar: ejecutando, listo (ready), durmiendo (sleeping), suspendido, o terminado. |

### 3.2 Estados de un Thread

```
┌──────────┐    schedule     ┌─────────┐
│ 睡眠/Sleeping │ ──────────→ │  Listo/Ready │
└──────────┘                └─────────┘
     ↑                            │
     │         schedule            │
     └────────────────────────────┘
                (yield)
                ┌──────────────┐
                │ Ejecutando   │
                │ (Running)    │
                └──────────────┘
                     │
                     ▼
                ┌──────────────┐
                │  Terminado   │
                │ (Terminated) │
                └──────────────┘
```

**Fuente:** [Zephyr Documentation — Threads](https://docs.zephyrproject.org/latest/kernel/services/threads/index.html)

### 3.3 Sincronización entre Threads

Zephyr provee múltiples mecanismos de sincronización:

| Mecanismo | Uso |
|---|---|
| **Mutexes** | Exclusion mutua para acceso a recursos compartidos. Soportan priority inheritance. |
| **Semaphores** | Control de acceso a recursos limitados (ej: pool de conexiones). |
| **Fifos** | Paso de mensajes primero-en-primero-fuera entre threads. |
| **LIFOs** | Paso de mensajes último-en-primero-fuera. |
| **Stacks** | Paso de mensajes con comportamiento de pila. |
| **Queues** | Colas de mensajes genéricas. |

**Fuente:** [Zephyr Documentation — Threads](https://docs.zephyrproject.org/latest/kernel/services/threads/index.html)

---

## 4. AMP (Asymmetric Multiprocessing) — OpenAMP

### 4.1 ¿Qué es AMP?

En **Asymmetric Multiprocessing (AMP)**, cada procesador core ejecuta su **propio sistema operativo o instancia del kernel**, de forma independiente. Los cores no comparten el mismo kernel:

- Un core puede ejecutar Linux.
- Otro core puede ejecutar Zephyr.
- La comunicación entre ellos se realiza via paso de mensajes (**mailbox**) o memoria compartida.

### 4.2 OpenAMP en Zephyr

Zephyr implementa AMP usando el framework **OpenAMP** (Open Asymmetric Multi Processing):

| Componente | Descripción |
|---|---|
| **OpenAMP** | Frameworkopen source que provee software components para sistemas AMP. |
| **RPMsg** | Protocolo de comunicación entre cores (mensajes entre Linux y Zephyr). |
| **Remoteproc** | Permite a un core cargar y controlar el firmware de otro core. |

**Ejemplo de uso:** En el SoC **STM32MP1** (STMicroelectronics), un Cortex-A7 ejecuta Linux mientras que un Cortex-M4 ejecuta Zephyr. Linux puede cargar el firmware del Cortex-M4 y comunicarse con él via RPMsg.

**Fuente:** [OpenAMP Documentation](https://openamp.readthedocs.io/en/latest/protocol_details/asymmetric_mp.html), [Collabora — AMP with Linux & Zephyr on STM32MP1](https://www.collabora.com/news-and-blog/blog/2021/03/03/asymmetric-multi-processing-with-linux-and-zephyr-on-stm32mp1/)

### 4.3 Beneficios de AMP

| Beneficio | Descripción |
|---|---|
| ** Aislamiento** | Cada core tiene su propio kernel, fallas en uno no afectan al otro. |
| **Flexibilidad** | Se puede usar el SO más adecuado para cada tarea (Linux para conectividad, Zephyr para tiempo real). |
| **Uso de heterogéneo** | Combinar cores de diferente tipo (ej: Cortex-A + Cortex-M). |
| **Determinismo** | El core que ejecuta Zephyr puede garantizar latencias de tiempo real sin interferencia de Linux. |

**Fuente:** [GitHub — Zephyrproject-rtos/open-amp](https://github.com/zephyrproject-rtos/open-amp), [Microchip — AMP on PIC64GX](https://ww1.microchip.com/downloads/aemDocuments/documents/MPU64/ProductDocuments/SupportingCollateral/Asymmetric_Multi-Processing_on_PIC64GX_White_Paper.pdf)

---

## 5. SMP (Symmetric Multiprocessing)

### 5.1 ¿Qué es SMP?

En **Symmetric Multiprocessing (SMP)**, múltiples procesadores cores comparten **el mismo kernel y el mismo espacio de direcciones**. El scheduler de Zephyr distribuye los threads entre los cores disponibles, balanceando la carga de trabajo.

| Aspecto | Descripción |
|---|---|
| **Kernel compartido** | Todos los cores corren la misma instancia del kernel de Zephyr. |
| **Memoria compartida** | Todos los cores acceden a la misma memoria física. |
| **Balance de carga** | El scheduler puede migrar threads entre cores automáticamente. |
| **Sincronización** | Se requieren primitivas de sincronización (spinlocks) para acceso a estructuras del kernel. |

**Fuente:** [Zephyr Documentation — SMP](https://docs.zephyrproject.org/latest/kernel/services/smp/smp.html), [Altera FPGA Developer — SMP in Zephyr](https://altera-fpga.github.io/rel-24.3.1/zephyr-embedded/smp/smp/)

### 5.2 Cómo Funciona el SMP en Zephyr

En Zephyr con SMP habilitado:

1. **Boot:** El código de arranque (bootloader) inicializa todos los cores.
2. **Run queues por core:** Cada core tiene su propia **run queue** local donde se encolan los threads listos para ejecutar.
3. **Scheduling local:** Cada core ejecuta el scheduler localmente para elegir el siguiente thread de su run queue.
4. **Acceso a memoria compartida:** Los spinlocks protejen las estructuras del kernel que son compartidas entre cores.
5. **Comunicación entre cores:** Los cores pueden comunicarse via memoria compartida o interrupciones IP (inter-processor interrupts).

> **Nota:** No todos los SoCs soportan SMP. La habilitación de SMP se configura en tiempo de compilación via Kconfig.

**Fuente:** [LinkedIn — How SMP Works in Zephyr on Multi-core RISC-V](https://www.linkedin.com/posts/tushar-aherkar_%F0%9D%90%92%F0%9D%90%8C%F0%9D%90%8F-%F0%9D%90%92%F0%9D%90%B2%F0%9D%90%A6%F0%9D%90%A6%F0%9D%90%9E%F0%9D%90%AD%F0%9D%90%AB%F0%9D%90%A2%F0%9D%90%9C-%F0%9D%90%8C%F0%9D%90%AE%F0%9D%90%A5%F0%9D%90%AD%F0%9D%90%A2%F0%9D%90%A9-activity-7391363600805818368-NlN_)

### 5.3 Ejemplo de Configuración SMP

En el archivo `prj.conf`:
```
CONFIG_SMP=y
CONFIG_MP_NUM_CPUS=4
```

Esto habilita SMP con 4 cores.

**Fuente:** [Zephyr Documentation — SMP Samples](https://docs.zephyrproject.org/latest/samples/arch/smp/index.html)

### 5.4 SMP vs AMP: Comparación

| Aspecto | **SMP** | **AMP** |
|---|---|---|
| **Kernel** | Compartido (todos los cores usan el mismo kernel) | Independiente (cada core puede tener su propio SO) |
| **Memoria** | Compartida (todos ven el mismo espacio de direcciones) | Puede ser compartida o aislada |
| **Scheduling** | Centralizado (el kernel balancea carga) | Distribuido (cada SO tiene su propio scheduler |
| **Caso de uso típico** | Aplicaciones de alto throughput, procesamiento paralelo | Sistemas heterogéneos, tiempo real + procesamiento general |
| **Complejidad** | Más simple (un solo kernel) | Más complejo (múltiples imágenes de SO) |

**Fuente:** [Sched — Multi-core Application Development with Zephyr](https://static.sched.com/hosted_files/osseu19/13/Multi-core%20application%20development%20with%20Zephyr%20RTOS%20-%202019.10.23.pdf)

---

## 6. Single Address Space (Espacio de Direcciones Único)

### 6.1 Concepto

En Zephyr, el **kernel y las aplicaciones comparten un único espacio de direcciones**:

```
┌─────────────────────────────────────────┐
│          APLICACIONES (User Mode)       │
│  Thread 1    Thread 2    Thread 3       │
├─────────────────────────────────────────┤
│          KERNEL (Privileged Mode)       │
│  Scheduler  │  Memory  │  Drivers       │
│             │  Management             │
└─────────────────────────────────────────┘
           MEMORIA FÍSICA COMPARTIDA
```

| Aspecto | Descripción |
|---|---|
| **Kernel + Apps** | Se compilan en un **único binario estático**. |
| **Sin MMU necesaria** | No se requiere Memory Management Unit para separar kernel y aplicaciones (aunque se soportan si está disponible). |
| **System calls** | Se implementan como **function calls** directos, sin cambio de contexto, lo que las hace muy eficientes. |

### 6.2 Beneficios del Single Address Space

| Beneficio | Descripción |
|---|---|
| **Comunicación directa** | Los threads pueden compartir datos directamente via punteros, sin necesidad de mecanismos IPC complejos. |
| **Overhead mínimo** | No hay costoso context switches kernel/user ni cambios de modo de privilegio para cada syscall. |
| **Código más simple** | El kernel no necesita mantener tablas de páginas separadas ni espacios de direcciones virtuales para cada proceso. |
| **Tamaño reducido** | El binario es más pequeño al no incluir estructuras de memoria virtual para múltiples procesos. |
| **Rendimiento** | La comunicación entre componentes es más rápida. |

**Fuente:** [Antmicro — Zephyr as Unikernel](https://antmicro.com/blog/2025/08/zephyr-as-unikernel/), [Zephyr Project — User Mode Explained](https://www.zephyrproject.org/user-mode-explained-in-simple-words/)

### 6.3 Protección sin MMU Completa

Aunque Zephyr comparte el espacio de direcciones, provee mecanismos de protección:

| Mecanismo | Descripción |
|---|---|
| **MPU (Memory Protection Unit)** | En arquitecturas sin MMU completo, la MPU divide la memoria en regiones con atributos específicos (solo lectura, ejecución prohibida, etc.). |
| **Memory Domains** | Agrupa threads y asigna particiones de memoria a cada dominio, controlando qué threads pueden acceder a qué regiones. |
| **User Mode** | Los threads pueden ejecutarse en modo no privilegiado, restringiendo su acceso a recursos del sistema. |

**Fuente:** [Zephyr Documentation — Memory Management](https://docs.zephyrproject.org/latest/kernel/memory_management/index.html), [Zephyr Project — User Mode in Simple Words](https://www.zephyrproject.org/user-mode-explained-in-simple-words/)

### 6.4 Desventajas y Limitaciones

| Limitación | Descripción |
|---|---|
| **Sin aislamiento de procesos** | Un bug en un thread puede corromper la memoria de otro thread o del kernel. |
| **Dependencia del compilador** | El desarrollador debe usar herramientas de análisis estático y code reviews para evitar errores. |
| **No es un SO de propósito general** | Zephyr no intenta ser Linux; está optimizado para sistemas embebidos donde el desarrollador tiene control total. |

---

## 7. Arquitecturas Soportadas (>15)

Zephyr es altamente portable y soporta una amplia variedad de arquitecturas de CPU:

### 7.1 Lista Completa de Arquitecturas

| Familia | Arquitecturas específicas | Ejemplos de uso |
|---|---|---|
| **ARM Cortex-M** | ARMv6-M, ARMv7-M, ARMv8-M | Microcontroladores STM32, NRF52 (Nordic) |
| **ARM Cortex-R** | ARMv7-R, ARMv8-R | Sistemas automotrices, industrial |
| **ARM Cortex-A** | ARMv7-A, ARMv8-A | Procesamiento de aplicaciones, SOMs |
| **RISC-V** | RV32, RV64 (32 y 64 bits) | SiFive, StarFive, ESP32-C3 |
| **x86** | IA-32 (32-bit), x86-64 (64-bit) | Intel Quark, procesadores de PC embebidos |
| **ARC** | ARC HS, ARC EM (ARCv2) | Procesadores Argonaut |
| **MIPS** | MIPS32 (32 bits) |有些不常见的SoC |
| **Nios II** | Nios II (soft-core) | FPGAs de Altera/Intel |
| **SPARC** | SPARC (particularmente LEON) | Aplicaciones espaciales, sistemas de alta confiabilidad |
| **Xtensa** | Tensilica (LX6, LX7, etc.) | ESP32 (Espressif) |
| **OpenRISC** | OpenRISC (añadido en v4.4.0) | Investigación, academic |
| **RISC-V (T-head)** | RISC-V vendor-specific | Algunos SoCs chinos |

> **Dato:** Zephyr soporta **más de 1,000 boards** diferentes, desde microcontroladores de 4 KB hasta sistemas con múltiples cores.

**Fuente:** [Zephyr Documentation — Introduction](https://docs.zephyrproject.org/latest/introduction/index.html), [Zephyr Datasheet (Mar 2024)](https://www.zephyrproject.org/wp-content/uploads/2024/03/zephyr_datasheet_032824-bleed.pdf), [Hackster — Zephyr 4.4.0](https://www.hackster.io/news/zephyr-4-4-0-brings-openrisc-support-performance-gains-and-wi-fi-direct-capabilities-b8da8e1b641b)

### 7.2 Tabla Resumen de Arquitecturas

```
Arquitectura    │ Bits  │ Tipo         │ Estado
────────────────┼───────┼──────────────┼────────
ARM Cortex-M    │ 32    │ RISC         │ Full support
ARM Cortex-R    │ 32    │ RISC         │ Full support
ARM Cortex-A    │ 32/64 │ RISC         │ Full support
RISC-V          │ 32/64 │ RISC         │ Full support
x86             │ 32/64 │ CISC         │ Full support
ARC             │ 32    │ RISC         │ Full support
MIPS            │ 32    │ RISC         │ Full support
Nios II         │ 32    │ Soft-core    │ Full support
SPARC           │ 32    │ RISC         │ Full support
Xtensa          │ 32    │ RISC         │ Full support
OpenRISC        │ 32    │ RISC         │ Full support (v4.4.0+)
```

### 7.3 Zephyr SDK

El **Zephyr SDK** incluye toolchains para **todas** las arquitecturas soportadas:

- ARM GCC (para Cortex-M/R/A)
- RISC-V GCC
- x86 GCC (32 y 64 bits)
- ARC GCC
- Nios II GCC
- SPARC GCC (para LEON)
- Xtensa GCC (para ESP32)
- MIPS GCC
- QEMU para emulación
- OpenOCD para debug

**Fuente:** [Zephyr Documentation — Getting Started](https://docs.zephyrproject.org/latest/develop/getting_started/)

---

## Resumen

| Aspecto | Detalle |
|---|---|
| **Kernel evolution** | Dual-kernel (nanokernel + microkernel) unificado en monolithic kernel desde v1.6 (dic 2016) |
| **Scheduling policies** | Cooperative (prioridad negativa), Preemptive (prioridad >= 0), y híbrido |
| **Multi-threading** | Threads con stacks propios, prioridades, y estados (running, ready, sleeping, terminated) |
| **AMP** | Basado en OpenAMP/RPMsg para ejecutar Zephyr junto a Linux u otro SO en cores separados |
| **SMP** | Múltiples cores comparten el mismo kernel y espacio de direcciones; cada core tiene su run queue local |
| **Single Address Space** | Kernel y aplicaciones comparten espacio de direcciones; protección via MPU y user mode |
| **Arquitecturas** | >15 familias: ARM, RISC-V, x86, ARC, MIPS, Nios II, SPARC, Xtensa, OpenRISC, etc. |

---

## Fuentes

- [Wikipedia — Zephyr (operating system)](https://en.wikipedia.org/wiki/Zephyr_(operating_system))
- [Zephyr Documentation — Introduction](https://docs.zephyrproject.org/latest/introduction/index.html)
- [Zephyr Documentation — Threads](https://docs.zephyrproject.org/latest/kernel/services/threads/index.html)
- [Zephyr Documentation — Scheduling](https://docs.zephyrproject.org/latest/kernel/services/scheduling/index.html)
- [Zephyr Documentation — SMP](https://docs.zephyrproject.org/latest/kernel/services/smp/smp.html)
- [Zephyr Documentation — Memory Management](https://docs.zephyrproject.org/latest/kernel/memory_management/index.html)
- [OpenAMP Documentation](https://openamp.readthedocs.io/en/latest/protocol_details/asymmetric_mp.html)
- [Collabora — AMP with Linux & Zephyr on STM32MP1](https://www.collabora.com/news-and-blog/blog/2021/03/03/asymmetric-multi-processing-with-linux-and-zephyr-on-stm32mp1/)
- [Scaler — How Zephyr OS Works](https://www.scaler.com/topics/zephyr-operating-system/)
- [DigiKey — Introduction to Zephyr Part 8: Multithreading](https://www.digikey.nl/en/maker/tutorials/2025/introduction-to-zephyr-part-8-multithreading)
- [Nordic Developer Academy — Scheduler In-Depth](https://academy.nordicsemi.com/courses/nrf-connect-sdk-intermediate/lessons/lesson-1-zephyr-rtos-advanced/topic/scheduler-in-depth/)
- [Zephyr Project — User Mode Explained in Simple Words](https://www.zephyrproject.org/user-mode-explained-in-simple-words/)
- [Antmicro — Zephyr as Unikernel](https://antmicro.com/blog/2025/08/zephyr-as-unikernel/)
- [Zephyr Datasheet (Mar 2024)](https://www.zephyrproject.org/wp-content/uploads/2024/03/zephyr_datasheet_032824-bleed.pdf)
- [Hackster — Zephyr 4.4.0 Brings OpenRISC Support](https://www.hackster.io/news/zephyr-4-4-0-brings-openrisc-support-performance-gains-and-wi-fi-direct-capabilities-b8da8e1b641b)
- [GitHub — Zephyrproject-rtos/open-amp](https://github.com/zephyrproject-rtos/open-amp)
- [Sched — Multi-core Application Development with Zephyr](https://static.sched.com/hosted_files/osseu19/13/Multi-core%20application%20development%20with%20Zephyr%20RTOS%20-%202019.10.23.pdf)

---
## Nota Académica — Fundamentos de SO
**Conceptos de la materia relacionados:**

- **§2.1 — Necesidad del scheduling y objetivos del scheduler**: Zephyr implementa un scheduler que debe balancear latencia de respuesta para tareas de tiempo real vs throughput. Su scheduler soporta prioridades y decide cuál thread ejecutar next en cada core.

- **§2.2 — Estados de un proceso**: Los threads de Zephyr tienen estados claros: running (ejecutando), ready (listo), sleeping (bloqueado/durmiendo), terminated, y suspendido. El diagrama de transición de estados mostrado (líneas 113-130) es una instancia del modelo clásico de estados de proceso.

- **§2.3 — PCB (Process Control Block)**: Cada thread en Zephyr tiene una estructura interna que contiene: stack, prioridad, opciones, estado, y contexto de CPU. Esto equivale a un PCB simplificado — aunque en Zephyr no hay paginación ni memoria virtual, el concepto de "bloque de control del proceso" se manifiesta en la структура k_thread.

- **§2.5 — Algoritmos de scheduling por prioridad y Round Robin**: Zephyr usa scheduling por prioridad fija (no hay round robin entre threads de igual prioridad — el primero en cola es el primero en ejecutar). Hilos cooperativos (prioridad negativa) y preemptivos (prioridad >= 0) coexisten, implementando un esquema híbrido.

- **§2.6 — Efecto convoy**: El documento no describe efecto convoy directamente, pero en el scheduling cooperativo, si un hilo de baja prioridad retiene la CPU innecesariamente, los demás hilos sufren latencia — un problema análogo al convoy.

- **§2.7 — Quantum óptimo y §2.8 — Dispatcher**: Zephyr NO usa quantum/time-slice en el sentido clásico de Round Robin. En scheduling cooperativo no hay interrupciones temporizadas; en preemptivo, la pérdida de CPU ocurre solo cuando llega un hilo de mayor prioridad. El dispatcher de Zephyr es eficiente porque no hay cambio de modo kernel/user (single address space) — las syscalls son function calls directos, eliminando el overhead de context switch descrito en §2.8.

- **Priority Inheritance (herencia de prioridad)**: Zephyr implementa priority inheritance para evitar inversión de prioridad — un problema reconocido en sistemas de scheduling por prioridad donde hilos de baja prioridad sostienen recursos que hilos de alta prioridad necesitan (§2.5 conceptos relacionados).