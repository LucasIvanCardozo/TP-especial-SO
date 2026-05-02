# slide-05-explicacion.md — Zephyr OS: Características Generales

## Introducción

Esta slide presenta las **características generales** de Zephyr OS, organizándolas en cuatro dominios técnicos principales:

1. **Arquitectura del Kernel** — cómo está estructurado internamente
2. **Scheduling** — cómo planifica la ejecución de tareas
3. **Modelo de Memoria** — cómo gestiona la memoria y la protección
4. **Arquitecturas Soportadas** — el hardware que puede ejecutar Zephyr

> **Contexto en el temario FSO:** Esta slide toca directamente los temas §1.3 (conceptos fundamentales de procesos y multitarea), §1.4 (arquitecturas de sistemas operativos: monolítico vs microkernel), §1.5 (modo dual kernel/usuario), §1.6 (instrucciones privilegiadas), y §2.5 (algoritmos de scheduling).

---

## 1. Arquitectura del Kernel

### 1.1 Kernel Monolítico Unificado

La slide indica: *"Kernel monolítico unificado (desde v1.6)"*.

**¿Qué significa esto en el contexto FSO (§1.4)?**

Un kernel monolítico tradicional (como UNIX o Linux clásico) es aquel donde **todas las funcionalidades del sistema operativo operan en modo kernel**: scheduling, sistema de archivos, manejo de memoria, drivers, network stack, todo en un único espacio de direcciones privilegiado. Esto contrasta con la arquitectura **microkernel**, donde el kernel solo contiene funcionalidades mínimas (scheduling, IPC, manejo básico de memoria) y el resto de los servicios (filesystem, drivers, networking) corren como procesos de usuario.

Zephyr utiliza un kernel monolítico **pero** con un diseño "microkernel-like" (según la documentación oficial): altamente modular y configurable. Los subsistemas pueden incluirse o excluirse en tiempo de compilación mediante Kconfig, lo que acerca su filosofía a la de un microkernel sin el overhead de comunicación entre procesos que estos últimos tienen.

**Contexto histórico:** Antes de la versión 1.6 (diciembre 2016), Zephyr tenía un diseño de **dual-kernel**:
- **Nanokernel**: para dispositivos con recursos muy limitados (~4-10 KB RAM)
- **Microkernel**: para dispositivos con más recursos

Cada uno tenía API diferente y requería compilación separada. Desde v1.6 se unificaron en un único kernel donde los conceptos de "fibers" y "tasks" se fusionaron en un único concepto de **thread**. Esta unificación simplificó el desarrollo y la portabilidad de aplicaciones entre diferentes plataformas.

### 1.2 Single Address Space

La slide indica: *"Single address space — kernel + apps compartido"*.

**¿Qué es el Single Address Space?**

En un sistema operativo convencional con memoria virtual (como Linux o Windows), cada proceso tiene su propio espacio de direcciones virtuales independiente. Cuando un proceso hace una llamada al sistema, hay un **cambio de contexto** donde:
1. Se guardan los registros de la CPU del proceso usuario
2. Se cambia el privilege level de usuario a kernel
3. Se ejecuta el código del kernel
4. Se restauran los registros y se vuelve al proceso usuario

Este cambio de contexto tiene overhead significativo: intercambio de páginas de tabla, flush de TLB, invalidación de cachés.

En Zephyr con **single address space**, el kernel y todas las aplicaciones comparten el **mismo espacio de direcciones físicas** (o el mismo espacio de direcciones virtuales, dependiendo de la arquitectura). No hay MMU隔离 entre procesos de usuario y kernel. Las system calls se implementan como **function calls** directos sin cambio de contexto.

**Ventajas:**
- Overhead de system call mínimo
- Comunicación entre hilos extremadamente rápida (pueden compartir punteros directamente)
- Simplicidad en el modelo de programación

**Desventajas:**
- Un bug en una aplicación de usuario puede corromper memoria del kernel
- Dependencia de MPU para aislamiento (ver sección de memoria)

**Conexión con §1.5 (Modo Dual):** Zephyr implementa user mode y kernel mode mediante privilege levels del procesador, incluso sin MMU. Los hilos pueden correr en modo privilegiado (kernel) o no privilegiado (user). La protección se logra con MPU (Memory Protection Unit), no con tablas de páginas como en sistemas con MMU completo.

### 1.3 System Calls como Function Calls

