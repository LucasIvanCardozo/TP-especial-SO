# Slide-01: Portada — Resumen

## Overview

Diapositiva de portada para un **Trabajo Práctico Especial** que compara **Zephyr OS** y **MOSIX** — dos sistemas operativos de categorías completamente distintas. Presentación académica de la Universidad Nacional de Mar del Plata para la materia Fundamentos de Sistemas Operativos.

---

## Los Dos Productos Comparados

### Zephyr OS

- **Qué es**: RTOS (Sistema Operativo de Tiempo Real) open source para sistemas embebidos con recursos restringidos
- **Nacimiento**: 2016, bajo Linux Foundation
- **Origen del código**: Proveniente de Virtuoso RTOS de Eonic Systems (1990s) → Wind River → código abierto como Rocket RTOS (2015) → donation a Linux Foundation como Zephyr (Feb 2016)
- **Licencia**: Apache 2.0 (permisiva, sin regalías)
- **Arquitectura**: Monolítica unificada (desde v1.6, dic 2016)
- **Requerimientos**: Desde **4 KB** hasta varios MB
- **Target**: Microcontroladores (MCU), IoT, wearables, dispositivos médicos, industrial
- **Placas soportadas**: >1,000 boards, >15 arquitecturas (ARM, RISC-V, x86)
- **Conectividad**: BLE, Wi-Fi, Thread, 802.15.4, LoRa, Cellular, CAN bus
- **Seguridad**: PSA Crypto API, Secure Boot (MCUboot), OpenSSF Gold Badge (desde 2018-03-10)
- **Estado**: **Activo** — 10 años de operación, 3000+ contribuyentes
- **Adopción 2026**: 70% organizaciones Norteamérica, 62% Europa usan Zephyr en productos comerciales

### MOSIX

- **Qué es**: Sistema operativo de cluster para computación de alto rendimiento (HPC)
- **Desarrollo**: 1977-2017, Hebrew University of Jerusalem, bajo Prof. Amnon Barak
- **Licencia**: Propietaria restrictiva (prohíbe modificación y derivados)
- **Arquitectura**: Extensión de kernel Linux (módulo/overlay desde 2014; previamente parche)
- **Modelo**: SSI (Single System Image) — cluster aparece como una única máquina
- **Característica principal**: Migración de procesos preemptiva, automática y transparente
- **Memoria**: Distribuida "shared-nothing" — cada nodo tiene su propia RAM. **No soporta memoria compartida entre nodos**
- **Memory Ushering**: Migra procesos proactivamente ANTES de OOM en un nodo
- **Estado**: **Inactivo** desde octubre 2017 (más de 8 años)
- **Competidores modernos**: SLURM (>60% Top500), Kubernetes, OpenMPI

---

## Linaje Técnico

### Zephyr OS

| Año | Evento |
|-----|--------|
| Finales 90s | Eonic Systems desarrolla Virtuoso RTOS para DSPs |
| 2001 | Wind River adquiere Eonic Systems |
| 2009 | Intel adquiere Wind River por ~$884M |
| Nov 2015 | Wind River abre código como Rocket RTOS (4 KB footprint) |
| Feb 2016 | Rocket se dona a Linux Foundation → nace Zephyr Project |
| Dic 2016 | Zephyr v1.6 — unificación nanokernel + microkernel |
| 2017-2026 | Crecimiento continuo hasta 1000+ boards |

### MOSIX

| Año | Evento |
|-----|--------|
| 1977-1979 | MOS v0 en PDP-11 (primeros experimentos de migración) |
| 1981-1983 | MOS v1 — primer sistema multicomputadora funcional |
| 1988-1989 | MOSIX — primer sistema con el nombre actual, cluster 16 nodos |
| 1998-1999 | MOSIX v7 en Linux 2.2 — primera versión Linux, 64 nodos |
| 2001 | MOSIX se vuelve propietario (código cerrado) |
| 2002 | Moshe Bar crea openMosix (fork open source bajo GPL) |
| 2014 | MOSIX-4 — funciona como módulo (sin parche de kernel) |
| Oct 2017 | MOSIX-4.4.4 — último release oficial |
| Post-2017 | Proyecto inactivo |

