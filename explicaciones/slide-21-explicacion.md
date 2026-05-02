# slide-21-explicacion.md — Zephyr OS: Soporte a Usuarios

---

## Visión General

Esta slide presenta el ecosistema de soporte de Zephyr OS, un RTOS open source gobernado por la Linux Foundation. El mensaje central es que Zephyr ofrece un modelo de soporte **multinivel** que combina recursos comunitarios gratuitos con opciones comerciales empresariales, creando un ecosistema autosostenible donde la documentación oficial, la comunidad activa, y el soporte corporativo de los miembros coexisten para dar cobertura a todo tipo de usuarios — desde makers hasta OEMs de electrónica embebida.

La slide está estructurada en cinco bloques informativos principales y una barra inferior que resume la estructura de membresía corporativa. Cada bloque aborda un aspecto diferente del soporte disponible.

---

## 1. Documentación Oficial (docs.zephyrproject.org)

### Qué es y qué contiene

docs.zephyrproject.org es el portal de documentación oficial del Proyecto Zephyr. Es una de las características más destacadas del proyecto y representa uno de los pilares del soporte a usuarios. La documentación se actualiza con cada release del proyecto y ofrece versiones archiveadas para versiones anteriores del kernel, lo que permite a usuarios que trabajan con versiones LTS acceder a la documentación específica de su versión sin temor a que se vuelva obsoleta.

La documentación cubre múltiples dimensiones:

- **Getting Started Guide**: Guía paso a paso para nuevos usuarios que cubre desde la instalación del toolchain hasta el primer "Hello World" en Zephyr. Incluye instrucciones para múltiples sistemas operativos (Windows, macOS, Linux) y múltiples metodologías de instalación (desde código fuente, desde releases binarios, usando packages managers).

- **API Reference**: Referencia completa de todas las APIs del kernel Zephyr, incluyendo las APIs dethreads, mutexes, semaphores, timers, interrupt handling, y subsystem-level APIs como Bluetooth, Wi-Fi, y storage. Cada función documenta parámetros, valores de retorno, y contexto de uso.

- **Kernel Guide**: Documentación profunda del diseño y arquitectura del kernel de Zephyr. Cubre topics como scheduling algorithms, memory management, interrupt handling, power management, y board-specific configurations. Es la referencia para desarrolladores que necesitan entender el kernel internals.