La slide indica: *"System calls como function calls (sin context switch)"*.

En sistemas tradicionales (UNIX), una system call como `read()` implica:
```
用户态: 调用 read() → Trap → Kernel态: execute sys_read() → Trap返回 → 用户态
```

En Zephyr, al no haber separación de espacios de direcciones entre kernel y aplicaciones, una system call es simplemente una **llamada a función C**. El código del kernel está linkeado directamente en el mismo binario que las aplicaciones. Cuando una aplicación quiere usar un servicio del kernel (ej: crear un thread, tomar un mutex), simplemente llama a la función correspondiente.

**Nota académica:** Esto es una simplificación. Zephyr aún tiene verificación de permisos y puede usar MPU para proteger regiones críticas del kernel, pero **no hay cambio de contexto** en el sentido de swap de registers y cambio de stack pointer.

### 1.4 Compilación Estática

La slide indica: *"Compilación estática — binario único, mínimo overhead"*.

Zephyr no tiene dynamic loader. Todo el código (kernel + aplicaciones + drivers) se compila en un **único binario estático** que se flashea en el microcontrolador. No hay sistema de archivos con executables separados (como en Linux), no hay shared libraries. El binario se genera mediante CMake + Kconfig, y el tamaño mínimo del kernel puede ser de ~4 KB.

Esto es posible porque:
1. El código de las aplicaciones se linkea estáticamente con el kernel
2. Los drivers pueden configuranse para incluirse o excluirse en tiempo de compilación
3. No hay overhead de dlopen/dlsym ni relocations dinámicas

---

## 2. Scheduling (Planificador)

### 2.1 Cooperative + Preemptive + Híbrido

La slide indica: *"Cooperativo + Preemptive + Híbrido"*.

**Contexto en §2.5 del temario FSO:**

Los algoritmos de scheduling se clasifican principalmente en:

| Tipo | Característica | Ejemplo |
|------|----------------|---------|
| **Cooperative (no preemptive)** | El proceso corre hasta que voluntariamente cede el CPU | Ventajas: simple, no overhead de cambios de contexto. Desventajas: un proceso malicioso puede monopolizar CPU |
| **Preemptive** | El SO puede interrumpir un proceso en cualquier momento (ej: quantum agotado) | Round Robin, Priority scheduling. Garantiza fairness |
| **Híbrido** | Combina ambos enfoques |

Zephyr permite configurar el scheduler según las necesidades de la aplicación:

- **Cooperative**: Los hilos cooperativos solo ceden el CPU cuando llaman a `k_yield()` o bloquean en una operación (ej: esperando un mutex). Hasta entonces corren indefinidamente. Útil para tareas de alta prioridad que no deben ser interrumpidas.

- **Preemptive**: Los hilos preemptivos pueden ser interrumpidos por hilos de mayor prioridad. Zephyr usa priority-based preemptive scheduling donde el hilo listo de mayor prioridad siempre corre.

- **Híbrido**: Es posible tener algunos hilos cooperativos y otros preemptivos en el mismo sistema.

**¿Por qué dar esta flexibilidad?** En sistemas embebidos de tiempo real, hay situaciones donde una tarea crítica no debe ser interrumpida (ej: handling de una interrupción de alta velocidad), pero otras tareas pueden usar scheduling preemptivo para garantizar respuesta a eventos.

### 2.2 SMP (Multi-core Simétrico)

La slide indica: *"SMP (multi-core simétrico)"*.

**Contexto en §1.3 del temario FSO (Multiprocesamiento):**

SMP significa que **múltiples CPUs (cores) comparten la misma memoria y ejecutan el mismo kernel**. Todas las CPUs son simétricas: no hay una CPU master controlando a las demás.

En Zephyr, SMP permite que el mismo kernel corra en múltiples cores, balanceando la carga de trabajo entre ellos. Los hilos pueden ejecutarse en cualquier core disponible, y el scheduler global coordina la distribución.

**Consideraciones para sistemas embebidos:**
- En microcontroladores, el número de cores típicos es 2-4 (ej: algunos STM32, NXP i.MX)
- La sincronización entre cores requiere atomic operations (ej: spinlocks) para evitar race conditions
- Zephyr soporta spinlocks para sincronización entre cores

### 2.3 AMP (Procesamiento Asimétrico)

La slide indica: *"AMP (procesamiento asimétrico via OpenAMP)"*.

**Contexto en §1.3 del temario FSO:**