---

## Conexión con el Temario de FSO

### §1.1 — ¿Qué es un SO?

- **Zephyr** = **máquina extendida**: oculta complejidad de hardware heterogéneo (MCU, periféricos, wireless) tras API unificada
- **MOSIX** = **gestor de recursos distribuidos**: administra CPU, memoria y red de múltiples nodos

### §1.2 — Generaciones de SO

- MOSIX nació en 4ta generación (1980s-90s: microprocesadores, clusters) y quedó obsoleto en 5ta generación (contenedores, nube)
- Zephyr nació en 5ta generación (2016) junto con IoT

### §1.4 — Arquitecturas de SO

| Arquitectura | Zephyr | MOSIX |
|--------------|--------|-------|
| Microkernel | ✅ Footprint mínimo 4KB | ❌ |
| Extensión de kernel | ❌ | ✅ Overlay sobre Linux |
| Cliente-Servidor | ✅ Gobernanza (Board + TSC) | ❌ |

### §2.1 y §2.5 — Scheduling

- **Zephyr**: optimiza **response time** (deadlines estrictos), soporta scheduling preemptive, cooperative e híbrido
- **MOSIX**: optimiza **throughput** y **utilization** — migración preemptiva automática basada en balanceo de carga

### §4.1 a §4.7 — Administración de Memoria

- **Zephyr**: memoria unificada con protección MPU (Memory Protection Unit), soporta paginación incluso sin MMU completa
- **MOSIX**: memoria **distribuida** "shared-nothing" — Memory Ushering reemplaza el nodo completo, no páginas individuales

### §3.1 a §3.9 — Sistemas de Archivos

- **Zephyr**: LittleFS (flash embebido), FAT FS (SD), NVS (clave-valor)
- **MOSIX**: DFSA (Direct File System Access) — acceso transparente a archivos remotos

---

## Glosario de Términos Clave

| Término | Definición |
|---------|------------|
| **RTOS** | Sistema operativo que debe completar tareas dentro de deadlines estrictos |
| **HPC** | Computación de alto rendimiento en clusters de miles de nodos |
| **SSI (Single System Image)** | Tecnología que hace que un cluster aparezca como una única máquina |
| **MCU** | Microcontrolador: chip con CPU, memoria y periféricos integrados |
| **Migración de procesos** | Movimiento de un proceso en ejecución de un nodo a otro sin detenerlo |
| **Memory Ushering** | Algoritmo de MOSIX que migra proactivamente procesos antes de OOM |
| **DFSA** | Mecanismo de MOSIX para acceso transparente a archivos en cualquier nodo |
| **MPU** | Memory Protection Unit — hardware de protección en microcontroladores (más simple que MMU) |
| **Nanokernel** | Kernel minimalista de Zephyr (pre-v1.6) |
| **Microkernel** | Diseño donde solo funciones esenciales corren en modo privilegiado |

---

## Elementos Visuales de la Portada

| Elemento | Descripción |
|----------|-------------|
| Franja azul lateral izquierda | Barra Zephyr (#0070C5), 0.15" de ancho |
| Tarjeta central blanca | 9" × 2.8" con sombra sutil |
| Título principal | "Zephyr OS vs MOSIX" — Arial Black 52pt |
| Subtítulo | "EVALUACIÓN DE PRODUCTOS" — azul Zephyr, Arial 32pt bold |
| Fecha | "3 de Junio — 13:30 hs" en azul Zephyr bold |
| Barra inferior | Degradado azul (#0070C5 + #66A9DC) |

---

*Fuente: slide-01.js (PptxGenJS), Universidad Nacional de Mar del Plata, Mayo 2026*
