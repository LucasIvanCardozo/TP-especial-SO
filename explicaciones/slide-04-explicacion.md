# Slide 04 — Explicación: La Empresa MOSIX

## Propósito de esta Slide

Esta slide introduce al contexto organizacional y académico detrás de MOSIX: quién lo desarrolló, en qué institución, con qué trayectoria histórica, y cuál es su estado actual. La intención es establecer que MOSIX no es un producto comercial tradicional sino un **proyecto de investigación universitaria** con décadas de desarrollo, y que su modelo de licenciamiento restrictivo (proprietario, no open source) fue lo que provocó su fork histórico open source llamado openMosix.

---

## 1. El Grupo de Investigación — Hebrew University of Jerusalem

### 1.1 La Universidad Hebrea de Jerusalén

La **Hebrew University of Jerusalem** (HUJI) es una de las universidades de investigación más prestigiosas de Israel, fundada en 1918 e inaugurada oficialmente en 1925. Su **Institute of Computer Science** (Instituto de Ciencia de la Computación) ha sido un polo de investigación en sistemas distribuidos, redes y computación de alto rendimiento desde las décadas de 1970-1980.

Israel como nación tiene una de las densidades más altas de startups tecnológicas per cápita del mundo, y sus universidades mantienen fuerte vínculo con la industria tecnológica (intel, IBM, Microsoft, Google tienen centros de I+D en Israel). La HUJI específicamente ha producido múltiples proyectos de sistemas distribuidos y clustering que influenciaron la industria global.

### 1.2 El Prof. Amnon Barak

El investigador principal de MOSIX es el **Prof. Amnon Barak**, docente del Instituto de Ciencia de la Computación de la HUJI. Su perfil académico es relevante:

- **71 publicaciones** en conferences y journals internacionales
- **~1,662 citas** acumuladas en su carrera académica
- Áreas de investigación: sistemas paralelos y distribuidos, algoritmos para gestión adaptativa de recursos en clouds, sistemas distribuidos de alto rendimiento
- En 1986 fue nombrado primer Director del **German-Israeli Foundation (GIF)**, una organización que fomenta la cooperación científica bilateral entre Alemania e Israel
- Otros proyectos suyos incluyen el **FFMK (Fast and Fault-Tolerant Microkernel-Based System for Exascale Computing)**

