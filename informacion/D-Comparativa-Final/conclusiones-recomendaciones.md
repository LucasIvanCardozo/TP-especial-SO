# Conclusiones y Recomendaciones Finales — Zephyr OS vs MOSIX

> **Nota:** Este documento es autónomo y sirve como sección de cierre del Trabajo Práctico Especial de Fundamentos de Sistemas Operativos. Toda la información se basa en los 24 archivos de investigación previamente creados en las carpetas A, B y C, y en las carpetas de investigación de cada proyecto. Las fuentes se citan con formato [nombre](url).

---

## SECCIÓN 1: Conclusiones sobre Zephyr OS

Zephyr OS es, en 2026, un sistema operativo de tiempo real (RTOS) **altamente viable y recomendado** para el mercado de sistemas embebidos IoT. Los datos de Linux Foundation Research de marzo 2026 confirman que el 70% de organizaciones en Norteamérica y 62% en Europa ya lo usan en productos comerciales, con un 69% planeando aumentar significativamente su adopción. [Zephyr Turns 10 Announcement](https://www.zephyrproject.org/zephyr-turns-10-as-global-adoption-surges-and-long-term-embedded-use-expands/)

### 1.1 Takeaways clave sobre Zephyr como producto viable en 2026

**1. Gobernanza neutral multisponsor elimina vendor lock-in.**
A diferencia de FreeRTOS (Amazon AWS) o ThreadX (Microsoft/Eclipse), Zephyr pertenece a la Linux Foundation y es gobernado por un Technical Steering Committee con miembros Platinum como Nordic Semiconductor, Intel, NXP, Renesas y Wind River. Esta estructura significa que ninguna empresa puede discontinuar el proyecto unilateralmente, reduciendo dramáticamente el riesgo para productos con ciclos de vida de 10-20 años. [Zephyr Project Official](https://www.zephyrproject.org)

**2. Seguridad robusta diseñada para IoT regulado.**
Zephyr incluye PSA Crypto API con implementación mbedTLS, secure boot chains, secure storage basado en PSA, Memory Protection Unit (MPU) con user mode, y un Security Subcommittee dedicado exclusivamente a seguridad. Obtuvo el OpenSSF Gold Badge en 2019 y mantiene actualizaciones de seguridad regulares. En un mercado IoT donde la seguridad es cada vez más regulada, estas features son un diferenciador competitivo real frente a competidores que tratan la seguridad como feature opcional. [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html)

**3. Conectividad wireless integrada — no hay que agregarla.**
Zephyr incluye stacks de BLE, Wi-Fi, Thread, 802.15.4, LoRa, Cellular y CAN bus directamente en el kernel. Esto contrasta marcadamente con FreeRTOS, que requiere agregar cada stack manualmente. Para productos IoT industriales que necesitan múltiples protocolos de conectividad (por ejemplo, BLE para configuración local + Wi-Fi para cloud + Thread para mesh entre sensores), Zephyr ofrece una plataforma integrada que reduce significativamente el tiempo de desarrollo. [Zephyr Documentation — Connectivity](https://docs.zephyrproject.org/latest/connectivity/index.html)

**4. Portabilidad extrema: 1000+ boards soportadas.**
Zephyr soporta más de 1000 boards diferentes y más de 15 arquitecturas de CPU (ARM Cortex-M/R/A, RISC-V, x86, MIPS, ARC, SPARC, Nios II, Xtensa). El sistema Devicetree permite abstraer la configuración de hardware sin modificar código de aplicación. Para productos que pueden necesitar cambiar de proveedor de microcontroller (ej: de NXP a Nordic a Renesas), esta portabilidad cross-vendor es invaluable. [Zephyr Documentation — Boards](https://docs.zephyrproject.org/latest/boards/index.html)

**5. Tamaño mínimo de ~4 KB con LTS activo.**
El kernel puede compilarse en tan solo 4 KB, haciéndolo viable para microcontroladores extremadamente restringidos. Las versiones LTS (Long Term Support) como LTS3 proporcionan estabilidad asegurada por múltiples años, ideal para productos industriales y médicos con largos ciclos de vida. El modelo de configuración Kconfig + Devicetree permite ajustar exactamente qué features se incluyen, optimizando el footprint. [Zephyr Documentation — Getting Started](https://docs.zephyrproject.org/latest/develop/getting_started/)

### 1.2 Por qué Zephyr es una elección sólida para IoT embebido en 2026

| Factor | Zephyr | FreeRTOS | NuttX | ThreadX |
|--------|--------|----------|-------|---------|
| **Seguridad integrada** | ✅ PSA Crypto, secure boot, Security Subcommittee | ❌ Básico | ❌ Básico | ⚠️ Certificaciones pre-existentes |
| **Conectividad wireless** | ✅ BLE, Wi-Fi, Thread, 802.15.4, LoRa, Cellular, CAN | ❌ Manual | ❌ Solo Ethernet/WiFi | ❌ NetX Duo (TCP/IP) |
| **Gobernanza neutral** | ✅ Linux Foundation (ningún vendor domina) | ❌ Amazon AWS | ✅ Apache meritocracia | ⚠️ Microsoft/Eclipse |
| **LTS para largo lifecycle** | ✅ LTS3 activo | ✅ Amazon LTS | ✅ Apache LTS | ✅ Eclipse LTS |
| **Portabilidad hardware** | ✅ >1000 boards, Devicetree | ❌ Limitado | ⚠️ ~300 boards | ⚠️ SoC-specific |
| **Licencia comercial** | Apache 2.0 (no copyleft) | MIT (permisiva) | Apache 2.0 | MIT |

**Conclusión:** Zephyr representa la opción más equilibrada para productos IoT comerciales que requieren seguridad robusta, conectividad multimódulo, portabilidad cross-vendor, y ciclos de vida industriales largos. Su licencia Apache 2.0 permite uso comercial sin restricciones de copyleft, y su gobernanza neutral elimina el riesgo de dependencia de un único proveedor.

> **Fuente general:** [Zephyr Project](https://www.zephyrproject.org), [Zephyr Documentation](https://docs.zephyrproject.org/latest/), [investigacion.md — Zephyr OS](./investigacion.md)

---

## SECCIÓN 2: Conclusiones sobre MOSIX

MOSIX (**Multi-Operating System Intellect System**) es un sistema operativo distribuido desarrollado por el Grupo de Investigación en Sistemas Distribuidos de la Hebrew University of Jerusalem bajo el liderazgo del Prof. Amnon Barak. Su última versión (MOSIX-4.4.4) fue lanzada el 24 de octubre de 2017, hace más de 8 años. [MOSIX Official Site](http://www.mosix.org/), [MOSIX History](https://mosix.cs.huji.ac.il/txt_history.html)

### 2.1 Takeaways sobre MOSIX como caso de estudio histórico

**1. Pionero en migración preemptiva de procesos (1977-presente).**
MOSIX fue el primer sistema en demostrar migración preemptiva funcional de procesos en un cluster Linux (1999). Durante más de 40 años (desde 1977), el proyecto innovó en el concepto de convertir múltiples máquinas físicas en un supercomputador virtual donde los procesos migran automáticamente según la carga. El paper de 1998 sobre MOSIX fue citado 488 veces en la academia, demostrando su impacto intelectual. [MOSIX History](https://mosix.cs.huji.ac.il/txt_history.html), [Wikipedia: MOSIX](https://en.wikipedia.org/wiki/MOSIX)

**2. Single System Image (SSI) completo.**
MOSIX implementaba el concepto de Single System Image, donde un cluster de computadoras se presenta a los usuarios como un único sistema con una vista unificada de CPU, memoria y procesos. Los usuarios no necesitaban especificar en qué nodo ejecutaban sus programas — el sistema decidía dinámicamente y migraba procesos transparéntemente. Este concepto sigue relevante hoy en cloud computing y edge computing. [MOSIX White Paper](https://mosix.cs.huji.ac.il/pub/MOSIX_wp.pdf)

**3. Balanceo de carga automático con Memory Ushering.**
El sistema de MOSIX incluía algoritmos sofisticados de balanceo de carga que consideraban velocidad de CPU, carga actual, memoria disponible y patrones de comunicación inter-procesos. Su feature "Memory Ushering" detectaba proactivamente nodos con poca memoria y migraba procesos antes de queoccurriera un out-of-memory. Estos algoritmos son ejemplos clásicos enseñados en cursos de sistemas distribuidos. [The MOSIX Algorithms for Managing Cluster — TU Dresden](https://os.inf.tu-dresden.de/Studium/DOS/SS2014/03-MOSIX.pdf)

**4. Proyecto sin desarrollo activo desde 2017.**
MOSIX está completamente inactivo: sin actualizaciones de seguridad, sin soporte comercial disponible, sin compatibilidad con kernels Linux modernos, y sin uso documentado en producción después de 2017. La última versión disponible es MOSIX-4.4.4 (24 de octubre de 2017). No existe empresa ni servicio de soporte técnico formal. [MOSIX Changelog](https://mosix.cs.huji.ac.il/txt_changelog.html)

**5. Software propietario con restricciones de modificación.**
MOSIX es software propietario que distribuye bajo una licencia restrictiva propia. La licencia prohíbe modificar, realizar ingeniería reversa o crear obras derivadas. Las contribuciones son propiedad intelectual del Prof. Amnon Barak. Esta naturaleza proprietaria contrasta con alternativas open source modernas (SLURM, Kubernetes) que permiten auditoría, contribución y evolución comunitaria. [MOSIX Distributions License](https://mosix.cs.huji.ac.il/txt_distributions.html)

### 2.2 Por qué MOSIX aún es relevante en contexto académico

MOSIX sigue siendo enseñado en universidades por su **valor histórico y pedagógico**, no por su vigencia tecnológica. Ilustra:

| Concepto | Cómo MOSIX lo demuestra | Relevancia actual |
|----------|-------------------------|-------------------|
| **Migración de procesos** | Migración preemptiva live con contexto completo | precedent histórico para container migration |
| **Single System Image** | SSI completo a nivel de SO | concepto base en cloud computing (recursos unificados) |
| **Balanceo de carga automático** | Memory Ushering + algoritmos clásicos | fundamento de load balancers modernos |
| **Evolución tecnológica** | MOSIX → SLURM → Kubernetes | entender por qué evoluciona la tecnología |

La progresión histórica MOSIX (1999-2017) → SLURM (2003-presente) → Kubernetes (2014-presente) demuestra cómo el paradigma de "migración de procesos a nivel kernel" fue reemplazado por "contenedores a nivel aplicación" debido a mejor eficiencia, portabilidad y comunidad.

> **Fuente general:** [MOSIX Official Site](http://www.mosix.org/), [Wikipedia: MOSIX](https://en.wikipedia.org/wiki/MOSIX), [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html), [investigacion.md — MOSIX](./investigacion.md)

---

## SECCIÓN 3: ¿Por qué son incomparables directamente?

### 3.1 Explicación simple: productos para problemas distintos

Zephyr OS y MOSIX son sistemas operativos diseñados para resolver **problemas fundamentalmente diferentes**. Intentar compararlos directamente es como comparar un automobile con un avión: ambos son medios de transporte, pero operan en dominios completamente distintos.

**Zephyr OS** es un RTOS (Sistema Operativo de Tiempo Real) para **microcontroladores individuales** en dispositivos IoT embebidos. Corre en dispositivos con recursos extremadamente restringidos (desde ~4 KB de memoria), управляет tareas en tiempo real, y opera en un solo dispositivo físico.

**MOSIX** es un **Distributed Operating System / Cluster Management System** que administra múltiples computadoras Linux como un único sistema lógico. No corre en un dispositivo individual, sino que transforma docenas o centenas de máquinas en un supercomputador virtual.

### 3.2 Tabla comparativa: dominios de aplicación

| Aspecto | Zephyr OS | MOSIX |
|---------|-----------|-------|
| **Qué administra** | Un microcontrolador individual | Un cluster de múltiples computadoras |
| **Problema que resuelve** | Tiempo real en dispositivos IoT embebidos | Computación de alto rendimiento (HPC) en clusters |
| **Target de hardware** | Microcontroladores (4 KB - 2 MB RAM) | Clusters de PCs (GB - TB de RAM total) |
| **Escala** | Un dispositivo | Cientos de nodos |
| **Modelo de memoria** | Memoria local con protección por MPU | Memoria distribuida ("shared-nothing") |
| **Migración** | No — opera en un solo SoC | Sí — migración preemptiva de procesos entre nodos |
| **Conectividad** | BLE, Wi-Fi, Thread, LoRa, Cellular, CAN | Red de área local (Ethernet, Myrinet histórico) |
| **Uso típico** | Sensor IoT, wearable, dispositivo médico | HPC académico, simulaciones científicas |
| **Última versión activa** | 2024+ (LTS3, 2026) | 2017 (MOSIX-4.4.4, abandonware) |

### 3.3 Por qué la comparación "injusta" es necesaria y valiosa

Esta comparación es **intencionalmente "injusta"** porque demuestra un punto pedagógico crucial: **el campo de sistemas operativos abarca soluciones radicalmente diferentes según el dominio de aplicación**.

Un estudiante que complete este TP comprenderá que:

1. **No existe "el mejor sistema operativo"** — existe "el sistema operativo correcto para este problema específico".
2. **La evolución tecnológica responde a cambios en los problemas**, no solo a mejoras técnicas. MOSIX fue innovador para su era (clusters de PCs en los 90s). Kubernetes es innovador para la era actual (microservicios, cloud-native).
3. **La comparación revela madurez de mercado**: Zephyr en 2026 tiene comunidad activa, soporte corporativo, y adopción comercial verificable. MOSIX es un caso histórico interesante pero sin relevancia para producción moderna.

> **Nota:** Si se buscara una comparación "justa" para Zephyr, los competidores relevantes serían FreeRTOS, NuttX, RT-Thread, RIOT OS y ThreadX. Si se buscara una comparación "justa" para MOSIX, los competidores relevantes serían SLURM, Kubernetes, OpenMPI y PBS Professional.

---

## SECCIÓN 4: Recomendaciones según caso de uso

### 4.1 Matriz de decisión

| Si necesitas... | Recomendación | Fuente |
|----------------|---------------|--------|
| **Producto IoT comercial embebido (2026+)** | Zephyr OS | [Zephyr Turns 10](https://www.zephyrproject.org/zephyr-turns-10-as-global-adoption-surges-and-long-term-embedded-use-expands/) |
| **Seguridad robusta + conectividad integrada** | Zephyr OS | [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html), [Zephyr Connectivity](https://docs.zephyrproject.org/latest/connectivity/index.html) |
| **Largo ciclo de vida (10+ años) para producto industrial/médico** | Zephyr OS (con LTS3) | [Zephyr LTS](https://www.zephyrproject.org/) |
| **Portabilidad cross-vendor entre microcontroladores** | Zephyr OS | [Zephyr Boards](https://docs.zephyrproject.org/latest/boards/index.html) |
| **Prototipo rápido sin experiencia embebida** | FreeRTOS o RIOT OS | [Nabto — Zephyr vs FreeRTOS](https://www.nabto.com/zephyr-vs-freertos-comparison/) |
| **Aprender conceptos de clustering histórico** | MOSIX (como estudio) | [MOSIX History](https://mosix.cs.huji.ac.il/txt_history.html), [TU Dresden MOSIX Algorithms](https://os.inf.tu-dresden.de/Studium/DOS/SS2014/03-MOSIX.pdf) |
| **Entender evolución HPC** | MOSIX → SLURM → K8s | [Top500 — Slurm adoption](https://www.top500.org/), [Kubernetes Official](https://kubernetes.io/) |
| **Proyecto HPC real en 2026** | SLURM o Kubernetes (no MOSIX) | [Slurm Official](https://slurm.schedmd.com/), [Slurm adoption >60% Top500](https://www.top500.org/) |
| **Certificaciones de seguridad pre-existentes** | ThreadX (IEC 61508, ISO 26262) | [Wikipedia — ThreadX](https://en.wikipedia.org/wiki/ThreadX) |
| **Mercado chino IoT** | RT-Thread | [RT-Thread Official](https://www.rt-thread.io/) |
| **Investigación académica con bajo门槛** | RIOT OS | [RIOT OS Official](https://riot-os.org/), [IEEE IoT Journal — RIOT](https://ieeexplore.ieee.org/document/8489785) |

### 4.2 Decisión rápida: ¿Zephyr o alternativa?

```
┌─────────────────────────────────────────────────────────────────────┐
│                    ¿Qué tipo de proyecto tenés?                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ SISTEMAS EMBEBIDOS / IoT / MICROCONTROLADORES                 │   │
│  │ (dispositivos individuales, recursos restringidos)             │   │
│  │                                                              │   │
│  │  ¿Ciclo de vida largo (10+ años)?                            │   │
│  │   ├── SÍ → Zephyr OS                                         │   │
│  │   └── NO → ¿Prototipo rápido?                                │   │
│  │           ├── SÍ → FreeRTOS                                  │   │
│  │           └── NO → ¿Mercado chino?                           │   │
│  │                   ├── SÍ → RT-Thread                          │   │
│  │                   └── NO → Zephyr OS                         │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                              │                                     │
│                              ▼                                     │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ CLUSTERS / HPC / COMPUTACIÓN DISTRIBUIDA                     │   │
│  │ (múltiples máquinas, cómputo paralelo)                       │   │
│  │                                                              │   │
│  │  ¿Estudio histórico de migración de procesos?                │   │
│  │   ├── SÍ → MOSIX (como caso de estudio académico)           │   │
│  │   └── NO → ¿Proyecto HPC moderno?                           │   │
│  │           ├── SÍ → SLURM + OpenMPI                          │   │
│  │           └── NO → ¿Cloud-native / microservicios?          │   │
│  │                   ├── SÍ → Kubernetes                        │   │
│  │                   └── NO → SLURM                            │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## SECCIÓN 5: Reflexión para el Trabajo Práctico

### 5.1 Cómo presentar esta comparación ante un tribunal universitario

Esta comparativa entre Zephyr OS y MOSIX puede presentarsedelante de un tribunal universitario de manera efectiva si se estructura en torno a una **narrativa de evolución tecnológica** en lugar de una simple lista de features:

**Narrativa sugerida:**

> "Zephyr OS y MOSIX representan dos respuestas a problemas completamente distintos en el espectro de sistemas operativos. Zephyr resuelve el problema de ejecutar tiempo real en dispositivos IoT con recursos extremadamente restringidos; MOSIX resolvió (históricamente) el problema de convertir múltiples computadoras en un supercomputador virtual. La comparación no busca determinar cuál es 'mejor', sino demostrar cómo diferentes dominios de problema generan soluciones arquitectónicas radicalmente diferentes."

**Puntos clave para la defensa:**

1. **Diferencia de escala y propósito es fundamental**, no un defecto de la comparación.
2. **MOSIX como caso histórico ilustra la evolución** hacia tecnologías actuales (SLURM, Kubernetes).
3. **Zephyr como ejemplo de RTOS moderno** con gobernanza open source, seguridad integrada, y adopción comercial masiva.
4. **La tabla de decisión de la Sección 4** demuestra que ambos sistemas tienen nichos donde son la elección correcta.

### 5.2 Por qué la diferencia de segmentos hace la comparación "injusta" pero necesaria

La comparación es "injusta" en el sentido de que compara apples con naranjas. Sin embargo, es **necesaria y pedagógica** porque:

| Por qué es "injusta" | Por qué es necesaria |
|---------------------|----------------------|
| Zephyr y MOSIX no compiten por los mismos recursos | Ambos son sistemas operativos que resuelven problemas de computación |
| Las métricas de evaluación son completamente distintas | Demuestra la amplitud del campo de sistemas operativos |
| No hay escenario real donde elegir uno u otro sea la decisión | Ilustra cómo diferentes problemas requieren diferentes soluciones |
| Zephyr está activo (2026); MOSIX está abandonado (2017) | El contraste de estados muestra diferencia entre tecnología vigente e histórica |

### 5.3 Qué demuestra sobre el campo de sistemas operativos

Esta comparativa demuestra principios fundamentales del campo de sistemas operativos:

**1. Diversidad de soluciones ante diversidad de problemas.**
No existe un "mejor sistema operativo universal". El campo produce soluciones especializadas porque los problemas son radicalmente distintos: desde microcontroladores de 4 KB hasta clusters de miles de nodos, desde tiempo real determinístico hasta cómputo paralelo masivo.

**2. Contexto histórico y evolución tecnológica.**
MOSIX no es "peor" que SLURM — es un precursor histórico que ilustró conceptos (migración de procesos, SSI, balanceo automático) que evolucionaron hacia soluciones más eficientes (contenedores, schedulers). Entender la historia de la tecnología es entender la tecnología misma.

**3. Importancia de la gobernanza y el soporte activo.**
Zephyr thrive porque tiene gobernanza neutral (Linux Foundation), soporte corporativo activo (Nordic, Intel, NXP, Renesas), y comunidad en crecimiento. MOSIX murió porque quedó abandonado sin soporte comercial. El ciclo de vida de un proyecto de software depende de factores organizacionales tanto como técnicos.

**4. La seguridad como diferenciador moderno.**
En 2026, Zephyr invierte activamente en seguridad (Security Subcommittee, PSA Crypto, OpenSSF Gold Badge) porque el mercado IoT regulado lo requiere. Esta tendencia refleja cómo la seguridad dejó de ser optional y se volvió un requisito table stakes para productos comerciales.

**5. Licencia y comunidad determinan longevidad.**
Apache 2.0 (Zephyr) permite uso comercial sin copyleft, atrayendo contribuidores corporativos. Licencia propietaria restrictiva (MOSIX) limitó la evolución comunitaria. La licencia open source no es solo una elección legal — es una estrategia de supervivencia del proyecto.

---

## Fuentes de esta sección

1. **Zephyr Project Official** — [zephyrproject.org](https://www.zephyrproject.org)
2. **Zephyr Turns 10 Announcement (Mar 2026)** — [zephyrproject.org/zephyr-turns-10](https://www.zephyrproject.org/zephyr-turns-10-as-global-adoption-surges-and-long-term-embedded-use-expands/)
3. **Zephyr Documentation** — [docs.zephyrproject.org](https://docs.zephyrproject.org/latest/)
4. **Zephyr Security Overview** — [docs.zephyrproject.org/latest/security/security-overview.html](https://docs.zephyrproject.org/latest/security/security-overview.html)
5. **Zephyr Connectivity** — [docs.zephyrproject.org/latest/connectivity/index.html](https://docs.zephyrproject.org/latest/connectivity/index.html)
6. **Zephyr Boards** — [docs.zephyrproject.org/latest/boards/index.html](https://docs.zephyrproject.org/latest/boards/index.html)
7. **MOSIX Official Site** — [mosix.org](http://www.mosix.org/)
8. **MOSIX History** — [mosix.cs.huji.ac.il/txt_history.html](https://mosix.cs.huji.ac.il/txt_history.html)
9. **MOSIX FAQ** — [mosix.cs.huji.ac.il/faq/output/faq_toc.html](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)
10. **MOSIX Distributions License** — [mosix.cs.huji.ac.il/txt_distributions.html](https://mosix.cs.huji.ac.il/txt_distributions.html)
11. **MOSIX Changelog** — [mosix.cs.huji.ac.il/txt_changelog.html](https://mosix.cs.huji.ac.il/txt_changelog.html)
12. **MOSIX White Paper** — [mosix.cs.huji.ac.il/pub/MOSIX_wp.pdf](https://mosix.cs.huji.ac.il/pub/MOSIX_wp.pdf)
13. **MOSIX Algorithms (TU Dresden)** — [os.inf.tu-dresden.de/Studium/DOS/SS2014/03-MOSIX.pdf](https://os.inf.tu-dresden.de/Studium/DOS/SS2014/03-MOSIX.pdf)
14. **Wikipedia — MOSIX** — [en.wikipedia.org/wiki/MOSIX](https://en.wikipedia.org/wiki/MOSIX)
15. **Wikipedia — Zephyr OS** — [en.wikipedia.org/wiki/Zephyr_(operating_system)](https://en.wikipedia.org/wiki/Zephyr_(operating_system))
16. **Wikipedia — ThreadX** — [en.wikipedia.org/wiki/ThreadX](https://en.wikipedia.org/wiki/ThreadX)
17. **Slurm Workload Manager** — [slurm.schedmd.com](https://slurm.schedmd.com/)
18. **Top500 Supercomputers** — [top500.org](https://www.top500.org/)
19. **Kubernetes Official** — [kubernetes.io](https://kubernetes.io/)
20. **RIOT OS Official** — [riot-os.org](https://riot-os.org/)
21. **RT-Thread Official** — [rt-thread.io](https://www.rt-thread.io/)
22. **"A Complete Guide to Zephyr vs. FreeRTOS in IoT" — Nabto** — [nabto.com/zephyr-vs-freertos-comparison](https://www.nabto.com/zephyr-vs-freertos-comparison/)
23. **"RIOT: An Open Source OS for Low-End Embedded Devices in the IoT" — IEEE IoT Journal 2018** — [ieeexplore.ieee.org/document/8489785](https://ieeexplore.ieee.org/document/8489785)

---

*Documento preparado para el Trabajo Práctico Especial de Fundamentos de Sistemas Operativos. Mayo 2026.*
*Sección de cierre de la comparativa final. Basado en los 24 archivos de investigación creados en las carpetas A, B y C.*

---
## Nota Académica — Fundamentos de SO
**Conceptos de la materia relacionados:**

- **§1.4 — Arquitecturas de SO / Diseño filosófico**: La recomendación de Zephyr para IoT embebido y MOSIX como caso histórico ilustra el principio de §1.4: **no existe arquitectura "mejor" — existe la arquitectura correcta para el problema**. Zephyr representa diseño monolithic-optimized para constraints de microcontroladores (4KB-RAM, energía limitada, time-critical); MOSIX representó diseño SSI para clusters HPC de su era. La recomendación de SLURM/Kubernetes sobre MOSIX para proyectos HPC actuales demuestra cómo las filosofías arquitectónicas evolucionan cuando los problemas cambian (contenedores vs migración a nivel kernel).

- **§2.1 — Objetivos del scheduler y §2.5 — Scheduling algorithms**: La matriz de decisión de Sección 4 mapea recomendaciones a los objetivos de scheduler estudiados. Para productos IoT industriales con ciclos de 10-20 años, se prioriza **predictability y response time** (Zephyr con preemptive scheduling). Para HPC moderno, se prioriza **throughput y utilization** (SLURM con backfill scheduling). El scheduling de Zephyr (cooperative/preemptive/hybrid) es controlable estáticamente en tiempo de compilación — una ventaja para sistemas embebidos donde el comportamiento debe ser determinístico. SLURM en cambio usa scheduling dinámico con políticas configurables — apropiado para cargas de trabajo heterogéneas.

- **§4.4/4.5 y §5.3 — Memory management y page replacement**: Las conclusiones sobre Zephyr mencionan MPU-based protection y demand paging como features de seguridad y eficiencia. Para MOSIX, el "Memory Ushering" representa una estrategia proactiva de page replacement a nivel distributed: migra el proceso entero cuando detecta presión de memoria, evitando el reemplazo local de páginas. Esta diferencia de aproximaciones (local replacement vs process migration) es un ejemplo clásico de cómo los mismos problemas de memoria se resuelven de forma radicalmente diferente según la arquitectura — un concepto central de §4.4/4.5 y §5.3.

- **§3.6 — Métodos de asignación de archivos y evolución de storage**: La progresión histórica MOSIX (DFSA, acceso transparente a archivos) → SLURM (gestión de jobs, no archivos) → Kubernetes (persistent volumes, storage classes) refleja la evolución de métodos de asignación vistos en clase. DFSA era un intento de presentar archivos distribuidos como locales; las soluciones modernas prefieren explícitamente la distribución (volúmenes remotos, stateful sets) porque el tradeoff de transparencia vs performance no favorece la transparencia en escenarios cloud-native.

- **Conclusión general de diseño**: La recomendación de "Zephyr para productos, MOSIX para estudio" plasma el principio de §1.4 de que el diseño de SO responde a constraints del problema. Un sistema operativo de producción necesita: (1) desarrollo activo, (2) soporte comercial, (3) seguridad actualizada, (4) comunidad activa. Estos factores determinan longevidad tanto como la calidad técnica — algo que MOSIX ilustra al haber muerto no por flaws técnicos sino por abandono comercial.
