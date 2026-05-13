# Slide 29 — Resumen: Cierre / Fuentes

## Overview

Slide 29 es la **slide de cierre** del Trabajo Práctico Especial sobre Zephyr OS vs MOSIX. Contiene:
- Agradecimiento y apertura a preguntas
- Fuentes documentales utilizadas
- Lista de integrantes del grupo
- Información del curso

---

## Los Dos Sistemas Comparados

| Característica | Zephyr OS | MOSIX |
|----------------|-----------|-------|
| **Tipo** | RTOS para sistemas embebidos e IoT | Sistema de clustering para HPC |
| **Desarrollador** | Linux Foundation | Hebrew University of Jerusalem (Prof. Amnon Barak) |
| **Estado** | Activo y en crecimiento (2026) | **Abandonado desde octubre 2017** |
| **Arquitectura** | Monolítico unificado | Overlay/daemon sobre Linux (SSI distribuida) |
| **Protección memoria** | MPU (Memory Protection Unit) | Sandbox sin protección entre nodos |
| **Optimización** | Latencia y determinismo | Throughput cluster-wide |

---

## Fuentes Documentales

### Fuentes primarias de Zephyr
- **docs.zephyrproject.org**: Documentación técnica oficial (architectural overview, API references, guides, security)
- **Linux Foundation Research (2026)**: Reporte "Zephyr at 10" basado en encuestas a 413 profesionales
  - 70% de organizaciones en Norteamérica usan Zephyr comercialmente
  - 62% en Europa
  - >3,000 contribuyentes globales
  - >1,000 boards soportadas

### Fuentes primarias de MOSIX
- **mosix.org** y **mosix.cs.huji.ac.il**: Administrator's Guide, White Paper, FAQ, historia del proyecto
- **Importante**: Información histórica, última versión MOSIX-4.4.4 (octubre 2017)

### Fuentes secundarias
- **Wikipedia**: Contexto histórico de ambos proyectos
- **Top500**: MOSIX no aparece en rankings modernos
- **Temario FSO**: Marco teórico de la materia

---

## Integrantes del Grupo

| Nombre | Rol |
|--------|-----|
| ARRIAGA | Investigación y análisis |
| BELLONE | Investigación y análisis |
| BISCAY | Investigación y análisis |
| CALLA ALIENDE | Investigación y análisis |
| CARDOZO | Investigación y análisis |

Todos de la carrera de Ingeniería en Computación, UNMDP.

---

## Aprendizajes Clave de la Comparación

### Zephyr OS demuestra:
- Cómo diseñar un SO para hardware extremadamente restringido (microcontroladores con KB de RAM)
- Protección de memoria sin MMU (usando MPU)
- RTOS con scheduling preemptive/configurable
- Gobernanza neutral multi-vendor en proyecto open source
- Seguridad integrada desde cero (PSA Crypto, secure boot)

### MOSIX demuestra:
- Single System Image (SSI) sobre múltiples kernels Linux
- Migración preemptiva de procesos a nivel kernel
- Balanceo de carga adaptativo (CPU, memoria, red)
- Memory Ushering (migración proactiva antes de OOM)
- Por qué el modelo de migración de procesos fue superado por contenedores

---

## Conexión con el Temario FSO

| Tema FSO | Zephyr | MOSIX |
|----------|--------|-------|
| Arquitectura (§1.4) | Monolítico unificado | Overlay sobre Linux (SSI) |
| Scheduling (§2.5) | Preemptive + cooperative + híbrido | Migración preemptiva automática |
| Archivos (§3.6) | LittleFS, FAT FS, NVS | DFSA (redirige E/S al nodo que tiene el archivo) |
| Memoria (§4.4) | Demand paging, MPU-based | No paginación; shared-nothing por nodo |
| Reemplazo páginas (§5.3) | LRU, FIFO | Memory Ushering (migra proceso antes de OOM) |

---

## Glosario de Términos Clave

- **RTOS**: Sistema operativo de tiempo real con respuesta determinística
- **SSI (Single System Image)**: Técnica que hace que un cluster parezca una única máquina
- **MPU**: Hardware simplificado para protección de memoria (sin paging). Usa regions con permisos
- **MMU**: Soporta memoria virtual completa con paginación
- **Memory Ushering**: Algoritmo de MOSIX que migra procesos proactivamente antes de out-of-memory
- **Wear leveling**: Técnica de filesystems flash que distribuye writes uniformemente para extender vida del storage
- **Shared-nothing**: Arquitectura donde cada nodo tiene memoria local independiente

---

## Información del Curso

- **Materia**: Fundamentos de Sistemas Operativos
- **Universidad**: Universidad Nacional de Mar del Plata (UNMDP)
- **Carrera**: Ingeniería en Computación
- **Fecha**: Mayo 2026

---

*Fuente: slides de cierre del TP Especial: Zephyr OS vs MOSIX*