Su producción académica demuestra que MOSIX nació de investigación seria y sostenida, no como un proyecto amateur o comercial. Esto explica por qué MOSIX tiene una documentación técnica tan detallada (white paper, administrator's guide, FAQ extenso) y por qué sobrevivió 40 años: era un proyecto de carrera académica, no un producto con fecha de vencimiento comercial.

### 1.3 Grupo de Sistemas Distribuidos

MOSIX fue desarrollado por el **Distributed Systems Research Group** de la HUJI, un grupo de investigación enfocado en sistemas donde múltiples computadoras cooperan para resolver problemas o proporcionar servicios. Los sistemas distribuidos son un tema avanzado de SO que aparece mentioned en el temario como tema no alcanzado en los TPs, pero cuya comprensión es esencial para entender MOSIX.

---

## 2. Historia Completa desde 1977

La cronología de MOSIX es una de las más largas en la historia de la computación distribuida. A continuación, el detalle de cada período.

### 2.1 1977–1979: Origen en PDP-11/45

El proyecto comenzó en la era de las computadoras de 16 bits cuando las arquitecturas distribuidas eran prácticamente desconocidas en producción. El equipo de investigación trabajó con **PDP-11/45** (Digital Equipment Corporation) corriendo **Unix v6**. En esta primera fase, demostraron que era posible migrar procesos entre computadoras conectadas en red —un concepto revolucionario para la época— incluso con enlaces de comunicación lentos. Los resultados mostraron ganancias de rendimiento, lo que validó la línea de investigación.

**Contexto histórico generacional (temario §1.2):** Estamos en la 3ª generación de SO (1965-1980: circuitos integrados, multiprogramación, time-sharing). Los mainframes y minicomputadoras dominaban la escena, y la idea de clusters de workstations era todavía experimental.

### 2.2 1981–1983: MOS Version 1 — Primer Sistema Multicomputadora Funcional

La segunda versión del proyecto (llamada MOS, antecesor directo de MOSIX) amplió el cluster a un total de **5 PDP-11** conectados, demostrando que un sistema operativo podía gestionar múltiples computadoras como un recurso unificado. El concepto de **Single System Image (SSI)** empieza a tomar forma concreta.

### 2.3 1987–1988: Puerto a NS32332 y Primer "MOSIX"

El proyecto fue portado a la arquitectura **National Semiconductor 32000**, y en 1988-1989 se creó el primer cluster con el nombre "MOSIX": un cluster de **16 nodos** basados en **NS32532**. Este fue el momento en que el nombre MOSIX se materializó oficialmente.

### 2.4 1991–1999: Evolución en BSD/OS y Transición a Linux

Durante esta década, MOSIX evolucionó significativamente:

- **MOSIX v6 (1991-1993):** Cluster de 8 equipos 486 y 32 Pentium PCs conectados por **Myrinet** (una red de alta velocidad para clusters HPC, muy popular en los 1990s)
- **MOSIX v7 (1998-1999):** Primera versión para **Linux 2.2**, cluster de 64 nodos x86 con Myrinet. Esta versión fue pivotal porque Linux estaba emergiendo como el SO dominante en investigación y servers.

### 2.5 1999: Transición Definitiva a Linux

A partir de 1999, **todas las versiones de MOSIX se desarrollaron sobre kernel Linux**. Esto fue una decisión pragmática: Linux era el SO con mayor crecimiento en la comunidad académica y de servidores, tenía código fuente abierto disponible, y ofrecía mejor soporte para hardware moderno. Además, la licencia GPL del kernel Linux era compatible con la filosofía académica de compartir conocimiento.

### 2.6 2001: Moment of Inflection — Se Vuelve Propietario

**Este es el evento más significativo en la historia de MOSIX desde la perspectiva de la comunidad open source.** En 2001, el equipo de investigación decidió cerrar el código y volver MOSIX un software propietario. Las razones exactas no son públicas, pero la literatura académica menciona que el equipo quería proteger la propiedad intelectual y posiblemente generar ingresos para sostener el proyecto.

Esta decisión tuvo consecuencias inmediatas: **Moshe Bar**, un desarrollador que había participado en el proyecto, tomó la última versión open source disponible y creó **openMosix** como bifurcación (fork) bajo licencia **GPL**. openMosix continuó el desarrollo de funcionalidades de migración de procesos bajo modelo open source hasta 2008.

### 2.7 2004–2006: MOSIX-2 / MOSIX v10

Esta versión introdujo soporte para **multiclusters y grids**, permitiendo que múltiples clusters de computers se administraran como una entidad unificada. Esto fue particularmente relevante para instituciones con múltiples laboratorios o departamentos que querían compartir recursos computacionales.

### 2.8 2014: Cambio Arquitectural — Ya No Requiere Parche de Kernel

Históricamente, MOSIX requería aplicar un **parche al kernel Linux** para funcionar. Esto significaba:

- El usuario debía recompilar o usar un kernel especial
- La compatibilidad con nuevas versiones de kernel era problemática
- La instalación era compleja y propensa a errores

En 2014, MOSIX liberó la versión **MOSIX-4**, que **ya no requería parche de kernel**. Funcionaba como un **módulo o overlay** sobre kernels Linux estándar. Este cambio fue fundamental porque:

1. Simplificó enormemente la instalación
2. Mejoró la compatibilidad con kernels modernos
3. Redujo la barrera de adopción
4. Hizo posible usar MOSIX en entornos de producción sin modificar el kernel base

Sin embargo, para cuando esto ocurrió (2014), el paradigma de contenedores ya estaba emergiendo strongly (Docker fue lanzado en 2013), lo que hizo que la migración de procesos a nivel kernel fuera menos relevante.

### 2.9 Octubre 2017: Último Release — MOSIX-4.4.4

El **24 de octubre de 2017** se lanzó **MOSIX-4.4.4**, el último release oficial hasta la fecha. Desde entonces, no ha habido actualizaciones, parches de seguridad, ni soporte activo.

---

## 3. Modelo de Licencia — Por Qué NO Es Open Source

### 3.1 La Realidad del Licenciamiento

MOSIX es **software propietario** distribuidos bajo una **licencia restrictiva propia** que establece explícitamente:

- **❌ Prohibido modificar** el software
- **❌ Prohibido realizar ingeniería reversa**
- **❌ Prohibido crear obras derivadas**
- **❌ Las contribuciones son propiedad intelectual del Prof. Amnon Barak**

Esta es una diferencia fundamental con el software open source. En una licencia como GPL o Apache 2.0, el usuario tiene derecho a modificar, crear derivados, y redistribuir. MOSIX no otorga ninguno de estos derechos.

### 3.2 Comparación con Alternativas

| Aspecto | MOSIX | openMosix (fork GPL) | Kubernetes |
|---------|-------|---------------------|-------------|
| Código fuente disponible | No | Sí | Sí |
| Permiso para modificar | No | Sí | Sí |
| Permiso para crear derivados | No | Sí | Sí |
| Requisito de código abierto | No | Sí (GPL) | No (Apache 2.0) |
| Uso comercial | Restringido | Sí | Sí |
| Último release | 2017 | ~2008 | Activo |

### 3.3 openMosix: El Fork Histórico

Cuando MOSIX se volvió propietario en 2001, **Moshe Bar** creó **openMosix** para mantener viva la visión open source. Cronología:

- **Febrero 2002:** Lanzamiento oficial de openMosix
- **2002–2007:** Período activo de desarrollo
- **17 de julio de 2007:** Anuncio oficial de discontinuación
- **Marzo 2008:** Cierre oficial del proyecto
- **Post-2008:** **LinuxPMI** continuó el desarrollo, pero también está discontinuado a 2025

openMosix permitió que la comunidad pudiera experimentar con migración de procesos en clusters Linux, pero su discontinuación junto con la de MOSIX dejó un vacío que eventualmente fue llenado por tecnologías de orquestación de contenedores (Docker, Kubernetes, SLURM).

---

## 4. Single System Image (SSI) — El Concepto Central

### 4.1 Definición Formal

**Single System Image (SSI)** es un concepto en sistemas distribuidos donde un cluster de computadoras aparece y se comporta como una **única máquina lógica** ante los usuarios y las aplicaciones. En un sistema SSI:

- Los usuarios ven un único sistema de archivos
- Los procesos pueden ejecutarse en cualquier nodo sin que el usuario lo solicite explícitamente
- La memoria de todos los nodos aparece como un espacio de memoria compartido (aunque físicamente esté distribuido)
- No es necesario saber qué nodo está ejecutando qué proceso

### 4.2 SSI en el Contexto del Temario FSO

El temario FSO en **§1.1** describe dos objetivos fundamentales del SO:

1. **Máquina extendida:** Oculta la complejidad del hardware y presenta una interfaz más simple al usuario
2. **Gestor de recursos:** Administra CPU, memoria y dispositivos de E/S eficientemente

MOSIX lleva ambos conceptos al extremo:

- **Como máquina extendida:** SSI hace que múltiples computadoras appear como una sola, ocultando la complejidad de la distribución física
- **Como gestor de recursos:** MOSIX migra procesos preemptivamente, balancea carga, y distribuye memoria entre nodos de forma transparente

### 4.3 Relación con Arquitectura de SO

En **§1.4**, el temario enumera arquitecturas de SO: monolítica, por capas, microkernel, cliente-servidor, y máquinas virtuales. MOSIX no encaja perfectamente en ninguna de estas categorías porque opera como una **capa sobre el kernel Linux** (un módulo/overlay). Esto lo convierte en una arquitectura híbrida o extensible — el kernel base proporciona los primitives de bajo nivel, y MOSIX extiende su funcionalidad.

Desde **§1.2 generación 4ª (1980-1990)**, MOSIX nació en la era de las computadoras personales, los microprocesadores, y los clusters de workstations. La 4ª generación vio el nacimiento de Linux (1991), que sería la plataforma definitiva de MOSIX.

---

## 5. Diferenciación: Cluster OS vs RTOS

### 5.1 Qué Es un RTOS (Real-Time Operating System)

Un **RTOS** (Sistema Operativo de Tiempo Real) es un SO diseñado para aplicaciones donde el tiempo de respuesta es crítico. Características:

- **Determinismo:** El tiempo máximo de ejecución de cada operación está garantizado
- **Latencia predecible:** Interrupciones y scheduling tienen bounded latency
- **Prioridad fija:** Tareas de alta prioridad siempre desalojan a las de baja prioridad
- **Ejemplos:** FreeRTOS, VxWorks, QNX, RTLinux (una versión de Linux con parches de tiempo real)

Los RTOS se usan en:
- Sistemas embebidos críticos (automotriz, aeroespacial, médico)
- Control industrial
- Sistemas de control de instruments científicas

### 5.2 Qué Es un Cluster OS

Un **Cluster OS** (Sistema Operativo de Cluster) es un SO diseñado para coordinar múltiples computadoras como un sistema unificado. Características:

- **Single System Image:** El cluster aparece como una sola máquina
- **Migración de procesos:** Procesos pueden moverse entre nodos transparently
- **Balanceo de carga dinámico:** El sistema distribuye trabajo según disponibilidad
- **Gestión de recursos distribuida:** CPU, memoria, almacenamiento se comparten entre nodos
- **Ejemplos históricos:** MOSIX, openMosix, openSSI, Kerrighed, LinuxPMI

### 5.3 Diferencias Fundamentales

| Aspecto | RTOS | Cluster OS |
|---------|------|------------|
| **Objetivo primario** | Tiempo real y determinismo | Computación de alto rendimiento (HPC) |
| **Migración de procesos** | Generalmente no (o fija) | Sí, dinámica y preemptiva |
| **Latencia** | Predictible y minima | Variable según red |
| **Aplicaciones típicas** | Embebido crítico, control | HPC, scientific computing, grids |
| **Ejemplos** | FreeRTOS, VxWorks, QNX | MOSIX, SLURM, openMosix |
| **Modelo de memoria** | Generalmente memoria local | Memoria distribuida o compartida |
| **Scheduling** | Prioridad fija, preemptive | Balanceo de carga, greedy |

### 5.4 Por Qué No Son lo Mismo

MOSIX es categorizado como **Cluster OS**, no como RTOS, por las siguientes razones:

1. **No hay garantía de tiempo real:** La migración de procesos introduce latencia no determinística
2. **Objetivo diferente:** MOSIX optimiza throughput y utilización de recursos, no determinismo temporal
3. **Modelo de scheduling:** MOSIX usa algoritmos de balanceo de carga (load balancing) que pueden mover procesos a nodos con menos carga, pero no garantiza latency bounds
4. **Hardware target:** Clusters de workstations/servers, no sistemas embebidos

### 5.5 RTOS en el Temario FSO

El temario FSO no cubre RTOS explícitamente, pero el concepto de **multitarea preemptiva** (§1.3) y **scheduling** (§2.1-§2.8) son prerequisitos para entender RTOS. La diferencia conceptual entre un SO general-purpose (como Linux) y un RTOS está en el algoritmo de scheduling y la gestión de interrupciones — temas que en un curso avanzado de SO incluirían discusión de scheduling de tiempo real.

---

## 6. Conexión con el Temario FSO

### 6.1 §1.1 — Máquina Extendida y Gestor de Recursos

MOSIX materializa ambos conceptos:

- **Máquina extendida:** SSI hace que múltiples nodos appear como uno solo, ocultando la complejidad distribución física
- **Gestor de recursos:** MOSIX implementa migración preemptiva, balanceo de carga dinámico, y distribución de memoria — todas formas avanzadas de gestión de recursos a nivel cluster

### 6.2 §1.2 — Generaciones de SO (4ª y 5ª)

MOSIX nació en la era de la 4ª generación (microprocesadores, clusters, Linux) y se volvió obsoleto en la era de la 5ª generación (contenedores, cloud computing, virtualización). Su historia (1977-2017) refleja la evolución de arquitecturas distribuidas a lo largo de cuatro décadas.

### 6.3 §1.4 — Arquitecturas de SO

MOSIX opera como una **capa sobre kernel Linux** (overlay/module). Esto lo hace relevante para entender:

- Arquitectura de módulos Linux (LKM — Loadable Kernel Modules)
- Extensión de funcionalidad de SO sin modificar el kernel base
- Limitaciones de modificar estado de kernel (zonas críticas, modo kernel vs usuario)

### 6.4 §1.5 — Modo Dual de Operación

La migración de procesos en MOSIX requiere manipulación de estado de procesos a nivel kernel. Esto involucra:

- El código de migración corre en **modo kernel** para poder manipular PCB y estado de CPU
- El scheduler de Linux (§2.2) es modificado o extendido para soportar migración
- La transición entre modos (kernel ↔ user) es fundamental en el diseño

### 6.5 §2 — Administración del Procesador

MOSIX es un caso de estudio advanced de scheduling:

- El scheduler de MOSIX decide en qué nodo ejecutar cada proceso
- Considera: carga de CPU, disponibilidad de memoria, latencia de red entre nodos
- La migración preemptiva permite mover procesos sin perder su estado de ejecución
- Esto contrasta con scheduling local (§2.5) porque es **scheduling distribuido**

---

## 7. Por Qué Israel como Hub de Investigación en Clusters

### 7.1 Contexto Histórico

Israel tiene una tradición de excelencia en ciencia de computación por varias razones:

1. **Inversión en educación:** El porcentaje del PIB destinado a educación es alto, y las universidades tienen fuerte énfasis en STEM
2. **Vínculo industria-academia:** Empresas como Intel, IBM, Microsoft, y Google tienen centros de I+D en Israel, creando un ecosistema donde la investigación fluye entre academia e industria
3. **Necessidad tecnológica:** rodeados de países con los que no tienen relaciones formales, Israel desarrolló capacidades de defensa y tecnología desde muy temprano
4. **Servicio militar técnico:** El servicio militar obligatorio incluye asignación a unidades tecnológicas (C4I, unidades de inteligencia) donde jóvenes graduados trabajan en proyectos de software y sistemas a gran escala

### 7.2 La HUJI Específicamente

La Hebrew University tiene un departamento de Ciencia de Computación con décadas de producción en sistemas distribuidos, networks, y teoría de computación. Esto no es casual: Israel invirtió estratégicamente en investigación de computadoras desde los años 1960s-1970s, y proyectos como MOSIX fueron posibles porque existed una masa crítica de investigadores talentosos y funding sostenido.

---

## 8. Glosario de Términos

### HPC (High Performance Computing)

**Definición:** Computación de alto rendimiento. Uso de múltiples computadoras (clusters) o supercomputadoras para resolver problemas computacionalmente intensivos.

**Contexto en MOSIX:** MOSIX fue diseñado como una plataforma HPC, permitiendo que aplicaciones paralelas corran más rápido al distribuirse across multiple nodos.

**Relación con temario:** HPC es un caso de aplicación de sistemas distribuidos y multiprocesamiento (§1.3).

---

### Cluster OS

**Definición:** Sistema operativo diseñado para administrar un cluster de computadoras como un sistema unificado. Proporciona Single System Image y permite migración de procesos entre nodos.

**Ejemplos históricos:** MOSIX, openMosix, openSSI, Kerrighed, LinuxPMI

**Relación con temario:** Conecta con §1.4 (arquitecturas de SO) como una arquitectura híbrida que extiende el SO base.

---

### SSI (Single System Image)

**Definición:** El concepto de hacer que un cluster de computadoras aparezca como una única máquina lógica. Los usuarios ven un único sistema de archivos, un único espacio de memoria, y pueden ejecutar procesos sin preocuparse por en qué nodo corren.

**Contexto en MOSIX:** SSI es el objetivo central de MOSIX. El proyecto fue pionera en implementar SSI en clusters Linux.

**Relación con temario:** SSI es una materialización del concepto de "máquina extendida" (§1.1).

---

### Investigación Académica

**Definición:** Investigación realizada en universidades o instituciones de investigación, generalmente financiada por grants gubernamentales o fondos universitarios, con el objetivo de avanzar el conocimiento científico más que de generar productos comerciales.

**Contexto en MOSIX:** MOSIX fue desarrollado por un grupo universitario como proyecto de investigación, no como producto comercial. Las publicaciones académicas (§1.4 en temario sobre generaciones) muestran que la investigación puede sobrevivir décadas cuando hay continuidad de funding y personal.

---

### Migración de Procesos

**Definición:** La capacidad de mover un proceso en ejecución de un nodo a otro sin que el proceso lo note. Involucra transferir el estado de ejecución (registros, memoria, archivos abiertos) del proceso.

**Contexto en MOSIX:** MOSIX implementaba **migración preemptiva**, lo que significa que el sistema podía mover un proceso en cualquier momento, incluso si el proceso estaba en medio de una operación.

**Relación con temario:** Conecta con §2 (PCB, estados de proceso, scheduling). La migración es una forma de scheduling distribuido.

---

### Balanceo de Carga (Load Balancing)

**Definición:** Distribución dinámica de trabajos entre múltiples nodos para evitar que algunos nodos estén sobrecargados mientras otros están subutilizados.

**Contexto en MOSIX:** MOSIX monitoreaba constantemente la carga de CPU y memoria de cada nodo y migraba procesos para mantener equilibrio.

**Relación con temario:** Conecta con §2.1 (necesidad de scheduling) y §2.5 (algoritmos de scheduling).

---

## 9. Estado Actual y Relevancia en 2026

### 9.1 Evaluación de Actividad

| Indicador | Estado |
|-----------|--------|
| Último release | MOSIX-4.4.4 (24 de octubre de 2017) |
| Antigüedad | Más de 8 años |
| Desarrollo activo | No |
| Soporte comercial | No |
| Comunidad activa | No |
| Compatibilidad con kernels modernos | Limitada (tested hasta Linux 4.X) |

### 9.2 Posicionamiento en el Ecosistema HPC Moderno

MOSIX ha sido supercedido por tecnologías modernas:

| Tecnología | Tipo | Estado | Adopción HPC |
|------------|------|--------|--------------|
| MOSIX | Migración de procesos nivel kernel | Inactivo | Nula (histórico) |
| SLURM | Job scheduling | Muy activo | >60% Top500 |
| Kubernetes | Orquestación de contenedores | Muy activo | Creciente |
| OpenMPI | Comunicación MPI | Muy activo | Muy amplia |

### 9.3 Valor Académico Actual

MOSIX sigue siendo relevante como:

1. **Caso de estudio de evolución de arquitecturas distribuidas:** 40 años de desarrollo proveen insights sobre cómo la tecnología evolucionó
2. **Ejemplo de SSI:** El concepto sigue válido aunque la implementación cambió
3. **Lección sobre licenciamiento:** El cierre del código en 2001 y la creación de openMosix muestran las tensiones entre investigación abierta y comercialización
4. **Referencia histórica:** Entender por qué ciertas tecnologías succeed y otras no requiere estudiar casos como MOSIX

### 9.4 No Recomendado para Producción

**Razones para no usar MOSIX en 2026:**

1. Sin soporte activo ni actualizaciones de seguridad
2. Incompatibilidad con el paradigma de contenedores (Docker, Kubernetes)
3. Modelo de licenciamiento restrictivo
4. Sin comunidad activa
5. Sin documentación actualizada

**Únicamente recomendado para:**

- Estudio académico de sistemas distribuidos
- Entendimiento histórico de la evolución de clustering
- Referencia para proyectos de investigación

---

## 10. Síntesis — Por Qué MOSIX Es Importante en la Historia de SO

MOSIX representa una era específica de la computación distribuida (1980s-2010s) donde la migración de procesos a nivel kernel era la técnica preferida para construir clusters de alto rendimiento. Su historia de 40 años demuestra:

1. **La investigación académica puede producir tecnología operativa** — no solo papers teóricos
2. **Las decisiones de licenciamiento tienen consecuencias a largo plazo** — el cierre del código en 2001 dio origen a openMosix
3. **Los paradigmas tecnológicos cambian** — contenedores reemplazaron a migración de procesos nivel kernel
4. **El concepto de SSI sigue válido** — aunque implementado de formas diferentes (VMs, contenedores, Kubernetes)

En el contexto del curso de Fundamentos de SO, MOSIX sirve como ejemplo concreto de cómo los conceptos del temario (gestión de procesos, scheduling, máquina extendida, arquitecturas de SO) se aplican en sistemas distribuidos reales.

---

## Fuentes

La información de esta explicación fue extraída de:

- **Slide 04.js** — Contenido visual de la presentación
- **empresa-mosix.md** — Investigación completa sobre MOSIX, incluyendo:
  - History of MOSIX - Hebrew University
  - Wikipedia: MOSIX y OpenMosix
  - MOSIX Official Site (mosix.org)
  - DBLP - Registro de publicaciones del Prof. Amnon Barak
  - ResearchGate - Perfil académico del Prof. Amnon Barak
  - MOSIX Distributions - Licensing
  - Slashdot - openMosix shutdown announcement
- **temario_FSO.md** — Programa de la materia Fundamentos de Sistemas Operativos

---

*Documento elaborado para Fundamentos de Sistemas Operativos — Mayo 2026*