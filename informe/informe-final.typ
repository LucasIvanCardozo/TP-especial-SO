// ============================================
// TRABAJO PRÁCTICO ESPECIAL
// Evaluación de Productos: Zephyr OS vs MOSIX
// ============================================

// Preámbulo
#let font-body = "Times New Roman"
#let font-sans = "Arial"
#let font-mono = "Courier New"

// Colores
#let header-bg = rgb(30, 80, 140)
#let alt-row = rgb(245, 245, 245)

#set document(
  title: "Trabajo Práctico Especial: Zephyr OS vs MOSIX",
  author: "ARRIAGA, Mario Esteban · BELLONE, Martín · BISCAY, Federico Javier · CALLA ALIENDE, Federico · CARDOZO, Lucas",
  date: datetime(year: 2026, month: 6, day: 3),
)

#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  header: context {
    if counter(page).at(here()).first() > 1 {
      align(right, text(font: font-sans, 9pt, fill: gray)[
        Fundamentos de Sistemas Operativos — TP Especial
      ])
    }
  },
  footer: context {
    if counter(page).at(here()).first() > 1 {
      align(center, text(font: font-sans, 9pt, fill: gray)[
        Universidad Nacional de Mar del Plata — Página #counter(page).display()
      ])
    }
  },
)

#set text(
  font: font-body,
  size: 11pt,
  lang: "es",
)

#set par(
  justify: true,
  first-line-indent: 1.5em,
  leading: 0.65em,
)

#set heading(numbering: "1.")

#show heading: it => {
  set text(header-bg)
  it
}

// Helper para fill de tablas
#let table-fill(row, col) = {
  if row == 0 { header-bg }
  else {
    if col == 0 { rgb(220, 220, 220) }  // Primera columna más oscura para texto blanco
    else {
      if calc.even(row) { alt-row }
      else { white }
    }
  }
}

// Reglas para evitar huérfanos: que títulos no queden solos al final de página
// Esto previene que un subtítulo (===) quede solo al final de página

// Primera columna de tablas con texto blanco y alineamiento izquierda
#show table.cell.where(x: 0): it => {
  set text(fill: white)
  it
}

// ============================================
// CARÁTULA
// ============================================

#align(center)[
  #v(1.5cm)
  #text(font: font-sans, size: 12pt, weight: "bold")[
    FUNDAMENTOS DE SISTEMAS OPERATIVOS 2026
  ]
  #v(0.3cm)
  #text(font: font-sans, size: 11pt, weight: "bold")[
    FACULTAD DE INGENIERÍA — UNIVERSIDAD NACIONAL DE MAR DEL PLATA
  ]
  #v(1.5cm)
  #text(font: font-sans, size: 20pt, weight: "bold", fill: header-bg)[
    Trabajo Práctico Especial
  ]
  #text(font: font-sans, size: 16pt, weight: "regular")[
    Evaluación de Productos
  ]
  #v(1cm)
  #text(font: font-sans, size: 22pt, weight: "bold", fill: header-bg)[
    Zephyr OS vs MOSIX
  ]
  #v(2cm)
  #box(stroke: 1pt, inset: 0.5cm)[
    #text(font: font-sans, size: 11pt, weight: "bold")[Integrantes:]
    #v(0.2cm)
    #text(font: font-sans, size: 11pt)[
      ARRIAGA, Mario Esteban 
      BELLONE, Martín 
      BISCAY, Federico Javier 
      CALLA ALIENDE, Federico 
      CARDOZO, Lucas
    ]
    #v(0.5cm)
    #text(font: font-sans, size: 11pt)[Fecha de presentación: 3 de Junio de 2026 — 13:30 hs]
  ]
  #v(2cm)
  #text(font: font-sans, size: 9pt, fill: gray)[
    Documento elaborado para el Trabajo Práctico Especial de Fundamentos de Sistemas Operativos
    #linebreak()
    Universidad Nacional de Mar del Plata — Mayo 2026
  ]
]

#pagebreak()

// ============================================
// ÍNDICE
// ============================================

#outline(title: "Índice", depth: 3)
#pagebreak()

// ============================================
// 1. INTRODUCCIÓN
// ============================================

= 1. Introducción

Este informe compara #strong("Zephyr OS") (RTOS para IoT embebido, ~16 KB RAM mínimo, Linux Foundation) y #strong("MOSIX") (sistema de clustering HPC nacido en 1977 en la Hebrew University of Jerusalem). Aunque responden a problemáticas radicalmente distintas —dispositivos restringidos vs. clusters de cientos de nodos—, la comparación ilustra cómo diferentes dominios generan soluciones arquitectónicas opuestas.

El objetivo es presentar un análisis técnico objetivo que permita comprender las fortalezas y debilidades de cada producto desde la perspectiva de consultores de infraestructura, evaluando tanto sus merits técnicos como su viabilidad comercial en el mercado actual.

// ============================================
// 2. LA EMPRESA
// ============================================

= 2. La Empresa

== 2.1 Zephyr OS — Linux Foundation

#strong("Origen:") Febrero 2016. Wind River donó el kernel de Rocket RTOS (originado en Virtuoso RTOS, adquirido a Eonic Systems en 2001) a la Linux Foundation. Miembros fundadores: Intel, Wind River, Synopsys, NXP.

#strong("Gobernanza:") Technical Steering Committee (TSC) + Governing Board con representantes de miembros corporativos.

#strong("Respaldo (2025-2026):") Platinum/Gold: Qualcomm, CARIAD (VW), Renesas, ZEISS, Analog Devices, Silicon Labs, Wind River, Antmicro. Silver: Nordic, Google, Meta, STMicroelectronics, Texas Instruments, Espressif, Arduino, Canonical, Microchip, Infineon.

