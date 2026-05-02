# Slide-01: Portada — Explicación Detallada

## Resumen de Elementos en Pantalla

La slide-01.js corresponde a la **portada del Trabajo Práctico Especial de Evaluación** que compara dos sistemas operativos: **Zephyr OS** y **MOSIX**. Es una presentación académica institucional de la Universidad Nacional de Mar del Plata para la materia Fundamentos de Sistemas Operativos.

### Elementos Visuales Identificados

| Elemento | Descripción | Código Fuente |
|----------|-------------|---------------|
| **Franja lateral izquierda** | Barra vertical azul Zephyr (#0070C5) de 0.15" de ancho, recorriendo todo el alto | `theme.accentZephyr` |
| **Tarjeta central blanca** | Bloque rectangular blanco (9" × 2.8") con sombra sutil (blur:3, offset:2, angle:45, opacity:0.15) | `fill: { color: theme.white }` |
| **"EVALUACIÓN DE PRODUCTOS"** | Título superior en azul Zephyr, Arial 32pt bold, espaciado de caracteres 4, centrado | `slide.addText("EVALUACIÓN DE PRODUCTOS", ...)` |
| **"Zephyr OS vs MOSIX"** | Título principal en negro (#2D3237), Arial Black 52pt bold, centrado | Producto principal siendo comparado |
| **"Trabajo Práctico Especial de Evaluación"** | Subtítulo en gris (#4C5155), Calibri 18pt, centrado | Propósito del documento |
| **Línea divisoria** | Barra horizontal gris claro (#D1D3D5) de 3" centrada en x=3.5, h=0.03" | Separador visual |
| **"Fundamentos de Sistemas Operativos"** | Nombre de la materia, Calibri 16pt italic, gris | Contexto académico |
| **"Universidad Nacional de Mar del Plata"** | Universidad, Calibri 14pt, gris | Institution |
| **Integrantes** | "ARRIAGA • BELLONE • BISCAY • CALLA ALIENDE • CARDOZO" en Calibri 11pt, espaciado 1 | Grupo de trabajo |
| **Fecha** | "3 de Junio — 13:30 hs" en azul Zephyr bold | Fecha de presentación |
| **Barra inferior** | Dos franjas superpuestas: azul (#0070C5) 0.175" + azul claro (#66A9DC) 0.075" | Efecto degradado |

---

## Contexto Académico y Profesional

### La Universidad y la Materia

La **Universidad Nacional de Mar del Plata** (UNMDP) es una universidad pública argentina. La materia **Fundamentos de Sistemas Operativos** es una materia de grado que cubrimos los siguientes temas según el temario oficial (§1 a §5):

- **§1 — Introducción**: Qué es un SO, generaciones, arquitecturas (monolítica, microkernel, capas), modo dual kernel/usuario, instrucciones privilegiadas, interrupciones, system calls
- **§2 — Administración del Procesador**: Scheduling, estados de proceso, PCB, algoritmos FCFS/SJF/Round Robin/prioridades, quantum óptimo, dispatcher
- **§3 — Sistemas de Archivos**: i-nodos, FAT, métodos de acceso, asignación contigua/enlazada/indexada, directorios, enlaces
- **§4 — Administración de Memoria**: MFT, MVT, paginación, segmentación, fragmentación interna/externa, compactación
- **§5 — Memoria Virtual**: Page faults, algoritmos de reemplazo FIFO/LRU/OPT, Thrashing, Working Set, anomalía de Belady

### Objetivo del Trabajo Práctico Especial

Este TP Especial consiste en una **evaluación comparativa de productos** entre dos sistemas operativos radicalmente diferentes:

1. **Zephyr OS** — RTOS open source para sistemas embebidos (microcontroladores IoT), nacido en 2016 bajo Linux Foundation
2. **MOSIX** — Sistema operativo de cluster para HPC (supercomputadoras), desarrollado desde 1977 en Hebrew University, estado inactivo desde 2017

La comparación es desafiante precisamente porque son productos de categorías distintas: Zephyr compite con FreeRTOS y ThreadX en el mercado de microcontroladores; MOSIX competía con SLURM y Kubernetes en clusters HPC. La diapositiva de portada establece esta dualidad desde el primer momento.

---

## Zephyr OS: Contexto del Producto (Referencia Cruzada con Investigación)

### Qué es Zephyr OS

**Zephyr OS** es un sistema operativo de tiempo real (RTOS) open source diseñado para sistemas embebidos con recursos restringidos. Es hosted bajo la **Linux Foundation** (organización neutral sin fines de lucro fundada en 2000 por Eric S. Raymond y Bruce Perens).

### Linaje Técnico

| Período | Evento | Relevancia |
|---------|--------|------------|
| **Finales de los '90** | **Eonic Systems** (Bélgica) desarrolla **Virtuoso RTOS** para DSPs | Origen del código |
| **2001** | **Wind River Systems** (creadora de VxWorks) adquiere Eonic Systems | El código pasa a Wind River |
| **2009** | Intel adquiere Wind River por ~$884M | Contexto corporativo |
| **Nov 2015** | Wind River abre el código de Virtuoso como **Rocket RTOS** (libre de regalías, cabía en 4 KB) | Apertura del código |
| **Feb 2016** | Wind River dona Rocket kernel a Linux Foundation → nace **Zephyr Project** | Nacimiento oficial |
| **Dic 2016** | Lanzamiento de **Zephyr v1.6** — unificación del nanokernel + microkernel en un solo kernel | Arquitectura unificada |
| **2017-2026** | Crecimiento continuo: 1000+ boards, 3000+ contribuyentes, 10 años de operación | Estado actual |

### Características Fundamentales

- **Licencia**: Apache License 2.0 (permisiva, no copyleft, sin regalías)
- **Arquitectura**: Monolítica unificada (desde v1.6, diciembre 2016 — previamente nanokernel + microkernel separados)
- **Memoria**: Requiere tan poco como **4 KB** (versiones mínimas) hasta varios MB según configuración
- **Target**: Microcontroladores (MCU), sistemas IoT, wearables, dispositivos médicos, industrial
- **Placas soportadas**: >1,000 boards, >15 arquitecturas (ARM, RISC-V, x86, etc.)
- **Conectividad**: BLE, Wi-Fi, Thread, 802.15.4, LoRa, Cellular, CAN bus
- **Seguridad**: PSA Crypto API, Secure Boot (MCUboot), Secure Storage, OpenSSF Gold Badge (desde 2019)
- **Miembros corporativos**: Qualcomm, CARIAD (Volkswagen), Renesas, ZEISS, Analog Devices, Silicon Labs, Wind River, Antmicro

### Productos Comerciales que Usan Zephyr

- Vestas Wind Turbines (energía eólica)
- Framework Laptop 13 DIY (notebook modular)
- Google Chromebook (componentes embedded)
- Oticon More (audífono recargable avanzado)
- HealthyPi Move (dispositivo médico ECG)
- GARDENA smart Irrigation Control (riego inteligente)
- Tenstorrent Blackhole (acelerador PCIe AI)

### Adopción Global (2026)

Según Linux Foundation Research ("Zephyr Turns 10", marzo 2026):
- **70%** de organizaciones en Norteamérica usan Zephyr en productos comerciales
- **62%** en Europa
- **69%** planea aumentar adopción
- **52%** da soporte por 5-10+ años
- >3,000 contribuyentes globales

### Gobernanza

Zephyr opera bajo un modelo estructurado:
- **Governing Board**: Define políticas y estrategia (Chair: Abitzen Xavier, Silicon Labs)
- **Technical Steering Committee (TSC)**: Decisiones técnicas (Chair: Anas Nashif, Intel)
- **Security Committee**: Supervisa seguridad (Chair: David Brown, Linaro)

---

## MOSIX: Contexto del Producto (Referencia Cruzada con Investigación)

### Qué es MOSIX

**MOSIX** (Multi-Operating System UNIX) es un sistema operativo de cluster para computación de alto rendimiento (HPC), desarrollado como proyecto de investigación académica por el **Grupo de Investigación en Sistemas Distribuidos** de la **Hebrew University of Jerusalem**, Israel, bajo liderazgo del **Prof. Amnon Barak**.

### Linaje Técnico

| Período | Evento | Relevancia |
|---------|--------|------------|
| **1977-1979** | MOS (Version 0) en PDP-11/45 + PDP-11/10 (Unix v6) — primeros experimentos de migración de procesos | 43 años de historia |
| **1981-1983** | MOS (Version 1) — primer sistema operativo multicomputadora funcional | Evolución técnica |
| **1987-1988** | NSMOS en NS32332 — puerto a arquitectura National Semiconductor | Cambio de plataforma |
| **1988-1989** | **MOSIX** — primer sistema con el nombre actual, cluster de 16 nodos NS32532 | Nomenclatura definitiva |
| **1991-1993** | MOSIX v6 en BSD/OS — cluster de 8 equipos 486 + 32 Pentium PCs con Myrinet | Expansión a x86 |
| **1998-1999** | MOSIX v7 en Linux 2.2 — primera versión Linux, cluster de 64 nodos | Transición a Linux |
| **2001** | MOSIX se vuelve **propietario** (se cierra el código) | Cambio de modelo |
| **2002** | Moshe Bar crea **openMosix** como fork open source | Respuesta comunitaria |
| **2014** | MOSIX-4 — ya no requiere parche de kernel (funciona como módulo) | Cambio arquitectural |
| **24 Oct 2017** | **MOSIX-4.4.4** — último release oficial | Fin del desarrollo |
| **Post-2017** | Proyecto **inactivo** — sin actualizaciones | Estado actual |

### Características Fundamentales

- **Licencia**: Propietaria restrictiva (prohíbe modificación, reverse engineering, derivados)
- **Arquitectura**: Extensión de kernel Linux (módulo/overlay desde 2014, previamente parche)
- **Modelo**: Single System Image (SSI) — cluster aparece como una única máquina
- **Migración de procesos**: Preemptiva, automática, transparente
- **Target**: Clusters HPC, supercomputadoras, grids de investigación
- **Plataforma**: x86/x86_64 Linux
- **Estado**: **Inactivo** desde octubre 2017 (más de 8 años)

### Modelo de Memoria Distribuida

MOSIX implementa un modelo **shared-nothing** donde cada nodo tiene su propia memoria local. Incluye **Memory Ushering**: migración proactiva de procesos antes de que ocurra OOM en un nodo. **No soporta memoria compartida entre nodos**, lo que es una limitación crítica para aplicaciones HPC modernas.

### Fork Histórico: openMosix

- **2001**: MOSIX se vuelve propietario
- **Feb 2002**: Lanzamiento de openMosix por Moshe Bar (fork open source bajo GPL)
- **Jul 2007**: openMosix se discontinúa oficialmente
- **Mar 2008**: Cierre oficial del proyecto
- **Post-2008**: LinuxPMI continuó el desarrollo (también discontinuado)

### Estado Actual (Mayo 2026)

| Indicador | Estado |
|-----------|--------|
| Último release | MOSIX-4.4.4 (24 de octubre de 2017) |
| Desarrollo activo | **NO** |
| Soporte comercial | **NO** |
| Adopción en producción | **Nula** (histórica únicamente) |
| Sitio web | Funcional pero sin actualizaciones |
| Documentación | Desactualizada |

### Comparación con Competidores HPC Modernos

| Tecnología | Tipo | Estado | Adopción Top500 |
|------------|------|--------|------------------|
| MOSIX | Migración de procesos (nivel SO) | Inactivo | 0% |
| SLURM | Job scheduling | Muy activo | >60% |
| Kubernetes | Orquestación de contenedores | Muy activo | Creciente |
| OpenMPI | Comunicación MPI | Muy activo | Universal |

**Veredicto**: MOSIX es un proyecto de investigación históricamente significativo pero técnicamente obsoleto. No se recomienda para uso en producción moderno.

---

## Conceptos del Temario FSO Conectados

### §1.1 — ¿Qué es un Sistema Operativo?

La portada muestra dos sistemas operativos de categorías completamente distintas, lo que ilustra los dos objetivos principales de un SO (§1.1):

1. **Máquina extendida**: Zephyr oculta la complejidad del hardware heterogéneo de microcontroladores (MCU) — diferentes arquitecturas (ARM, RISC-V, x86), periféricos, timers, comunicación wireless — tras una API unificada. Sin Zephyr, el programador debería escribir drivers para cada periférico de cada MCU. Zephyr presenta una "máquina virtual" simplificada para desarrollo embebido.

2. **Gestor de recursos**: MOSIX administra recursos distribuidos (CPU, memoria, red)across múltiples nodos de un cluster. La migración de procesos de MOSIX es un ejemplo de gestión adaptativa de recursos donde el SO decide dinámicamente dónde ejecutar cada proceso basándose en carga, disponibilidad de memoria y latencia de red.

### §1.2 — Generaciones de Sistemas Operativos

La historia de ambos productos refleja las generaciones del temario:

- **MOSIX** nació en la era de la **4ª generación** (1980s-1990s: microprocesadores, clusters, UNIX) y se volvió obsoleto en la era de la **5ª generación** (móvil, nube, contenedores). Su obsolescencia se debe a que el paradigma de migración de procesos a nivel kernel fue superado por contenedores y orchestrators modernos.

- **Zephyr** nació en la **5ª generación** (2016) junto con el auge de IoT y sistemas embebidos conectados. Es heredero de la tradición Linux pero diseñado específicamente para constraints de microcontroladores.

### §1.4 — Arquitecturas de SO

La comparativa de arquitecturas entre ambos productos es pedagógica:

| Arquitectura | Zephyr OS | MOSIX |
|--------------|-----------|-------|
| **Monolítica** | ✅ Kernel unificado desde v1.6 (nanokernel + microkernel integrados) | ❌ No es monolítico puro |
| **Microkernel** | ✅ Diseño minimalista (footprint 4 KB), servicios en espacio de usuario | ❌ No aplica |
| **Por capas** | ❌ No explícitamente | ❌ No aplica |
| **Cliente-Servidor** | ✅ Modelo de gobernanza (Governing Board + TSC + Working Groups) | ❌ No aplica |
| **Extensión de kernel** | ❌ No | ✅ Opera como módulo/overlay sobre Linux |

Zephyr implementa una **arquitectura microkernel** donde el kernel está dividido en componentes mínimos. Esto contrasta con sistemas monolithíticos como Linux tradicionales. La ventaja: baja latencia y footprint mínimo (4 KB) manteniendo modularidad.

MOSIX opera como una **capa sobre el kernel Linux** (parche o módulo desde 2014). Académicamente, esto lo posiciona como una arquitectura híbrida: no es microkernel puro ni monolítico tradicional, sino un "overlay" que extiende las capacidades del kernel sin modificar el kernel base.

### §1.5 — Modo Dual de Operación

En sistemas embebidos como Zephyr, la distinción kernel/user mode sigue presente pero con nuances. Zephyr soporta arquitectura de **privilege levels** (Supervisor vs User) donde drivers y scheduling corren en modo privilegiado. El hardware de microcontroladores (MPU — Memory Protection Unit) enforce esta separación en lugar de MMU completa.

En MOSIX, la migración de procesos a nivel kernel involucra zonas críticas donde el código corre en **modo kernel** para manipular estado de procesos. El modelo depende de que el kernel Linux provea primitives de bajo nivel (schedule, migrate) accesibles solo en modo privilegiado.

### §2.1 y §2.5 — Scheduling y Procesos

Los objetivos del scheduler según §2.1 se manifiestan de forma opuesta en cada producto:

- **Zephyr**: optimiza **response time** para tareas de tiempo real (deadlines estrictos). Soporta scheduling preemptive, cooperative e híbrido — permitiendo elegir el algoritmo según la aplicación (time-critical vs throughput-oriented).

- **MOSIX**: optimiza **throughput** y **utilization** a nivel cluster. Implementa migración preemptiva automática de procesos basada en balanceo de carga dinámico que considera CPU, memoria y velocidad de red. La migración busca evitar nodos cuello de botella y maximizar utilización de recursos distribuidos.

### §4.1 a §4.7 — Administración de Memoria

La diferencia de modelos de memoria entre ambos productos es instructive:

- **Zephyr**: memoria unificada (single address space) con protección vía **MPU** (Memory Protection Unit). Implementa heap, memory slabs, demand paging, virtual memory, memory domains, y user mode. La paginación permite que sistemas con MPU (sin MMU completa) tengan memoria virtual.

- **MOSIX**: memoria **distribuida** ("shared-nothing") donde cada nodo tiene su propia RAM local. El **Memory Ushering** de MOSIX es un algoritmo de migración proactiva que mueve procesos entre nodos ANTES de que ocurra OOM — conceptualmente diferente al replacement de páginas en sistemas paginados: en lugar de reemplazar páginas dentro de una memoria virtual, se reemplaza el nodo completo donde corre el proceso.

### §3.1 a §3.9 — Sistemas de Archivos

La comparativa de filesystems muestra dos paradigmas completamente diferentes:

- **Zephyr**: Usa **LittleFS** (optimizado para flash embebido con wear leveling), **FAT FS** (para tarjetas SD), y **NVS** (Non-Volatile Storage, sistema clave-valor). Todos son archivos locales; Zephyr no tiene concepto de sistema de archivos distribuido porque no es un sistema distribuido.

- **MOSIX**: No tiene filesystem propio — usa **DFSA (Direct File System Access)** que redirige operaciones de E/S al nodo que posee el archivo. DFSA no es un FS paralelo sino un mecanismo de acceso transparente a archivos remotos. Esta diferencia ilustra por qué los métodos de asignación deben diseñarse para el patrón de acceso esperado.

---

## Glosario de Términos

| Término | Definición | Relevancia para la Portada |
|---------|------------|----------------------------|
| **RTOS (Real-Time Operating System)** | Sistema operativo que debe completar tareas dentro de deadlines estrictos. Zephyr es un RTOS. | Diferencia fundamental: Zephyr garantiza tiempo de respuesta; MOSIX no es RTOS |
| **HPC (High Performance Computing)** | Computación de alto rendimiento en clusters de miles de nodos. MOSIX era para HPC. | Contexto de uso de MOSIX |
| **SSI (Single System Image)** | Tecnología que hace que un cluster aparezca como una única máquina. MOSIX implementa SSI. | Característica definitoria de MOSIX |
| **Cluster OS** | Sistema operativo diseñado para administrar un cluster de computadoras como una unidad | Categoría de MOSIX |
| **Microcontrolador (MCU)** | Chip con CPU, memoria y periféricos integrados en un solo integrado. Target de Zephyr. | Hardware target de Zephyr |
| **Linux Foundation** | Organización sin fines de lucro que hospeda proyectos open source (Zephyr, Kubernetes, Linux kernel). Fundada en 2000. | Sponsor de Zephyr |
| **Migración de procesos** | Movimiento de un proceso en ejecución de un nodo a otro sin detenerlo. Característica principal de MOSIX. | Diferencia técnica clave |
| **Memory Ushering** | Algoritmo de MOSIX que migra proactivamente procesos antes de OOM. | Mecanismo de MOSIX |
| **DFSA (Direct File System Access)** | Mecanismo de MOSIX para acceso transparente a archivos en cualquier nodo del cluster. | Sistema de archivos de MOSIX |
| **Nanokernel** | Kernel minimalista de Zephyr que provee scheduling y comunicación. | Arquitectura de Zephyr (pre-v1.6) |
| **Microkernel** | Diseño de kernel donde solo las funciones esenciales corren en modo privilegiado. | Arquitectura de Zephyr (post-v1.6 unificado) |
| **MPU (Memory Protection Unit)** | Hardware de protección de memoria en microcontroladores (más simple que MMU). | Mecanismo de protección de Zephyr |
| **Apache License 2.0** | Licencia permisiva que permite uso comercial, modificación y derivados sin copyleft. | Licencia de Zephyr |
| **Licencia propietaria restrictiva** | Licencia que prohibe modificación, reverse engineering y creación de derivados. | Licencia de MOSIX |
| **OpenSSF Gold Badge** | Certificación de seguridad para proyectos open source. Zephyr la obtuvo en 2019. | Diferencia de seguridad |
| **LTS (Long Term Support)** | Versiones de Zephyr con soporte extendido para productos de ciclo de vida largo. | Estrategia de Zephyr |
| **RTOS preemptive** | RTOS donde el scheduler puede interrumpir tareas de menor prioridad. | Tipo de scheduling en Zephyr |
| **RTOS cooperative** | RTOS donde las tareas ceden voluntariamente el control al scheduler. | Tipo de scheduling en Zephyr |

---

## Análisis de Diseño Visual (slide-01.js)

### Paleta de Colores

| Color | Código Hex | Uso en la slide | Significado |
|-------|------------|-----------------|-------------|
| **primary** | `#2D3237` | Título "Zephyr OS vs MOSIX" | Texto principal, gris oscuro corporativo |
| **secondary** | `#4C5155` | Subtítulos, nombres, universidad | Texto secundario, gris medio |
| **accentZephyr** | `#0070C5` | "EVALUACIÓN DE PRODUCTOS", fecha, barra superior, barra lateral izquierda | Color institucional Zephyr (azul) |
| **accentZephyrLight** | `#66A9DC` | Barra inferior clara | Acento secundario de Zephyr |
| **accentMosix** | `#4C5155` | (definido pero no usado en portada) | Color corporativo MOSIX (gris) |
| **accentMosixLight** | `#8C9196` | (definido pero no usado en portada) | Acento secundario MOSIX |
| **light** | `#D1D3D5` | Línea divisoria | Gris claro para separadores |
| **bg** | `#F6F7F8` | Fondo de la slide | Gris muy claro, casi blanco |
| **white** | `#FFFFFF` | Tarjeta central | Fondo de la tarjeta de título |

### Elementos de Layout

**Franja lateral izquierda** (x=0, w=0.15): Elemento de branding Zephyr — refuerza visualmente la identidad del proyecto que tiene el color azul corporativo en la Linux Foundation. Esta barra no aparece en otros elementos de la presentación más allá de la portada.

**Tarjeta central** (x=0.5, y=1.4, w=9, h=2.8): Elemento focal que agrupa todo el contenido del título. La sombra sutil (blur:3, offset:2, angle:45, opacity:0.15) crea efecto de elevación "card" moderno, común en presentaciones corporativas.

**Barra inferior** (y=5.45): Efecto degradado con dos franjas (azul + azul claro) que refuerzan la identidad visual de Zephyr. Es consistente con el color accentZephyr de la barra lateral izquierda.

### Jerarquía Tipográfica

1. **"Zephyr OS vs MOSIX"** — 52pt Arial Black: Título principal, máxima jerarquía
2. **"EVALUACIÓN DE PRODUCTOS"** — 32pt Arial bold con letter-spacing 4: Subtítulo de sección, jerarquía alta
3. **"Trabajo Práctico Especial de Evaluación"** — 18pt Calibri: Descripción del tipo de documento
4. **"Fundamentos de Sistemas Operativos"** — 16pt Calibri italic: Contexto académico
5. **"Universidad Nacional de Mar del Plata"** — 14pt Calibri: Institution
6. **Integrantes** — 11pt Calibri con letter-spacing 1: Información grupal
7. **Fecha** — 11pt Calibri bold en accentZephyr: Información logística

---

## Referencias y Fuentes

### Fuentes de la Investigación

1. **Slide source**: `../slides/slide-01.js` — archivo JavaScript de PptxGenJS
2. **Zephyr empresa**: `../../informacion/A-La-Empresa/empresa-zephyros.md`
3. **MOSIX empresa**: `../../informacion/A-La-Empresa/empresa-mosix.md`
4. **Comparativa técnica**: `../../informacion/D-Comparativa-Final/comparativa-tecnica-zephyros-mosix.md`
5. **Temario FSO**: `../../temario_FSO.md`

### Fuentes Web Verificadas

- [Zephyr Project Official](https://www.zephyrproject.org)
- [Zephyr Governing Board](https://www.zephyrproject.org/governing-board/)
- [Zephyr TSC](https://www.zephyrproject.org/tsc/)
- [Linux Foundation — Zephyr at 10](https://www.linuxfoundation.org/blog/zephyr-at-10-a-decade-of-open-source-embedded-innovation)
- [Wikipedia — Zephyr (operating system)](https://en.wikipedia.org/wiki/Zephyr_(operating_system))
- [Wikipedia — MOSIX](https://en.wikipedia.org/wiki/MOSIX)
- [MOSIX Official Site](http://www.mosix.org/)
- [MOSIX History — Hebrew University](https://mosix.cs.huji.ac.il/txt_history.html)
- [Prof. Amnon Barak — HUJI](https://www.cs.huji.ac.il/~amnon)

---

*Documento de explicación para slide-01 (Portada) del Trabajo Práctico Especial de Evaluación — Zephyr OS vs MOSIX*
*Fundamentos de Sistemas Operativos — Universidad Nacional de Mar del Plata*
*Mayo 2026*