# Slide 18 — Explicación: MOSIX — Fortalezas y Debilidades

## Propósito de esta slide

Esta slide presenta un **análisis crítico balanceado** de MOSIX: sus fortalezas técnicas (por qué fue innovador) y sus debilidades (por qué quedó obsoleto). La intención no es demonizar a MOSIX ni idealizarlo, sino mostrarlo como un caso de estudio de cómo la tecnología evoluciona — y por qué soluciones pioneras pueden ser superadas por alternativas más simples o abiertas.

La comparación con OpenMPI, TORQUE, Kubernetes y SLURM contextualiza a MOSIX en el ecosistema actual de HPC y cloud computing.

---

## 1. Contexto: ¿Qué es MOSIX?

MOSIX es un **Cluster Operating System** (Sistema Operativo de Cluster) desarrollado originalmente en la Hebrew University of Jerusalem. Su objetivo era transformar un cluster de PCs en un único sistema lógico mediante **Single System Image (SSI)**.

A diferencia de un scheduler de jobs (como SLURM), MOSIX funciona como una **extensión del kernel Linux** que permite la **migración preemptiva de procesos** — mover procesos en ejecución de un nodo a otro sin que la aplicación lo perciba.

### Posicionamiento en el ecosistema

| Tipo | Ejemplos | Qué resuelven |
|------|----------|---------------|
| **Cluster OS (SSI completo)** | MOSIX | "Quiero que el cluster parezca una sola máquina" |
| **Resource Manager + Scheduler** | SLURM, PBS Pro | "Quiero asignar nodos a jobs" |
| **Orquestador de contenedores** | Kubernetes, Docker Swarm | "Quiero desplegar aplicaciones contenerizadas" |
| **Librería de comunicación** | OpenMPI | "Quiero que procesos se comuniquen eficientemente" |

MOSIX pertenece a la primera categoría: ofrece SSI completo, mientras que las otras soluciones resuelven problemas parcialmente ortogonales.

---

## 2. Fortalezas de MOSIX — Explicación Detallada

### 2.1 Cluster se presenta: Migración transparente de procesos

**Lo que dice la slide:**
> "Procesos migran en ejecución sin código modificado"

**Explicación técnica:**

La **migración de procesos** es el corazón de MOSIX. Un proceso en ejecución puede ser movido de un nodo a otro del cluster de forma preemptiva — es decir, el sistema lo decide sin intervención del usuario y sin que el proceso lo sepa.

El mecanismo funciona así:

1. El nodo origen detecta que otro nodo tiene menos carga (CPU, memoria)
2. El kernel MOSIX decide migrar el proceso
3. Se copia el estado del proceso (contexto de CPU, memoria, archivos abiertos) al nodo destino
4. El proceso se reanuda en el nodo destino como si nunca hubiera cambiado de nodo
5. El proceso "cree" que siempre estuvo en el mismo nodo — las system calls funcionan igual

Esta transparencia es clave: **no requiere que la aplicación sepa que está corriendo en un cluster**. Cualquier binario Linux ELF funciona.

**Relación con FSO §1.1 (máquina extendida vs gestor de recursos):**

MOSIX implementa el paradigma de **máquina extendida** al máximo: el cluster se oculta completamente detrás de la abstracción de un sistema único. El usuario no gestiona recursos — el sistema decide por él. Esto contrasta con SLURM, donde el usuario explícitamente pide recursos (nodos, tiempo, memoria).

### 2.2 Single System Image (SSI)

**Lo que dice la slide:**
> "Cluster présenté como un único sistema lógico"

**Explicación técnica:**

Single System Image es el concepto de que un cluster de computadoras se presente como **un solo sistema operativo** con una vista unificada de recursos (CPU, memoria, procesos, archivos).

En MOSIX:
- El usuario ve todos los nodos como si fueran un solo sistema
- `ps` muestra procesos de todos los nodos
- `top` muestra la carga agregada del cluster
- No hay noción de "este proceso está en el nodo 3"

Esto es conceptualmente diferente a un scheduler:
- **Scheduler (SLURM)**: "Ejecutá este job en 4 nodos"
- **SSI (MOSIX)**: "Ejecutá este proceso — el sistema decide dónde"