#strong("Mercado:") IoT, microcontroladores de 32-bit (~16 KB RAM mínimo), wearables, industrial, dispositivos médicos, transporte, energía renovable.

#strong("Modelo:") Código abierto, Apache 2.0, 3,000+ contribuyentes, 1,000+ boards (ARM Cortex-M, RISC-V, x86, ARC).

== 2.2 MOSIX — Hebrew University of Jerusalem

#strong("Origen:") 1977, Prof. Amnon Barak. Cronología:

- 1977-1979: PDP-11/45 con Unix v6 (primera migración de procesos)
- 1981-1983: MOS (antecesor), cluster de 5 PDP-11
- 1988-1989: primer "MOSIX" de 16 nodos
- 1999: transición a Linux
- 2001: se vuelve propietario
- 2002: openMosix (fork GPL, discontinuado 2008)
- 2014: MOSIX-4 (funciona como módulo sin parche de kernel)
- Oct 2017: último release MOSIX-4.4.4

#strong("Gobernanza:") Investigador principal único. Sin Governing Board. MOSIX es marca registrada.

#strong("Respaldo:") Académico (71+ publicaciones, ~1,662 citas). Sin soporte comercial.

#strong("Mercado:") HPC, clusters científicos, grids, Single System Image (SSI).

#strong("Modelo:") Propietario restrictivo (prohíbe modificación, ingeniería reversa, obras derivadas). No es open source.

#pagebreak(weak: true)
== Síntesis

#table(
  columns: (auto, 1fr, 1fr),
  stroke: 0.5pt,
  align: (left, left, left),
  fill: table-fill,
  inset: (x: 0.3cm, y: 0.15cm),
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Aspecto],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Zephyr OS],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[MOSIX],
  [Organización], [Linux Foundation], [Hebrew University of Jerusalem],
  [Origen], [2016], [1977],
  [Tipo], [Código abierto comercial], [Investigación académica],
  [Licencia], [Apache 2.0 (permisiva)], [Propietaria restrictiva],
  [Segmento], [IoT, embebidos, wearables], [HPC, clusters, grids],
  [Estado], [Activo (LTS3, 2026)], [Inactivo desde 2017],
)

// ============================================
// 3. CARACTERÍSTICAS GENERALES
// ============================================

= 3. Características Generales

#table(
  columns: (auto, 1fr, 1fr),
  stroke: 0.5pt,
  align: (left, left, left),
  fill: table-fill,
  inset: (x: 0.3cm, y: 0.15cm),
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Aspecto],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Zephyr OS],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[MOSIX],
  [Tipo de kernel], [Híbrido monolítico configurable], [Extensión de kernel Linux (módulo + daemon)],
  [Arquitectura], [Single Address Space], [SSI — cluster como único sistema],
  [Modelo], [RTOS para dispositivos embebidos], [Sistema operativo distribuido para clusters],
  [Footprint mínimo], [~16 KB RAM], [N/A (requiere máquinas Linux completas)],
  [Protección], [MPU (8-16 regiones)], [Protección nativa de Linux por nodo],
)

#v(0.5em)

#strong("Zephyr OS:") Kernel monolítico unificado (desde v1.6). Single Address Space: syscalls son llamadas a función C directas sin trap ni cambio de contexto. Scheduling: cooperative + preemptive priority-based. Soporte AMP via OpenAMP.

#strong("MOSIX:") Capa sobre kernel Linux existente. Módulo de kernel que intercepta syscalls + daemon en espacio de usuario. Paradigma: #strong("migración preemptiva de procesos") (mover proceso en ejecución de un nodo a otro transparentemente). #strong("Memory Ushering"): migración proactiva de memoria antes de OOM (swapping distribuido a nivel de cluster). Modelo #strong("shared-nothing"): cada nodo memoria local independiente. No soporta threads ni memoria compartida entre nodos.

// ============================================
// 4. SISTEMA DE ARCHIVOS
// ============================================

= 4. Sistema de Archivos

#table(
  columns: (auto, 1fr, 1fr),
  stroke: 0.5pt,
  align: (left, left, left),
  fill: table-fill,
  inset: (x: 0.3cm, y: 0.15cm),
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Aspecto],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Zephyr OS],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[MOSIX],
  [Arquitectura], [VFS (capa de abstracción central)], [DFSA (Distributed File System Adapter)],
  [FS propios], [LittleFS, FAT FS, NVS], [No posee — delega a FS locales],
  [FS subyacentes], [Flash interna, SD card, USB], [ext3, ext4, XFS, NFS, ext2],
  [Permisos UNIX], [No], [POSIX completo],
)

#v(0.5em)

#strong("Zephyr OS:") VFS estilo POSIX pero #strong("no es POSIX compliant") (faltan fcntl, flock, mmap). Tres FS:

- #strong("LittleFS"): log-structured para flash interna, write-always (nunca sobrescribe), garbage collection, wear leveling automático, tolerancia a power loss (transacciones atómicas + CRC). RAM mínima ~2 KB.
- #strong("FAT FS"): para SD y USB. Sin wear leveling, no tolerant a power loss. #emph[No usar en flash interna.]
- #strong("NVS"): clave-valor para configuración, datos por ID numérico, sin estructura de directorios, con wear leveling propio.

No soporta symbolic/hard links. Modelo de permisos inexistente (similar a DOS).

