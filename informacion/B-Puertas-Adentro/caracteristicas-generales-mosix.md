# Características Generales de MOSIX

> **Nota del documento:** Este archivo describe MOSIX como caso de estudio para el Trabajo Práctico de Fundamentos de Sistemas Operativos. La información se basa en documentación oficial de MOSIX, Wikipedia, papers académicos y fuentes verificadas públicamente. Dado que MOSIX es un proyecto de investigación propietario con documentación limitada, algunos detalles técnicos internos no están públicamente disponibles y se indica explícitamente cuando es el caso.

---

## 1. ¿Qué tipo de sistema operativo es MOSIX?

MOSIX (**Multi-Operating System Intellect System**) es un **sistema operativo distribuido para clusters** (también llamado *Cluster Operating System* o *Distributed OS*). No es un sistema operativo que se instala en una sola máquina, sino un conjunto de software que administra un cluster de computadoras como si fueran un único sistema.

### Clasificación técnica

| Categoría | Tipo |
|-----------|------|
| **Tipo de sistema** | Distributed OS / Cluster Management System |
| **Modelo de cluster** | Single System Image (SSI) — Imagen de Sistema Único |
| **Paradigma** | Migración preemptiva de procesos a nivel kernel |
| **Licencia** | Propietaria (restrictiva, no open source) |
| **Plataforma** | Linux (x86, x86_64) |
| **Última versión** | MOSIX-4.4.4 (24 de octubre de 2017) |

### ¿Es un sistema operativo convencional?

**No.** MOSIX no reemplaza a Linux ni funciona como sistema operativo standalone. En cambio:

- Se ejecuta **sobre Linux** como una capa de software que extiende el kernel
- Transforma un grupo de máquinas Linux independientes en un **cluster unificado**
- Requiere Linux como sistema base en cada nodo del cluster
- A partir de MOSIX-4 (2014), **ya no requiere parche de kernel** — funciona como módulo/daemon sobre Linux estándar

### Contexto académico

MOSIX se estudia en universidades como caso de estudio de sistemas distribuidos y arquitectura de clusters. Su relevancia es **histórica y pedagógica**: fue pionero en migración de procesos, pero tecnologías modernas (SLURM, Kubernetes) han superado sus casos de uso para producción.