**Evolución histórica del SSI:**

El concepto de SSI fue popular en los 1990s-2000s con proyectos como:
- MOSIX
- openMosix (fork open source)
- LinuxPMI (continuación de openMosix)
- SCO Unix (ccNUMA)

La idea era crear "el próximo UNIX distribuido". Sin embargo, la industria migró hacia soluciones más pragmáticas: en lugar de ocultar la distribución, se aceptó la complejidad y se construyeron herramientas para gestionarla (schedulers, orquestadores).

### 2.3 Zero-code-change porting

**Lo que dice la slide:**
> "Binarios Linux estándar funcionan sin recompilación"

**Explicación técnica:**

Cualquier executable Linux compilado para x86_64 puede ejecutarse en un cluster MOSIX **sin recompilación, sin relinking, sin uso de librerías especiales**.

Esto se diferencia radicalmente de:
- **OpenMPI**: Requiere que la aplicación use funciones MPI (`MPI_Send`, `MPI_Recv`, etc.)
- **Aplicaciones RPC**: Requieren definir interfaces, stubs, etc.
- **Hadoop/Spark**: Requieren APIs específicas del framework

En MOSIX, un binario como `python mi_script.py` o un executable compilado con `gcc` funciona tal cual. El usuario ejecuta `mosrun ./mi_programa` y MOSIX decide dónde ejecutarlo.

**Limitación importante**: Este es uno de los puntos donde MOSIX brilla conceptualmente pero tiene limitaciones prácticas — si la aplicación hace suposiciones sobre la topología de memoria o usa threads, no funcionará correctamente.

### 2.4 Pioneer technology — Migración preemptiva funcional (1999)

**Lo que dice la slide:**
> "Primer sistema con migración preemptiva funcional (1999)"

**Explicación técnica:**

MOSIX fue el **primer sistema operativo de cluster** en demostrar migración preemptiva funcional de procesos en producción. El paper seminal de Bar et al. (1998-1999) demostró que la migración de procesos podía funcionar en clusters de PCs conectados con Myrinet.

**¿Por qué fue innovador?**

Antes de MOSIX:
- Los clusters eran gestionados manualmente (scripts de `rsh`, `ssh`)
- La migración de procesos era un tema académico sin implementaciones funcionales
- Los schedulers (como PBS) podían asignar jobs a nodos, pero no migrar procesos en ejecución

MOSIX demostró que:
1. La migración preemptiva era técnicamente viable
2. El overhead de migración podía ser aceptable para ciertas cargas de trabajo
3. El balanceo de carga automático mejoraba la utilización del cluster

**Contexto histórico:**

- 1977-1979: MOS (primera versión, PDP-11)
- 1981-1983: MOS Version 1
- 1988-1989: MOSIX (nombre actual, cluster NS32532 de 16 nodos)
- 1998-1999: MOSIX v7 para Linux (cluster de 64 nodos x86 con Myrinet)
- 2001: openMosix fork (cuando MOSIX se volvió propietario)
- 2017: Última versión (MOSIX-4.4.4)

---

## 3. Debilidades de MOSIX — Explicación Detallada

### 3.1 INACTIVE since Oct 2017

**Lo que dice la slide:**
> "Sin parches, updates ni soporte disponible"

**Explicación técnica:**

La última versión oficial de MOSIX (MOSIX-4.4.4) fue released el **24 de octubre de 2017** — hace más de 8 años. Desde entonces:

- **Sin parches de seguridad**: Vulnerabilidades conocidas en kernels Linux no se parchean en MOSIX
- **Sin compatibilidad con kernels modernos**: MOSIX requería parches al kernel Linux, y esos parches no se han actualizado para kernels 5.x o 6.x
- **Sin soporte oficial**: Los desarrolladores académicos no ofrecen soporte formal; la única vía es email informal
- **Sin comunidad activa**: No hay foros, no hay contribución de terceros

**Implicaciones prácticas:**

1. **No usar en producción**: Cualquier vulnerabilidad de seguridad queda expuesta sin posibilidad de parche
2. **No usar en entornos críticos**: Sin soporte, no hay quien responda ante fallos
3. **Solo para contexto académico**: Útil para aprender conceptos, no para implementar soluciones