#strong("MOSIX:") No provee FS distribuido propio. #strong("DFSA") intercepta syscalls y redirige al nodo donde reside el archivo. Cada nodo mantiene su FS local. Limitaciones: no es parallel filesystem (archivo en un solo nodo), sin striping, latencia de red como cuello de botella, enlaces no cruzan límites de nodo.

// ============================================
// 5. ADMINISTRACIÓN DE MEMORIA
// ============================================

= 5. Administración de Memoria

== Zephyr OS

#strong("MPU vs MMU:") Usa #strong("MPU") en microcontroladores ARM Cortex-M y RISC-V embebido. Define 8-16 regiones con permisos separados (lectura/escritura/ejecución). #strong("No traduce direcciones"): dirección virtual = física. Acceso fuera de región permitida genera excepción. MMU solo en plataformas avanzadas (Cortex-A, x86, RISC-V de aplicación) para memoria virtual y paginación.

#strong("Modelo de memoria plana:") Single Address Space: kernel y apps comparten espacio. Aislamiento mediante #strong("Memory Domains") (colección de particiones que define acceso por thread) y #strong("Partitions") (regiones contiguas con atributos).

#strong("Regiones:") KERNEL (modo privilegiado: .text, .rodata, .data/.bss, stack interrupciones), APPLICATION (user mode con MPU), DRAM/PERIFÉRICOS (heap, stacks, devices). Tipo Normal (con caché) o Device (sin caché).

#strong("Asignadores:") k_heap (sincronizado multi-thread), sys_heap (sin sincronización, combina bloques adyacentes, buckets por tamaño, O(1) 1-200 ciclos), Memory Slabs (tamaño fijo, O(1)), k_malloc/k_free (system heap, configurable, cero por defecto).

#strong("Sin swap:") No hay swap ni memoria virtual en microcontroladores. Recursos definidos en compilación; thrashing no ocurre.

== MOSIX

#strong("Modelo shared-nothing:") Cada nodo memoria física independiente y autónoma. Sin memoria compartida entre nodos. Cuando agota memoria, migra procesos completos a otros nodos (no swapping a disco).

#strong("Memory Ushering:") Detecta proactivamente nodos con memoria baja y migra procesos #strong("antes") de contención severa. Flujo: monitoreo con umbrales críticos → identificación de nodo con memoria disponible → selección de proceso → transferencia por red (heap, stack, código, datos) → continuación en destino.

#strong("Checkpoint/Restart:") Serializa estado completo: PCB (PID, estado, PC, registros, scheduling, descriptores), imagen de memoria completa. En destino: recrea espacio de direcciones, carga registros, reanuda ejecución.

#strong("Limitaciones:") No soporta memoria compartida (ni POSIX shm_open ni System V shmget/shmat). Sin DSM. Procesos gigabytes toman minutos en migrar. debe evaluar si costo de migración supera beneficio.

#pagebreak(weak: true)
== Comparación

#table(
  columns: (auto, 1fr, 1fr),
  stroke: 0.5pt,
  align: (left, left, left),
  fill: table-fill,
  inset: (x: 0.3cm, y: 0.15cm),
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Aspecto],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Zephyr OS],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[MOSIX],
  [Hardware], [Microcontroladores], [Clusters de PCs],
  [Protección], [MPU (regiones fijas)], [Aislamiento por nodo],
  [Memoria virtual], [Solo con MMU], [No (migración de procesos)],
  [Swap], [No hay], [No hay (migración)],
  [Dynamicidad], [Estática (compilación)], [Dinámica (ejecución)],
  [Thrashing], [No ocurre], [Memory Ushering previene],
)

// ============================================
// 6. ADMINISTRACIÓN DEL PROCESADOR
// ============================================

= 6. Administración del Procesador

== Zephyr OS

#strong("Threads como unidad:") Cada thread tiene propio stack y contexto, comparte espacio de direcciones con kernel y otros threads. k_thread = PCB simplificado (stack pointer, prioridad, estado, área de stack).

#strong("Estados:") READY (en run queue), RUNNING (ejecutándose), SLEEPING (bloqueado), TERMINATED, SUSPENDED.

#strong("Políticas:") Cooperative (prioridad negativa, retiene CPU hasta que libere voluntariamente) y Preemptive (prioridad no negativa, desalojo por prioridad mayor).

#strong("Priority-based sin Round Robin:") Sin time-slicing, sin quantum. Determinismo > equidad. Consecuencias: starvation posible, sin fair sharing entre igual prioridad.

#strong("Syscalls como function calls:") No hay int 0x80 ni cambio de modo usuario/kernel. Thread de usuario llama función API wrapper → verifica punteros → transfiere control al kernel → retorna.

#strong("Priority inheritance:") Evita inversión de prioridad (eleva temporalmente prioridad de hilo bloqueante).

== MOSIX

#strong("Migración preemptiva como scheduler distribuido:") Extiende administración a cluster completo. Ciclo: serializa checkpoint (PCB, memoria, archivos abiertos, sockets, señales) → transfiere por red → reconstruye en destino → continúa desde punto de serialización.

#strong("Load balancing multi-paramétrico:") Evalúa simultáneamente velocidad de CPU, carga actual, memoria disponible, latencia de red, número de cores. Algoritmo adaptativo: nodos intercambian estadísticas, detectan desbalances, migran preemptivamente sin que la aplicación lo perciba.

#strong("Scheduler de tres niveles:") Largo plazo (colocación inicial), medio plazo (memory ushering), corto plazo (evaluación continua de migración).

#strong("SSI:") Cluster presentado como única máquina con N CPUs lógicas. Aplicaciones sin modificaciones ni recompilación.