- **Security Documentation**: Sección dedicada aPSA Certified compliance, secure boot, hardware attack surface mitigation, y las security advisories publicadas. Zephyr mantiene un Security Subcommittee que publica CVEs y parches de seguridad en [docs.zephyrproject.org/latest/security/index.html](https://docs.zephyrproject.org/latest/security/index.html).

- **Samples and Tutorials**:Repositorio de ejemplos de código funcionales que cubren desde demos básicos hasta implementaciones complejas de Bluetooth Low Energy, Thread, Wi-Fi, y sistemas de archivos.

### Características técnicas destacadas

La documentación ofrece búsqueda integrada (search bar en la esquina superior derecha) que permite buscar a través de toda la documentación, incluyendo múltiples versiones. El selector de versión permite cambiar entre la documentación de diferentes releases — algo útil cuando se trabaja con versiones LTS que pueden tener comportamiento específico.

Esta documentación exhaustiva es relevante para FSO porque refleja el concepto de que un SO no es solo código sino también el ecosistema de conocimiento que lo rodea. En sistemas embebidos, donde el hardware es altamente heterogéneo, la documentación de soporte de hardware (boards, sensores, actuadores) es parte integral de la gestión de recursos del sistema.

---

## 2. Comunidad Activa (Discord, GitHub, Mailing Lists, IRC)

### Canales comunitarios

Zephyr tiene múltiples canales comunitarios que sirven diferentes propósitos y diferentes estilos de comunicación:

**Discord (canal primario de chat en tiempo real)**: El servidor oficial de Discord es descrito en la documentación oficial como el canal de chat principal usado por los desarrolladores de Zephyr. El servidor tiene canales temáticos para diferentes arquitecturas (ARM, RISC-V, x86), para diferentes subsystems (Bluetooth, networking, filesystem), y para diferentes stages de adopción (newcomers, intermediate, advanced). Los propios ingenieros que escriben el código participan en Discord, lo que hace que sea posible obtener respuestas directas de los maintainers del proyecto. El enlace de invitación es [discord.com/invite/zephyr-888818750588092488](https://discord.com/invite/zephyr-888818750588092488).

**GitHub Discussions**: Dentro del repositorio principal [github.com/zephyrproject-rtos/zephyr](https://github.com/zephyrproject-rtos/zephyr), la sección Discussions sirve como un forum asíncrono donde usuarios pueden hacer preguntas, compartir proyectos, y solicitar features. A diferencia de Issues (que son para bugs específicos), Discussions está diseñado para preguntas generales, ideas, y conversaciones que no tienen un bug tracking asociado. Es el canal apropiado para preguntas como "¿cómo implemento device tree en mi board?" que no son bugs pero tampoco son lo suficientemente complejas como para requerir una issue formal.

**Mailing Lists**: El proyecto mantiene tres tipos de mailing lists categorizadas por propósito:

- **Developer Lists**: Para discusiones técnicas sobre el desarrollo del código de Zephyr. Aquí se discuten patches, architecture decisions, y contribuciones al codebase. Es donde los contributors discutinen cambios antes de submetê-los como pull requests.

- **Users Lists**: Para preguntas y soporte general. El equivalente mailing list del Discord, pero archivado públicamente y searchable. Antes de hacer una pregunta nueva, la documentación recomienda buscar en los archivos para ver si la duda ya fue respondida.

- **Announce Lists**: Para anuncios oficiales de nuevas versiones, security advisories, y eventos de la comunidad. Solo los maintainers pueden posting; es un canal unidireccional de información.

Las mailing lists están archivadas públicamente y son consultables, lo que crea un conocimiento acumulativo que sobrevive a las conversaciones en tiempo real. Esto es análogo a cómo los archivos de mailing lists de Linux kernel permiten buscar decisiones históricas de diseño.

**Wiki de GitHub**: La [wiki del repositorio](https://github.com/zephyrproject-rtos/zephyr/wiki) contiene información mantenida por la comunidad que complementa la documentación oficial. Incluye listado de proyectos basados en Zephyr, guías de contributed, y listado de dispositivos comerciales que usan Zephyr. La wiki es editable por cualquier contributor y representa conocimiento generado por la comunidad que no aparece en la documentación oficial.

### TSC (Technical Steering Committee) público

El proyecto cuenta con un Technical Steering Committee (TSC) que organiza reuniones públicas cuyas actas se documentan en la wiki. En estas reuniones se discuten el roadmap técnico, decisiones de arquitectura, y estado general del proyecto. La existencia de un TSC público significa que la gobernanza del proyecto es transparente — cualquier persona puede ver cómo se toman las decisiones técnicas. Esto es un diferenciador respecto a RTOS propietarios donde las decisiones de roadmap son internas.

### Dato de escala: 3000+ contribuidores

La slide menciona "3000+ contribuidores" como dato de la comunidad activa. Este número se refiere al total de contributors únicos en el historial del repositorio de GitHub. Zephyr alcanzó este número de contribuidores durante su primera década de existencia (2016-2026). Comparado con MOSIX, que tenía una comunidad pequeña y eventualmente murió por falta de mantenimiento, Zephyr demuestra cómo una comunidad grande y diversa es crítica para la longevidad de un proyecto de SO.

### Conexión con FSO: Comunidad como diferenciador (§1.2)

La materia FSO cubre las generaciones de sistemas operativos (§1.2), donde la 5ª generación (1990-presente) incluye smartphones, cloud computing, y virtualización. En esta era, el éxito de un SO depende tanto de su comunidad como de su código. Zephyr con 3000+ contribuidores ejemplifica este patrón: así como la comunidad de Linux kernel hizo que Linus Torvalds sea tan importante como el código, la comunidad de Zephyr es lo que mantiene el proyecto vivo y relevante.

La documentación oficial con múltiples versiones y búsqueda integrada evidencia un pensamiento maduro sobre cómo los usuarios acceden al conocimiento — algo que no todos los RTOS competidores tienen.

---

## 3. Soporte Comercial (Opcional)

### Modelo de soporte dual

Zephyr opera con un modelo de soporte que tiene dos niveles:

1. **Soporte comunitario gratuito**: Documentación, Discord, GitHub Discussions, mailing lists. Disponible para cualquier persona sin costo.

2. **Soporte comercial de empresas miembros**: Los miembros corporativos (Nordic, Intel, NXP, Renesas, Wind River, etc.) ofrecen soporte en el contexto de sus propios productos. Este soporte es comercial en el sentido de que las empresas lo ofrecen como parte de sus servicios de venta de hardware, pero no es un producto de soporte independiente como un contrato de soporte tradicional.

### Miembros corporativos principales

**Nordic Semiconductor**: Es uno de los mayores contribuidores de código al proyecto Zephyr. Su soporte se enfoca en el uso de Zephyr en sus chips nRF ( BLE, Thread, Zigbee,matter). Nordic ofrece documentación específica para Zephyr en su portal de documentación, y su equipo de engineers participa activamente en la comunidad. El soporte de Nordic es implicitly incluido con la compra de sus chips.

**Intel**: Como miembro fundador y contribuidor principal, Intel proporciona soporte y documentación para el uso de Zephyr en plataformas Intel. Su artículo "The Zephyr Story: How It Became a Self-Sustaining Ecosystem" documenta la evolución del proyecto y su rol en el ecosistema.

**NXP Semiconductors**: NXP ofrece soporte extensivo para Zephyr en sus microcontroladores, incluyendo guías de inicio, documentación técnica, y soporte en sus foros comunitarios. Su portal dedicado a Zephyr incluye una guía de inicio ("Getting Started with Zephyr") disponible en su sitio web.

**Renesas**: En 2025, Renesas elevated su membresía a nivel Platinum. Ofrece soporte para Zephyr en sus plataformas de microcontroladores, incluyendo soporte técnico relacionado con el uso de Zephyr en sus productos.

**Wind River Systems**: Wind River es miembro fundador — el código original de Zephyr vino de Wind River cuando donaron el proyecto a la Linux Foundation. Wind River ofrece soporte comercial a través de **Rocket**, que es una versión comercial de Zephyr con soporte dedicado, actualizaciones de seguridad, servicios en la nube, y certificaciones específicas.

### Training Partners

El Zephyr Training Partner Program es un programa oficial donde miembros Platinum y Silver proporcionan capacitación profesional en Zephyr RTOS. Los training partners ofrecen currículos autorizados por la Zephyr Foundation, lo que garantiza calidad y consistencia en la formación.

Los partners mencionados en la slide:

- **ModularMX**: Training partner oficial que ofrece un currículo autorizado por la Zephyr Foundation. Su programa cubre desde conceptos básicos hasta temas avanzados de desarrollo embebido con Zephyr.

- **Golioth**: Ofrece trainings en vivo mensuales y trainings bajo demanda. La propuesta de Golioth incluye que los participantes solo necesitan traer su propia development board; las herramientas y el entorno son provistos por Golioth.

- **Hacod**: Proveedor de cursos especializados en Zephyr RTOS. Representa el ecosistema de training partners distribuidos globalmente.

Este programa de training partners es un diferenciador respecto a otros RTOS. Mientras FreeRTOS tiene documentación AWS y ThreadX tiene soporte Microsoft, Zephyr tiene un programa estructurado de capacitación con partners autorizados que no depende de una sola empresa.

### Conexión con FSO: Gestión de recursos (§1.1)

En FSO, la gestión de recursos se define como la administración eficiente de CPU, memoria, y dispositivos de E/S. Pero el concepto de "recurso" se extiende más allá del hardware — incluye el recurso humano: la comunidad de desarrolladores y usuarios. Zephyr demuestra que sin documentación exhaustiva, training partners oficiales, y committees técnicos (TSC, Security Subcommittee), incluso el mejor kernel fracasa. El soporte a usuarios es parte integral de la gestión del recurso humano.

---

## 4. Desarrollo Activo (Releases + Bug Tracking + Security)

### Releases regulares y security patches

Zephyr sigue un ciclo de releases regular con nuevas versiones del kernel cada 2-3 meses. Cada release incluye nuevas features, mejoras de performance, soporte para nuevo hardware, y security patches. Las releases se publican en GitHub y se anuncian en la mailing list de Announcements.

### Bug tracking via GitHub Issues

El bug tracking de Zephyr se realiza a través de GitHub Issues en el repositorio principal. Cada issue tiene labels que indican el subsystem afectado, la severidad, y el target release para la fix. La transparencia del bug tracking permite a cualquier persona ver qué bugs están abiertos, cuáles son los priorities, y cómo progressan las fixes.

El proceso de submission de bugs sigue un template estructurado que requiere información como: board y configuración, steps para reproducir, output esperado vs actual, y versión de Zephyr. Esto ayuda a que los bugs sean reproducibles y facilita la diagnosis.

### Security Subcommittee dedicado

Zephyr tiene un Security Subcommittee dedicado que supervisa la seguridad del proyecto. Este subcommittee es responsable de:

- Recibir y evaluar reportes de seguridad
- Coordinar la publicación de CVEs (Common Vulnerabilities and Exposures)
- Mantener el proceso de security advisories
- Revisar código por vulnerabilidades

La existencia de un Security Subcommittee dedicado es un diferenciador respecto a muchos RTOS comunitarios que no tienen un grupo dedicado a seguridad.

### LTS versions con soporte 10-20 años

Zephyr ofrece Long Term Support (LTS) versions que reciben soporte por 10 a 20 años. Esto es crítico para sistemas embebidos de largo lifecycle como dispositivos médicos, automotive, y sistemas industriales donde el producto puede necesitar soporte de seguridad por décadas después del deployment inicial.

Las versiones LTS reciben backports de security patches pero no se les agregan nuevas features. Esto permite que productos en el campo permanezcan seguros sin las complejidades de actualizarse a una nueva versión major.

---

## 5. Estructura de Membresía (Platinum / Gold / Silver)

### Los tres niveles

La membresía en el proyecto Zephyr está estructurada en tres niveles basados en la contribución financiera y técnica al proyecto:

**Platinum Members**: Son los miembros con mayor nivel de influencia y compromiso. Pagjan la membresía más alta y tienen representación garantizada en el Technical Steering Committee (TSC). Los Platinum members contribuyen código significativamente al proyecto y son los principales drivers del roadmap técnico.

Miembros Platinum mencionados en la slide:

- **Nordic Semiconductor** (actualizado a Platinum en 2025)
- **Renesas** (actualizado a Platinum en 2025)
- **Wind River** (actualizado a Platinum en 2025)

**Gold Members**: Contribuidores significativos con voz en la gobernanza pero en un nivel debajo de Platinum. Miembros Gold mencionado en la slide:

- **Intel** (miembro fundador)
- **NXP** (miembro fundador)

**Silver Members**: Membresía básica que da acceso a recursos y participación en la comunidad. Nuevos Silver members mencionados en 2025:

- **Blecon**
- **Embeint**

### Qué soporte genera cada nivel de membresía

Cada nivel de membresía genera diferentes formas de soporte al proyecto:

- **Voz en la gobernanza**: Los Platinum y Gold members tienen representación en el TSC, lo que les da influencia sobre el roadmap técnico y las decisiones arquitectónicas del proyecto.

- **Código y soporte de hardware**: Los miembros corporativa contribuyen código que añade soporte para sus propios productos (boards, SoCs, sensores). Nordic contribuye soporte para nRF series, NXP para sus LPC y i.MX series, Intel para sus plataformas.

- **Documentación específica**: Cada miembro mantiene documentación específica para sus productos en sus propios portales, lo que expande la documentación general disponible para usuarios.

- **Training partners**: Los miembros Platinum y Gold pueden convertirse en Zephyr Training Partners, ofreciendo capacitación profesional autorizada.

- **Soporte técnico indirecto**: Cuando un usuario tiene un problema con Zephyr en una platform de un miembro (por ejemplo, Nordic nRF52), puede buscar soporte en los foros del miembro.

### Conexión con FSO: Gobernanza y evolución arquitectónica (§1.4)

La estructura de membresía de Zephyr refleja cómo las arquitecturas de SO modernas incorporan governance structures. La neutralidad de la Linux Foundation como "umbrella" evita vendor lock-in — un concepto análogo a cómo UNIX evolucionó con POSIX como layer de neutralidad. Empresas que usan Zephyr no están atadas a un vendor específico (como sí ocurre con FreeRTOS/AWS o ThreadX/Azure), lo que reduce el riesgo de dependencia.

Wind River oferecendo "Rocket" como versión comercial de Zephyr exemplifica el pattern de open-core que muchos proyectos de SO adoptan: la base es open source (Zephyr), y sobre ella se construye una capa comercial (Rocket) con soporte dedicado y features adicionales.

---

## Glosario de Términos

### Bug Tracking

Sistema de registro y seguimiento de bugs (defectos de software). En Zephyr, GitHub Issues sirve como bug tracker oficial. Cada bug tiene un estado (open, in progress, closed), labels de categorización, y puede estar asignado a un maintainer específico. El bug tracking permite que la comunidad vea el estado de la calidad del software y que los desarrolladores prioricen fixes.

### Commercial Support

Modelo de soporte donde una empresa cobra por proporcionar soporte técnico, usualmente con garantías de tiempo de respuesta y availability. En el contexto de Zephyr, el commercial support viene de empresas como Wind River (Rocket) y de los miembros corporativos en el contexto de sus productos de hardware. No es un soporte centralizado como Red Hat Enterprise Linux, sino un ecosistema descentralizado.

### Community Support

Soporte gratuito proporcionado por la comunidad (otros usuarios, contributors, maintainers). Incluye foros, Discord, mailing lists, y GitHub Discussions. El community support es asíncrono y depende de la disponibilidad de voluntarios, por lo que no hay garantías de tiempo de respuesta.

### Discord Community

Plataforma de chat en tiempo real con canales temáticos. El Discord de Zephyr es el canal de chat primario para soporte en tiempo real. Es apropiado para preguntas que necesitan respuesta rápida y para discussions en tiempo real entre developers. A diferencia de las mailing lists (asíncronas y archivadas), Discord es efímero y no searchable públicamente.

### LTS (Long Term Support)

Versiones de software que reciben actualizaciones de seguridad y bugs por un período extendido (10-20 años en el caso de Zephyr). Las versiones LTS son apropiadas para productos con ciclos de vida largos donde actualizar a una nueva versión no es práctico. Las versiones no-LTS tienen soporte más corto (típicamente 1-2 años).

### Mailing Lists

Sistemas de comunicación por email donde los mensajes se envían a una lista de suscriptores. En Zephyr existen developer, users, y announce lists. Las mailing lists son archivadas públicamente, lo que crea un conocimiento histórico searchable. Son más formales que Discord y apropiadas para discusiones que necesitan persistencia.

### Membership Tiers

Niveles de membresía corporativa en el proyecto Zephyr (Platinum, Gold, Silver). Cada nivel tiene diferentes beneficios de gobernanza y diferentes requisitos de contribución financiera y técnica.

### TSC (Technical Steering Committee)

Comité Directivo Técnico del Proyecto Zephyr. Responsable de definir el roadmap técnico, tomar decisiones arquitectónicas, y supervisar la dirección del proyecto. Los Platinum y Gold members tienen representación en el TSC. Las reuniones del TSC son públicas y documentadas.

### Training Partner

Empresa que ha sido autorizada por la Zephyr Foundation para proporcionar capacitación oficial en Zephyr RTOS. Los training partners siguen un currículo autorizado y proporcionan formación profesional en un entorno profesional. Son típicamente miembros Platinum o Silver.

### Wind River Rocket

Producto comercial de Wind River Systems basado en Zephyr. Incluye soporte técnico dedicado, actualizaciones de seguridad, servicios en la nube, y certificaciones específicas. Es un ejemplo del modelo open-core donde una empresa toma la base open source y añade una capa comercial con soporte premium.

---

## Nota Académica: Conexión con FSO

La slide referencia explícitamente dos secciones del temario de FSO:

### §1.1 — Gestión de recursos: ecosistema de soporte

En FSO, la gestión de recursos se define como la administración eficiente de CPU, memoria, y dispositivos de E/S. Pero el concepto de "recurso" se extiende al recurso humano: la comunidad de desarrolladores y usuarios. Zephyr demuestra que sin documentación exhaustiva, training partners oficiales, y committees técnicos, incluso el mejor kernel fracasa.

El soporte a usuarios es parte integral de la gestión del recurso humano. Así como un SO debe gestionar la CPU y la memoria, debe facilitar que los humanos que interactúan con el sistema (desarrolladores, usuarios finales, integradores) puedan usarlo efectivamente.

La documentación de Zephyr con soporte multi-version y búsqueda integrada es análoga a cómo un SO gestiona múltiples versiones de archivos o múltiples espacios de memoria — requiere pensar en términos de versiones, lifecycle, y acceso.

### §1.2 — Comunidad como diferenciador (5ª generación)

La 5ª generación de sistemas operativos (1990-presente) incluye móviles, cloud computing, y virtualización. En esta era, el éxito de un SO depende tanto de su comunidad como de su código.

Zephyr tiene 3,000+ contribuidores mientras que MOSIX murió por falta de comunidad. Este patrón se ve también en Linux kernel — la comunidad hizo que Linus Torvalds sea tan importante como el código. En la era post-2000, un proyecto de SO sin comunidad activa tiene dificultades para sobrevivir: necesita reviews, necesita bugs reportados, necesita contribuciones de código, necesita documentation.

La documentación oficial de Zephyr con multi-version support y search integrado evidencia un pensamiento maduro sobre cómo los usuarios acceden al conocimiento — algo que muchos RTOS competidores no tienen.

### §1.4 — Gobernanza y evolución arquitectónica

La estructura de membresía de Zephyr (Platinum/Gold/Silver) refleja cómo las arquitecturas de SO modernas incorporan governance structures. La neutralidad de la Linux Foundation como "umbrella" evita vendor lock-in — un concepto análogo a cómo UNIX evolucionó con POSIX como layer de neutralidad.

Wind River oferecendo "Rocket" como versión comercial de Zephyr exemplifica el pattern de open-core que muchos proyectos de SO adoptan: la base es open source (Zephyr), y sobre ella se construye una capa comercial (Rocket) con soporte dedicado y features adicionales.

---

## Comparación del Modelo de Soporte con Competidores

| RTOS | Sponsor/Org | Soporte Cloud | Modelo de Soporte |
|------|-------------|---------------|--------------------|
| **Zephyr** | Linux Foundation | No tiene integración cloud nativa | Comunitario + Miembros corporativos + Wind River (comercial) |
| **FreeRTOS** | Amazon (AWS) | AWS IoT integrado | Comunitario + Documentación AWS + SafeRTOS (comercial) |
| **ThreadX** | Microsoft | Azure integrado | Comunitario + Microsoft support + certificaciones |
| **NuttX** | Apache Foundation | No tiene | Comunitario |
| **RIOT OS** | Comunidad | No tiene | Comunitario + Académico |

### Diferenciadores de Zephyr

1. **Gobernanza neutral**: No pertenece a Amazon (FreeRTOS) ni a Microsoft (ThreadX), lo que atrae empresas que quieren evitar vendor lock-in.

2. **Training Partner Program oficial**: Un programa estructurado de capacitación con partners autorizados.

3. **Soporte multi-vendor**: La diversidad de miembros corporativos (Nordic, Intel, NXP, Renesas) provee soporte para múltiples ecosistemas de hardware.

4. **Security Subcommittee dedicado**: Un comité específico para seguridad.

5. **Releases LTS con soporte 10-20 años**: Para productos de largo lifecycle.

---

## Fuentes de Información

Toda la información de esta explicación proviene de las siguientes fuentes verificadas:

1. [Zephyr Project Official Site](https://www.zephyrproject.org)
2. [Zephyr Project Community Page](https://www.zephyrproject.org/community/)
3. [Zephyr Discord Server](https://discord.com/invite/zephyr-888818750588092488)
4. [Communication and Collaboration — Zephyr Documentation](https://docs.zephyrproject.org/latest/project/communication.html)
5. [Zephyr Training Partner Program](https://www.zephyrproject.org/training-partner-program/)
6. [Ecosystem Vendor Offerings — Zephyr Project](https://www.zephyrproject.org/ecosystem-vendor-offerings/)
7. [Zephyr Member Offerings](https://zephyrproject.org/member-offerings/)
8. [Zephyr Wiki en GitHub](https://github.com/zephyrproject-rtos/zephyr/wiki)
9. [Zephyr Documentation](https://docs.zephyrproject.org/latest/index.html)
10. [Intel — The Zephyr Story](https://www.intel.com/content/www/us/en/developer/articles/community/zephyr-story-how-became-self-sustaining-ecosystem.html)
11. [NXP — Zephyr OS for Edge Connected Devices](https://www.nxp.com/design/design-center/software/embedded-software/zephyr-os-for-edge-connected-devices:ZEPHYR-OS-EDGE)
12. [Zephyr Turns 10 announcement](https://www.zephyrproject.org/zephyr-turns-10-as-global-adoption-surges-and-long-term-embedded-use-expands/)
13. [Golioth — Zephyr Training](https://blog.golioth.io/zephyr-training-in-now-anytime-anywhere-thanks-to-codespaces/)
14. [ModularMX — The Zephyr Training](https://modular-mx.com/Trainings/thezephyrtraining/)

---

*Explicación generada para la slide 21 del TP Especial Zephyr-MOSIX — Fundamentos de Sistemas Operativos, UNMDP*