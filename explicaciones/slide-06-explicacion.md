# slide-06-explicacion.md — MOSIX: Características Generales

> Este documento acompaña a `slide-06.js` y proporciona una explicación detallada para ingenieros que ya conocen fundamentos de sistemas operativos.

---

## 1. ¿QUÉ ES MOSIX?

### 1.1 Definición y Contexto

**MOSIX** (*Multi-Operating System Intellect System*) es un **sistema operativo distribuido para clusters** que transforma un conjunto de máquinas Linux independientes en un sistema unificado con **Single System Image (SSI)**. No reemplaza Linux: funciona como una **capa de software sobre el kernel Linux existente**, extendiendo sus capacidades sin modificarlo.

Técnicamente, MOSIX se clasifica como:

| Categoría | Tipo |
|-----------|------|
| **Tipo de sistema** | Distributed OS / Cluster Operating System |
| **Modelo de cluster** | Single System Image (SSI) — Imagen de Sistema Único |
| **Paradigma central** | Migración preemptiva de procesos a nivel kernel |
| **Plataforma** | Linux (x86, x86_64) |
| **Última versión** | MOSIX-4.4.4 (octubre 2017) |

### 1.2 Arquitectura: Kernel Module + Daemon

A partir de **MOSIX-4 (2014)**, el sistema ya no requiere parches al kernel Linux. Su arquitectura se compone de:

1. **Kernel Module**: Un módulo de kernel de Linux que intercepta syscalls relacionadas con procesos y memoria. Se carga en cada nodo del cluster.

2. **Daemon Userspace**: Un proceso daemon que corre en cada nodo, responsible de:
   - Descubrimiento automático de nodos en el cluster
   - Comunicación entre nodos para coordinación de migración
   - Monitoreo de recursos (CPU, memoria, carga)
   - Decisiones de balanceo de carga

Esta separación permite que MOSIX funcione sobre **cualquier distribución Linux estándar** sin modificaciones al kernel base.

### 1.3 Conexión con §1.4 del Temario (Arquitecturas de SO)

MOSIX representa una **arquitectura de sistema operativo distribuido** que no encaja perfectamente en las categorías tradicionales (§1.4):

| Arquitectura clásica | Descripción | MOSIX |
|---------------------|--------------|-------|
| **Monolítica** | Todo en modo kernel | No — funcionalidad dividida entre kernel + daemon |
| **Por capas** | Capas jerárquicas | Parcialmente — capa de cluster sobre kernel Linux |
| **Microkernel** | Kernel mínimo, servicios en usuario | No — usa kernel Linux completo |
| **Cliente-Servidor** | Servicios como servidores | Sí, en parte — daemon coordina nodos |
| **Máquinas virtuales** | SO simulado | No — comparte el mismo kernel Linux |

MOSIX es más precisamente un **sistema middleware de cluster** que extiende Linux, análogo a una "máquina extendida" (§1.1: máquina extendida como objetivo del SO). El concepto de "máquina extendida" se escala a nivel de cluster: el cluster entero se presenta como una única máquina virtual con N CPUs y M memoria.

---

## 2. SINGLE SYSTEM IMAGE (SSI)

### 2.1 Concepto

**Single System Image (SSI)** es el concepto central de MOSIX y representa una abstracción donde un cluster de computadoras se presenta a usuarios y aplicaciones como **un único sistema computacional**, aunque esté físicamente distribuido.

Desde la perspectiva del usuario:
```
"Veo un sistema Linux con 256 CPUs y 1TB RAM"
```