#strong("Evitación del efecto convoy:") Detecta procesos CPU-bound que monopolizan un nodo y los migra a nodos menos cargados.

#strong("Limitaciones:") No soporta memoria compartida ni threads POSIX. Procesos grandes generan tráfico significativo.

#pagebreak(weak: true)
== Comparación

#table(
  columns: (auto, 1fr, 1fr),
  stroke: 0.5pt,
  align: (left, left, left),
  fill: table-fill,
  inset: (x: 0.3cm, y: 0.15cm),
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Aspecto],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Zephyr OS],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[MOSIX],
  [Unidad], [Thread (contexto liviano)], [Proceso completo (PCB)],
  [Niveles scheduler], [Solo corto plazo], [Largo + medio + corto],
  [Algoritmo], [Priority-based puro], [Balanceo multi-paramétrico],
  [Time slicing], [No tiene], [No tiene],
  [Objetivo], [Determinismo, latencia mínima], [Throughput global de cluster],
)

// ============================================
// 7. SEGURIDAD
// ============================================

= 7. Seguridad

== Zephyr OS

#strong("Aislamiento por MPU:") Código/Flash: Read + Execute, No Write. RAM: Read + Write, No Execute. Periféricos: Read + Write, No Execute. Configuración solo en modo privilegiado.

#strong("Modo dual:") Kernel mode (privilegiado) y User mode (no privilegiado, restricciones MPU activas, trap en instrucciones privilegiadas).

#strong("ARM TrustZone:") Secure World (criptografía, claves, root of trust) y Non-Secure World (aplicaciones normales).

#strong("Criptografía:") PSA Crypto API con backend mbedTLS. TLS 1.2 mínimo obligatorio (versiones anteriores rechazadas por vulnerabilidades). Configuraciones predefinidas para TLS 1.2 con AES-CCM, CoAP/DTLS.

#strong("Secure Boot + MCUboot:") Cadena: Hardware (RoT immutable) → ROM Bootloader → MCUboot → Zephyr Kernel + Apps. MCUboot usa RSA-2048, RSA-3072, ECDSA P-256. A/B partitioning para actualizaciones atómicas con rollback. Contador de imágenes previene rollback a versiones vulnerables.

#strong("Stack protection:") Canaries entre buffers y return addresses (verificados antes de cada retorno/context switch). Regiones de stack no-ejecutables (MPU_XN).

#strong("Modelo de permisos:") No DAC ni RBAC. Aislamiento: separación kernel/user via MPU, memory domains, filtrado de syscalls.

#strong("Certificaciones:") OpenSSF Gold Badge (2018-03-10): 90% statement coverage, 80% branch coverage, auditoría NCC Group (2020), two-person code review. Gold Badge mantenido y actualizado hasta 2024-06-05.

== MOSIX

#strong("Confianza mutua requerida:") Todos los nodos deben ser mutuamente confiables. Sin mecanismo para verificar integridad de nodos ni aislar procesos de nodos no-confiables.

#strong("Sandboxing a nivel de kernel:") LKM en modo privilegiado dentro del kernel de Linux. Intercepta syscalls → si son peligrosas, bloquea/redirige; si no, pasa al kernel normal.

#strong("Procesos guest:") Puede ejecutar código normalmente, usar CPU/memoria asignada, acceder archivos del nodo origen (via DFSA). No puede acceder archivos locales del nodo host, modificar configuración del SO host, instalar software o cargar módulos, ver procesos del nodo host, ni ejecutar syscalls peligrosas (mount, chroot, ptrace, syslog).

#strong("Checkpoint/Restart:") Transfiere UID efectivo/real, GIDs, capabilities, directorio de trabajo, descriptores, umask, límites, señales, estado de memoria. #strong("Crítico:") archivos de checkpoint #strong("no cifrados por defecto") — contienen toda la memoria (contraseñas, claves en texto claro).

== Comparación

#table(
  columns: (auto, 1fr, 1fr),
  stroke: 0.5pt,
  align: (left, left, left),
  fill: table-fill,
  inset: (x: 0.3cm, y: 0.15cm),
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Aspecto],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Zephyr OS],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[MOSIX],
  [Aislamiento], [Hardware (MPU)], [Lógico (kernel module)],
  [Criptografía], [PSA Crypto + mbedTLS + Secure Boot], [No disponible],
  [Verificación firmware], [Firmas asimétricas + rollback protection], [No disponible],
  [Control de acceso], [MPU regions (sin DAC/RBAC)], [UID unificado + permisos locales],
  [Confianza en nodos], [N/A (dispositivo único)], [Requerida en todos],
  [Multi-tenant], [Compatible], [Incompatible],
  [Certificaciones], [OpenSSF Gold Badge (2018-2024)], [No aplica],
)

// ============================================
// 8. FACILIDADES PARA DESARROLLADORES
// ============================================

= 8. Facilidades para Desarrolladores

== Zephyr OS

#strong("West (meta-build tool):") Gestiona repositorios Git múltiples, build, flash y debug en Python. west init -l myapp, west update, west build -b board, west flash, west debug.

#strong("CMake + KConfig:") CMake genera archivos nativos (Ninja por defecto), cross-compilation nativa, multiplataforma, integración IDE. KConfig genera macros `CONFIG_X` para compilación condicional.

#strong("Device Tree:") Archivos .dts describen periféricos, direcciones, pines, IRQs. Mismo driver funciona en Nordic nRF52840, STM32, ESP32 sin cambios.

