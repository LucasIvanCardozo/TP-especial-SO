# 3. Características Generales del Kernel

## Comparación: Zephyr OS vs MOSIX

| Aspecto | Zephyr OS | MOSIX |
|---------|-----------|-------|
| **Tipo de kernel** | Híbrido monolítico configurable | Kernel Linux extendido (módulo + daemon) |
| **Arquitectura** | Single Address Space (kernel y apps comparten espacio de direcciones) | Single System Image (SSI) — cluster presentado como un único sistema |
| **Modelo de ejecución** | RTOS para dispositivos embebidos | Sistema operativo distribuido para clusters |
| **Footprint mínimo** | ~16 KB RAM (nanokernel histórico ~4 KB) | N/A (requiere máquinas Linux completas) |
| **SMP** | Soporta hasta 4 cores con spinlocks | Múltiples nodos con scheduler distribuido |
| **Protección de memoria** | MPU (Memory Protection Unit) — ~8-16 regiones | Basado en protección nativa de Linux |

---

### Zephyr OS

Zephyr utiliza un **kernel monolítico unificado** (desde v1.6) donde todas las funcionalidades — scheduling, drivers, filesystem, networking — operan en modo kernel. Sin embargo, su diseño es altamente modular: los subsistemas pueden incluirse o excluirse en tiempo de compilación mediante Kconfig, acercándose a la filosofía de un microkernel sin el overhead de comunicación entre procesos.

Su característica distintiva es el **Single Address Space**: kernel y aplicaciones comparten el mismo espacio de direcciones. Esto permite que las system calls sean llamadas a función C directas, sin trap ni cambio de contexto, logrando overhead mínimo. La protección se logra mediante MPU, ya que la mayoría de los microcontroladores target (Cortex-M0/M3/M4/M7, RISC-V sin MMU) no poseen MMU completa.

El scheduling combina **cooperative + preemptive** en un esquema priority-based preemptive: los hilos de mayor prioridad pueden interrumpir a los de menor prioridad. Implementa además priority inheritance para evitar problemas de inversión de prioridad.

Orientado a **tiempo real (RTOS)**, soporta cooperative multitasking, preemptive scheduling, y cuenta con soporte AMP (procesamiento asimétrico) via OpenAMP.

---

### MOSIX

MOSIX (*Multi-Operating System Intellect System*) funciona como una **capa sobre el kernel Linux existente**, no lo reemplaza. Su arquitectura se compone de un módulo de kernel que intercepta syscalls relacionadas con procesos y memoria, más un daemon en espacio de usuario que maneja descubrimiento automático de nodos, comunicación inter-nodos, monitoreo de recursos y decisiones de balanceo de carga.

Su paradigma central es la **migración preemptiva de procesos**: mover un proceso en ejecución de un nodo a otro de forma transparente, transfiriendo contexto completo de CPU y espacio de memoria. El sistema decide dónde ejecutar cada proceso basándose en velocidad de CPU, carga actual, memoria disponible y patrones de comunicación inter-procesos.

Implementa **Memory Ushering**, un mecanismo de migración proactiva de memoria que detecta nodos con poca memoria libre y migra procesos antes de que ocurra out-of-memory — análogo a un "swapping distribuido" a nivel de cluster.

El modelo de cluster es **SSI (Single System Image)**: el usuario ve un único sistema computacional aunque el cluster esté físicamente distribuido. El scheduler distribuido balancea la carga entre nodos automáticamente.

Usa un modelo **shared-nothing**: cada nodo tiene memoria local, sin memoria compartida entre nodos. Limitaciones importantes: no soporta threads ni memoria compartida, y los procesos multi-threaded no pueden migrar.

---

# 4. Sistema de Archivos

## Comparación: Zephyr OS vs MOSIX

| Aspecto | Zephyr OS | MOSIX |
|---------|-----------|-------|
| **Arquitectura** | VFS como capa de abstracción central | DFSA (Distributed File System Adapter) como capa de interposición |
| **FS propios** | LittleFS, FAT FS, NVS | No posee FS propio — delega a FS locales |
| **FS subyacentes** | Flash interna, SD card, USB | ext3, ext4, XFS, NFS, ext2 (todos basados en i-nodos) |
| **Modelo de datos** | Log-structured (LittleFS), tabla FAT, clave-valor (NVS) | Journaling con i-nodos |
| **Permisos UNIX** | No — sin permisos UNIX clásicos | POSIX completo |
| **Coherencia** | Por FS individual (local) | Consistente dentro del cluster via DFSA |

---

### Zephyr OS

Zephyr implementa un **Virtual File System (VFS)** como capa de abstracción que oculta las diferencias entre los distintos sistemas de archivos y provee una API estilo POSIX (`fs_open()`, `fs_read()`, `fs_write()`, `fs_mkdir()`). Sin embargo, **no es POSIX compliant**: faltan funciones como `fcntl()`, `flock()`, `mmap()` y no hay memoria virtual ni aislamiento entre procesos.

Los tres sistemas de archivos disponibles son:

- **LittleFS**: sistema de archivos log-structured diseñado para flash interna. Opera escribiendo al final del log (nunca sobrescribe directamente), con garbage collection que compacta datos. Soporta wear leveling automático distribuido por todo el storage y tolerancia a power loss mediante transacciones atómicas y CRC. RAM mínima ~2 KB fija.

- **FAT FS** (FatFs de ChaN): para tarjetas SD y USB. Soporta FAT12/16/32/exFAT pero carece de wear leveling y no es tolerant a pérdidas de energía. **Nunca usar en flash interna.**

- **NVS** (Non-Volatile Storage): almacenamiento clave-valor para datos de configuración. Datos identificados por ID numérico (no nombre de archivo), sin estructura de directorios. Implementa wear leveling propio.

No hay soporte para symbolic ni hard links. El modelo de permisos es inexistente — similar a DOS.

---

### MOSIX

MOSIX **no proporciona su propio sistema de archivos distribuido**. En cambio, **DFSA** (*Direct File System Access*) actúa como capa de interposición que intercepta syscalls de archivos (`open`, `read`, `write`, `close`, etc.) y las redirige al nodo donde el archivo reside físicamente.

Cuando un proceso migrado realiza una operación de archivo, DFSA determina si el archivo está en el nodo actual o en otro nodo del cluster. Si está en otro nodo, redirige la operación por red de forma transparente. Las aplicaciones ven operaciones locales aunque el archivo esté en otro nodo; no se requieren prefijos especiales de ruta.

Cada nodo mantiene su **FS local** (ext3, ext4, XFS, NFS, ext2), todos basados en i-nodos. MOSIX no crea su propia estructura de datos en disco — delega la gestión de archivos a los sistemas locales.

**Limitaciones importantes**: no es un parallel filesystem — cada archivo reside en un solo nodo, sin striping. No hay paralelismo de E/S: si un archivo está en Nodo A, todas las operaciones pasan por Nodo A. La latencia de red puede convertirse en cuello de botella. No hay memoria compartida distribuida via FS, y los enlaces (simbólicos y hard) no cruzan límites de nodo.

En resumen, Zephyr resuelve el desafío de almacenamiento en dispositivos embebidos limitados con múltiples FS especializados para cada tipo de medio, mientras que MOSIX abstrae el acceso a archivos distribuidos en un cluster Linux existente mediante interposición de syscalls.