**Conexión con FSO §1.4 (arquitecturas de SO):**

La historia de MOSIX ilustra un patrón común en sistemas distribuidos: la decisión de diseño de **modificar el kernel** (en lugar de funcionar a nivel usuario) fue su fortaleza inicial pero se convirtió en su perdición cuando el proyecto quedó sin recursos para mantener el parche contra versiones nuevas del kernel Linux.

### 3.2 Proprietary

**Lo que dice la slide:**
> "Licencia restrictiva — no open source"

**Explicación técnica:**

La licencia de MOSIX prohíbe:
- Modificar el código fuente
- Hacer ingeniería reversa
- Crear obras derivadas
- Redistribuir modificaciones

Esto contrasta con:
- **SLURM**: GPL (código abierto, permite auditoría y contribución)
- **Kubernetes**: Apache 2.0 (open source con patentes)
- **OpenMPI**: BSD (permite uso comercial y modificaciones)

**Impacto en la evolución:**

Cuando MOSIX se volvió propietario en 2001, Moshe Bar bifurcó el código para crear **openMosix** (open source). openMosix sobrevivió hasta 2008, cuando fue discontinuado a favor de **LinuxPMI** (Linux Process Migration Infrastructure), que continuó el desarrollo independiente hasta ~2012.

La moraleja: **las soluciones open source sobreviven a sus creadores; las propietarias mueren cuando el financiamiento desaparece.**

### 3.3 Only x86_64

**Lo que dice la slide:**
> "Sin soporte para arquitecturas modernas"

**Explicación técnica:**

MOSIX solo soporta procesadores x86_64 (Intel/AMD de 64 bits). No hay soporte para:
- **ARM64** (Apple Silicon, AWS Graviton, smartphones, embedded)
- **RISC-V** (arquitectura emergente)
- **POWER** (IBM PowerPC, used in some HPC)
- **SPARC** (histórico, algunos mainframes)

**¿Por qué es una limitación fatal?**

En 2026:
- Los clouds públicos ofrecen instancias ARM64 (AWS Graviton, Azure Ampere)
- Apple Silicon mostró que ARM64 es viable para cómputo de alto rendimiento
- RISC-V está emergiendo como alternativa abierta
- Kubernetes, SLURM y todas las alternativas modernas soportan múltiples arquitecturas

**Conexión con temario FSO:**

Esta limitación ilustra lo que el temario dice sobre **arquitecturas de SO** (§1.4): las decisiones de diseño de bajo nivel (acoplamiento a una arquitectura de CPU) tienen consecuencias a largo plazo. MOSIX fue diseñado cuando x86 dominaba; cuando el panorama cambió, no pudo seguir.

### 3.4 Modern competitors: SLURM, Kubernetes

**Lo que dice la slide:**
> "SLURM, Kubernetes dominan el mercado"

**Explicación técnica:**

El ecosistema de cluster computing evolucionó significativamente:

**SLURM (Simple Linux Utility for Resource Management):**
- Resource manager y scheduler de jobs
- GPL open source (SchedMD)
- **>60% de las Top500 supercomputadoras** lo usan
- Escalabilidad comprobada a miles de nodos
- Integración con MPI, GPUs, containers
- Soporte comercial disponible

**Kubernetes:**
- Orquestador de contenedores
- CNCF (Cloud Native Computing Foundation)
- Estándar para cloud computing y microservicios
- Auto-scaling, rolling updates, service mesh
- Portabilidad entre clouds y on-premise

**Comparativa de adopción:**

| Solución | Adopción HPC Top500 | Adopción Cloud | Adopción General |
|----------|---------------------|----------------|------------------|
| SLURM | >60% | Baja | Media (HPC) |
| Kubernetes | Creciente | Dominante | Alta |
| MOSIX | 0% | 0% | Nula (histórica) |

**¿Por qué ganó SLURM sobre MOSIX?**

1. **Modelo más simple**: SLURM no necesita modificar el kernel — funciona a nivel usuario
2. **Open source**: La comunidad puede contribuir y mantener
3. **Enfoque pragmático**: En lugar de "migración transparente", SLURM ofrece "re-scheduling cuando el job termina" — menos elegante pero más robusto
4. **Integración con MPI**: SLURM se diseñó desde el inicio para trabajar con OpenMPI