#strong("API POSIX-like:") open/close/read/write, socket/bind/listen/accept/connect, select/poll. Por qué no POSIX completo: memoria limitada en microcontroladores.

#strong("Zephyr SDK:") GCC/Binutils/GDB, LLVM/Clang, QEMU (emulación), OpenOCD (debugging JTAG/SWD), Ninja.

#strong("Documentación:") docs.zephyrproject.org — Getting Started, API Reference (Doxygen), Kernel Guide, Security, Samples. GitHub Discussions, Discord, mailing lists.

== MOSIX

#strong("Compatibilidad POSIX total:") No modifica interfaz de syscalls. Se inserta a nivel del scheduler, interceptando decisiones de migración después de que el kernel procesó las llamadas. Aplicaciones compilan/linkitan como en Linux normal.

#strong("ELF estándar:") Acepta ejecutables ELF directamente, sin conversión ni flags especiales. Migración transparente.

#strong("mosrun:") Marca PCB como "migrable". Scheduler monitorea carga y migra automáticamente. mosrun -k 8 ./aplicacion (-k maxjobs limita jobs concurrentes).

#strong("Herramientas:") mosmon (monitor en tiempo real), mosps (lista procesos en todos los nodos), mostat (estadísticas de nodos). Acceden via /proc/hpc.

#strong("SLURM:") Puede funcionar con SLURM (60%+ de Top500). Integración no nativa, requiere configuración manual.

#strong("Limitaciones:") Threads no migran automáticamente. Memoria compartida no soportada. Pipes/sockets funcionan; message queues/semaphores variables.

== Comparación

#table(
  columns: (auto, 1fr, 1fr),
  stroke: 0.5pt,
  align: (left, left, left),
  fill: table-fill,
  inset: (x: 0.3cm, y: 0.15cm),
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Facilidad],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Zephyr OS],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[MOSIX],
  [Build system], [West + CMake + Ninja], [Standard gcc/Linux],
  [Configuración], [KConfig + Device Tree], [mosrun + configuración de nodo],
  [API del SO], [Subconjunto POSIX], [POSIX completa],
  [Debugging], [GDB + OpenOCD (JTAG/SWD)], [GDB estándar Linux],
  [Docs], [Exhaustiva (docs.zephyrproject.org)], [Limitada],
)

// ============================================
// 9. PUERTAS AFUERA
// ============================================

= 9. Puertas Afuera

== 9.1 Difusión y Presencia

#table(
  columns: (auto, 1fr, 1fr),
  stroke: 0.5pt,
  align: (left, left, left),
  fill: table-fill,
  inset: (x: 0.3cm, y: 0.15cm),
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Aspecto],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Zephyr OS],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[MOSIX],
  [Adopción], [3,000+ contribuidores en 70+ países], [Inactiva desde 2017],
  [Plataformas], [1,000+ boards (ARM/RISC-V/x86/MIPS/ARC/SPARC)], [Clusters universitarios históricos],
  [Backing], [Intel, Nordic, Renesas, NXP, Wind River], [Ninguno (académico)],
  [Eventos], [Open Source Summit, Embedded World, Zephyr Developer Summit], [Papers académicos (1998-2010)],
  [Productos comerciales], [Vestas, Google Chromebook, Oticon More, Framework Laptop, GARDENA], [Cero casos modernos],
  [Tendencia], [69% organizaciones planea aumentar uso], [Inactivo desde oct 2017],
)

== 9.2 Soporte a Usuarios

#table(
  columns: (auto, 1fr, 1fr),
  stroke: 0.5pt,
  align: (left, left, left),
  fill: table-fill,
  inset: (x: 0.3cm, y: 0.15cm),
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Aspecto],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Zephyr OS],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[MOSIX],
  [Documentación], [Completa y actualizada], [Desactualizada desde 2017],
  [Comunidad], [Discord (miles), GitHub Discussions, mailing lists], [Prácticamente inactiva],
  [Soporte comercial], [Disponible via miembros + Wind River Rocket], [No disponible],
  [Seguridad], [Security Subcommittee, parches a LTS (10-20 años)], [Zero parches desde +8 años],
  [Training], [Training Partners autorizados], [No disponible],
)

== 9.3 Casos de Uso

#table(
  columns: (auto, 1fr, 1fr),
  stroke: 0.5pt,
  align: (left, left, left),
  fill: table-fill,
  inset: (x: 0.3cm, y: 0.15cm),
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Dominio],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Zephyr OS],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[MOSIX],
  [IoT y sensotización industrial], [[OK] Ideal], [[NO] Inactivo],
  [Wearables y dispositivos médicos], [[OK] Oticon More, HealthyPi Move], [[NO] No aplica],
  [Microcontroladores de 32-bit], [[OK] ARM Cortex-M/RISC-V/x86], [[NO] No aplica],
  [Tiempo real embebido], [[OK] Determinístico, tickless], [[NO] No aplica],
  [Clusters HPC académico], [[NO] No es target], [[WARNING] Histórico (1999-2010)],
  [HPC producción], [[NO] No es target], [[NO] Inactivo — usar SLURM/Kubernetes],
)

== 9.4 Costos y Licenciamiento

#table(
  columns: (auto, 1fr, 1fr),
  stroke: 0.5pt,
  align: (left, left, left),
  fill: table-fill,
  inset: (x: 0.3cm, y: 0.15cm),
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Aspecto],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Zephyr OS],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[MOSIX],
  [Licencia], [Apache 2.0 (permisiva)], [Propietaria restrictiva],
  [Código fuente], [Completo en GitHub], [No disponible],
  [Costo de entrada], [Cero], [Histórico: ~61,141 USD (año 2000)],
  [Costo por unidad], [Cero sin regalías], [Desconocido (inactivo)],
  [Soporte comercial], [Opt-in via miembros, Wind River Rocket], [No disponible],
  [Viabilidad 2026], [[OK] Activo con sponsors múltiples], [[NO] Inactivo desde 2017],
)

