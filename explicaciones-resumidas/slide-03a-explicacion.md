# Resumen: Zephyr OS — La Empresa (Historia y Gobernanza)

## ¿Qué es Zephyr?

**Zephyr** es un sistema operativo de tiempo real (RTOS) de código abierto diseñado para dispositivos IoT y sistemas embebidos con recursos muy limitados. Puede funcionar en apenas **~4 KB de RAM**, lo que lo hace ideal para microcontroladores de decenas de KB.

---

## Línea de Tiempo Histórica

| Año | Evento | Detalle |
|-----|--------|---------|
| **1990s** | **Virtuoso RTOS** | Creado por **Eonic Systems** (Bélgica) para DSPs (procesadores de señal digital). Ya tenía +15 años de desarrollo comercial antes de donarse. |
| **2001** | **Adquisición por Wind River** | Wind River (creadora de VxWorks) compra Eonic Systems. |
| **2009** | Wind River es comprada por **Intel** (~884 millones USD) | |
| **2018** | Intel revende Wind River a **TPG Capital** | |
| **Nov 2015** | **Rocket RTOS** | Wind River abre el código de Virtuoso, lo renombra Rocket y lo ofrece royalty-free. Kernel de solo ~4 KB. |
| **Feb 2016** | **Nacimiento de Zephyr** | Wind River dona Rocket a la **Linux Foundation**. Founding members: Intel, Wind River, Synopsys, NXP. |
| **2016-2026** | Crecimiento | 3,000+ contribuyentes, 1,000+ boards soportadas (ARM, RISC-V, x86, etc.), 70% de organizaciones en Norteamérica lo usan comercialmente. |

---

## Gobernanza: ¿Por qué Linux Foundation?

Linux Foundation es una organización sin fines de lucro (año 2000) que hospeda proyectos open source y provee:

- **Infraestructura legal** (licencias, protección de marca)
- **Infraestructura técnica** (repositorios, CI/CD, seguridad)
- **Neutralidad**: ninguna empresa controla el proyecto

### ¿Por qué importa la neutralidad?

Empresas que usan Zephyr en productos de largo ciclo de vida (industrial, médico, automotriz) no quieren depender de un único proveedor (como Amazon con FreeRTOS, Microsoft con ThreadX, o Google con Fuchsia).

### Estructura de Gobernanza de Zephyr

- **Governing Board**: Define políticas y estrategia. Compuesto por representantes de miembros Platinum/Gold.
- **TSC (Technical Steering Committee)**: Máximo órgano de decisión técnica. Chair actual (2026): **Anas Nashif** (Intel).
- **Security Committee**: Supervisa seguridad, mantiene Vulnerability Alert Registry.

---

## Miembros Corporativos

### Founding Members (2016)
| Empresa | Rol |
|---------|-----|
| Intel | CPUs, FPGAs, SoCs para IoT |
| Wind River | Dueños originales de Virtuoso/Rocket, creadora de VxWorks |
| Synopsys | Diseño de chips, procesadores ARC |
| NXP | Microcontroladores (familias LPC, Kinetis, i.MX) |

### Platinum Members (2025)
Renesas, Wind River, Intel, Qualcomm, CARIAD (Volkswagen), ZEISS, Analog Devices, Silicon Labs, Antmicro.

### Miembros Silver
Nordic Semiconductor, Google, Meta, STMicroelectronics, Texas Instruments, Arduino, Canonical, Microchip, Infineon, Espressif Systems, y otros.

---

## Conexión con FSO (§1.2 y §1.4)

### §1.2 — Generaciones de Sistemas Operativos

Zephyr ejemplifica la **evolución entre generaciones**:

| Generación | Características | Relación con Zephyr |
|------------|-----------------|-------------------|
| 3ª (1965-1980) | Time-sharing, multiprogramación | Virtuoso ya tenía scheduling preemptive |
| 4ª (1980-1990) | Microprocesadores, UNIX, Linux | Hospedado bajo Linux Foundation, hereda filosofía open source |
| 5ª (1990-presente) | IoT, móvil, nube | Zephyr es específicamente un RTOS para IoT |

**Key insight**: La línea entre generaciones no es nítida. Zephyr combina filosofía de la 4ª generación (open source) con constraints de la 3ª generación (tiempo real).

### §1.4 — Arquitectura de SO

**Zephyr implementa arquitectura microkernel:**

- **Nanokernel** (modo kernel mínimo): scheduling, interrupciones, sincronización
- **Microkernel** (desde v1.6 unificado): drivers, sistema de archivos FAT, networking
- **Servicios** (modo usuario): shells, logs, debugging

**Tradeoff del microkernel:**

| Ventajas | Desventajas |
|----------|-------------|
| Modularidad (cada servicio puede arrancarse/detenerse independientemente) | Mayor overhead de IPC (comunicación entre procesos) |
| Seguridad (fallo de driver no corrompe kernel) | Potencial mayor latencia en llamadas al sistema |
| Portabilidad (solo reescribir el kernel mínimo para nueva arquitectura) | |

**Gobernanza como cliente-servidor**: El modelo de gobernanza de Zephyr es funcionalmente una arquitectura cliente-servidor: miembros proponen/votan cambios; TSC orquesta la implementación.

---

## Glosario Esencial

### RTOS (Real-Time Operating System)
Sistema donde el resultado correcto **y** el tiempo en que se produce son críticos. Se clasifica en:

- **Hard real-time**: Incumplir el deadline = fallo catastrófico (ej: frenos ABS)
- **Soft real-time**: Incumplir degrada calidad pero no falla (ej: streaming de audio)
- **Firm real-time**: Incumplir produce resultado inútil pero no dañino

Zephyr soporta los tres tipos según configuración y hardware.

### Vendor Lock-in
Dependencia de un proveedor específico. Zephyr lo evita al estar bajo Linux Foundation.

### Footprint
Cantidad de memoria (RAM/ROM) que consume el SO. Zephyr: ~4 KB mínimo.

---

## ¿Por qué es relevante para FSO?

1. **Caso real de evolución de generaciones de SO**: Virtuoso (comercial años 90) → Zephyr (open source 2026).
2. **Arquitectura microkernel en la práctica**: Compara con MINIX, QNX — mismos tradeoffs.
3. **Modelo de desarrollo open source**: Analiza si produce sistemas más robustos que el modelo propietario tradicional.

---

*Fuente: slide-03a-explicacion.md — TP Especial Zephyr MOSIX, FSO UNMDP, mayo 2026.*
