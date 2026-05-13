# 2. La Empresa

En este capítulo se presentan las organizaciones detrás de cada sistema operativo, su origen, modelo de desarrollo y posicionamiento en el mercado.

---

## 2.1 Zephyr OS — Linux Foundation

### Origen y Historia

Zephyr OS es un proyecto de **código abierto** hospeado bajo el paraguas de la **[Linux Foundation](https://www.linuxfoundation.org/)**, una organización sin fines de lucro fundada en el año 2000. El proyecto nació oficialmente en **febrero de 2016**, aunque sus orígenes se remontan a **noviembre de 2015**, cuando Wind River Systems decidió abrir el código de su RTOS comercial **Virtuoso RTOS** (adquirido en 2001 a Eonic Systems), renombrándolo como **Rocket RTOS** y ofreciéndolo libre de regalías.

En febrero de 2016, Wind River donó el kernel de Rocket a la Linux Foundation, dando origen formal al **Zephyr Project**. Los miembros fundadores fueron Intel, Wind River, Synopsys y NXP Semiconductors.

### Gobernanza

Zephyr opera bajo un modelo de **gobernanza comunitaria estructurada**. La Linux Foundation provee el umbrella legal y la infraestructura, pero las decisiones técnicas las toma el **Technical Steering Committee (TSC)**, liderado actualmente por Anas Nashif (Intel). El **Governing Board** define políticas y estrategia con representantes de los miembros corporativos.

### Respaldo Corporativo

El proyecto cuenta con el respaldo de múltiples empresas líderes en semiconductores y sistemas embebidos:

- **Founding Members (2016):** Intel, Wind River, Synopsys, NXP
- **Platinum Members (2025-2026):** Qualcomm, CARIAD (Volkswagen), Renesas, ZEISS, Analog Devices, Silicon Labs, Wind River, Antmicro
- **Silver Members:** Nordic Semiconductor, Google, Meta, STMicroelectronics, Texas Instruments, Espressif Systems, Arduino, Canonical, Microchip, Infineon, y otros

### Segmento de Mercado

Zephyr se posiciona en el mercado de **sistemas embebidos y IoT**, con enfoque en:

- **IoT y sensores conectados** — dispositivos de bajo consumo
- **Microcontroladores (MCUs) de 32-bit** — chips con recursos muy limitados (~16 KB RAM mínimo; nanokernel histórico ~4 KB)
- **Wearables** — smartwatches, audífonos inteligentes
- **Industrial** — controladoras programables, automatización
- **Dispositivos médicos** — monitores ECG, audífonos recargables
- **Transporte** — scooters eléctricos, cerraduras BLE, GPS
- **Energía renovable** — turbinas eólicas (Vestas)

### Modelo de Desarrollo

El desarrollo es **abierto y colaborativo**, con más de **3,000 contribuyentes globales** y soporte para más de **1,000 boards** (ARM Cortex-M, RISC-V, x86, ARC). El código se distribuye bajo licencia **Apache 2.0**, sin regalías ni costos de licenciamiento.

| Dato | Valor |
|------|-------|
| Año de origen | 2016 |
| Organización | Linux Foundation (paraguas neutral) |
| Tipo de respaldo | Corporativo/miembros múltiples |
| Licencia | Apache 2.0 |
| Contribuidores | 3,000+ |
| Boards soportadas | 1,000+ |
| Adopción en Norteamérica | 70% de organizaciones |

---

## 2.2 MOSIX — Hebrew University of Jerusalem

### Origen y Historia

MOSIX es un **proyecto de investigación académica** desarrollado por el **Grupo de Investigación en Sistemas Distribuidos** del Instituto de Ciencia de la Computación de la **[Hebrew University of Jerusalem](https://www.cs.huji.ac.il/)**, Israel. El investigador principal es el **Prof. Amnon Barak**, quien lidera el desarrollo desde **1977**.

La cronología del proyecto abarca más de cuatro décadas:

| Período | Hito |
|---------|------|
| **1977–1979** | Inicio en PDP-11/45 con Unix v6 — primera demostración de migración de procesos |
| **1981–1983** | MOS (antecesor de MOSIX) — cluster de 5 PDP-11 |
| **1988–1989** | Primer cluster llamado "MOSIX" — 16 nodos NS32532 |
| **1999** | Transición definitiva a Linux como plataforma base |
| **2001** | MOSIX se vuelve **propietario** — código cerrado |
| **2002** | Moshe Bar crea **openMosix** (fork open source) |
| **2014** | MOSIX-4 — ya no requiere parche de kernel (funciona como módulo) |
| **Oct 2017** | Último release: **MOSIX-4.4.4** |

### Gobernanza

Al ser un proyecto académico, MOSIX no posee una estructura de gobernanza corporativa. El **Prof. Amnon Barak** es el único propietario intelectual del software, y **MOSIX®** es una marca registrada. No existe un Governing Board ni TSC; las decisiones técnicas son tomadas por el equipo de investigación de la Hebrew University.

### Respaldo Académico

El respaldo es **exclusivamente académico**:

- **Publicaciones:** el Prof. Barak cuenta con más de 71 publicaciones y ~1,662 citas en sistemas distribuidos y paralelos
- **Grid académico:** clusters universitarios en Israel utilizan MOSIX para investigación
- **Papers técnicos:** white papers, administrator guides y FAQs disponibles en el sitio oficial
- **Sin soporte comercial formal:** no existe una empresa dedicada al soporte o desarrollo comercial

### Segmento de Mercado

MOSIX se orientó históricamente al mercado de:

- **HPC (High Performance Computing)** — clusters de computadoras de alto rendimiento
- **Clusters de cómputo** — granjas de servidores para computación científica
- **Grids de computadoras** — administración de múltiples clusters como un sistema unificado
- **Single System Image (SSI)** — clusters que aparentan ser una única máquina lógica

### Modelo de Desarrollo

MOSIX es **software propietario** con licencia restrictiva que **prohíbe** modificar, realizar ingeniería reversa o crear obras derivadas. No es open source. Las contribuciones son propiedad intelectual del Prof. Amnon Barak.

Existe un fork histórico llamado **openMosix** (2002-2008) que fue open source bajo licencia GPL, pero está discontinuado desde 2008.

| Dato | Valor |
|------|-------|
| Año de origen | 1977 |
| Organización | Hebrew University of Jerusalem (grupo de investigación) |
| Tipo de respaldo | Académico (no comercial) |
| Licencia | Propietaria restrictiva |
| Líder | Prof. Amnon Barak |
| Último release | 4.4.4 (octubre 2017) |
| Estado actual | Inactivo (sin desarrollo desde 2017) |

---

## Síntesis Comparativa

| Aspecto | Zephyr OS | MOSIX |
|---------|-----------|-------|
| **Organización** | Linux Foundation (paraguas neutral) | Hebrew University of Jerusalem |
| **Año de origen** | 2016 | 1977 |
| **Tipo de proyecto** | Código abierto comercial | Investigación académica |
| **Modelo de licencia** | Apache 2.0 (permisiva) | Propietaria restrictiva |
| **Gobernanza** | TSC + Governing Board | Investigador principal |
| **Respaldo** | 30+ empresas miembros | Publicaciones académicas |
| **Segmento** | IoT, sistemas embebidos, wearables | HPC, clusters, grids |
| **Estado actual** | Activo y en crecimiento | Inactivo desde 2017 |

---

*Fuentes: Linux Foundation Research ("Zephyr at 10", marzo 2026); sitio oficial de MOSIX (mosix.org); Historia de MOSIX — Hebrew University.*