// ============================================
// 10. COMPARATIVA TÉCNICA
// ============================================

= 10. Comparativa Técnica

#table(
  columns: (auto, 1fr, 1fr),
  stroke: 0.5pt,
  align: (left, left, left),
  fill: table-fill,
  inset: (x: 0.3cm, y: 0.15cm),
  text(font: font-sans, size: 9pt, fill: white, weight: "bold")[Aspecto],
  text(font: font-sans, size: 9pt, fill: white, weight: "bold")[Zephyr OS],
  text(font: font-sans, size: 9pt, fill: white, weight: "bold")[MOSIX],
  [Tipo], [RTOS embebido], [Cluster OS / HPC],
  [Segmento], [IoT, wearables, microcontroladores], [HPC, grids académicos],
  [Licencia], [Apache 2.0], [Propietaria restrictiva],
  [RAM mínima], [~16 KB], [N/A],
  [Arquitectura], [Híbrido monolítico], [Extensión de kernel Linux],
  [Sistema de archivos], [VFS con LittleFS, FAT FS, NVS], [DFSA (no tiene FS propio)],
  [Gestión de memoria], [MPU + Memory Domains + User Mode], [Shared-nothing + Memory Ushering],
  [Scheduling], [Preemptive / Cooperative / Híbrido], [Migración preemptiva entre nodos],
  [Tiempo real], [Sí (RTOS determinístico)], [No],
  [Migración de procesos], [No aplica], [Sí — transparente preemptiva],
  [Seguridad], [MPU + TrustZone + PSA Crypto + OpenSSF Gold], [Sandboxing + checkpoint (sin crypto)],
  [Conectividad], [BLE, Wi-Fi, Thread, 802.15.4, LoRa, Cellular, CAN], [Ethernet, InfiniBand histórico],
  [Herramientas], [West, CMake, KConfig, Device Tree, QEMU], [mosrun, mosmon, mosps, mostat],
  [Comunidad], [Activa (3,000+ contribuyentes)], [Inactiva desde oct 2017],
  [Soporte comercial], [Sí (Nordic, Intel, NXP, Renesas, Wind River)], [No],
  [Última versión], [LTS3 (2026)], [MOSIX-4.4.4 (oct 2017)],
  [Competidores], [FreeRTOS, NuttX, RT-Thread, RIOT OS], [SLURM, Kubernetes, OpenMPI, PBS],
)

#v(0.5em)

== Análisis

#strong("Comparación inherentemente \"injusta\":") No son competidores directos. Zephyr compite con FreeRTOS/NuttX (RTOS para microcontroladores); MOSIX competía con SLURM/PBS Professional (schedulers de cluster HPC).

#table(
  columns: (auto, 1fr, 1fr),
  stroke: 0.5pt,
  align: (left, left, left),
  fill: table-fill,
  inset: (x: 0.3cm, y: 0.15cm),
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Dimensión],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Zephyr OS],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[MOSIX],
  [Qué administra], [Un microcontrolador individual], [Un cluster de múltiples computadoras],
  [Problema], [Tiempo real en IoT embebido], [HPC en clusters],
  [Target hardware], [Microcontroladores (4 KB - 2 MB RAM)], [Clusters de PCs (64 GB - TB por nodo)],
  [Escala], [Un dispositivo], [Cientos de nodos],
  [Migración], [No], [Sí],
)

#strong("Valor pedagógico:") La comparación tiene valor académico, no para selección de producto. Ilustra cómo diferentes dominios generan soluciones radicalmente diferentes, y revela la importancia de factores no técnicos: gobernanza, licencia open source, comunidad activa vs. licencia propietaria y abandono.

#strong("Progresión histórica:") MOSIX (1999-2017) → SLURM (2003-presente) → Kubernetes (2014-presente).

// ============================================
// 11. CONCLUSIONES Y RECOMENDACIONES
// ============================================

= 11. Conclusiones y Recomendaciones

== 11.1 Conclusiones

=== Zephyr OS (2026)

Solución moderna, activa y bien respaldada para IoT embebido. 70% organizaciones en Norteamérica, 62% en Europa, 69% planeando aumentar uso.

#strong("Fortalezas técnicas:")

1. #strong("Gobernanza neutral multisponsor:") Linux Foundation con TSC (Nordic, Intel, NXP, Renesas, Wind River). Elimina vendor lock-in.
2. #strong("Seguridad robusta para IoT regulado:") PSA Crypto API + mbedTLS, secure boot chains, secure storage, MPU con user mode, Security Subcommittee, OpenSSF Gold Badge (2018-2024).
3. #strong("Conectividad wireless integrada:") BLE, Wi-Fi, Thread, 802.15.4, LoRa, Cellular, CAN bus en el kernel.
4. #strong("Portabilidad extrema:") 1,000+ boards, 15+ arquitecturas CPU. Device Tree abstrae hardware.
5. #strong("LTS para largo ciclo:") LTS3 estabilidad por años, ideal para productos industriales/médicos (10-20 años).

#v(0.3em)
#strong[Factores Clave de Éxito — Segmento IoT/Industrial/Médico:]

Desde la perspectiva de consultoría de infraestructura, los factores que determinan el éxito de un RTOS en el mercado IoT actual son:

#v(0.2em)

