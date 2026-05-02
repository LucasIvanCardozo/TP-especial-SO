# Costos de Zephyr OS — Uso Comercial y Modelo de Licenciamiento

> **Nota:** Este documento describe el modelo de costos y licenciamiento de Zephyr OS para uso comercial. Está orientado a equipos de desarrollo y empresas que evalúan RTOSes para productos comerciales.

---

## 1. Licencia Apache 2.0

Zephyr OS se distribuye bajo la **[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)**, una licencia de software libre **permisiva** (no copyleft).

### ¿Qué significa en la práctica?

| Aspecto | Detalle |
|---|---|
| **Uso comercial** | ✅ Permitido sin restricciones |
| **Modificación del código** | ✅ Permitido |
| **Distribución del código modificado** | ✅ Permitido, requiere atribución y aviso de licencia |
| **Uso en productos propietarios** | ✅ Permitido — se puede incluir en software closed-source |
| **Copyleft** | ❌ **NO** — no existe la obligación de liberar el código modificado |
| **Regalías** | ❌ **NINGUNA** — no se requiere pago alguno |
| **Patentes** | ✅ Incluye licencia de patentes de Apache para los contribuidores |

### ¿Por qué "no copyleft" es importante?

A diferencia de licencias copyleft como **LGPL** o **GPL**, la Apache 2.0 permite:

- **Incorporar Zephyr en productos comerciales propietario** sin obligación de publicar las modificaciones internas.
- **Usar Zephyr como base para software cerrado** (por ejemplo, el firmware de un producto comercial).
- **No imponer restricciones a nivel de licenciamiento** sobre el producto final.