### 3.5 No threads support

**Lo que dice la slide:**
> "Aplicaciones multithread no son compatibles"

**Explicación técnica:**

MOSIX puede migrar **procesos individuales**, pero **no puede migrar threads de un proceso de forma atómica**.

Esto significa:
- Aplicaciones **single-threaded**: Funcionan correctamente
- Aplicaciones **multi-threaded**: Los threads quedan en el nodo original mientras el proceso principal migra — comportamiento indefinido
- Aplicaciones que usan **pthreads, OpenMP, threads de Java**: No son compatibles

**¿Por qué es una limitación crítica?**

En 2026, prácticamente toda aplicación moderna usa threads:
- Servidores web (nginx, Apache)
- Bases de datos (PostgreSQL, MySQL)
- Aplicaciones de usuario (la mayoría usan threads para concurrencia)
- Frameworks de ML (TensorFlow, PyTorch usan múltiples threads)

**Conexión con temario FSO §2.5 (scheduling):**

El scheduling de threads es un tema complejo que MOSIX nunca resolvió. En un sistema operativo normal, los threads de un proceso comparten el mismo espacio de direcciones, lo que hace la migración de todo el proceso (incluyendo threads) significativamente más compleja. El diseño de MOSIX asumió procesos como entidades independientes — una simplificación que funcionó en los 1990s pero no escala a aplicaciones modernas.

---

## 4. Conexión con el Temario de FSO

### §1.4 — Arquitecturas de SO

La slide menciona: *"§1.4 (arquitecturas — SO distribuido)"*

MOSIX fue un intento de crear un **Sistema Operativo Distribuido a nivel kernel**. La migración de procesos vivía dentro del kernel Linux parcheado, lo que lo convierte en un ejemplo de:

- **Diseño monolítico modificado**: MOSIX no era un microkernel (los servicios de migración corrían en el kernel), pero tampoco era un kernel monolítico estándar — era una extensión.
- **Trade-off de diseño**: La decisión de meter la migración en el kernel permitió transparencia total, pero también acoplamiento estrecho con versiones específicas del kernel.

**Evolución arquitectónica mostrada por MOSIX:**

| Período | Arquitectura | Enfoque |
|---------|--------------|---------|
| 1990s | MOSIX (kernel patches) | "Todo en el kernel" |
| 2000s | LinuxPMI (kernel modules) | "Módulo cargable" |
| 2010s | Containers (cgroups/namespaces) | "Aislamiento en espacio de usuario" |
| 2020s | Kubernetes + SLURM hybrid | "Orquestación a nivel aplicación" |

La tendencia fue desde soluciones kernel-level hacia soluciones user-level. La razón: **es más fácil mantener y actualizar software que corre en espacio de usuario**.

### §2.5 — Scheduling y balanceo de carga distribuido

La slide menciona: *"§2.5 (scheduling — balanceo de carga distribuido)"*

MOSIX implementa un **scheduler distribuido** donde cada nodo:
1. Monitorea su propia carga (CPU, memoria)
2. Comunica esta información a otros nodos
3. Decide migrar procesos proactivamente (Memory Ushering)

**Algoritmo de Memory Ushering:**

MOSIX no espera a que un nodo se quede sin memoria (OOM). Su algoritmo de **Memory Ushering**:
1. Monitorea uso de memoria en cada nodo
2. Detecta tendencias (no solo estados instantáneos)
3. Migra procesos **antes** de que ocurra el page fault
4. Busca nodos con memoria disponible

Esto es análogo a un **scheduler preventivo (preemptive)** en el sentido de que anticipa problemas en lugar de reaccionar a ellos.

**Comparación con algoritmos de scheduling del temario:**

| Algoritmo (§2.5) | Descripción | Analogía en MOSIX |
|-----------------|-------------|-------------------|
| FCFS | First Come First Served | Job submission order |
| SJF | Shortest Job First | Prioriza procesos cortos |
| Round Robin | Quantum fijo | Time-sharing en cada nodo |
| Priority scheduling | Mayor prioridad primero | Nodos con más recursos reciben más trabajo |
| **Memory Ushering** | Migración proactiva | No tiene análogo directo — es específico de clusters |