- #strong("Cyber-Resiliencia:") En mercados regulados (dispositivos médicos IEC 62304, automotor ISO 26262, industrial IEC 61508), la certificación de seguridad independiente (OpenSSF Gold Badge) no es un atributo técnico sino una #strong("barrera comercial crítica"). Reduce el costo y tiempo de auditoría regulatoria porque un tercero independiente (NCC Group, 2020) ya verificó el código.

- #strong("Soporte a largo plazo (LTS):") Los productos IoT industriales y médicos tienen ciclos de vida de 10 a 20 años. La versión LTS3 de Zephyr garantiza parches de seguridad backporteados durante este período. Esto se traduce en #strong("reducción del costo total de propiedad") porque no hay necesidad de redesignar hardware o re-certificar cada 2-3 años.

- #strong("Vendor independence:") La gobernanza neutral de la Linux Foundation elimina el riesgo de que un proveedor específico discontinúe el proyecto. Competidores como FreeRTOS (Amazon) o ThreadX (Microsoft) presentan riesgo de lock-in.

- #strong("Eficiencia de conectividad:") La integración nativa de múltiples protocolos wireless (BLE, Wi-Fi, Thread, 802.15.4, LoRa, Cellular) en el kernel elimina la necesidad de desarrollar drivers propietarios, reduciendo time-to-market.

=== MOSIX

Enfoque académico interesante pero sin evolución desde 2017. Último release: MOSIX-4.4.4 (oct 2017).

#strong("Valor académico:")

1. #strong("Pionero en migración preemptiva (1977-presente):") Primero en demostrar funcionalmente migración preemptiva en clusters Linux (1999), 40+ años innovating.
2. #strong("SSI completo:") Cluster como único sistema lógico — precursor del cloud computing moderno.
3. #strong("Memory Ushering:") Algoritmo de migración proactiva antes de OOM, enseñado en cursos de sistemas distribuidos.
4. #strong("Moraleja:") Evolución hacia SLURM/Kubernetes demuestra cómo soluciones pragmáticas superan a "perfectas pero frágiles".

#v(0.3em)
#strong[Desde la perspectiva de consultoría de infraestructura:]

La adopción de MOSIX en producción representa un #strong("riesgo crítico inaceptable") por las siguientes razones:

#v(0.2em)

- #strong("Ausencia absoluta de parches de seguridad desde hace 8 años:") Vulnerabilidades conocidas (CVEs) en kernels Linux y en el propio módulo MOSIX no serán corregidas. En 2026, vulnerabilidades tipo Spectre/Meltdown y sus variantes siguen siendo relevantes. No existe forma de mitigar porque el código es propietario y el desarrollador original no está activo.

- #strong("Riesgo regulatorio en mercados sensibles:") Para HPC en instituciones financieras, hospitals o gubernamentales, usar software sin soporte activo puede ser un blocker para certificación de seguridad corporativa o cumplimiento regulatorio.

- #strong("Licenciamiento propietario restrictivo:") La licencia prohíbe modificación, ingeniería reversa y obras derivadas. Esto impide la auditoría independiente del código del módulo de kernel y limita cualquier adaptación a necesidades específicas.

- #strong("Costo de negociación impredecible:") Cualquier modificación o soporte requiere negociar con la Hebrew University of Jerusalem. En 2026, esto representa un costo y timeline de negociación no predecible.

- #strong("Checkpoint files sin cifrado:") Archivos de checkpoint contienen memoria completa del proceso (contraseñas, claves API en texto claro). En un entorno multi-tenant esto es una vulnerabilidad crítica.

#v(0.3em)
#strong("Valor histórico confirmado:") La existencia de MOSIX demuestra que la migración preemptiva transparente es técnicamente viable. Sin embargo, la historia también demuestra que la licencia propietaria sin gobernanza comunitaria lleva al abandono. SLURM y Kubernetes heredaron el concepto sin las restricciones de licenciamiento.

== 11.2 Recomendaciones

=== 1. Proyectos IoT/embebido: Zephyr OS

#strong("Por qué:") Tiempo real determinístico, footprint mínimo (~16 KB), desarrollo activo (3,000+ contribuidores), gobernanza neutral, LTS para 10-20 años.

#strong("Casos:") Productos IoT ciclos largos, dispositivos médicos/industriales regulados, múltiples protocolos wireless, portabilidad cross-vendor.

=== 2. Estudio académico de clustering: MOSIX

#strong("Para aprender:") Migración preemptiva de procesos, Single System Image (precursor de Kubernetes), Memory Ushering, por qué murió (licencia propietaria + falta de gobernanza = abandono).

=== 3. NO usar MOSIX en producción

#strong("Razones:") Abandonado desde 2017, sin security patches, sin soporte, sin seguridad moderna, propietario (no auditable, no extensible).

=== 4. Matriz de Decisión

#align(center)[
```
¿Real-time embebido con footprint mínimo?
+-- Sí + ¿Sin MMU? → [OK] ZEPHYR
`-- No → ¿Para qué?
         +-- HPC producción → SLURM / Kubernetes
         +-- Estudio académico → MOSIX
         `-- Otras necesidades → Alternativas según caso
```
]

