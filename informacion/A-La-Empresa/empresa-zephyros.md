# La Empresa Detrás de Zephyr OS

> **Nota:** Este documento es autónomo y explica todo lo necesario para entender quién está detrás de Zephyr OS, su historia completa, gobernanza y modelo de negocio. Está orientado a lectores que nunca escucharon de Zephyr Project.

---

## 1. ¿Qué Organización Está Detrás de Zephyr OS?

**Zephyr OS no es una empresa** — es un **proyecto de código abierto** hospedado bajo el paraguas de la **[Linux Foundation](https://www.linuxfoundation.org/)**, una organización sin fines de lucro que actúa como neutral trusted hub (centro neutral de confianza) para proyectos de software abierto.

La Linux Foundation fue fundada en 2000 por **Eric S. Raymond** y **Bruce Perens** con el objetivo de promover, proteger y avanzar el software de código abierto. Hoy hospeda cientos de proyectos (Kubernetes, Node.js, Linux kernel, Cloud Foundry, etc.) y provee la infraestructura legal, administrativa y técnica para que empresas y desarrolladores colaboren en proyectos abiertos.

**Zephyr Project** fue lanzado públicamente en **febrero de 2016** bajo este paraguas. El objetivo era crear un sistema operativo de tiempo real (RTOS), seguro, neutral (sin vendor lock-in) y optimizado para dispositivos IoT y sistemas embebidos con recursos restringidos.

**Sitio oficial:** [www.zephyrproject.org](https://www.zephyrproject.org)

**Repositorio principal:** [github.com/zephyrproject-rtos/zephyr](https://github.com/zephyrproject-rtos/zephyr)

> **Fuente:** [The Linux Foundation — About](https://www.linuxfoundation.org/about), [Zephyr Project Official Site](https://www.zephyrproject.org), [Wikipedia — Zephyr (operating system)](https://en.wikipedia.org/wiki/Zephyr_(operating_system))

---

## 2. Historia y Origen Completo (de Virtuoso RTOS hasta Hoy)

La historia de Zephyr es particular porque **no nació como proyecto open source**. Su linaje atraviesa varias empresas y productos comerciales antes de llegar a la comunidad.

### 2.1 Orígenes: Virtuoso RTOS (Finales de los '90)

En la **década de 1990**, la empresa belga **[Eonic Systems](https://en.wikipedia.org/wiki/Eonic_Systems)** desarrolló **[Virtuoso RTOS](https://en.wikipedia.org/wiki/Zephyr_(operating_system))**, un sistema operativo de tiempo real diseñado para **procesadores de señal digital (DSPs)**. Virtuoso era un RTOS comercial para embedded systems de alta gama.

### 2.2 Adquisición por Wind River (2001)

En **2001**, **[Wind River Systems](https://www.windriver.com/)** — empresa estadounidense líder en software para sistemas embebidos, creadora del famous RTOS **VxWorks** — adquiere **[Eonic Systems](https://en.wikipedia.org/wiki/Eonic_Systems)** y con ello el código de **Virtuoso RTOS**.

Wind River pasó a ser subsidiaria de **Intel** en **2009** por aproximadamente **$884 millones**, y posteriormente fue separada y vuelta a vender en **2018** al grupo **[TPG Capital](https://en.wikipedia.org/wiki/Wind_River_Systems)**.

> **Fuente:** [Wikipedia — Wind River Systems](https://en.wikipedia.org/wiki/Wind_River_Systems), [Wikipedia — Eonic Systems](https://en.wikipedia.org/wiki/Eonic_Systems), [Wind River Press Release](https://www.windriver.com/news/press/news-6921)

### 2.3 Nacimiento de Rocket RTOS (Noviembre 2015)

En **noviembre de 2015**, Wind River tomó la decisión estratégica de **abrir el código de Virtuoso** bajo una licencia open source. Lo renombró como **Rocket RTOS** y lo ofreció **libre de regalías**. El objetivo era competir en el mercado de sistemas embebidos "tiny": mientras **VxWorks** necesitaba **~200 KB** de memoria, Rocket cabía en apenas **4 KB**.

En palabras de Jim Turley (Electronic Engineering Journal, nov 2015): *"Wind River sets Rocket RTOS on free trajectory"* — buscando democratizar el acceso a RTOS para dispositivos extremadamente restringidos.

> **Fuente:** [Electronic Engineering Journal — "Wind River Sets Rocket RTOS on Free Trajectory"](https://www.eetimes.com/wind-river-sets-rocket-rtos-on-free-trajectory/), [Wind River Blog — "Wind River Welcomes Linux Foundation's Zephyr Project"](https://www.windriver.com/blog/wind-river-welcomes-linux-foundations-zephyr-project)

### 2.4 Donation a la Linux Foundation y Nacimiento de Zephyr (Febrero 2016)

En **febrero de 2016**, Wind River contribuyó el kernel de **Rocket** a la **Linux Foundation**, naciendo oficialmente el proyecto **Zephyr**. El código de Rocket continuó existiendo como **versión comercial** de Zephyr (Wind River lo ofrecía como producto pago con soporte y servicios en la nube).

Según el blog de Wind River:

> *"To this end, we launched Wind River Rocket in November 2015, which is essentially the commercial version of Zephyr."*

El proyecto fue lanzado públicamente con un pequeño grupo de ** Founding Members** (miembros fundadores): Intel, Wind River, Synopsys y NXP Semiconductors.

> **Fuente:** [Linux Foundation Press Release — "The Linux Foundation Announces Project to Build Real-Time Operating System for IoT Devices"](https://www.linuxfoundation.org/press/press-release/the-linux-foundation-announces-project-to-build-real-time-operating-system-for-internet-of-things-devices), [Wikipedia — Zephyr (operating system)](https://en.wikipedia.org/wiki/Zephyr_(operating_system)), [Intel Developer Article — "The Zephyr Story"](https://www.intel.com/content/www/us/en/developer/articles/community/zephyr-story-how-became-self-sustaining-ecosystem.html)

### 2.5 Línea de Tiempo Completa

| Año | Evento |
|-----|--------|
| **Finales de los '90** | Eonic Systems (Bélgica) desarrolla **Virtuoso RTOS** para DSPs |
| **2001** | Wind River Systems adquiere Eonic Systems → Virtuoso pasa a ser de Wind River |
| **2009** | Intel adquiere Wind River por ~$884 millones |
| **Nov 2015** | Wind River abre el código de Virtuoso como **Rocket RTOS**, libre de regalías |
| **Feb 2016** | Wind River dona el kernel de Rocket a la **Linux Foundation** → nace **Zephyr Project** |
| **2016** | Founding Members: Intel, Wind River, Synopsys, NXP |
| **Dic 2016** | Lanzamiento de **Zephyr v1.6** — unificación del kernel (nanokernel + microkernel unificados) |
| **2017-2024** | Crecimiento continuo: nuevos miembros, 1000+ boards soportadas, 3000+ contribuyentes |
| **Mar 2026** | Zephyr cumple **10 años** — 70% de organizaciones en Norteamérica lo usan en productos comerciales |

> **Fuente:** [Wikipedia — Zephyr (operating system)](https://en.wikipedia.org/wiki/Zephyr_(operating_system)), [Shawn Hymel — "A Brief History of Zephyr RTOS"](https://shawnhymel.com/2791/a-brief-history-of-zephyr-rtos/)

---

## 3. Miembros y Partners (Founding Members + Actuales)

### 3.1 Founding Members (Miembros Fundadores, 2016)

Cuando Zephyr se lanzó bajo la Linux Foundation en febrero 2016, cuatro empresas fueron los ** Founding Members**:

1. **[Intel Corporation](https://www.intel.com/)** — Gigante de semiconductores (fabricante de CPUs, FPGAs, SoCs para IoT)
2. **[Wind River Systems](https://www.windriver.com/)** — Creadores de VxWorks y propietarios originales del código de Virtuoso/Rocket
3. **[Synopsys](https://www.synopsys.com/)** — Empresa de diseño de chips (creadora de ARC processors)
4. **[NXP Semiconductors](https://www.nxp.com/)** — Fabricante de microcontroladores (LPC, Kinetis, i.MX)

> **Fuente:** [Intel Developer Article — "The Zephyr Story"](https://www.intel.com/content/www/us/en/developer/articles/community/zephyr-story-how-became-self-sustaining-ecosystem.html), [NXP Blog — "Zephyr at 10 Years"](https://www.nxp.com/company/about-nxp/smarter-world-blog/BL-ZEPHYR-10-YEAR)

### 3.2 Miembros Actuales (2025-2026)

El proyecto ha crecido significativamente. Los miembros se dividen en tres niveles según su contribución financiera y compromiso:

#### Platinum Members (nivel más alto)

Representan las principales empresas que lideran el proyecto. Según datos de 2025-2026:

- **[Qualcomm Technologies, Inc.](https://www.qualcomm.com/)**
- **[CARIAD](https://www.cariad.com/)** (filial de Volkswagen para software automotriz)
- **[Renesas Electronics Corporation](https://www.renesas.com/)**
- **[ZEISS](https://www.zeiss.com/)** (tecnología óptica y médica)
- **[Analog Devices](https://www.analog.com/)**
- **[Silicon Labs](https://www.silabs.com/)**
- **[Wind River](https://www.windriver.com/)**
- **[Antmicro](https://www.antmicro.com/)** (empresa de ingeniería de software embebido)

En **junio de 2025**, Renesas y Wind River **elevaron** su membresía a Platinum (habían sido Gold previamente).

> **Fuente:** [Zephyr Project — Platinum Members](https://zephyrproject.org/members_category/platinum/), [PR Newswire — "Zephyr RTOS Expands Ecosystem"](https://www.prnewswire.com/news-releases/zephyr-rtos-expands-ecosystem-with-renesas-and-wind-river-upgrading-to-platinum-membership-and-new-silver-members-blecon-and-embeint-302485307.html)

#### Silver Members

Incluyen empresas como Nordic Semiconductor, Google, Meta, STMicroelectronics, Texas Instruments, Microchip, Infineon, Espressif Systems, Qualcomm, Arduino, Canonical, y otras. También se han incorporado recientemente:

- **[Blecon](https://blecon.com/)** — Soluciones BLE para IoT
- **[Embeint](https://embeint.com/)** — Embedded systems
- **[MicroEJ](https://www.microej.com/)** — Java embebido
- **[Qt Group](https://www.qt.io/)** — Framework de UI

> **Fuente:** [Zephyr Project — Project Members](https://www.zephyrproject.org/project-members/), [Linux Foundation Press — "MicroEJ and Qt Group Join Zephyr"](https://www.linuxfoundation.org/press/microej-and-qt-group-join-the-zephyr-project)

#### Miembros Individuales y Contribuidores

Además de las empresas, miles de desarrolladores individuales contribuyen código, documentación y soporte. Para **2024**, Zephyr tuvo **1,100 unique contributors**, con más del **50% siendo contribuidores por primera vez**.

> **Fuente:** [Zephyr Project — "2024 Wrap Up"](https://zephyrproject.org/zephyr-rtos-2024-wrap-up-a-year-of-growth-innovation-and-community-impact/)

### 3.3 Principales Contribuidores de Código

Aunque todos pueden contribuir, las empresas que más código aportan (en orden aproximado) son:

1. **[Nordic Semiconductor](https://www.nordicsemi.com/)** — Líder en Bluetooth Low Energy chips, muy activo en drivers BLE y connectivity
2. **[Intel](https://www.intel.com/)** — TSC Chair (Anas Nashif), múltiples contribuciones arquitectónicas
3. **[NXP](https://www.nxp.com/)** — Soporte extenso para sus familias de microcontroladores (i.MX, LPC, Kinetis)
4. **[Synopsys](https://www.synopsys.com/)** — Mantiene la arquitectura ARC
5. **[Renesas](https://www.renesas.com/)** — Creciendo significativamente desde 2024-2025
6. **[Silicon Labs](https://www.silabs.com/)** — Wireless connectivity, Z-Wave, Wi-SUN
7. **[STMicroelectronics](https://www.st.com/)** — STM32 families
8. **[Wind River](https://www.windriver.com/)** — Soporte comercial y contribuciones técnicas

> **Fuente:** [Zephyr Project TSC](https://www.zephyrproject.org/tsc/), investigación propia

---

## 4. Modelo de Gobernanza

Zephyr opera bajo un modelo de **gobernanza comunitaria estructurada** definido en su **[Charter](https://zephyrproject.org/charter)** (estatuto). La Linux Foundation provee el umbrella legal y financiero, pero las decisiones técnicas y estratégicas las toman los miembros y la comunidad.

### 4.1 Governing Board (Junta Gobernante)

El **Governing Board** es el órgano de gobierno de alto nivel. Sus responsabilidades incluyen:

- Definir políticas del proyecto
- Articular la estrategia
- Proveer orientación al TSC

Está compuesto por representantes de los miembros y el **TSC Chair**. Los miembros actuales (2026) incluyen:

- **Abitzen Xavier** (Silicon Labs) — Governing Board Chair
- **Anas Nashif** (Intel) — TSC Chair
- **Alexey Brodkin** (Synopsys)
- **Amber Hibberd** (Intel)
- **Brendon Slade** (NXP)
- **Carl Turner** (Google)
- **Dan Ahern** (Meta)
- **David Brown** (Linaro) — Security Committee Chair
- **David Mraihi** (CARIAD)
- **Howard Alyne** (Wind River)
- **John Kikidis** (Renesas)
- **Kumar Gala** (Analog Devices)
- **Marti Bolivar** (Qualcomm)
- **Megan Knight** (Arm)
- **Peter Gielda** (Antmicro)
- **Reidar Martin Svendsen** (Nordic Semiconductor)
- **Vitalij Selynin** (ZEISS)

> **Fuente:** [Zephyr Project — Governing Board](https://www.zephyrproject.org/governing-board/)

### 4.2 Technical Steering Committee (TSC)

El **Technical Steering Committee (TSC)** es el máximo órgano de **decisión técnica**. Sus responsabilidades incluyen:

- Definir y mantener la visión técnica del proyecto
- Servir como el máximo cuerpo decisión técnica
- Coordinar la colaboración entre comunidades

Está compuesto por **project maintainers** (mantenedores del proyecto) de diversas organizaciones. El **TSC Chair** actual es **Anas Nashif** (Intel).

Los TSC members incluyen representantes de: Nordic Semiconductor, Intel, NXP, Alif Semiconductor, Blues Wireless, Canonical, Demant, Linaro, Blecon, Percepio, STMicroelectronics, Qualcomm, Google, Hubble Network, Vestas, Wind River, Tenstorrent, ZEISS, Silicon Labs, Antmicro, Renesas, Doulos, Arduino, MicroEJ, Microchip, Meta, Whirlpool, IAR, Espressif Systems, Realtek, Raytac, Qt Company, Infineon, Texas Instruments, y miembros elegidos por la comunidad.

> **Fuente:** [Zephyr Project — TSC](https://www.zephyrproject.org/tsc/)

### 4.3 Niveles de Membresía y Financiamiento

La Linux Foundation opera con un modelo de membresías escalonado:

| Nivel | Descripción |
|-------|-------------|
| **Platinum** | Máximo nivel. Aportan financiamiento significativo y representación en el Governing Board |
| **Gold** | Nivel intermedio. Contribuyen financieramente y tienen voz en gobernanza |
| **Silver** | Nivel base para corporaciones. Cuota según cantidad de empleados (entre $5,000 y $20,000 USD anuales) |

Los Gold Members contribuyen un total combinado de **US$1.2 millones** (dato de Linux Foundation).

> **Fuente:** [Wikipedia — Linux Foundation](https://en.wikipedia.org/wiki/Linux_Foundation)

### 4.4 Seguridad y Comités Especializados

Zephyr cuenta con un **[Security Committee](https://www.zephyrproject.org/security/)** dedicado chaired por **David Brown** (Linaro). Este comité:

- Supervisa el desarrollo seguro del código
- Mantiene el **Vulnerability Alert Registry**
- Coordina **security disclosures** vía GitHub Security Advisories
- Gestiona **code reviews** y static code analysis periódica

> **Fuente:** [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html)

---

## 5. Segmento de Mercado

### 5.1 Posicionamiento

Zephyr se posiciona en el mercado de:

- **IoT (Internet of Things)** — sensores, dispositivos conectados de bajo consumo
- **Sistemas embebidos de recursos restringidos** — microcontroladores (microcontrollers, MCUs)
- **Wearables** — smartwatches, dispositivos médicos auditivos (hearing aids)
- **Industrial** — controladoras programables, sistemas de automatización
- **Dispositivos médicos** — audífonos avanzados (ej: Oticon More), monitores de ECG
- **Transporte** — scooters eléctricos, cerraduras Bluetooth, trackers GPS
- **Sostenibilidad** — turbinas eólicas (Vestas), paneles solares

### 5.2 Adopción Global (Datos 2026)

Según el reporte de Linux Foundation Research **"Zephyr Turns 10"** (marzo 2026), basado en encuestas a 413 profesionales globales:

- **70%** de organizaciones en **Norteamérica** ya usan Zephyr en productos comerciales
- **62%** de organizaciones en **Europa** usan Zephyr en productos comerciales
- **69%** planea **aumentar o significativamente aumentar** la adopción
- **52%** de organizaciones reportan dar soporte a productos Zephyr por **5 a 10 años o más**
- Solo **1%** espera disminuir el uso
- Más de **3,000 contribuyentes** globales
- Más de **1,000 boards** soportadas

> **Fuente:** [Linux Foundation — "Zephyr at 10: A Decade of Open Source Embedded Innovation"](https://www.linuxfoundation.org/blog/zephyr-at-10-a-decade-of-open-source-embedded-innovation), [Zephyr Project Announcement — "Zephyr Turns 10"](https://www.zephyrproject.org/zephyr-turns-10-as-global-adoption-surges-and-long-term-embedded-use-expands/)

### 5.3 Productos Comerciales que Usan Zephyr

La lista oficial de productos comerciales incluye docenas de ejemplos notables:

| Producto | Empresa/Sector |
|----------|---------------|
| **Vestas Wind Turbines** | Energía eólica a gran escala |
| **Framework Laptop 13 DIY** | Notebook modular con AMD Ryzen 7040 |
| **Google Chromebook** | Componentes embedded de ChromeOS |
| **Oticon More** | Audífono recargable avanzado |
| **HealthyPi Move** | Dispositivo médico ECG |
| **Tauro Smart Collar** | Collar GPS para ganado |
| **Bitvis Power Hub** | Medidor de energía HAN-port |
| **GARDENA smart Irrigation Control** | Controlador de riego inteligente |
| **Tenstorrent Blackhole** | Acelerador PCIe AI |
| **Tibbo Project System** | Plataforma modular IoT industrial |
| **Wise BLixt Zero** | Interruptor de circuito sólido mini |

> **Fuente:** [zephyrproject.org/products-running-zephyr](https://www.zephyrproject.org/products-running-zephyr/)

### 5.4 ¿Por Qué las Empresas Eligen Zephyr?

Según la investigación de Linux Foundation, las principales razones son:

1. **Eliminación de vendor lock-in** — Al no depender de Amazon (FreeRTOS) o Microsoft (ThreadX), las empresas preservan independencia
2. **Portabilidad de hardware** — 49% de usuarios citan que la portabilidad entre diferentes MCUs es el mayor beneficio
3. **Seguridad robusta** — Security Subcommittee dedicado, PSA Crypto, secure boot, OpenSSF Gold Badge
4. **Conectividad integrada** — BLE, Wi-Fi, Thread, 802.15.4, LoRa, Cellular, CAN bus incluidos
5. **LTS (Long Term Support)** — Versiones con soporte extendido para productos de largo ciclo de vida industrial

> **Fuente:** [Linux Foundation Research — "Zephyr Turns 10"](https://www.linuxfoundation.org/hubfs/Research%20Reports/ZephyrTurns10_Report_022726.pdf)

---

## 6. Modelo de Negocio

Zephyr en sí mismo es **completamente gratuito**:

- **Licencia del kernel:** [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) (permisiva, no copyleft)
- **Licencia del SDK:** También Apache 2.0
- **Sin regalías ni costos de licenciamiento**

### ¿Cómo se financian entonces?

El modelo es **indirecto**. Las empresas miembro pagan membresía a la Linux Foundation por los beneficios de:

- Acceso a la gobernanza del proyecto
- Influencia técnica
- Colaboración con otros miembros
- Acceso a talento y comunidad de desarrolladores

Empresas como **Wind River** ofrecen **servicios de soporte comercial** sobre Zephyr para empresas que lo necesitan. Otras como **Nordic, NXP, Renesas** incluyen soporte Zephyr como parte de sus servicios de venta de chips.

> **Fuente:** [Zephyr Licensing Page](https://docs.zephyrproject.org/latest/LICENSING.html), investigación propia

---

## 7. Gobernanza Neutral: Ventaja Competitiva

Una característica distintiva de Zephyr frente a sus competidores es su **neutralidad**:

| Competidor | Sponsor Principal | Implicancia |
|------------|------------------|-------------|
| **Zephyr** | Linux Foundation (neutral) | Sin vendor lock-in |
| **FreeRTOS** | Amazon (AWS) | Integración nativa con AWS cloud, pero dependencia |
| **ThreadX** | Microsoft/Azure | Integración con Azure, dependencia |
| **RT-Thread** | Comunidad china | Dominante en China, menos soporte occidental |

Zephyr, al estar bajo la Linux Foundation, no pertenece a ninguna empresa individual. Esto atrae a empresas que no quieren depender de un solo proveedor para su infraestructura crítica de embedded systems.

> **Fuente:** [NXP Blog — "Why NXP Became a Founding Member"](https://www.nxp.com/company/about-nxp/smarter-world-blog/BL-ZEPHYR-10-YEAR)

---

## 8. Estructura de Archivos de Información Relacionada

Para mayor profundidad técnica, ver los siguientes documentos del mismo directorio:

- `../B-Historia-y-Evolucion/historia-zephyros.md` — Historia técnica detallada
- `../C-Caracteristicas-Tecnicas/caracteristicas-zephyros.md` — Características técnicas puertas adentro
- `../D-Presencia-en-el-Mercado/presencia-zephyros.md` — Adopción, ecosistema y casos de uso

---

## 9. Fuentes

1. **[Zephyr Project Official](https://www.zephyrproject.org)** — Sitio oficial del proyecto
2. **[Zephyr Governing Board](https://www.zephyrproject.org/governing-board/)** — Miembros de la junta Gobernante
3. **[Zephyr Technical Steering Committee (TSC)](https://www.zephyrproject.org/tsc/)** — Comité Directivo Técnico
4. **[Wikipedia — Zephyr (operating system)](https://en.wikipedia.org/wiki/Zephyr_(operating_system))**
5. **[Wikipedia — Linux Foundation](https://en.wikipedia.org/wiki/Linux_Foundation)**
6. **[Wikipedia — Wind River Systems](https://en.wikipedia.org/wiki/Wind_River_Systems)**
7. **[Wikipedia — Eonic Systems](https://en.wikipedia.org/wiki/Eonic_Systems)**
8. **[Intel Developer Article — "The Zephyr Story: How It Became a Self-Sustaining Ecosystem"](https://www.intel.com/content/www/us/en/developer/articles/community/zephyr-story-how-became-self-sustaining-ecosystem.html)**
9. **[Linux Foundation Blog — "Zephyr at 10: A Decade of Open Source Embedded Innovation"](https://www.linuxfoundation.org/blog/zephyr-at-10-a-decade-of-open-source-embedded-innovation)**
10. **[Shawn Hymel — "A Brief History of Zephyr RTOS"](https://shawnhymel.com/2791/a-brief-history-of-zephyr-rtos/)**
11. **[Wind River Blog — "Wind River Welcomes Linux Foundation's Zephyr Project"](https://www.windriver.com/blog/wind-river-welcomes-linux-foundations-zephyr-project)**
12. **[NXP Blog — "Zephyr at 10 Years: Why NXP Became a Founding Member"](https://www.nxp.com/company/about-nxp/smarter-world-blog/BL-ZEPHYR-10-YEAR)**
13. **[Linux Foundation Press Release — "The Linux Foundation Announces Project to Build Real-Time Operating System for IoT Devices"](https://www.linuxfoundation.org/press/press-release/the-linux-foundation-announces-project-to-build-real-time-operating-system-for-internet-of-things-devices)**
14. **[Zephyr Project — "Zephyr Turns 10 as Global Adoption Surges"](https://www.zephyrproject.org/zephyr-turns-10-as-global-adoption-surges-and-long-term-embedded-use-expands/)**
15. **[Zephyr Project — "Zephyr RTOS Expands Ecosystem with Renesas and Wind River Upgrading to Platinum Membership"](https://www.prnewswire.com/news-releases/zephyr-rtos-expands-ecosystem-with-renesas-and-wind-river-upgrading-to-platinum-membership-and-new-silver-members-blecon-and-embeint-302485307.html)**
16. **[Zephyr Project — Project Members](https://www.zephyrproject.org/project-members/)**
17. **[Zephyr Project — Products Running Zephyr](https://www.zephyrproject.org/products-running-zephyr/)**
18. **[Zephyr Project — Platinum Members](https://zephyrproject.org/members_category/platinum/)**
19. **[Zephyr Licensing Page](https://docs.zephyrproject.org/latest/LICENSING.html)**
20. **[Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html)**

---

*Documento preparado para el Trabajo Práctico Especial de Fundamentos de Sistemas Operativos. Última actualización: mayo 2026.*

---
## Nota Académica — Fundamentos de SO

**Conceptos de la materia relacionados:**

- **§1.4 — Microkernel (Arquitectura de SO)**: Zephyr OS implementa una **arquitectura microkernel** donde el kernel está dividido en componentes mínimos (nanokernel + microkernel unificados desde v1.6). Esto contrasta con sistemas monolithíticos como Linux tradicionales. La ventaja académica es que Zephyr demuestra cómo un microkernel logra baja latencia y footprint mínimo (4 KB) mientras mantiene modularidad — un caso real del tradeoff entre comunicación por paso de mensajes (microkernel) vs llamada de procedimiento directo (monolítico).

- **§1.1 — Máquina Extendida (gestor de recursos)**: Zephyr ejemplifica el concepto de SO como "máquina extendida" al abstraer el hardware restringido de microcontroladores (MCU) para IoT. Sin Zephyr, el programador debería manejar directamente registros de periféricos, timers, y comunicación BLE. Zephyr presenta una API unificada que oculta la heterogeneidad de arquitecturas (ARM, RISC-V, x86) — democratizando el desarrollo embebido.

- **§1.5 — Modo Dual de Operación (kernel vs usuario)**: En sistemas embebidos como Zephyr, la distinción kernel/user mode sigue presente pero con nuances. Zephyr soporta arquitectura de privilege levels (Supervisor vs User) donde drivers y scheduling corren en modo privilegiado. Estudiar Zephyr permite entender cómo el modo dual opera en MCUs donde el hardware no soporta MMU completa — relevante para sistemas operativos de tiempo real.

- **§1.2 — 4ª Generación (UNIX, Linux)**: Zephyr es un proyecto hospeado bajo la **Linux Foundation**, lo que lo vincula directamente a la evolución del software libre始于 UNIX/Linux. Su linaje (Virtuoso → Rocket → Zephyr bajo Linux Foundation) refleja la tendencia de empresas como Wind River de abrir código proprietario hacia el modelo abierto. Esto conecta con el tema de cómo las generaciones de SO evolucionaron desde mainframes hacia sistemas abiertos y distribuidos.

- **§1.4 — Cliente-Servidor (Arquitectura)**: El modelo de gobernanza de Zephyr (Governing Board + TSC + Working Groups) es funcionalmente una arquitectura **cliente-servidor**: los miembros (clientes) proponen y votan cambios, mientras el TSC (servidor) orquestra la implementación técnica. Esto es análogo a cómo muchos SO modernos implementan servicios como daemons (systemd, DBus) comunicándose por mensajes.