A diferencia de SMP, en **AMP** cada core puede ejecutar un **sistema operativo diferente** o al menos una instancia de kernel diferente. Un caso típico es:
- **Core 0**: Ejecuta Zephyr (RTOS para tiempo real)
- **Core 1**: Ejecuta Linux (o algún otro OS para tareas de menor prioridad)

**OpenAMP** es el framework que Zephyr usa para implementar AMP. Permite comunicación entre los diferentes kernels corriendo en cores distintos mediante mecanismos como mailbox y shared memory.

**Aplicaciones típicas:**
- Procesamiento de sensores en tiempo real (Zephyr) + comunicación Wi-Fi (Linux)
- Safety-critical tasks (Zephyr) + user interface (Linux)
- Audio en tiempo real (Zephyr) + network stack (Linux)

### 2.4 Priority Inheritance

La slide indica: *"Priority inheritance — evita inversión de prioridad"*.

**¿Qué es el problema de inversión de prioridad?**

Es un problema clásico de sistemas operativos de tiempo real donde:
1. Un hilo de **baja prioridad** (L) bloquea un recurso (ej: mutex)
2. Un hilo de **alta prioridad** (H) quiere ese recurso pero debe esperar a que L lo libere
3. Mientras H espera, un hilo de **prioridad media** (M) preempt a L, retrasando aún más a H

```
Tiempo →
L (baja) tiene mutex
H (alta) quiere mutex → BLOQUEADA
M (media) corre → ocupa CPU

Resultado: H (la más importante) queda atrapada esperando a L, que a su vez no puede correr porque M la preemptó
```

**¿Cómo funciona Priority Inheritance?**

Cuando H se bloquea intentando adquirir el mutex que L holds, el mutex boosting mechanism eleva la prioridad de L al mismo nivel que H. Ahora M no puede preempt a L hasta que libere el mutex, permitiendo que H eventualmente获得 el recurso y complete su trabajo crítico.

Zephyr implementa este mecanismo para evitar inversiones de prioridad en sus primitivas de sincronización (mutexes, semaphores).

---

## 3. Modelo de Memoria

### 3.1 MPU-based Protection

La slide indica: *"MPU-based protection (sin MMU en la mayoría)"*.

**¿Qué es MPU?**

MPU = **Memory Protection Unit**. A diferencia de una MMU (Memory Management Unit) que provee memoria virtual completa con paginación, la MPU es un hardware más simple que permite definir **regiones de memoria con permisos**.

Una MPU típica permite configurar ~8-16 regiones con atributos como:
- Tamaño y dirección base
- Permisos: lectura, escritura, ejecución
- Puede ser accesible desde user mode, kernel mode, o ambos

**¿Por qué Zephyr usa MPU en lugar de MMU?**

La mayoría de los microcontroladores target de Zephyr (Cortex-M0, M3, M4, M7, RISC-V sin MMU) **no tienen MMU**. Implementar memoria virtual completa requiere:
- Tablas de páginas en memoria (overhead significativo: 4KB-16KB mínimo)
- TLB hardware (más complejo y costoso)
- Page fault handling en software
- Demand paging (necesita almacenamiento secundario)

En un microcontrolador con 32KB-256KB de RAM total, el overhead de MMU sería prohibitivo. La MPU proporciona protección básica con overhead mínimo.

**Conexión con §1.6 (Instrucciones Privilegiadas):**

Cuando un hilo corre en user mode, intentos de acceder a memoria fuera de sus regiones permitidas o ejecutar instrucciones privilegiadas generan excepciones (fault) que el kernel maneja. Las regiones del kernel están protegidas para que user mode no pueda accederlas.

### 3.2 User Mode + Kernel Mode

La slide indica: *"User mode + Kernel mode (privilege levels)"*.

**Contexto en §1.5 del temario FSO (Modo Dual):**

La mayoría de los procesadores modernos tienen al menos dos privilege levels:
- **Modo privilegiado (kernel/supervisor)**: Acceso completo a todos los recursos
- **Modo no privilegiado (user)**: Acceso limitado a memoria e instrucciones

En Zephyr:
- El kernel corre en modo privilegiado
- Los hilos de aplicación pueden correr en modo no privilegiado
- Intentos de ejecutar instrucciones privilegiadas desde user mode generan excepciones

**¿Por qué es útil user mode en sistemas embebidos?**