#table(
  columns: (auto, auto),
  stroke: 0.5pt,
  align: (left, left),
  fill: table-fill,
  inset: (x: 0.3cm, y: 0.15cm),
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Si necesitás...],
  text(font: font-sans, size: 10pt, fill: white, weight: "bold")[Recomendación],
  [Producto IoT comercial (2026+)], [Zephyr OS],
  [Seguridad robusta + conectividad], [Zephyr OS],
  [Largo ciclo vida producto industrial], [Zephyr OS (LTS3)],
  [Portabilidad cross-vendor], [Zephyr OS],
  [Prototipo rápido, equipo sin experiencia], [FreeRTOS o RIOT OS],
  [Aprender conceptos de clustering histórico], [MOSIX (estudio)],
  [Proyecto HPC real en 2026], [SLURM o Kubernetes],
  [Certificaciones pre-existentes (IEC 61508, ISO 26262)], [ThreadX],
)

== 11.3 Síntesis Final y Factores Decisivos por Segmento

#strong("Como cierre, desde la perspectiva de consultoría de infraestructura, los factores más importantes en cada segmento de mercado son:")

#v(0.5em)

#strong("En el mercado IoT embebido (2026+):")

El factor más importante es la #strong("Cyber-Resiliencia y el mantenimiento a largo plazo"). Los dispositivos IoT industriales y médicos requieren:

- Parches de seguridad garantizados por 10-20 años (ciclos de vida del producto)
- Certificación independiente verificable (OpenSSF Gold Badge)
- Gobernanza neutral que evite vendor lock-in
- Ecosistema de conectividad nativa (BLE, Wi-Fi, Thread, 802.15.4, LoRa)

#strong("Zephyr gana por goleada en este segmento.") Su versión LTS3, su OpenSSF Gold Badge mantenido hasta 2024, su gobernanza neutral en la Linux Foundation, y su integración nativa de protocolos wireless lo convierten en la opción correcta para productos IoT que necesitan longevity y compliance regulatorio.

#v(0.5em)

#strong("En el mercado HPC (Clusters de producción):")

El factor más importante es el #strong("Throughput, la escalabilidad de red y el soporte de contenedores modernos"). Los clusters HPC actuales requieren:

- Soporte activo con parches de seguridad ongoing
- Integración con schedulers estándares (SLURM, PBS)
- Compatibilidad con el ecosistema de contenedores (Docker, Kubernetes)
- Auditoría de código posible (open source o license que permita review)

#strong("MOSIX quedó obsoleto porque no compite en estos factores.") Su overhead de red en contextos de migración completa, su falta de integración con Kubernetes/Docker, su licencia propietaria restrictiva, y su abandono desde 2017 lo descalifican completamente para HPC de producción en 2026. El paradigma actual de contenedores y microservicios dejó atrás su modelo de migración preemptiva de procesos.

#v(0.5em)

#align(center)[
  #text(font: font-body, size: 12pt, style: "italic", fill: header-bg)[
    "No existe 'el mejor sistema operativo' — existe 'el correcto para tu problema'."
  ]
]

#v(0.5em)

- #strong("Zephyr para productos IoT reales en 2026:") comunidad activa, documentación completa, soporte comercial, seguridad robusta, LTS para largo ciclo.
- #strong("MOSIX para estudio académico:") valor histórico en migración preemptiva y SSI, no recomendado para producción moderno.

La viabilidad comercial depende tanto de factores organizacionales (governanza, comunidad, soporte) como de mérito técnico.

// ============================================
// 12. BIBLIOGRAFÍA
// ============================================

#pagebreak()
= 12. Bibliografía

#strong("Fuentes Oficiales Zephyr:")

- Zephyr Project Documentation: https://docs.zephyrproject.org/
- Zephyr GitHub Repository: https://github.com/zephyrproject-rtos/zephyr
- Zephyr Introduction (RAM mayor igual 16KB): https://docs.zephyrproject.org/latest/introduction/index.html
- Zephyr Security Overview: https://docs.zephyrproject.org/latest/security/security-overview.html
- Linux Foundation Research "Zephyr at 10" (marzo 2026): https://www.linuxfoundation.org/research/zephyr-turns-10
- OpenSSF Best Practices Gold Badge: https://www.bestpractices.dev/projects/74/gold (última actualización 2024-06-05)

#strong("Fuentes MOSIX:")

- MOSIX Official Site: http://www.mosix.org/
- MOSIX Distributions & Licensing: https://mosix.cs.huji.ac.il/txt_distributions.html
- Hebrew University CS Department: https://www.cs.huji.ac.il/
- USENIX 2000 Historical Pricing: "Historical price documented in USENIX 2000 proceedings"

#strong("Publicaciones:")

- Prof. Amnon Barak (~1,662 citas en sistemas distribuidos)
- MOSIX Administrator's Guide (histórico)
- MOSIX White Papers (histórico)

#strong("Recursos de Desarrollo:")

- Device Tree Specification
- PSA Crypto API Documentation (Arm): https://developer.arm.com/architectures/security-architectures/platform-security-architecture
- OpenAMP Framework

#strong("Información de Mercado y Competidores:")

- Linux Foundation Members List (2025-2026): https://www.linuxfoundation.org/members
- SLURM Workload Manager: https://slurm.schedmd.com/
- Top500 Supercomputers List: https://www.top500.org/

#v(1em)
#align(center)[
  #text(font: font-sans, size: 9pt, fill: gray)[
    Nota: Todas las fuentes web consultadas en mayo 2026.
    #linebreak()
    #linebreak()
    *Documento elaborado para el Trabajo Práctico Especial de Fundamentos de Sistemas Operativos*
    *Universidad Nacional de Mar del Plata — Mayo 2026*
    #linebreak()
    *Grupo: ARRIAGA, Mario Esteban; BELLONE, Martín; BISCAY, Federico Javier;*
    *CALLA ALIENDE, Federico; CARDOZO, Lucas.*
  ]
]
