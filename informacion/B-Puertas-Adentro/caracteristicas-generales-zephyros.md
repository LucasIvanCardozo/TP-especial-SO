# Características Generales de Zephyr OS

> **Nota:** Este documento forma parte de la sección "Puertas Adentro" del Trabajo Práctico Especial de Fundamentos de Sistemas Operativos, enfocándose en las características técnicas internas de Zephyr OS.

---

## 1. ¿Qué tipo de sistema operativo es Zephyr?

Zephyr es un **Sistema Operativo de Tiempo Real (RTOS)** de código abierto, diseñado específicamente para sistemas embebidos con recursos restringidos (microcontroladores, dispositivos IoT, wearables, sistemas industriales).

Pertenece a la **Linux Foundation** y es gobernado por un Comité Directivo Técnico (TSC) con miembros de diversas empresas (Nordic Semiconductor, Intel, NXP, Renesas, Wind River, entre otros). Fue lanzado públicamente en **febrero de 2016** y se desarrolla bajo el modelo open source con gobernanza comunitaria.

**Fuente:** [Zephyr Project Official Site](https://www.zephyrproject.org)

---

## 2. Arquitectura General

### 2.1 Tipo de Kernel

Zephyr utiliza un **kernel monolítico unificado** (desde la versión 1.6, diciembre 2016).

- **Antes de v1.6**: Zephyr empleaba un diseño de **dual-kernel** compuesto por:
  - **Nanokernel**: Para dispositivos con recursos muy limitados.
  - **Microkernel**: Para dispositivos con más recursos.
  - Cada uno tenía API diferente y requería compilación separada.

- **Desde v1.6**: Se unificó en un **monolithic kernel** donde todas las funcionalidades (threads, sincronización, scheduling, drivers) están compiladas en un único binario estático. Los conceptos de "fibers" y "tasks" se fusionaron en un único concepto de **thread**.

> Esta unificación simplificó significativamente el desarrollo y portabilidad de aplicaciones entre diferentes plataformas de hardware.

**Fuente:** [Wikipedia — Zephyr OS](https://en.wikipedia.org/wiki/Zephyr_(operating_system))

### 2.2 Características Arquitectónicas Clave

| Característica | Descripción |
|---|---|
| **Single Address Space** | Todas las aplicaciones y el kernel comparten un único espacio de direcciones, simplificando la comunicación entre hilos y reduciendo overhead. |
| **Compilación estática** | Kernel y aplicaciones se compilan en un único binario estático. No hay dynamic loaders, lo que reduce la superficie de ataque y el tamaño del ejecutable. |
| **System calls** | Se implementan como **function calls** sin cambios de contexto, lo que las hace más eficientes que en sistemas con separación kernel/user clásica. |
| **Microkernel-like design** | Aunque es monolítico, la arquitectura está diseñada para ser altamente modular y configurable, permitiendo incluir o excluir subsistemas según las necesidades de la aplicación. |

**Fuente:** [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html), [Intel Developer Article](https://www.intel.com/content/www/us/en/developer/articles/community/zephyr-story-how-became-self-sustaining-ecosystem.html)

### 2.3 Modelo de Memoria

Zephyr ofrece un sistema de memoria sofisticado con múltiples mecanismos:

| Mecanismo | Descripción |
|---|---|
| **Heap Memory** | Asignador dinámico clásico (single heap y shared multi-heap para compartir regiones entre múltiples asignadores). |
| **Memory Slabs** | Asignador de bloques de tamaño fijo (similar a pools de memoria). |
| **Memory Blocks** | Sistema de bloques de memoria para asignación estructurada. |
| **Demand Paging** | Soporte para cargar páginas de memoria bajo demanda (en arquitecturas que lo soporten). |
| **Virtual Memory** | Soporte para memoria virtual en arquitecturas con MMU (ej: ARM con MMU). |
| **MPU-based protection** | En plataformas sin MMU completo, usa la **Memory Protection Unit** para aislar hilos y asignar regiones con atributos (solo lectura, ejecución prohibida, etc.). |
| **User Mode** | El kernel puede ejecutarse en modo privilegiado (kernel mode) y los hilos de aplicación pueden ejecutarse en modo no privilegiado (user mode), imponiendo restricciones a nivel de hardware. |

**Fuente:** [Zephyr Documentation — Memory Management](https://docs.zephyrproject.org/latest/kernel/memory_management/index.html)

---

## 3. Scheduling (Planificador)

El scheduler de Zephyr soporta múltiples políticas y configuraciones:

| Característica | Detalle |
|---|---|
| **Políticas de scheduling** | Cooperative, preemptive, y híbrido. El developer elige según las necesidades de la aplicación. |
| **Multi-threading** | Soporte completo de múltiples hilos de ejecución con prioridades. |
| **AMP (Asymmetric Multiprocessing)** | Basado en OpenAMP: permite ejecutar el kernel en múltiples procesadores de forma asimétrica (ej: un core para RTOS, otro para Linux). |
| **SMP (Symmetric Multiprocessing)** | Permite que el mismo kernel corra en múltiples CPUs simétricamente, balanceando carga entre cores. |
| **Prioridades** | Sistema de prioridades para hilos, con soporte para herencia de prioridad (priority inheritance) para evitar problemas de inversión de prioridad. |

**Fuente:** [Wikipedia — Zephyr OS](https://en.wikipedia.org/wiki/Zephyr_(operating_system)), [Zephyr Documentation](https://docs.zephyrproject.org/latest/kernel/)

---

## 4. Sistemas de Archivos

Zephyr implementa un **Virtual File System Switch (VFS)** que permite montar múltiples sistemas de archivos en diferentes puntos de montaje, con una API POSIX-like para operaciones de archivo.

| File System | Descripción |
|---|---|
| **LittleFS** | File system diseñado para sistemas embebidos con memoria flash. Tolerante a fallas, de bajo overhead, optimizado para escritura limitada. |
| **FAT FS** | Implementación de FatFS (by ChaN). Para sistemas de archivos estilo MSDOS. |
| **NVS (Non-Volatile Storage)** | Sistema de almacenamiento simple, pensado para guardar datos de configuración en memoria flash no volátil. |

**Fuente:** [Zephyr Documentation — File Systems](https://docs.zephyrproject.org/latest/services/storage/index.html)

---

## 5. Características de Seguridad

Zephyr tiene una arquitectura de seguridad elaborada:

| Característica | Descripción |
|---|---|
| **PSA Crypto API** | Implementación de Platform Security Architecture con cifrado, hashing, firmas digitales. Usa **mbedTLS** como implementación subyacente. |
| **Secure Storage** | Almacenamiento seguro basado en PSA. |
| **Memory Separation** | Particionado de memoria por hilos/grupos de hilos usando MPU. |
| **Stack Protection** | Protección contra stack overruns (disponible desde v1.9). |
| **User Mode** | Hilos pueden correr en modo no privilegiado, aislado del kernel. |
| **Secure Boot** | Soporte para cadenas de secure boot. |
| **Over-the-Air (OTA) Updates** | Actualización de firmware de dispositivos en campo. |
| **Security Subcommittee** | Comité dedicado exclusivamente a seguridad dentro del proyecto. |
| **OpenSSF Gold Badge** | Certificación de seguridad (obtenida en 2019). |
| **Code Reviews obligatorios** | Reviews obligatorios antes de merge de código. |
| **Static Code Analysis** | Análisis estático de código de forma periódica. |

**Fuente:** [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html)

---

## 6. Arquitecturas Soportadas (más de 15)

Zephyr soporta un conjunto amplio y diverso de arquitecturas de CPU:

| Familia | Arquitecturas específicas |
|---|---|
| **ARM** | Cortex-M, Cortex-R, Cortex-A (incluyendo ARMv6-M, ARMv7-M, ARMv8-M, ARMv7-R, ARMv8-A) |
| **RISC-V** | Diversas implementaciones RISC-V de 32 y 64 bits |
| **x86** | 32 bits y 64 bits (Intel, AMD) |
| **ARC** | Argonaut RISC Core (ARC HS, ARC EM) |
| **MIPS** | Versiones de 32 bits |
| **Nios II** | Processor soft-core de Altera/Intel |
| **SPARC** | Arquitectura SPARC (particularmente LEON) |
| **Xtensa** | Tensilica (usado en muchos SoCs como ESP32) |

> **Dato:** Zephyr soporta **más de 1,000 boards** diferentes, lo que lo convierte en uno de los RTOS con mayor soporte de hardware del mercado.

**Fuente:** [Zephyr Documentation — Board Porting](https://docs.zephyrproject.org/latest/hardware/porting/board_porting.html), [Zephyr Project Announcement (Mar 2026)](https://www.zephyrproject.org/zephyr-turns-10-as-global-adoption-surges-and-long-term-embedded-use-expands/)

---

## 7. Herramientas de Desarrollo

| Herramienta | Descripción |
|---|---|
| **Zephyr SDK** | Incluye toolchains para todas las arquitecturas soportadas, QEMU (emulación), y OpenOCD (debug). |
| **West** | Herramienta multi-propósito para gestión de repositorios, flashing de firmware, debugging, consola serie. |
| **CMake** | Sistema de build portable entre Linux, macOS y Windows. |
| **Kconfig** | Sistema de configuración en tiempo de compilación (similar a Linux kernel). |
| **Devicetree** | Descripción de hardware en tiempo de compilación, permite configurar pines, interrupts, clocks sin modificar código. |
| **Python** | Usado en scripts de build y herramientas auxiliares. |

**Fuente:** [Zephyr Documentation — Getting Started](https://docs.zephyrproject.org/latest/develop/getting_started/)

---

## 8. Conectividad y Stacks Wireless

Zephyr incluye stacks de conectividad integrados:

| Stack | Descripción |
|---|---|
| **Bluetooth Low Energy (BLE)** | Soporte completo BLE 4.x, 5.0, 5.1, 5.2 (incluyendo Long Range, 2M PHY, Coded PHY). |
| **Wi-Fi** | Soporte para dispositivos Wi-Fi (802.11 a/b/g/n/ac). |
| **Thread** | Protocolo mesh IPv6 de bajo consumo (basado en 802.15.4). |
| **802.15.4** | Stack inalámbrico de bajo consumo para IoT. |
| **LoRa** | Soporte para conectividad LoRa. |
| **Cellular** | Soporte para módulos celulares (LTE-M, NB-IoT). |
| **CAN Bus** | Controller Area Network para automatización industrial. |
| **Ethernet** | Soporte para conectividad Ethernet con Cable. |

> Esta integración de stacks wireless es una de las ventajas distintivas de Zephyr sobre competidores como FreeRTOS, que requiere agregar stacks manualmente.

**Fuente:** [Zephyr Documentation — Networking](https://docs.zephyrproject.org/latest/connectivity/)

---

## 9. Características Distintivas Más Importantes

### 9.1 Gobernanza Neutral (Linux Foundation)

A diferencia de FreeRTOS (Amazon AWS) o ThreadX (Microsoft/Eclipse Foundation), Zephyr no pertenece a un único vendor. La Linux Foundation provee un paraguas neutral que evita vendor lock-in, algo muy atractivo para empresas que no quieren depender de un solo proveedor.

### 9.2 Seguridad Robusta

Zephyr tiene un Security Subcommittee dedicado, actualizaciones de seguridad regulares, OpenSSF Gold Badge, yPSA Crypto integrado. En el mercado IoT donde la seguridad es cada vez más regulada, esto es un diferenciador clave frente a otros RTOS open source.

### 9.3 Portabilidad Extrema

Con más de 1,000 boards soportadas y más de 15 arquitecturas de CPU, Zephyr ofrece la mayor portabilidad de hardware entre los RTOS open source. El uso de Devicetree permite abstraer el hardware y portar aplicaciones entre diferentes microcontroladores con cambios mínimos.

### 9.4 Tamaño Mínimo (~4 KB)

El kernel puede compilarse en tan solo **4 KB de memoria**, lo que lo hace adequado para microcontroladores muy restringidos. El tamaño final depende de la configuración y features habilitados.

### 9.5 Long Term Support (LTS)

Zephyr ofrece versiones LTS (Long Term Support) con estabilidad asegurada por múltiples años. LTS3 es la versión actual, asegurando soporte extendido para productos con ciclos de vida largos (10-20 años, típicos en industrial y médico).

### 9.6 Plataforma Integrada vs. Biblioteca

Zephyr no es solo un scheduler: es una **plataforma** donde conectividad, filesystem, seguridad, y power management trabajan juntos desde el inicio. Esto diferencia a Zephyr de FreeRTOS (que es más una biblioteca que hay que configurar).

---

## 10. Resumen Técnico

| Aspecto | Detalle |
|---|---|
| **Tipo** | RTOS (Sistema Operativo de Tiempo Real) monolítico |
| **Licencia** | Apache License 2.0 |
| **Sponsor** | Linux Foundation (organización neutral, sin vendor lock-in) |
| **Origen** | Virtuoso RTOS (1990s) → Wind River Rocket (2015) → Zephyr (2016) |
| **Versión actual** | LTS3 activa en 2026 |
| **Kernel desde v1.6** | Monolithic kernel unificado |
| **Scheduling** | Cooperative, preemptive, híbrido — SMP y AMP soportados |
| **Memoria** | Heap, slabs, blocks, demand paging, virtual memory, MPU protection, user mode |
| **File Systems** | LittleFS, FAT FS, NVS (VFS con API POSIX-like) |
| **Arquitecturas** | >15 (ARM, RISC-V, x86, ARC, MIPS, Nios II, SPARC, Xtensa) |
| **Boards** | >1,000 |
| **Seguridad** | PSA Crypto, Secure Boot, Secure Storage, MPU, User Mode, OpenSSF Gold |
| **Conectividad** | BLE, Wi-Fi, Thread, 802.15.4, LoRa, Cellular, CAN, Ethernet |
| **Build system** | CMake + Kconfig + Devicetree + West |
| **Lenguaje** | C (kernel), Python (build scripts) |
| **Adopción** | 70% organizaciones NA, 62% Europa (2026), 3,000+ contribuyentes |

---

## Fuentes

- [Zephyr Project Official Site](https://www.zephyrproject.org)
- [Wikipedia — Zephyr (operating system)](https://en.wikipedia.org/wiki/Zephyr_(operating_system))
- [Zephyr Documentation](https://docs.zephyrproject.org/latest/)
- [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html)
- [Zephyr Memory Management](https://docs.zephyrproject.org/latest/kernel/memory_management/index.html)
- [Zephyr File Systems](https://docs.zephyrproject.org/latest/services/storage/index.html)
- [Intel Developer Article — Zephyr Story](https://www.intel.com/content/www/us/en/developer/articles/community/zephyr-story-how-became-self-sustaining-ecosystem.html)
- [Zephyr Turns 10 Announcement (Mar 2026)](https://www.zephyrproject.org/zephyr-turns-10-as-global-adoption-surges-and-long-term-embedded-use-expands/)
- ["A Brief History of Zephyr RTOS" — Shawn Hymel](https://shawnhymel.com/2791/a-brief-history-of-zephyr-rtos/)

## Nota Académica — Fundamentos de SO

**Conceptos de la materia relacionados:**

- **§1.4 — Arquitectura de SO (Monolítico vs Microkernel)**: Zephyr utiliza un **kernel monolítico unificado** desde su versión 1.6, pero con un diseño **microkernel-like** altamente modular y configurable. Esto contrasta con la definición clásica de monolítico: en Zephyr los subsistemas pueden incluirse o excluirse en tiempo de compilación, lo que lo acerca al espíritu de microkernel sin su overhead de comunicación entre procesos.

- **§1.4 — Multiprocesamiento (SMP y AMP)**: Zephyr soporta tanto **SMP** (Symmetric Multiprocessing) donde el mismo kernel corre en múltiples CPUs balanceando carga, como **AMP** (Asymmetric Multiprocessing) basado en OpenAMP, donde diferentes cores pueden ejecutar kernels distintos (ej: un core para RTOS, otro para Linux). Esto ilustra las dos arquitecturas de multiprocesamiento vistas en la materia.

- **§1.3 — Proceso vs Programa y Multitarea**: Zephyr fusionó los conceptos de "fibers" y "tasks" en un único concepto de **thread**, unificando lo que en otros RTOS son hebras cooperativas y preemptivas. El scheduler ofrece políticas cooperativas, preemptivas e híbridas, ejemplificando cómo la multitarea se implementa en sistemas embebidos con recursos limitados.

- **§1.5 — Modo Dual (Kernel vs Usuario)**: Zephyr implementa **User Mode** donde los hilos de aplicación pueden ejecutarse en modo no privilegiado, aislados del kernel mediante MPU. Esto refleja el concepto de modo dual visto en clase, donde el hardware impone restricciones a nivel de rings/privileges.

- **§1.6 — Instrucciones Privilegiadas**: La separación User Mode/Kernel Mode en Zephyr se enforced por hardware mediante MPU (Memory Protection Unit). Las instrucciones que manipulan recursos protegidos solo pueden ejecutarse en modo privilegiado (kernel mode), siguiendo el modelo de instrucciones privilegiadas vs no privilegiadas de la materia.

- **§1.8 — Llamadas al Sistema**: Zephyr implementa system calls como **function calls** sin cambios de contexto, lo que las hace más eficientes que en sistemas con separación kernel/user clásica. Este es un diseño atípico que combina la simplicidad de llamada a función con la protección de modo dual.