Even when hardware resources are constrained, user mode provides a layer of protection:
- Un bug en una aplicación no puede corromper estructuras críticas del kernel
- Malfunctioning application can be terminated without crashing entire system
- Facilita debugging y aislamiento de errores

### 3.3 Demand Paging

La slide indica: *"Demand paging (arquitecturas con MMU)"*.

**Contexto en §5 del temario FSO (Memoria Virtual):**

Demand paging es el mecanismo donde las páginas de memoria se cargan del disco a RAM solo cuando son referenciadas (page fault). Esto permite que un proceso use más memoria de la físicamente disponible.

En Zephyr, demand paging está disponible **solo en arquitecturas que tienen MMU** (ej: Cortex-A con MMU,某些 ARMv8-M implementations). En microcontroladores comunes (Cortex-M sin MMU), no hay demand paging.

**Nota:** Even where MMU exists, Zephyr's embedded nature means demand paging is typically limited to specific use cases like loading code from external flash storage into RAM for execution.

### 3.4 Heap, Memory Slabs, Memory Blocks

La slide indica: *"Heap, Memory Slabs, Memory Blocks"*.

Zephyr provee múltiples asignadores de memoria:

| Mecanismo | Descripción | Uso típico |
|-----------|-------------|------------|
| **Heap** | Asignador dinámico clásico (malloc/free) | Asignación de tamaño variable en tiempo de ejecución |
| **Memory Slabs** | Asignador de bloques de tamaño fijo pre-allocated | Sistemas de tiempo real donde no se tolera fragmentación |
| **Memory Blocks** | Sistema de bloques estructurados para asignación eficiente | Arrays de objetos del mismo tipo |

Los **Memory Slabs** son particularmente importantes en sistemas embebidos de tiempo real: al tener bloques de tamaño fijo pre-allocados, se evita la fragmentación que puede causar que malloc tarde tiempo impredecible en buscar espacio libre.

---

## 4. Arquitecturas Soportadas

### 4.1 Lista de Arquitecturas en la Slide

La slide muestra una grilla de 6 arquitecturas:
- **ARM**: Cortex-M, Cortex-R, Cortex-A
- **RISC-V**: 32 y 64-bit
- **x86**: 32 y 64-bit
- **ARC**: HS, EM (Argonaut RISC Core)
- **Nios II**: Soft-core de Altera/Intel
- **Xtensa**: Usado en ESP32

### 4.2 Más de 15 Arquitecturas

Según la documentación de Zephyr, las arquitecturas soportadas incluyen además:
- **MIPS** (32-bit)
- **SPARC** (particularmente LEON)
- Y más

### 4.3 +1,000 Boards y ~4 KB Footprint

La slide menciona: *"1,000+ boards • >15 arquitecturas • ~4 KB footprint mínimo"*.

**¿Por qué 4 KB es relevante?**

En sistemas embebidos con microcontroladores de recursos muy limitados:
- Un STM32F0 con 8KB RAM total
- Un PIC32 con 32KB RAM
- Un RISC-V de bajo costo con 16KB RAM

El kernel de Zephyr puede configurarse para ocupar tan solo ~4 KB de ROM y ~1 KB de RAM, permitiendo que el sistema completo quepa en estos dispositivos.

El **footprint** depende de:
- Features habilitados (solo scheduling básico vs full networking stack)
- Arquitectura target (ARM Cortex-M0 es más liviano que ARM Cortex-A)
- Nivel de optimización del compilador

---

## 5. Nota Académica de la Slide

La slide incluye: *"Zephyr como microkernel-like monolith — single address space elimina context switch (§1.4, §1.5) — contraste con Unix/Linux kernel tradicional"*.

### 5.1 Zephyr como Microkernel-like Monolith

**Conexión con §1.4 (Arquitecturas de SO):**

La definición clásica de kernel monolítico dice que todo corre en modo kernel. Zephyr técnicamente es un kernel monolítico porque kernel y aplicaciones comparten el mismo espacio de direcciones y corren en el mismo privilege level (a menos que se use MPU para aislamiento). Sin embargo, su diseño altamente modular lo hace filosóficamente similar a un microkernel:
- Los subsistemas pueden habilitarse/deshabilitarse en tiempo de compilación
- Drivers pueden compilarse fuera del kernel principal
- La configuración determina qué se incluye en el binario final

### 5.2 Single Address Space Elimina Context Switch

**Conexión con §1.5 (Modo Dual):**