Físicamente:
```
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

### 2.2 ¿Por qué es "revolucionario"?

SSI es revolucionario porque resuelve un problema fundamental de los clusters tradicionales:

**Sin SSI**: El usuario debe:
- Conocer cuántos nodos existen
- Decidir manualmente en qué nodo ejecutar cada proceso
- Gestionar manualmente la distribución de archivos
- Monitorear manualmente la carga de cada nodo

**Con SSI**: El usuario ve un sistema único donde:
- Los procesos se ejecutan "en algún lugar" del cluster
- La migración automática transparenta la ubicación física
- El cluster se escala agregando nodos sin cambiar la interfaz

### 2.3 Relación con Conceptos de FSO

| Concepto FSO (§1.1) | Aplicación en SSI |
|---------------------|-------------------|
| **Máquina extendida** | El cluster completo actúa como una "máquina extendida" a escala |
| **Gestor de recursos** | MOSIX gestiona CPU, memoria y E/S de todo el cluster como un recurso unificado |
| **Abstracción** | SSI es la máxima abstracción: esconde toda la complejidad distribuida |

---

## 3. MIGRACIÓN DE PROCESOS

### 3.1 Definición

La **migración de procesos** es la característica central y más distintiva de MOSIX: la capacidad de mover un proceso que se ejecuta en un nodo a **otro nodo del cluster**, de forma preemptiva y transparente, sin que la aplicación lo perciba.

### 3.2 Cómo Funciona la Migración

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

**Pasos de la migración:**

1. **Decisión**: El daemon de MOSIX decide que el proceso debe migrar (balanceo de carga, nodo saturado, etc.)
2. **Preemption**: Se interrumpe el proceso en ejecución en el nodo origen
3. **Serialización del contexto**: Se empaqueta el estado completo de la CPU (registros, PC, flags)
4. **Transferencia de memoria**: Se copia el espacio de memoria completo del proceso al nodo destino
5. **Reinicio**: El proceso se reanuda en el nodo destino continuando desde donde estaba
6. **Actualización de tablas**: Se actualizan las estructuras internas de MOSIX para reflejar la nueva ubicación

### 3.3 Propiedades de la Migración

| Propiedad | Descripción | Analogía FSO |
|-----------|-------------|--------------|
| **Preemptiva** | El sistema puede migrar un proceso incluso mientras está ejecutando | Similar a scheduling preemptivo (§2.1) donde el proceso puede ser desalojado |
| **Contexto completo** | Se transfiere el estado de CPU + espacio de memoria | Extiende el concepto de contexto de CPU (§2.3 PCB) a nivel distribuido |
| **Transparente** | El proceso no sabe que fue migrado; syscalls siguen funcionando | El proceso opera igual que antes, como si nada hubiera cambiado |
| **Reversible** | Un proceso migrado puede volver al nodo original si las condiciones cambian | El proceso no está "atado" a ningún nodo |

### 3.4 Factores Considerados en la Decisión de Migrar

MOSIX evalúa múltiples factores antes de decidir migrar un proceso:

| Factor | Descripción |
|--------|-------------|
| **Velocidad de CPU** | Nodos más rápidos reciben más carga |
| **Carga actual** | Nodos menos cargados reciben nuevos procesos |
| **Memoria disponible** | Procesos se migran a nodos con más memoria libre |
| **Comunicación inter-procesos (IPC)** | Procesos que se comunican entre sí se mantienen cerca para minimizar latencia |

### 3.5 Conexión con §2.1 y §2.4 del Temario (Scheduling)

La migración de procesos en MOSIX es, en esencia, una forma de **scheduling distribuido**:

**Sin migración de procesos (scheduling tradicional, §2.1)**:
- El scheduler (§2.4) selecciona qué proceso corre en la CPU actual
- La decisión es binaria: este nodo o ningún nodo
- La granularidad es el proceso completo

**Con migración de procesos (MOSIX)**:
- El "scheduler" es el daemon de MOSIX
- La decisión incluye: ejecutar localmente, migrar a otro nodo, o no ejecutar
- La granularidad puede ser fina: migrar procesos individuales incluso entre nodos idle

| Concepto FSO | Aplicación en MOSIX |
|--------------|---------------------|
| **Scheduler de corto plazo (§2.4)** | El daemon de MOSIX decide migrar procesos entre nodos — es un "scheduler de cluster" |
| **Objetivos del scheduler (§2.1)** | Maximizar throughput del cluster, minimizar tiempo de ejecución, equitidad |
| **Quantum y context switch** | La migración implica un "context switch distribuido" con transferencia de estado completo |
| **Estados de proceso (§2.2)** | Un proceso migrado pasa de "ejecutando en nodo A" a "ejecutando en nodo B" |

### 3.6 Limitaciones de la Migración

| Limitación | Descripción |
|------------|-------------|
| **No soporta threads** | Procesos multi-threaded no pueden migrar como unidad |
| **No soporta memoria compartida** | Procesos que usan `shared memory` entre procesos no pueden migrar |
| **Overhead en procesos grandes** | Procesos con mucha memoria generan tráfico de red significativo durante migración |
| **Memoria compartida entre nodos** | No hay memoria compartida entre nodos (modelo "shared-nothing") |

---

## 4. MEMORY USHERING

### 4.1 Concepto

**Memory Ushering** es un mecanismo de MOSIX que implementa **migración proactiva de memoria**: detecta nodos con poca memoria libre y migra procesos **antes** de que ocurra una condición de "out of memory" (OOM).

### 4.2 Cómo Funciona

1. **Monitoreo continuo**: Cada daemon monitorea la memoria disponible en su nodo
2. **Detección de umbral**: Cuando la memoria libre cae bajo un umbral configurable, se activa el mecanismo
3. **Selección de víctima**: Se selecciona un proceso "migrable" (que no tenga restricciones como threads o shared memory)
4. **Migración preventiva**: El proceso se migra a un nodo con más memoria disponible
5. **Evaluación post-migración**: Se verifica que la condición de memoria haya mejorado

### 4.3 Relación con Conceptos de FSO

| Concepto FSO | Aplicación en Memory Ushering |
|--------------|-------------------------------|
| **Swapping (§2.4 — scheduler de medio plazo)** | Memory Ushering es una forma de "swapping distribuido": migra procesos completos entre nodos en lugar de páginas individuales |
| **Thrashing (§5.6)** | Memory Ushering busca **prevenir** thrashing antes de que ocurra, no reactivamente |
| **Working Set (§5.7)** | El daemon evalúa cuáles procesos tienen mayor "working set" para decidir cuáles migrar |

---

## 5. DFSA — Direct File System Access

### 5.1 Concepto

MOSIX no proporciona su propio sistema de archivos distribuido. En cambio, implementa **DFSA** (*Direct File System Access*), que permite que procesos migrados accedan archivos en **cualquier nodo del cluster** de forma transparente.

### 5.2 Cómo Funciona

Cuando un proceso migrado realiza una operación de archivo:

1. El proceso ejecuta `open()`, `read()`, `write()`, etc. en el nodo destino
2. El módulo kernel de MOSIX intercepta la syscall
3. Si el archivo reside en otro nodo, MOSIX redirige la operación al nodo correcto
4. El resultado se retorna al proceso como si la operación hubiera sido local

### 5.3 Relación con §1.7 y §1.8 (Interrupciones y Syscalls)

DFSA es análogo a una **interrupción software a nivel de cluster**:

| Concepto FSO | Aplicación en DFSA |
|--------------|---------------------|
| **Syscall (§1.8)** | El proceso hace syscall normalmente; MOSIX intercepta y redirige |
| **Interrupción software (§1.7)** | La syscall cruza límites de nodo de forma transparente |
| **Operaciones de E/S (§3)** | Acceso a archivos se abstrae a nivel de cluster, igual que acceso a dispositivos |

---

## 6. ARQUITECTURA DE CLUSTER SSI — DIAGRAMA EXPLICADO

```
┌─────────────────────────────────────────────────────┐
│                 USUARIO / APLICACIÓN                │
│    (ve un sistema único, no conoce los nodos)       │
└─────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────┐
│              CLUSTER MOSIX (SSI)                   │
│                                                     │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐   │
│  │ Nodo 1  │ │ Nodo 2  │ │ Nodo 3  │ │ Nodo 4  │   │
│  │(kernel) │ │(kernel) │ │(kernel) │ │(kernel) │   │
│  │(daemon) │ │(daemon) │ │(daemon) │ │(daemon) │   │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘   │
│                                                     │
│  Kernel module: intercepta syscalls de proceso      │
│  Daemon: coordina migración y balanceo de carga     │
└─────────────────────────────────────────────────────┘
```

**Flujo de una migración típica:**

1. Aplicación en nodo 1 ejecuta un programa → proceso criado
2. Daemon en nodo 1 detecta que otro nodo tiene menos carga
3. Kernel module en nodo 1 inicia preemption del proceso
4. Contexto CPU + memoria se transfieren a nodo 3
5. Proceso continúa ejecutando en nodo 3, transparentemente
6. Si el proceso hace syscall de archivo, DFSA redirige al nodo que tiene el archivo

---

## 7. GLOSARIO DE TÉRMINOS

| Término | Definición | Contexto |
|---------|------------|----------|
| **MOSIX** | *Multi-Operating System Intellect System* — Sistema operativo distribuido para clusters de Linux | Caso de estudio histórico de migración de procesos preemptiva |
| **SSI** | *Single System Image* — Abstracción que presenta un cluster como un único sistema | Concepto central de MOSIX; el usuario ve una sola máquina |
| **Process Migration** | Capacidad de mover un proceso en ejecución entre nodos de un cluster | Característica distintiva de MOSIX; preemptiva y transparente |
| **Kernel Module** | Módulo de kernel de Linux que extiende funcionalidad sin recompilar el kernel | Componente de MOSIX que intercepta syscalls |
| **Daemon** | Proceso en espacio de usuario que corre en segundo plano | En MOSIX: coordina descubrimiento de nodos, monitoreo de recursos, decisiones de migración |
| **Distributed OS** | Sistema operativo que gestiona múltiples máquinas como un sistema unificado | Categoría de MOSIX; diferente de SO de máquina única |
| **Cluster OS** | Sistema operativo diseñado para gestionar clusters de computadoras | Sinónimo de Distributed OS en contexto MOSIX |
| **Memory Ushering** | Mecanismo que migra proactivamente procesos antes de OOM | Extensión de swapping a nivel de cluster |
| **DFSA** | *Direct File System Access* — Acceso transparente a archivos en cualquier nodo | Sistema de archivos distribuido de MOSIX (no es un FS real, sino redirección de syscalls) |
| **Checkpoint/Restart** | Capacidad de salvar estado de proceso para recuperación posterior | Soportado por MOSIX para migración manual y fault tolerance |
| **Shared-Nothing** | Modelo de arquitectura donde cada nodo tiene memoria local, sin memoria compartida entre nodos | Modelo de MOSIX; simplifica diseño pero limita ciertos tipos de aplicaciones |
| **Load Balancing** | Distribución equitativa de carga de trabajo entre nodos | Función de MOSIX; evalúa CPU, memoria, IPC |

---

## 8. CONEXIONES CON EL TEMARIO FSO COMPLETO

### §1.3 — Programa vs Proceso y Multitarea

MOSIX extiende el concepto de **proceso** (§1.3) a un entorno distribuido:
- **Programa**: Código passivo almacenado en disco — sin cambios
- **Proceso**: Programa en ejecución con contexto de CPU completo — ahora puede migrar entre máquinas
- La migración preserva el contexto completo, entonces el proceso continúa ejecutando como si nunca se hubiera movido

### §1.4 — Arquitecturas de SO

MOSIX representa una arquitectura de **sistema distribuido** que corre sobre Linux:
- No es monolítico (funcionalidad dividida entre kernel module + daemon)
- No es microkernel (usa kernel Linux completo)
- Es una capa de middleware que extiende el kernel existente
- Análogo a máquinas virtuales (§1.4): ambos extienden la máquina física

### §2.1 — Necesidad del Scheduling

La necesidad del scheduling (§2.1) en sistemas de un solo CPU es:
- Mantener CPU ocupada mientras procesos esperan E/S
- Maximizar utilización, throughput, minimizar turnaround

MOSIX lleva esto al nivel de cluster:
- Mantener todos los nodos ocupados
- Balancear carga no solo entre CPUs de un nodo, sino entre nodos del cluster
- La migración de procesos es el mecanismo de "desalojo" a nivel cluster

### §2.4 — Tipos de Schedulers

| Scheduler FSO | Equivalente MOSIX |
|---------------|-------------------|
| **Largo plazo** (job admission) | Descubrimiento de nodos y aceptación inicial de procesos |
| **Medio plazo** (swapping) | Memory Ushering — migra procesos completos entre nodos |
| **Corto plazo** (CPU scheduling) | Decisión de migrar o no un proceso a otro nodo |

### §1.5 — Modo Dual

Los procesos migrados en MOSIX se ejecutan en un **entorno sandbox** en nodos destino:
- Aislamiento del sistema host
- Limitación de operaciones permitidas
- Analogía con modo usuario: procesos migrados tienen privilegios受限

### §1.7 — Interrupciones y §1.8 — Llamadas al Sistema

DFSA implementa interceptación de syscalls a nivel de cluster:
- Análogo a una interrupción software que cruza límites de máquina
- La syscall cruza nodos de forma transparente
- Aplications Linux estándar funcionan sin recompilación

---

## 9. LIMITACIONES Y CONTEXTO HISTÓRICO

### Limitaciones Técnicas

| Limitación | Impacto |
|------------|---------|
| **No soporta threads** | Aplicaciones con múltiples threads no pueden beneficiarse de migración |
| **Memoria compartida** | Procesos con `shm_open`/`mmap` compartidas no pueden migrar |
| **Software propietario** | No open source, sin comunidad ni desarrollo activo (desde 2017) |
| **No es HPC completo** | No替代 sistemas de archivos paralelos como Lustre o GPFS |

### Contexto Histórico

MOSIX fue **pionero en migración de procesos** pero fue superado por tecnologías modernas:
- **1998-2008**: Era Beowulf/MOSIX — clusters de PCs
- **2003+**: SLURM, PBS Professional — job schedulers especializados
- **2010s+**: Kubernetes, Docker — contenedores cambiaron el paradigma
- **2020s+**: K8s + Slurm hybrid — el mercado evolucionó

### Relevancia Pedagógica

MOSIX se estudia no por su vigencia, sino por ser un **caso de estudio clásico** de:
1. Migración preemptiva de procesos
2. Single System Image
3. Balanceo de carga distribuido
4. Evolución histórica de sistemas distribuidos

---

## FUENTES

- Wikipedia — MOSIX: https://en.wikipedia.org/wiki/MOSIX
- History of MOSIX: https://mosix.cs.huji.ac.il/txt_history.html
- MOSIX Official Site: http://www.mosix.org/
- MOSIX FAQ: http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html
- MOSIX Administrator's Guide: http://www.mosix.cs.huji.ac.il/pub/Guide.pdf
- MOSIX White Paper: https://mosix.cs.huji.ac.il/pub/MOSIX_wp.pdf
- The MOSIX Algorithms for Managing Cluster (TU Dresden): https://os.inf.tu-dresden.de/Studium/DOS/SS2014/03-MOSIX.pdf
- The MOSIX Direct File System Access Method — Springer: https://link.springer.com/article/10.1023/B:CLUS.0000018563.68085.4b

---

*Documento creado para Fundamentos de Sistemas Operativos — Mayo 2026*
*Autor: Agente SDD — Basado en investigación de MOSIX*