**Trade-off discutido en clase:**

El temario de FSO menciona que el scheduling busca:
- Maximizar utilización de CPU
- Minimizar tiempo de respuesta
- Equidad entre procesos

MOSIX agrega una dimensión: **el costo de la migración**. Migrar un proceso consume:
- Ancho de banda de red
- Tiempo de CPU en ambos nodos
- Tabla de páginas transferida

El algoritmo de MOSIX debe decidir: "¿el beneficio de migrar supera el costo de la migración?"

---

## 5. Comparativa Extendida con SLURM, Kubernetes y OpenMPI

### 5.1 MOSIX vs SLURM

| Aspecto | MOSIX | SLURM |
|---------|-------|-------|
| **Migración live** | ✅ Sí — procesos migran en ejecución | ❌ No — jobs se re-schedulean cuando terminan |
| **Single System Image** | ✅ Completo — cluster como un sistema | ❌ No — usuario ve nodos individuales |
| **Transparencia** | ✅ Total — aplicación no sabe que está en cluster | ❌ Parcial — usuario debe especificar recursos |
| **Estado del proyecto** | ❌ Inactivo desde 2017 | ✅ Activo (actualizaciones semanales) |
| **Licencia** | ❌ Propietaria | ✅ GPL |
| **Adopción Top500** | ❌ 0% | ✅ >60% |
| **Escalabilidad** | ⚠️ Cientos de nodos (no verificado modernamente) | ✅ Miles de nodos (verificado) |
| **Threads** | ❌ No soportados | ✅ Soportados |

**¿Por qué SLURM ganó?**

SLURM resolvió un problema más simple y lo resolvió bien:
- No intenta透明的 migración
- No requiere parches de kernel
- Se integra con MPI desde el diseño
- Open source permite que la comunidad lo mantenga

### 5.2 MOSIX vs Kubernetes

| Aspecto | MOSIX | Kubernetes |
|---------|-------|------------|
| **Abstracción** | Proceso Linux (nivel kernel) | Contenedor (nivel aplicación) |
| **Migración live** | ✅ Sí — proceso individual | ❌ No — pods son reimplantados, no migrados |
| **Single System Image** | ✅ Completo | ❌ Parcial (Service Discovery es una forma limitada) |
| **Estado del proyecto** | ❌ Inactivo | ✅ Muy activo (CNCF) |
| **Portabilidad** | ❌ Requiere mismo kernel/arquitectura | ✅ Container corre en cualquier cluster |
| **Aislamiento** | Sandbox (procesos) | Containers (namespaces + cgroups) |
| **Storage** | Limitado (DFSA) | PersistentVolumes, CSI |
| **Curva de aprendizaje** | Media | Alta |

**¿Por qué Kubernetes ganó?**

Kubernetes tomó una decisión diferente: en lugar de ocultar la distribución, **explicó la distribución como primitiva** (container) y construyó herramientas de orquestación encima.

- **Container** = unidad de despliegue (no de cómputo)
- **Pod** = grupo de contenedores que comparten red/storage
- **Deployment** = gestiona réplicas de pods
- **Service** = descubrimiento de servicios

Este modelo es más verboso, pero:
- Es más explícito y controlable
- Permite rollbacks, auto-scaling, health checks
- La comunidad puede agregar features sin tocar el kernel

### 5.3 MOSIX vs OpenMPI

> **Nota importante:** OpenMPI y MOSIX resuelven **problemas ortogonales**. OpenMPI es una librería de comunicación para cómputo paralelo. MOSIX es un sistema de gestión de cluster. La comparación directa es like comparing a car's engine to its GPS.

| Aspecto | MOSIX | OpenMPI |
|---------|-------|---------|
| **Propósito** | Gestión de cluster (migración, balanceo) | Comunicación entre procesos paralelos |
| **Modelo de código** | Ningún cambio | Requiere API MPI |
| **Migración dinámica** | ✅ Sí | ❌ No |
| **Balanceo automático** | ✅ Sí | ❌ Limitado |
| **Memoria compartida** | ❌ No | ✅ Sí (intra-nodo) |
| **Adopción HPC** | ❌ Ninguna actual | ✅ Universal |