En Linux/UNIX, una llamada al sistema implica:
1. Cambio de modo usuario → modo kernel (cambio de privilege level)
2. Cambio de stack (de stack de usuario a stack de kernel)
3. Cambio de contexto de CPU (guardar/restaurar registros)
4. Posiblemente cambio de espacio de direcciones (CR3 en x86)

En Zephyr con single address space, las llamadas al kernel son function calls directos, eliminando estos overheads.

### 5.3 Contraste con Unix/Linux

| Aspecto | Unix/Linux | Zephyr |
|---------|------------|--------|
| Arquitectura | Monolítico (tradicional) | Monolítico (microkernel-like) |
| Espacio de direcciones | Separado por proceso (MMU) | Compartido (single address space) |
| System calls | Trap + cambio de contexto | Function calls |
| Memoria virtual | Sí (MMU completo) | Opcional (demanding paging, arquitecturas con MMU) |
| Protección entre procesos | Tablas de páginas separadas | MPU (regiones) o ninguna |
| Tamaño típico | Megabytes a Gigabytes | Kilobytes (~4 KB mínimo) |
| Target | PCs, servidores | Microcontroladores, IoT |

---

## 6. Glosario de Términos

### Microkernel

**Definición:** Arquitectura de kernel donde el kernel solo implementa funcionalidades mínimas (scheduling, IPC básico, manejo de memoria bajo nivel) y los servicios restantes (filesystem, drivers, networking) corren como procesos de usuario.

**Ejemplos históricos:** MINIX, QNX, GNU Hurd

**Relación con Zephyr:** Zephyr técnicamente es un kernel monolítico unificado, pero su diseño modular y configurable lo acerca filosóficamente al concepto de microkernel. A diferencia de un microkernel tradicional, Zephyr no tiene comunicación entre procesos separada del espacio de direcciones compartido.

### MPU (Memory Protection Unit)

**Definición:** Hardware de protección de memoria que permite definir regiones de memoria con permisos específicos (lectura, escritura, ejecución). A diferencia de MMU, no provee memoria virtual con paginación.

**Uso en Zephyr:** La mayoría de los microcontroladores target de Zephyr no tienen MMU completo, por lo que la MPU es el mecanismo primario de protección entre hilos y entre user/kernel mode.

### Single Address Space

**Definición:** Modelo donde el kernel y todas las aplicaciones comparten el mismo espacio de direcciones de memoria. No hay separación de espacios de direcciones virtuales entre procesos.

**Implicancias:**
- System calls como function calls (sin context switch)
- Hilos pueden compartir punteros directamente
- Dependencia de MPU o software para aislamiento
- Sin memoria virtual entre procesos

### Preemptive Scheduling

**Definición:** Algoritmo de scheduling donde el sistema operativo puede interrumpir la ejecución de un proceso en cualquier momento (ej: cuando expire su quantum de tiempo) para dar CPU a otro proceso.

**Contexto en §2.5 del temario FSO:** A diferencia de scheduling cooperativo donde los procesos ceden voluntariamente el CPU, el scheduling preemptivo garantiza que ningún proceso monopolice la CPU y permite que procesos de alta prioridad sean atendidos con baja latencia.

### Priority Inheritance

**Definición:** Mecanismo para resolver el problema de inversión de prioridad donde un hilo de baja prioridad que sostiene un recurso compartido es elevado temporalmente a la prioridad del hilo de alta prioridad que lo espera, evitando que hilos de prioridad media preempt al primero.

### SMP (Symmetric Multiprocessing)

**Definición:** Arquitectura de multiprocesamiento donde múltiples CPUs idénticas comparten memoria y ejecutan el mismo sistema operativo. Todas las CPUs son simétricas; no hay CPU master/esclavo.

### AMP (Asymmetric Multiprocessing)

**Definición:** Arquitectura de multiprocesamiento donde cada CPU puede ejecutar un sistema operativo o kernel diferente. Típicamente usado para combinar un RTOS (tiempo real) con Linux (aplicaciones generales) en sistemas embebidos heterogéneos.

### OpenAMP

**Definición:** Framework open source para implementación de procesamiento asimétrico. Permite comunicación entre diferentes kernels (ej: Zephyr y Linux) corriendo en cores distintos de un sistema embebido.

### Demand Paging

**Definición:** Técnica de memoria virtual donde las páginas se cargan del almacenamiento secundario a memoria principal solo cuando son referenciadas, no todas al inicio del proceso.

