# Slide 29 — Explicación: Cierre / Fuentes

## Contenido de la Slide

La slide 29 (index 29, página 30 en la presentación) es la slide de cierre del Trabajo Práctico Especial sobre Zephyr OS vs MOSIX. Contiene cinco bloques principales de información:

1. **Título "Cierre"** con subtítulo "¡Gracias! / Preguntas"
2. **Panel "FUENTES PRINCIPALES"** — lista de fuentes documentales utilizadas
3. **Panel "INTEGRANTES"** — lista de los cinco miembros del grupo
4. **Información del curso**: "Fundamentos de Sistemas Operativos — Mayo 2026"
5. **Referencia del TP**: "Trabajo Práctico Especial: Zephyr OS vs MOSIX"

---

## 1. Agradecimientos y Contexto de Cierre

La slide de cierre cierra el ciclo de la presentación del TP Especial. El formato de "¡Gracias! / Preguntas" es estándar en presentaciones académicas y marca la transición de la exposición de contenido hacia el período de preguntas y revisión.

En el contexto de Fundamentos de Sistemas Operativos, esta slide representa la culminación de un análisis comparativo entre dos sistemas operativos de categorías radicalmente distintas:

- **Zephyr OS**: RTOS para sistemas embebidos e IoT, bajo la Linux Foundation, activo y en crecimiento comercial en 2026.
- **MOSIX**: Sistema operativo de clustering para HPC, desarrollado en la Hebrew University of Jerusalem por el Prof. Amnon Barak, abandonado desde octubre 2017.

Esta dualidad define toda la presentación: no se trata de comparar competidores directos, sino de usar DOS enfoques radicalmente distintos al problema de diseño de sistemas operativos para extraer aprendizajes sobre arquitectura de SO, gestión de recursos, scheduling, memoria y sistemas de archivos.

---

## 2. Fuentes Principales Documentales

### 2.1 Fuentes oficiais de Zephyr OS

**zephyrproject.org** y **docs.zephyrproject.org**

El sitio oficial del proyecto y su documentación técnica exhaustiva constituyen la fuente primaria de información sobre Zephyr. La documentación oficial incluye:

- Architectural overview y kernel design
- API references para todas las subsystems
- Guides para desarrollo de drivers y aplicaciones
- Security documentation (PSA Crypto, secure boot)
- Porting guides para diferentes arquitecturas de hardware

Estas fuentes son maintained por el Technical Steering Committee (TSC) y la comunidad, bajo oversight de la Linux Foundation. Son fuentes vivas, actualizadas con cada release.

**Linux Foundation Research (2026)**

El reporte "Zephyr at 10: A Decade of Open Source Embedded Innovation" (marzo 2026) proporciona datos estadísticos sobre adopción global, casos de uso comerciales y tendencias. Este reporte está basado en encuestas a 413 profesionales globales y es la fuente de los siguientes datos clave:

- 70% de organizaciones en Norteamérica usan Zephyr en productos comerciales
- 62% en Europa
- >3,000 contribuyentes globales
- >1,000 boards soportadas
- 52% de organizaciones dan soporte por 5-10 años o más

### 2.2 Fuentes oficiales de MOSIX

**mosix.org** y **mosix.cs.huji.ac.il**

El sitio oficial de MOSIX y el sitio técnico del Computer Science Dept. de la Hebrew University of Jerusalem. Estas fuentes incluyen:

- MOSIX Administrator's Guide (PDF)
- MOSIX White Paper (PDF)
- FAQ oficial
- History of MOSIX — texto cronológico del proyecto

Es importante notar que estas fuentes dejaron de actualizarse en 2017. El último release fue MOSIX-4.4.4 el 24 de octubre de 2017. La información sobre MOSIX en estas fuentes es therefore histórica y no refleja el estado actual del proyecto.

### 2.3 Fuentes enciclopédicas y de investigación