**En HPC real, SLURM + OpenMPI es la combinación estándar:**
- SLURM asigna nodos a jobs
- OpenMPI maneja la comunicación inter-procesos
- MOSIX no tiene rol en este stack

---

## 6. Evolución: Clusters → Containers

### 6.1 Por qué cambió el paradigma

La slide muestra la evolución de tecnología de clusters. Aquí se explica por qué:

**1. La migración de procesos es pesada:**

Migrar un proceso Linux implica:
- Copiar todo el espacio de direcciones (páginas de memoria)
- Copiar estado de CPU (registros, program counter)
- Copiar descriptores de archivos abiertos
- Actualizar tablas de páginas
- Sincronizar con el file system

Un container en cambio:
- Comparte el kernel con el host
- Su "estado" es principalmente el filesystem (capas de imagen)
- Migrar un container es principalmente transferir la imagen + estado

**2. El kernel Linux evolucionó:**

Cuando MOSIX fue diseñado, el aislamiento de procesos era primitivo. Las features modernas de containers (cgroups, namespaces, seccomp) hicieron innecesario parchear el kernel — el aislamiento puede lograrse desde espacio de usuario.

**3. Comunidad open source:**

SLURM tiene cientos de contribuidores. Kubernetes tiene miles. MOSIX tenía un equipo académico pequeño. **La escala de comunidad determina la longevidad.**

**4. Portabilidad:**

Un container Docker corre en cualquier cluster Kubernetes. Un proceso MOSIX requiere:
- Mismo kernel version
- MOSIX instalado
- Misma arquitectura (x86_64)

### 6.2 Línea temporal de evolución

```
1999: MOSIX v7 (Linux)
    ├── Primera versión para Linux
    ├── Cluster de 64 nodos x86 con Myrinet
    └── Demostró viabilidad de migración preemptiva

2003: SLURM (origen)
    └── Scheduler de jobs open source

2008: openMosix discontinuado
    └── LinuxPMI continuó hasta ~2012

2013: Docker lanzado
    └── Contenedores se popularizan

2014: Kubernetes lanzado (Google)
    └── Orquestación de contenedores

2017: MOSIX-4.4.4 (último release)
    └── Proyecto esencialmente abandonado

2020s: SLURM + Kubernetes hybrid
    └── HPC cloud-native, contenedores en supercomputadoras
```

---

## 7. Glosario de Términos

### Cluster OS (Sistema Operativo de Cluster)

Software que gestionar múltiples nodos como un sistema integrado, proporcionando Single System Image. Ejemplos históricos: MOSIX, openMosix, LinuxPMI.

**Diferencia con otros tipos:**
- **Job scheduler**: Solo asigna recursos a jobs (SLURM, PBS)
- **Orquestador**: Gestiona ciclo de vida de aplicaciones distribuidas (Kubernetes)
- **Cluster OS**: Provee abstracción de sistema único (MOSIX)

### Single System Image (SSI)

Propiedad de un sistema distribuido donde el cluster se presenta como un solo sistema con visión unificada de recursos. En SSI, el usuario no sabe (ni necesita saber) en qué nodo corre su proceso.

**SSI completo** (como MOSIX):
- ps muestra todos los procesos del cluster
- top muestra carga agregada
- No hay noción de "nodo remoto"

**SSI parcial** (como Kubernetes):
- Cada pod tiene su propia vista
- Service Discovery permite encontrar servicios
- Pero no hay abstracción de "una sola máquina"

### Transparent Migration (Migración Transparente)

Capacidad de mover un proceso de un nodo a otro sin que la aplicación lo perciba. El proceso "cree" que siempre estuvo en el mismo nodo.

**Requisitos técnicos:**
- Copia de contexto de CPU
- Copia de espacio de direcciones
- Redirección de file descriptors
- Sincronización de estado de red

**Migración preemptiva vs voluntaria:**
- **Preemptiva**: El sistema decide migrar sin que el proceso lo solicite
- **Voluntaria**: El proceso o usuario inicia la migración

### Containerization (Contenedorización)

Tecnología que aísla aplicaciones usando features del kernel Linux (namespaces, cgroups). A diferencia de VMs, containers comparten el kernel del host.

**Docker** popularizó contenedores en 2013. **Kubernetes** se convirtió en el orquestador estándar.