**Conexión con §5 del temario FSO:** El page fault es la señal de que una página no está en RAM y debe cargarse. El algoritmo de reemplazo de páginas (FIFO, LRU, etc.) determina qué página victimizar para hacer lugar a la nueva.

### Kernel Monolítico

**Definición:** Arquitectura de SO donde todo (kernel, servicios, drivers, filesystem) corre en modo kernel con acceso total al hardware. Todo en un único proceso masivo.

**Contraste:** Microkernel tiene kernel mínimo y servicios en espacio de usuario.

---

## 7. Conexión con el Temario FSO

### §1.3 — Conceptos Fundamentales

| Concepto FSO | En Zephyr |
|--------------|-----------|
| Tarea/Proceso | **Thread**: concepto unificado desde v1.6 (fusionó fibers y tasks) |
| Programa | Código compilado estáticamente en el binario |
| Multiprogramación | Múltiples threads en memoria simultáneamente |
| Multitarea | Scheduling cooperativo/preemptive/híbrido |
| Multiprocesamiento | SMP y AMP soportados |

### §1.4 — Arquitecturas de SO

| Arquitectura FSO | Zephyr |
|-------------------|--------|
| Monolítico | Sí, kernel monolítico unificado |
| Por capas | No directamente (diseño plano) |
| Microkernel | Diseño "microkernel-like" pero técnicamente monolítico |
| Cliente-Servidor | Servicios del kernel no son servidores IPC separados |

### §1.5 — Modo Dual de Operación

| Concepto FSO | En Zephyr |
|--------------|-----------|
| Modo kernel | Hilos ejecutándose en privilege level privilegiado |
| Modo usuario | Hilos ejecutándose en modo no privilegiado, aislados por MPU |
| System call | Function call directo (no trap) |

### §1.6 — Instrucciones Privilegiadas

| Concepto FSO | En Zephyr |
|--------------|-----------|
| Instrucciones privilegiadas | Prohibidas en user mode, ejecutadas solo en kernel mode |
| MPU enforcement | MPU genera fault si user mode intenta acceder a regiones protegidas |

### §2.5 — Algoritmos de Scheduling

| Algoritmo FSO | En Zephyr |
|---------------|-----------|
| Cooperative | Sí, hilos cooperativos ceden CPU voluntariamente |
| Preemptive | Sí, hilos preemptivos pueden ser interrumpidos |
| Por prioridad | Sí, scheduling basado en prioridades |
| Round Robin | Implícito en scheduling preemptivo por prioridades |
| Priority inheritance | Sí, para evitar inversión de prioridad |

---

## 8. Resumen de Contenido de la Slide

La slide-05 presenta las características generales de Zephyr organizadas en:

1. **Arquitectura del Kernel**:
   - Kernel monolítico unificado (desde v1.6)
   - Single address space para kernel y aplicaciones
   - System calls como function calls (sin cambio de contexto)
   - Compilación estática con footprint mínimo (~4 KB)

2. **Scheduling**:
   - Cooperativo, preemptive e híbrido
   - SMP para multi-core simétrico
   - AMP basado en OpenAMP
   - Priority inheritance para evitar inversión de prioridad

3. **Modelo de Memoria**:
   - Protección vía MPU (Memory Protection Unit)
   - User mode y kernel mode (privilege levels)
   - Demand paging en arquitecturas con MMU
   - Heap, Memory Slabs y Memory Blocks

4. **Arquitecturas**:
   - Soporte para más de 15 arquitecturas: ARM, RISC-V, x86, ARC, Nios II, Xtensa, MIPS, SPARC
   - Más de 1,000 boards soportadas

---

## Fuentes Verificadas

- [Zephyr Project Official Site](https://www.zephyrproject.org)
- [Wikipedia — Zephyr (operating system)](https://en.wikipedia.org/wiki/Zephyr_(operating_system))
- [Zephyr Documentation — Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html)
- [Zephyr Documentation — Memory Management](https://docs.zephyrproject.org/latest/kernel/memory_management/index.html)
- [Intel Developer Article — Zephyr Story](https://www.intel.com/content/www/us/en/developer/articles/community/zephyr-story-how-became-self-sustaining-ecosystem.html)
- [Zephyr Turns 10 Announcement (Mar 2026)](https://www.zephyrproject.org/zephyr-turns-10-as-global-adoption-surges-and-long-term-embedded-use-expands/)