> **Fuente:** [Wikipedia - MOSIX](https://en.wikipedia.org/wiki/MOSIX)

---

## 2. Arquitectura General

### 2.1 Migración de Procesos

La característica central de MOSIX es su capacidad de **migración preemptiva de procesos**: un proceso que inició en un nodo puede ser automáticamente movido a otro nodo del cluster sin que el usuario lo perciba.

**¿Cómo funciona?**

```
┌──────────────┐         ┌──────────────┐
│   Nodo A     │   →     │   Nodo B     │
│  (origen)    │ migración│  (destino)   │
│              │         │              │
│ Proceso P ──┼─────────→│ Proceso P    │
│ (context +  │         │ (continúa)   │
│  memory)    │         │              │
└──────────────┘         └──────────────┘
```

**Aspectos clave de la migración:**

1. **Preemptiva:** El sistema puede migrar un proceso incluso mientras está ejecutando — no requiere que el proceso "cooperе"
2. **Contexto completo:** Se transfiere el estado de la CPU + espacio de memoria del proceso
3. **Transparente:** El proceso no sabe que fue migrado; las llamadas al sistema siguen funcionando
4. **Reversible:** Un proceso migrado puede volver al nodo original si las condiciones cambian

**Limitaciones de la migración:**

- Procesos con **threads** no son soportados de forma nativa
- Procesos con **memoria compartida** entre procesos no pueden migrar
- Procesos con mucha memoria pueden generar sobrecarga de red durante la migración

> **Fuente:** [The MOSIX Algorithms for Managing Cluster, Multi-Clusters, GPU](https://os.inf.tu-dresden.de/Studium/DOS/SS2014/03-MOSIX.pdf)

### 2.2 Balanceo de Carga (Load Balancing)

MOSIX implementa **balanceo de carga dinámico y automático** para distribuir procesos entre nodos según la capacidad disponible.

**Factores considerados para la migración:**

| Factor | Descripción |
|--------|-------------|
| **Velocidad de CPU** | Nodos más rápidos reciben más carga |
| **Carga actual** | Nodos menos cargados reciben nuevos procesos |
| **Memoria disponible** | Procesos migrated a nodos con más memoria |
| **Comunicación inter-procesos** | Procesos que se comunican entre sí se mantienen cerca |

**Algoritmo de decisión:**
El sistema monitorea constantemente los recursos de todos los nodos y toma decisiones de migración basadas en umbrales y políticas configurables. La migración busca:

1. **Maximizar throughput** del cluster
2. **Minimizar tiempo de ejecución** de procesos individuales
3. **Prevenir sobrecarga** de nodos individuales

**Memory Ushering:**
MOSIX incluye un mecanismo llamado *Memory Ushering* que detecta nodos con poca memoria libre y migra proactivamente procesos desde esos nodos hacia otros con más memoria disponible, intentando prevenir condiciones de "out of memory" antes de que ocurran.

> **Fuente:** [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)

### 2.3 Descubrimiento Automático de Recursos

MOSIX automaticamente descubre y configura los nodos disponibles en el cluster:

- **Sin configuración manual** de nodos — el cluster se auto-configura
- **Monitoreo continuo** del estado de cada nodo
- **Detección de nodos nuevos** o nodos que se desconectan
- **Interfaz `/proc/hpc`** para que administradores y aplicaciones interactúen con el cluster

> **Fuente:** [MOSIX Administrator's Guide](http://www.mosix.cs.huji.ac.il/pub/Guide.pdf)

---

## 3. Modelo de Cluster — Single System Image (SSI)

### ¿Qué es Single System Image?

Single System Image (SSI) es un concepto donde un cluster de computadoras se presenta a los usuarios y aplicaciones como **un único sistema computacional**, aunque esté formado por múltiples máquinas físicas.

**Con MOSIX:**
```
┌─────────────────────────────────────────────────────┐
│                 USUARIO / APLICACIÓN                │
│                                                     │
│    "Veo un sistema Linux con 256 CPUs y 1TB RAM"    │
│                                                     │
└─────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────┐
│              CLUSTER MOSIX (SSI)                   │
│                                                     │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐   │
│  │ Nodo 1  │ │ Nodo 2  │ │ Nodo 3  │ │ Nodo 4  │   │
│  │ 64 CPUs │ │ 64 CPUs │ │ 64 CPUs │ │ 64 CPUs │   │
│  │ 256 GB  │ │ 256 GB  │ │ 256 GB  │ │ 256 GB  │   │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘   │
│                                                     │
│  El usuario NO sabe (ni necesita saber) dónde       │
│  se ejecutan sus procesos                           │
└─────────────────────────────────────────────────────┘
```

**Beneficios del modelo SSI:**

1. **Simplicidad para el usuario:** No necesita conocer la arquitectura física del cluster
2. **Transparencia:** Los procesos pueden migrar sin que las aplicaciones lo noten
3. **Escalabilidad:** Se pueden agregar nodos sin cambiar la forma de usar el sistema

### Gestión de Multi-Clusters y Grids

MOSIX puede gestionar no solo un cluster individual, sino también **multi-clusters** y **grids institucionales** donde múltiples clusters cooperan manteniendo su autonomía local:

- Cada cluster mantiene su propia administración
- Los procesos pueden migrar entre clusters
- Políticas de uso compartido configurables

> **Fuente:** [MOSIX White Paper](https://mosix.cs.huji.ac.il/pub/MOSIX_wp.pdf)

---

## 4. Evolución desde 1977 — Historia de MOSIX

MOSIX tiene una de las historias más largas en sistemas distribuidos, con más de **45 años de desarrollo**.

### Línea temporal

| Período | Versión | Plataforma | Hitos |
|---------|---------|------------|-------|
| **1977-1979** | MOS v0 | PDP-11/45 + PDP-11/10 (Unix v6) | Primer proyecto de migración de procesos. Demostró ganancias de rendimiento incluso con enlaces de comunicación lentos. |
| **1981-1983** | MOS v1 | PDP-11/45 + 4 PDP-11/23 (Unix v7) | Primer sistema operativo multicomputadora funcional del mundo. |
| **1987-1988** | NSMOS | NS32332 | Puerto a arquitectura National Semiconductor 32000. |
| **1988-1989** | MOSIX | NS32532 cluster (16 nodos) | Primer sistema con el nombre "MOSIX". Cluster de 16 nodos. |
| **1991-1993** | MOSIX v6 | BSD/OS (cluster 486/Pentium) | Cluster de 8 equipos 486 y 32 Pentium PCs con Myrinet. |
| **1998-1999** | MOSIX v7 | Linux 2.2 | Primera versión para Linux. Cluster de 64 nodos x86 con Myrinet. Este fue el punto de inflexión que definió el futuro de MOSIX. |
| **1999** | — | Linux | A partir de aquí, **todas las versiones se desarrollan sobre kernel Linux**. |
| **2003** | MOSIX v9 | Linux 2.4/2.6 | Cluster con cientos de estaciones de trabajo. |
| **2004-2006** | MOSIX v10 (MOSIX-2) | Linux 2.6 | Gestión de multiclusters y grids. |
| **2014** | MOSIX-4 | Linux 3.X/4.X | **Ya no requiere parche de kernel.** Funciona como módulo sobre Linux estándar. |
| **2017** | MOSIX-4.4.4 | Linux 3.X/4.X | **Última versión hasta la fecha.** Sin desarrollo activo posterior. |

### Puntos de inflexión importantes

**1999 — Enfoque en Linux:**
Cuando MOSIX migró a Linux, ganó compatibilidad con el ecosistema Linux más amplio y se simplificó la instalación. Este movimiento fue crucial para su adopción en clusters académicos.

**2014 — Sin parche de kernel:**
La versión MOSIX-4 eliminó la necesidad de aplicar parches al kernel Linux, haciéndolo mucho más accesible. Ahora funcionaba como módulo/paquete que se instalaba sobre distribuciones Linux estándar.

**2001 — Fork openMosix:**
Cuando MOSIX se volvió propietario en 2001, Moshe Bar bifurcó la última versión libre y creó **openMosix** (febrero 2002). Este proyecto fue open source y activo hasta marzo de 2008, cuando fue discontinuado. El código continuó en **LinuxPMI**.

> **Fuente:** [History of MOSIX](https://mosix.cs.huji.ac.il/txt_history.html)

---

## 5. Características Distintivas Más Importantes

### 5.1 Migración Automática y Preemptiva

La capacidad de mover procesos **en cualquier momento** sin cooperación del proceso es la característica más distintiva de MOSIX. La mayoría de los sistemas distribuidos requieren que las aplicaciones colaboren o se recompilen.

### 5.2 No Requiere Modificación de Aplicaciones

MOSIX puede usar aplicaciones Linux estándar **sin recompilación ni linkedición** con librerías especiales. Las aplicaciones existentes funcionan inmediatamente en el cluster.

### 5.3 Modelo "Shared-Nothing"

MOSIX utiliza un modelo de **memoria distribuida** donde cada nodo tiene su propia memoria local. No hay memoria compartida entre nodos (a diferencia de sistemas NUMA). Esto simplifica la arquitectura pero limita ciertos tipos de aplicaciones.

### 5.4 Sistema de Archivos DFSA (Direct File System Access)

MOSIX no proporciona su propio sistema de archivos distribuido. En cambio, implementa **DFSA** que permite que procesos migrated accedan archivos en cualquier nodo del cluster de forma transparente. El sistema intercepta operaciones de archivos y las redirige al nodo donde reside el dato.

### 5.5 Seguridad con Sandbox

Los procesos migrated se ejecutan en un **entorno sandbox** que los aísla del sistema host. Esto permite ejecutar procesos en nodos potencialmente no confiables con garantías de que no serán modificados.

### 5.6 Checkpoint/Restart

MOSIX soporta **puntos de control (checkpoint)** para guardar el estado de un proceso y **restart** para recuperarlo. Esto permite:

- Recuperación ante fallos de nodos
- Suspensión y resume de procesos largos
- Migración manual de procesos

### 5.7 Integración con SLURM

MOSIX puede integrarse con **SLURM** (scheduler de jobs estándar en HPC) para complementar la planificación de recursos a nivel de cluster.

---

## 6. Limitaciones Conocidas

| Limitación | Descripción |
|------------|-------------|
| **No soporta threads** | Aplicaciones con múltiples threads no son soportadas de forma nativa |
| **No soporta memoria compartida** | Procesos que usan shared memory no pueden beneficiarse de la migración |
| **Software propietario** | No se puede modificar, hacer reverse engineering ni crear obras derivadas |
| **Sin desarrollo activo** | Última versión de 2017, sin actualizaciones de seguridad |
| **No es verdaderamente distribuidos** | DFSA no es un sistema de archivos paralelo completo (como PVFS, Lustre) |
| **E/S puede ser cuello de botella** | Acceso a archivos puede limitar el rendimiento en aplicaciones con alta E/S |

> **Fuente:** [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)

---

## 7. Contexto para el Trabajo Práctico

MOSIX fue incluido en este trabajo práctico no por su vigencia tecnológica, sino por su **valor histórico y pedagógico**:

1. **Pionero en migración de procesos:** Fue el primer sistema en demostrar migración preemptiva funcional en un cluster Linux
2. **Single System Image:** Concepto fundamental que sigue relevante en cloud computing moderno
3. **Balanceo de carga automático:** Algoritmos clásicos que se enseñan en cursos de sistemas distribuidos
4. **Evolución tecnológica:** Entender MOSIX ayuda a comprender por qué el mercado evolucionó hacia contenedores y schedulers

### Posicionamiento histórico

| Período | Tecnología dominante | Enfoque |
|---------|---------------------|---------|
| 1990s-2000s | Beowulf, MOSIX | Clusters de PCs, migración de procesos |
| 2003+ | SLURM, PBS | Job scheduling profesional |
| 2010s+ | Kubernetes, Docker | Contenedores, microservices |
| 2020s+ | K8s + Slurm hybrid | HPC cloud-native |

> **Fuente:** [Teaching Parallel and Distributed Computing Using a Cluster Computing Portal - TCPP Curriculum](https://tcpp.cs.gsu.edu/curriculum/sites/default/files/Teaching%20Parallel%20and%20Distributed%20Computing%20Using%20a%20Cluster%20Computing%20Portal.pdf)

---

## 8. Fuentes

1. [Wikipedia - MOSIX](https://en.wikipedia.org/wiki/MOSIX)
2. [History of MOSIX](https://mosix.cs.huji.ac.il/txt_history.html)
3. [MOSIX Official Site](http://www.mosix.org/)
4. [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)
5. [MOSIX Distributions (Licencia)](https://mosix.cs.huji.ac.il/txt_distributions.html)
6. [MOSIX White Paper](https://mosix.cs.huji.ac.il/pub/MOSIX_wp.pdf)
7. [MOSIX Administrator's Guide](http://www.mosix.cs.huji.ac.il/pub/Guide.pdf)
8. [The MOSIX Algorithms for Managing Cluster (TU Dresden)](https://os.inf.tu-dresden.de/Studium/DOS/SS2014/03-MOSIX.pdf)
9. [The MOSIX Direct File System Access Method - Springer](https://link.springer.com/article/10.1023/B:CLUS.0000018563.68085.4b)
10. [Wikipedia - OpenMosix](https://en.wikipedia.org/wiki/OpenMosix)

---

*Documento creado para Fundamentos de Sistemas Operativos — Mayo 2026*

## Nota Académica — Fundamentos de SO

**Conceptos de la materia relacionados:**

- **§1.3 — Programa vs Proceso y Multitarea**: MOSIX introduce el concepto de **migración preemptiva de procesos**: un proceso (entidad en ejecución) puede moverse entre nodos del cluster conservando su estado completo (contexto CPU + memoria). Esto extiende el concepto de proceso visto en clase a un entorno distribuido, donde "en ejecución" ya no significa en una única máquina física.

- **§1.3 — Multiprocesamiento en un Cluster Distribuido**: MOSIX implementa un modelo de **Single System Image (SSI)** donde múltiples máquinas físicas se presentan como un único sistema. Esto ejemplifica el multiprocesamiento a escala de cluster: desde la perspectiva del usuario, el cluster es una máquina con N CPUs y M memoria, aunque físicamente estén distribuidas. El balanceo de carga dinámico de MOSIX es una forma de scheduling distribuido.

- **§1.4 — Arquitectura de SO Distribuido**: A diferencia de monolítico/microkernel/cliente-servidor, MOSIX representa una **arquitectura de sistema distribuido** que corre sobre Linux. No reemplaza el SO base sino que lo extiende, funcionando como una capa de middleware que intercepta syscalls y gestiona la migración. Esto se relaciona con el concepto de máquinas virtuales y sistemas operativos de cluster.

- **§1.5 — Modo Dual en Contexto Distribuido**: Los procesos migrados en MOSIX se ejecutan en un **entorno sandbox** en los nodos destino, aislados del sistema host. Esto puede relacionarse con el concepto de modo dual: aunque todos los nodos corren Linux (mismo nivel de privilegio), la sandbox crea un dominio de aislamiento que limita qué operaciones puede realizar un proceso migrado.

- **§1.7 — Interrupciones y Syscalls en un Cluster**: Cuando un proceso migrado realiza una syscall en un nodo remoto (ej: abrir un archivo), MOSIX intercepta esta llamada mediante **DFSA (Direct File System Access)** y la redirige al nodo donde reside el archivo. Este mecanismo es análogo a una interrupción software a nivel de cluster: la operación cruza límites de nodos de forma transparente.

- **§1.8 — Llamadas al Sistema Distribuidas**: MOSIX permite que aplicaciones Linux estándar funcionen sin recompilación en el cluster. Las syscalls continúan funcionando correctamente aunque el proceso esté ejecutándose en otro nodo — MOSIX abstrae esta transparencia a nivel del kernel Linux extendido, ejemplificando cómo las llamadas al sistema pueden funcionar en un entorno distribuido.