**Docker vs MOSIX:**
| Aspecto | Docker | MOSIX |
|---------|--------|-------|
| Aislamiento | Namespaces + cgroups | Sandbox de procesos |
| Migración | Imagen + volumen | Contexto de memoria |
| Portabilidad | Alta (cualquier host) | Baja (mismo kernel) |
| Performance | Baja overhead | Baja overhead |
| Estado | Stateless preferible | Procesos stateful |

### SLURM (Simple Linux Utility for Resource Management)

Resource manager y scheduler de jobs open source para clusters Linux. Es el estándar de facto en HPC, usado en >60% de las Top500 supercomputadoras.

**Funcionalidades:**
- Asignación de nodos a jobs
- Colas de jobs (partitions)
- Fairshare (equidad entre usuarios)
- Checkpoint/restart
- Integración con MPI, GPUs

**Diferencia con MOSIX:** SLURM no hace migración live — los jobs se ejecutan en los nodos asignados hasta que terminan o son cancelados.

### Kubernetes

Sistema de orquestación de contenedores open source (CNCF). Gestiona el ciclo de vida de aplicaciones containerizadas en clusters.

**Conceptos clave:**
- **Pod**: Grupo de containers que comparten red/storage
- **Deployment**: Gestión de réplicas de pods
- **Service**: Descubrimiento de servicios (DNS interno)
- **Ingress**: Balanceo de carga HTTP
- **PersistentVolume**: Almacenamiento persistente

**Kubernetes no es un Cluster OS** — no proporciona SSI. Cada pod es independiente y la distribución es explícita.

---

## 8. Conclusión: Por qué estudiar MOSIX en FSO

### Valor académico

MOSIX se incluye en el TP por razones **históricas y conceptuales**, no porque sea tecnología para usar en producción:

1. **Pionero en migración de procesos**: MOSIX demostró que la migración preemptiva era viable — concepto fundamental en sistemas distribuidos

2. **SSI como ideal de transparencia**: Ilustra el trade-off entre transparencia (MOSIX) y control explícito (SLURM) — dos filosofías de diseño de sistemas

3. **Algoritmos de balanceo de carga**: Memory Ushering es un ejemplo de scheduling proactivo que anticipa problemas

4. **Caso de estudio de obsolescencia**: Muestra cómo decisiones de diseño (código propietario, parches de kernel, x86_64 only) llevan al abandono

### Qué usar en producción (2026)

| Necesidad | Tecnología recomendada |
|-----------|----------------------|
| HPC clásico (clusters de PCs) | **SLURM** + OpenMPI |
| Cloud-native / microservicios | **Kubernetes** |
| Cómputo paralelo con memoria compartida | **OpenMPI** + SLURM |
| Contenedores en HPC | **SLURM + Docker/Kubernetes** |
| Educarse en migración de procesos | **MOSIX** (contexto académico) |

### Mensaje final

MOSIX fue un sistema innovador que resolvió un problema difícil (migración transparente de procesos) con una solución elegante pero frágil (parches de kernel). La evolución hacia containers y schedulers muestra que la industria prefiere soluciones pragmáticas a elegantes: SLURM no hace migración live, pero funciona y se mantiene. Kubernetes no proporciona SSI, pero es portable y escalabile.

Esto es un patrón común en sistemas: **el diseño "perfecto" que requiere control total del sistema往往会 ser superado por soluciones "imperfectas" que funcionan dentro de los límites del ecosistema existente**.

---

## Fuentes

- Slide: `presentacion/slides/slide-18.js`
- Investigación: `informacion/B-Puertas-Adentro/pros-contras-mosix.md`
- Temario: `temario_FSO.md`
- Historial MOSIX: https://mosix.cs.huji.ac.il/txt_history.html
- Changelog MOSIX: https://mosix.cs.huji.ac.il/txt_changelog.html
- FAQ MOSIX: http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html
- SLURM: https://slurm.schedmd.com/
- Top500: https://www.top500.org/
- Kubernetes: https://kubernetes.io/
- OpenMPI: https://www.open-mpi.org/
- TU Dresden - MOSIX Algorithms: https://os.inf.tu-dresden.de/Studium/DOS/SS2014/03-MOSIX.pdf