> *"The Apache License 2.0 is a permissive license, meaning there are few restrictions on the use of the code."* — [Snyk, "Apache License 2.0 Explained"](https://snyk.io/articles/apache-license/)

> *"You can use the software for commercial purposes without paying any royalties. This makes the Apache 2.0 License an attractive option for commercial products."* — [FTP Bills, "Understanding The Apache License 2.0"](https://ftp.bills.com.au/lunar-tips/understanding-the-apache-license-2-0-a-simple-guide-1764799539)

**Fuente:** [Zephyr Licensing Documentation](https://docs.zephyrproject.org/latest/LICENSING.html)

---

## 2. Sin Costos de Licenciamiento ni Regalías

Zephyr OS es **completamente gratuito** para usar en cualquier contexto:

| Concepto | Costo |
|---|---|
| **Descarga del código fuente** | USD $0 |
| **Uso en productos comerciales** | USD $0 |
| **Regalías por unidad vendida** | USD $0 |
| **Permisos de uso** | No se requieren |
| **Auditorías de licencia** | No aplica |

El kernel y el SDK de Zephyr se distribuyen sin costo alguno. No existe un "producto de pago" obligatorio para usar Zephyr en productos comerciales.

> *"Zephyr is totally free — no licensing costs, no royalties, no permissions needed."* — Basado en [investigación.md §3.5](investigacion.md)

**Fuente:** [Zephyr Licensing Documentation](https://docs.zephyrproject.org/latest/LICENSING.html)

---

## 3. Gratuito para Uso Comercial

Esta característica hace a Zephyr especialmente atractivo para:

- **Startups y PyMEs** que no pueden pagar licencias costosas de RTOS propietarios.
- **Empresas que fabrican millones de unidades** (por ejemplo, IoT devices), donde las regalías de otros RTOS podrían representar un costo significativo.
- **Productos de ciclo de vida largo** (industrial, médico, automotriz) que requieren estabilidad de licenciamiento por 10-20 años.

### Comparación de Costo Inicial

| RTOS | Costo de licenciamiento | Regalías |
|---|---|---|
| **Zephyr** | USD $0 | USD $0 |
| **FreeRTOS** | USD $0 (MIT) | USD $0 |
| **ThreadX** | USD $0 (MIT, desde 2024) | USD $0 |
| **RT-Thread** | USD $0 (Apache 2.0) | USD $0 |
| **RTOS propietarioss** (VxWorks, QNX, etc.) | Costo por licencia fija o anual | Frecuentemente por unidad |

> **Nota:** Los RTOS de código abierto mencionados (FreeRTOS, ThreadX, RT-Thread) también son gratuitos. La diferencia no está en el costo sino en la gobernanza, soporte comercial y features.

**Fuente:** Investigación existente (sección 3.5), [AWS FreeRTOS Pricing](https://aws.amazon.com/freertos/pricing/), [RT-Thread Licensing](https://www.rt-thread.io/contribution.html)

---

## 4. ¿Cómo se Financia el Proyecto? — Membresía a Linux Foundation

Zephyr no es una empresa ni un producto comercial de un vendor individual. Es un proyecto de la **[Linux Foundation](https://www.linuxfoundation.org/)**, una organización sin fines de lucro que alberga proyectos de código abierto.

### Modelo de Financiamiento

El proyecto Zephyr se sostiene mediante **membresías corporativas** a la Linux Foundation:

| Nivel de membresía | Ejemplos (2025) |
|---|---|
| **Platinum** | Intel, Nordic Semiconductor, NXP, Renesas, Wind River, Google, Meta, Analog Devices, Antmicro, CARIAD |
| **Gold** | Miembros de nivel inferior |
| **Silver** | Blecon, Embeint (2025), entre otros |

Cada miembro corporativo paga una cuota anual que financia:

- El equipo de desarrollo central de Zephyr.
- Eventos y conferencias (Embedded World, etc.).
- Infraestructura (CI/CD, servidores de documentación).
- El personal administrativo del proyecto.

> *"Corporate members pay membership fees to the Linux Foundation; companies like Wind River offer commercial support services on top of Zephyr."* — Basado en [investigacion.md §3.5](investigacion.md)

### ¿Por qué las empresas pagan membresía?

Las empresas membresías obtienen:

1. **Influencia técnica** en la roadmap del proyecto (a través del Technical Steering Committee).
2. **Acceso prioritario** a soporte técnico de los engineering teams de Zephyr.
3. **Visibilidad de marca** como sponsors del proyecto.
4. **Talent pool** — acceso a desarrolladores entrenados en Zephyr.

> *"The Zephyr Project announced that Renesas and Wind River have upgraded membership to Platinum as Blecon and Embeint join as Silver members."* — [PR Newswire, junio 2025](https://www.prnewswire.com/news-releases/zephyr-rtos-expands-ecosystem-with-renesas-and-wind-river-upgrading-to-platinum-membership-and-new-silver-members-blecon-and-embeint-302485307.html)

**Fuente:** [Linux Foundation Press Release](https://www.linuxfoundation.org/press/zephyr-rtos-expands-ecosystem-with-renesas-and-wind-river-upgrading-to-platinum), [Zephyr Project Member Ecosystem](https://www.zephyrproject.org/ecosystem-vendor-offerings/)

---

## 5. Servicios de Soporte Comercial Opcionales

Aunque Zephyr en sí es gratuito, existen **servicios de soporte comercial opcionales** ofrecidos por empresas del ecosistema:

### 5.1 Wind River

**Wind River Systems** es uno de los miembros Platinum más activos. Ofrece servicios profesionales para Zephyr:

- **Soporte técnico comercial** para equipos usando Zephyr en productos de producción.
- **Formación y entrenamiento** certificado.
- **Servicios de consultoría** para porting y desarrollo de drivers.

> *"Wind River's professional services for Zephyr empower embedded developers to overcome challenges and achieve success in their projects."* — [Zephyr Project Blog](https://www.zephyrproject.org/making-zephyr-projects-a-breeze-how-wind-river-empowers-embedded-developers/)

Wind River también ofrece **Wind River Rocket**, una versión comercial derivada de Zephyr con soporte y herramientas adicionales.

### 5.2 Nordic Semiconductor

**Nordic Semiconductor** (líder en Bluetooth LE) ofrece soporte para Zephyr en sus chips:

- **Documentación específica** para usar Zephyr con microcontroladores Nordic.
- **Soporte técnico** a través de sus canales de soporte para clientes de hardware Nordic.
- **Contribution activa** — Nordic es el mayor contribuidor de código a Zephyr (2025).

### 5.3 Otros Miembros con Soporte

| Empresa | Tipo de soporte |
|---|---|
| **Intel** | Soporte para plataformas Intel embebidas |
| **NXP** | Soporte para microcontroladores NXP (i.MX, LPC, etc.) |
| **Renesas** | Soporte para RA, RX, RZ, y otros |
| **Antmicro** | Servicios de ingeniería, simulación, testing |
| **Doulos** | Training partners oficial para Zephyr |

### ¿Cuánto cuestan estos servicios?

**Información no disponible públicamente** en la web abierta. Los costos de soporte comercial varían según:

- El nivel de servicio contratado.
- El número de dispositivos o engineers cobertos.
- El tipo de contrato (anual, por proyecto, etc.).

> **Nota:** Si se requieren servicios de soporte comercial, se debe contactar directamente a los vendors para obtener cotización.

---

## 6. Comparación de Costos con Alternativas

A continuación se presenta una comparativa de costos de Zephyr vs. sus principales alternativas en el segmento IoT/RTOS embebido:

### 6.1 Tabla Comparativa de Costos

| RTOS | Licencia | Costo de licencia | Regalías | Soporte comercial opcional |
|---|---|---|---|---|
| **Zephyr** | Apache 2.0 | USD $0 | USD $0 | Sí (Wind River, Nordic, Intel, NXP, Renesas, Antmicro, etc.) |
| **FreeRTOS** | MIT | USD $0 | USD $0 | Sí (AWS, High Integrity Systems, otros) |
| **ThreadX** (Eclipse) | MIT | USD $0 | USD $0 | Sí (Eclipse Foundation, partners de certificación) |
| **RT-Thread** | Apache 2.0 | USD $0 | USD $0 | Sí (RT-Thread Studio, servicios de consultoría) |
| **NuttX** | Apache 2.0 | USD $0 | USD $0 | Limitado (comunidad) |
| **RIOT OS** | LGPLv2.1 | USD $0 | USD $0 | Limitado (comunidad) |
| **VxWorks** | Propietario | Costo por licencia | Frecuentemente por unidad | Sí (Wind River — mismo vendor) |
| **QNX** | Propietario | Costo por licencia | Por unidad | Sí (BlackBerry QNX) |

### 6.2 Análisis de Cada Alternativa

#### FreeRTOS (MIT License)

- **Costo:** Gratuito. Amazon ofrece FreeRTOS sin costo bajo licencia MIT.
- **Modelo:** Amazon subsidia el desarrollo a través de AWS para impulsar adopción en la nube de AWS.
- **Soporte comercial:** AWS ofrece soporte básico sin costo; empresas como [High Integrity Systems](https://www.highintegritysystems.com/freertos-services/) ofrecen soporte comercial pago.

> *"There is no charge for using FreeRTOS. FreeRTOS is released under the MIT open source license."* — [AWS FreeRTOS Pricing](https://aws.amazon.com/freertos/pricing/)

**Fuente:** [FreeRTOS Licensing](https://www.freertos.org/libraries/license.html)

#### ThreadX / Azure RTOS (MIT License)

- **Costo:** Gratuito. Microsoft abrió el código de ThreadX bajo licencia MIT en noviembre de 2023, donándolo a la Eclipse Foundation.
- **Modelo:** Anteriormente era un producto comercial pago. Ahora es open source con soporte opcional a través de la Eclipse Foundation y partners.

> *"Since it is available under the permissive MIT license, you can use ThreadX without licensing or royalty fees."* — [Eclipse ThreadX FAQ](https://threadx.io/faq/)

**Fuente:** [The Register — Microsoft opensources ThreadX](https://www.theregister.com/2023/11/28/microsoft_opens_sources_threadx/)

#### RT-Thread (Apache 2.0)

- **Costo:** Gratuito. RT-Thread es completamente open source bajo Apache 2.0.
- **Modelo:** El desarrollo es impulsado por la comunidad china con sponsors corporativos.
- **Soporte comercial:** RT-Thread Studio es gratuita; existen servicios de consultoría a través de la comunidad.

> *"RT-Thread follows the Apache License 2.0 free software license. It's completely open-source, can be used in commercial applications for free."* — [RT-Thread](https://www.rt-thread.io/contribution.html)

### 6.3 Punto Clave: Todas las Alternativas Open Source Son Gratuitas

En el año 2026, **todas las alternativas open source principales a Zephyr (FreeRTOS, ThreadX, RT-Thread) son gratuitas** para uso comercial. La diferencia entre ellas no está en el costo sino en:

| Factor | Zephyr | FreeRTOS | ThreadX | RT-Thread |
|---|---|---|---|---|
| **Gobernanza** | Linux Foundation (neutral) | Amazon AWS (vendor lock-in) | Eclipse Foundation (neutral) | Comunidad china |
| **Seguridad** | Security subcommittee, PSA Crypto, OpenSSF Gold Badge | Básico | Certificaciones pre-existentes (IEC 61508, ISO 26262) | Básico |
| **Conectividad** | BLE, Wi-Fi, Thread, 802.15.4, LoRa, Cellular, CAN | Solo BLE | NetX Duo (TCP/IP, IPv4/IPv6, TLS) | Ethernet, Wi-Fi, Bluetooth, NB-IoT |
| **Soporte comercial** | Múltiples vendors | AWS únicamente | Eclipse + partners | Limitado fuera de China |

---

## 7. Resumen Ejecutivo

| Aspecto | Zephyr |
|---|---|
| **Licencia** | Apache 2.0 (permisiva, no copyleft) |
| **Costo del software** | USD $0 — sin costos de licenciamiento ni regalías |
| **Uso comercial** | ✅ Completamente gratuito, incluso en productos propietarios |
| **Financiamiento del proyecto** | Membresías corporativas a Linux Foundation (Intel, Nordic, NXP, Renesas, Wind River, Google, Meta, etc.) |
| **Soporte técnico comunitario** | ✅ Discord, mailing lists, GitHub Discussions (gratuito) |
| **Soporte comercial pago** | ✅ Múltiples vendors: Wind River, Nordic, Intel, NXP, Renesas, Antmicro, Doulos (training), etc. |
| **Costo de servicios de soporte** | Información no disponible públicamente (cotizar con vendors) |

### Implicaciones para el Desarrollo Comercial

1. **No existe barrera económica** para usar Zephyr en productos comerciales, incluso para productos de alto volumen.
2. **No existe riesgo de regalías ocultas** — el modelo es simple: gratis = gratis.
3. **El soporte puede comprarse** si se requiere ayuda profesional, pero no es obligatorio.
4. **La gobernanza neutral** (Linux Foundation) reduce el riesgo de vendor lock-in comparado con alternativas como FreeRTOS (Amazon AWS) o ThreadX (Microsoft/Azure).

---

## FUENTES

1. **Zephyr Licensing Documentation** — [docs.zephyrproject.org/latest/LICENSING.html](https://docs.zephyrproject.org/latest/LICENSING.html)
2. **Apache License 2.0 — Apache Software Foundation** — [apache.org/licenses/LICENSE-2.0](https://www.apache.org/licenses/LICENSE-2.0)
3. **"Apache License 2.0 Explained" — Snyk** — [snyk.io/articles/apache-license](https://snyk.io/articles/apache-license/)
4. **"Understanding The Apache License 2.0" — FTP Bills** — [ftp.bills.com.au](https://ftp.bills.com.au/lunar-tips/understanding-the-apache-license-2-0-a-simple-guide-1764799539)
5. **Investigación existente — TP Zephyr** — [investigacion.md §3.5](investigacion.md) (sección 3.5)
6. **"Zephyr Turns 10" — Zephyr Project Announcement** — [zephyrproject.org](https://www.zephyrproject.org/zephyr-turns-10-as-global-adoption-surges-and-long-term-embedded-use-expands/)
7. **"Zephyr RTOS Expands Ecosystem" — PR Newswire (junio 2025)** — [prnewswire.com](https://www.prnewswire.com/news-releases/zephyr-rtos-expands-ecosystem-with-renesas-and-wind-river-upgrading-to-platinum-membership-and-new-silver-members-blecon-and-embeint-302485307.html)
8. **"Wind River Joins Zephyr as Platinum Member" — LinkedIn** — [linkedin.com](https://www.linkedin.com/posts/stevebeck99_excited-to-see-that-wind-river-has-upgraded-activity-7341898785507201028-A1oT)
9. **"Wind River Empowers Embedded Developers" — Zephyr Project Blog** — [zephyrproject.org](https://www.zephyrproject.org/making-zephyr-projects-a-breeze-how-wind-river-empowers-embedded-developers/)
10. **Zephyr Ecosystem Vendor Offerings** — [zephyrproject.org](https://www.zephyrproject.org/ecosystem-vendor-offerings/)
11. **AWS FreeRTOS Pricing** — [aws.amazon.com/freertos/pricing](https://aws.amazon.com/freertos/pricing/)
12. **FreeRTOS License Details** — [freertos.org/libraries/license.html](https://www.freertos.org/libraries/license.html)
13. **"Microsoft Opensources ThreadX" — The Register** — [theregister.com/2023/11/28/microsoft_opens_sources_threadx](https://www.theregister.com/2023/11/28/microsoft_opens_sources_threadx/)
14. **Eclipse ThreadX FAQ** — [threadx.io/faq](https://threadx.io/faq/)
15. **RT-Thread Contribution Page** — [rt-thread.io/contribution.html](https://www.rt-thread.io/contribution.html)
16. **RT-Thread Official Site** — [rt-thread.io](https://www.rt-thread.io/)

---

*Documento preparado para el Trabajo Práctico Especial de Fundamentos de Sistemas Operativos. Última actualización: mayo 2026.*

---
## Nota Académica — Fundamentos de SO
**Conceptos de la materia relacionados:**

- **§1.1 — Impacto del licenciamiento en la adopción de SO**: El modelo de licencia Apache 2.0 de Zephyr reduce la barrera de entrada para adopción, similar a cómo la disponibilidad de SO open source (Linux) transformó la industria; el licenciamiento determina cómo se distribuya y adopte un SO.

- **Distribución GPL vs. propietaria vs. permissiva**: Zephyr bajo Apache 2.0 representa el modelo "permissivo" que permite uso comercial sin copyleft, a diferencia de Linux (GPL) o QNX/VxWorks (propietario); esto ilustra cómo diferentes modelos de distribución impactan el ecosistema y la adopción.

- **Modelo de financiamiento open source**: El caso de Zephyr (membresías corporativas a Linux Foundation) demuestra cómo proyectos open source sostenibles financian desarrollo, análogo a cómo los SO mantenidos por comunidades sostenían proyectos históricos antes de corporate sponsorship.