**Wikipedia — Zephyr OS**

Entrada enciclopédica sobre Zephyr que incluye historia del proyecto, desde Virtuoso RTOS (Eonic Systems, finales de los '90) hasta Wind River Rocket (2015) y la donación a la Linux Foundation (febrero 2016). Proporciona contexto histórico y referencias cruzadas con otros proyectos (VxWorks, Linux Foundation).

**Wikipedia — MOSIX**

Entrada enciclopédica que documenta la historia de MOSIX desde 1977, incluyendo hitos como la migración a Linux (1999), el fork openMosix (2002), y la última versión MOSIX-4 (2014). Incluye información sobre el Prof. Amnon Barak y su grupo de investigación.

### 2.4 Fuentes de mercado HPC

**Top500 Supercomputers**

La lista Top500 (top500.org) es la referencia estándar para benchmarking y tendencias en supercomputación. Es relevante para el análisis de MOSIX porque permite contextualizar la posición de mercado de sistemas de clustering. Según los datos de Top500, MOSIX no aparece en ningún ranking moderno — su última versión (2017) es anterior a la dominate actual de contenedores y orchestrators como Kubernetes y SLURM en el ecosistema HPC.

### 2.5 Temario FSO como fuente conceptual

El documento `temario_FSO.md` de la materia Fundamentos de Sistemas Operativos es una fuente de referencia para los conceptos teóricos que sustentan la comparación. Los temas cubiertos en el temario que son directamente relevantes a la comparativa Zephyr vs MOSIX incluyen:

- **§1.4 — Arquitecturas de SO**: Monolítica vs microkernel vs distribuida
- **§2.1-2.5 — Administración del Procesador**: Scheduling, estados de proceso, PCB, algoritmos de scheduling, quantum óptimo, dispatcher
- **§3.1-3.9 — Sistemas de Archivos**: Métodos de acceso, asignación de espacio, estructura de directorios, i-nodos, enlaces
- **§4.1-4.7 — Administración de Memoria**: Particiones fijas/variables, paginación, segmentación, fragmentación
- **§5.1-5.7 — Memoria Virtual**: Page fault, algoritmos de reemplazo, thrashing, working set

La comparativa Zephyr vs MOSIX es esencialmente una aplicación práctica de estos conceptos teóricos a dos sistemas reales con filosofías de diseño opuestas.

---

## 3. Los Integrantes del Grupo

### 3.1 Lista de miembros

Los cinco integrantes del grupo de trabajo, en orden alfabético:

| Integrante | Rol en el proyecto |
|------------|-------------------|
| **ARRIAGA** | Investigación y análisis |
| **BELLONE** | Investigación y análisis |
| **BISCAY** | Investigación y análisis |
| **CALLA ALIENDE** | Investigación y análisis |
| **CARDOZO** | Investigación y análisis |

El formato de la slide usa mayúsculas para los nombres, lo cual es standard en presentaciones académicas para dar visibilidad equal a todos los miembros.

### 3.2 Contexto académico

El grupo constituye un equipo de trabajo de la carrera de Ingeniería en Computación de la Universidad Nacional de Mar del Plata (UNMDP). El Trabajo Práctico Especial es parte de la evaluación de la materia Fundamentos de Sistemas Operativos y representa un análisis técnico comparativo de dos sistemas operativos de categorías diferentes con el objetivo de demostrar comprensión de conceptos de arquitectura de SO, gestión de recursos, scheduling, memoria y sistemas de archivos.

---

## 4. El Valor Académico de la Comparación

### 4.1 Por qué estudiar dos SO de categorías diferentes

La elección de comparar Zephyr OS y MOSIX no es arbitraria. Ambos representan respuestas radicalmente diferentes al problema fundamental de todo sistema operativo: **cómo administrar recursos de hardware para servir aplicaciones de usuario**.

Esta comparación tiene valor académico porque permite observar cómo diferentes dominios de problema conducen a diferentes decisiones de diseño, ilustrando que no existe "el mejor SO" — existe el SO apropiado para cada contexto.

### 4.2 Aprendizajes sobre diseño de sistemas operativos

**Zephyr OS** enseña:

- Cómo diseñar un SO para hardware extremadamente restringido (microcontroladores con KB de RAM)
- El tradeoff entre footprint mínimo y funcionalidad
- Cómo implementar protección de memoria sin MMU (usando MPU)
- Cómo construir un RTOS con scheduling preemptive/configurable
- Cómo mantener gobernanza neutral multi-vendor en un proyecto open source
- La importancia de la seguridad en sistemas embebidos (PSA Crypto, secure boot)

**MOSIX** enseña:

- Cómo construir una Single System Image (SSI) sobre múltiples kernels Linux
- El concepto de migración preemptiva de procesos y sus challenges
- Balanceo de carga adaptativo basado en múltiplos recursos (CPU, memoria, red)
- Memory Ushering como alternativa distribuida al replacement de páginas
- La evolución histórica de cluster computing (1977-2017)
- Por qué el modelo de migración de procesos a nivel kernel fue superado por contenedores

**Comparación cruzada**:
- Zephyr usa arquitectura monolítica unificada; MOSIX opera como extensión/overlay sobre Linux
- Zephyr optimiza para latencia y determinismo; MOSIX optimiza para throughput cluster-wide
- Zephyr tiene protección de memoria via MPU; MOSIX tiene sandbox pero sin protección entre nodos
- Zephyr es activamente mantenido; MOSIX está abandonado desde 2017

### 4.3 Conexión con el temario FSO

Cada tema del temario de FSO encuentra su expresión concreta en alguno de los dos sistemas:

| Tema FSO | Manifestación en Zephyr | Manifestación en MOSIX |
|----------|------------------------|------------------------|
| **§1.4 Arquitectura** | Monolítico unificado (kernel compilado en una imagen) | Overlay/daemon sobre kernel Linux (SSI distribuida) |
| **§2.5 Scheduling** | Preemptive + cooperative + híbrido (configurable) | Migración preemptiva automática entre nodos |
| **§3.6 Asignación archivos** | LittleFS (wear leveling), FAT FS, NVS | DFSA (redirige E/S al nodo que posee el archivo) |
| **§4.4 Paginación** | Demand paging, virtual memory, MPU-based protection | No paginación — memoria "shared-nothing" por nodo |
| **§5.3 Reemplazo páginas** | Algoritmos LRU, FIFO dentro de cada MCU | Memory Ushering: migración de proceso completo antes de OOM |

Esta correspondencia demuestra que la teoría de SO no es abstracta — son las same decisiones de diseño que Practitioners toman cuando construyen sistemas reales.

---

## 5. Glosario de Términos

### 5.1 Fuentes académicas y técnicas

| Término | Definición |
|---------|------------|
| **Technical Steering Committee (TSC)** | Órgano máximo de decisión técnica en proyectos de la Linux Foundation. Define visión técnica, coordina colaboración entre comunidades, y mantiene la integridad arquitectónica del proyecto. En Zephyr, el TSC Chair actual es Anas Nashif (Intel). |
| **Linux Foundation** | Organización sin fines de lucro founded en 2000 por Eric S. Raymond y Bruce Perens. Actúa como neutral trusted hub para cientos de proyectos open source (Kubernetes, Linux kernel, Zephyr, Node.js). Proveee infraestructura legal, administrativa y financiera. |
| **Gobernanza comunitaria** | Modelo de gestión donde las decisiones se toman mediante consenso de miembros y contributors, no por una única empresa o individuo. Zephyr ejemplifica esto con su Governing Board + TSC structure. |
| **Long Term Support (LTS)** | Versiones de software con soporte extendido (típicamente 2-3 años para Zephyr). Importante para productos industriales con ciclos de vida de 10-20 años. Zephyr LTS3 fue released en 2024. |

### 5.2 Referencias técnicas de Zephyr

| Término | Definición |
|---------|------------|
| **RTOS (Real-Time Operating System)** | Sistema operativo diseñado para aplicaciones de tiempo real donde el tiempo de respuesta es determinístico. Zephyr soporta tres modos: preemptive (tiempo real duro), cooperative, y híbrido. |
| **Nanokernel / Microkernel** | Componentes históricos del kernel Zephyr (separados hasta v1.6). Nanokernel para devices muy tiny; microkernel para devices con más recursos. Desde v1.6 unificados en un único kernel. |
| **PSA Crypto API** | Platform Security Architecture Crypto API — API estándar para criptografía en IoT. Incluye primitivas simétricas y asimétricas, hashing, HMAC, RNG. Implementada via mbedTLS. |
| **MCUboot** | Bootloader seguro standarizado para microcontroladores. Soporta secure boot y firmware updates cifrados. Integrado con Zephyr. |
| **MPU (Memory Protection Unit)** | Hardware unit presente en muchos microcontroladores que permite definir regions de memoria con permisos específicos (read/write/execute). Zephyr usa MPU para implementar protección entre threads y user mode. |
| **Devicetree** | Mecanismo de descripción de hardware device-agnostic. Permite definir qué hardware está presente sin recompilar el kernel. Especialmente importante en Zephyr para soportar >1,000 boards diferentes. |
| **West** | Meta-tool de Zephyr que gestiona repositorios, build system, y tooling. Parte del Zephyr SDK. |
| **LittleFS** | Filesystem diseñado para sistemas embebidos con flash. Implementa wear leveling y es resistente a unexpected power losses. Diseñado por ARM mbed. |

### 5.3 Referencias técnicas de MOSIX

| Término | Definición |
|---------|------------|
| **SSI (Single System Image)** | Técnica que hace que un cluster de computadoras aparezca como una única máquina. MOSIX implementaba esto haciendo que cada nodo pareciera tener la misma vista de procesos y recursos. |
| **Migración preemptiva de procesos** | Capacidad de mover un proceso en ejecución de un nodo a otro sin que el proceso lo solicite. MOSIX lo implementaba a nivel kernel, monitoreando CPU, memoria y latencia de red para decidir cuándo y dónde migrar. |
| **Memory Ushering** | Algoritmo de MOSIX que monitorea memoria de cada nodo y migra proactivamente procesos ANTES de que ocurra out-of-memory. Busca prevenir paging a disco cuando hay nodos con memoria disponible. |
| **DFSA (Direct File System Access)** | Mecanismo de MOSIX que permite a un proceso en nodo A acceder archivos localizados en nodo B transparentemente. Las operaciones de E/S son redirigidas al nodo que posee el archivo sin que la aplicación lo sepa. |
| **Checkpoint/Restart** | Técnica para salvar el estado completo de un proceso (memoria, registros, file descriptors) y restaurarlo en otro nodo. MOSIX lo soportaba para permitir migración de procesos stateful. |
| **openMosix** | Fork open source de MOSIX creado por Moshe Bar en 2002 cuando el equipo original decidió cerrar el código. Duró hasta 2008. LinuxPMI continuó su desarrollo hasta también discontinuarse. |

### 5.4 Terminología general de sistemas operativos

| Término | Definición |
|---------|------------|
| **Kernel monolítico** | Arquitectura donde todo el SO (scheduling, memoria, drivers, filesystem) corre en modo kernel como un único proceso grande. Linux tradicional es monolítico. Zephyr usa monolítico unificado desde v1.6. |
| **Microkernel** | Diseño donde el kernel contiene solo funcionalidades mínimas (IPC, scheduling básico, gestión de memoria) y el resto corre en modo usuario (drivers, filesystem, red). MINIX, QNX son ejemplos. Zephyr es más cercano a monolítico que microkernel. |
| **MPU vs MMU** | MPU (Memory Protection Unit) es versión simplificada de MMU. MPU define regions de memoria con permisos pero sin paging. MMU (Memory Management Unit) soporta memoria virtual con paginación completa. Zephyr usa MPU porque la mayoría de microcontroladores no tienen MMU completa. |
| **Wear leveling** | Técnica en filesystems para flash que distribuye writes uniformemente para extender la vida del storage. LittleFS y NVS (Zephyr) lo implementan. |
| **Shared-nothing architecture** | Diseño donde cada nodo tiene memoria y almacenamiento local independiente. MOSIX usaba shared-nothing entre nodos. Contrasta con shared-memory donde múltiples nodos comparten la misma RAM. |

---

## 6. Relevancia de las Fuentes para el Trabajo

### 6.1 Fuentes primarias vs secundarias

| Tipo | Fuentes | Uso en el TP |
|------|---------|-------------|
| **Primarias** | docs.zephyrproject.org, mosix.org, mosix.cs.huji.ac.il | Documentación técnica directa, características de diseño, especificaciones |
| **Secundarias** | Wikipedia, Linux Foundation Research | Contextualización, datos estadísticos, historia |
| **Académicas** | Temario FSO, papers (TU Dresden, Springer) | Marco teórico, conceptos de SO |
| **Mercado** | Top500, Zephyr products page | Posicionamiento comercial, adopción |

### 6.2 Cadena de información

La información fluye en esta investigación de la siguiente manera:

1. **Documentación oficial** → Especificaciones técnicas directas de cada proyecto
2. **Investigación de mercado** → Datos de adopción y casos de uso comerciales (Linux Foundation Research, Top500)
3. **Análisis histórico** → Evolución de cada proyecto para entender decisiones de diseño (Wikipedia, history pages)
4. **Marco teórico FSO** → Conceptos para analizar y comparar las implementaciones
5. **Comparativa técnica** → Síntesis lado a lado que cristaliza los aprendizajes

Este flujo garantiza que ninguna afirmación en el TP sea inventada — todo proviene de fuentes verificables.

---

## 7. Síntesis: Qué Aporta Este TP al Aprendizaje de SO

### 7.1 Zephyr como caso de estudio

Zephyr demuestra:
- Cómo un SO moderno aborda el problema de dispositivos IoT heterogéneos
- Que la modularidad no requiere un microkernel completo — un kernel monolítico bien diseñado puede ser configurable
- Que la seguridad puede construirse desde cero en un proyecto nuevo (a diferencia de legacy systems)
- Que la gobernanza open source neutral atrae contribuciones de múltiples vendors competidores

### 7.2 MOSIX como caso de estudio

MOSIX demuestra:
- Que la migración de procesos a nivel kernel fue una estrategia válida para clustering (1980s-2000s)
- Por qué ese modelo fue superado por contenedores: la portabilidad y aislamiento de contenedores es superior para clouds modernas
- Que el modelo de fuente cerrada en investigación académica dificulta la adopción masiva
- Que la obsolescencia técnica no quita valor histórico — MOSIX anticipó muchos conceptos que ahora usan Kubernetes y SLURM

### 7.3 Aprendizaje integrado

El valor final del TP es que el estudiante que lo completa puede:
- Reconocer y explicar las diferencias entre arquitectura monolítica, microkernel, y distribuida
- Entender cómo los constraints de hardware (MCU vs cluster HPC) determinan las decisiones de diseño
- Analizar sistemas reales usando el marco conceptual del temario
- Apreciar que no existe "el mejor SO" — existe el apropiado para cada contexto

---

*Explicación elaborada para la Slide 29 del Trabajo Práctico Especial: Zephyr OS vs MOSIX*
*Fundamentos de Sistemas Operativos — Universidad Nacional de Mar del Plata — Mayo 2026*
