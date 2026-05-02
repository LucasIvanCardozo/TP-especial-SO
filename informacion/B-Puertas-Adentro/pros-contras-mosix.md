# MOSIX: Puntos Fuertes y Débiles — Análisis Comparativo

> **Documento autónomo** — Todo concepto técnico se explica desde cero. Fuentes al final de cada sección.

---

## 1. Fortalezas de MOSIX

| Fortaleza | Explicación detallada |
|-----------|----------------------|
| **Single System Image (SSI)** | El cluster se presenta como un **único sistema lógico**. El usuario no necesita especificar en qué nodo se ejecuta su proceso. El sistema decide dinámicamente dónde correr cada proceso según la carga. |
| **Migración preemptiva automática de procesos** | MOSIX puede **migrar procesos en ejecución** (preemptive) sin que la aplicación lo sepa. Si un nodo se satura, el proceso se mueve a otro nodo con más recursos disponibles. No requiere reprogramación de la aplicación. |
| **No requiere modificación de código** | Las aplicaciones Linux estándar funcionan **sin recompilación ni linkedición**. Cualquier executable Linux es compatible. No se necesitan librerías especiales ni APIs propietarias. |
| **Migración transparente de procesos** | Un proceso iniciado en el nodo A puede ejecutarse parcialmente en el nodo B, luego volver al A, sin intervención del usuario. El proceso "cree" que está corriendo en su nodo original. |
| **Balanceo de carga dinámico** | El sistema monitorea CPU, memoria y carga de cada nodo y **redistribuye procesos automáticamente**. Nodos más rápidos reciben más trabajo. Nodos lentos reciben menos carga. |
| **Gestión de multiclusters y grids** | MOSIX puede administrar **varios clusters como una unidad** (multicluster). Cada cluster mantiene autonomía administrativa pero comparte recursos cuando es necesario. |
| **Soporte de checkpoint/restart** | Los procesos pueden guardar su estado (checkpoint) para **recuperarse** si el nodo falla o se desconecta. Ideal para procesos largos que necesitan resiliencia. |
| **Sandbox para procesos guest** | Los procesos migrados a nodos no confiables se ejecutan en un **entorno aislado** que protege tanto al nodo host como al proceso guest de modificaciones no autorizadas. |
| **Memory Ushering (monitoreo de memoria)** | Detecta nodos con **memoria escasa** y migra proactivamente procesos antes de que ocurra un "out of memory". Optimiza el uso de memoria distribuida. |
| **Sin costo de licencia para uso no comercial** | Según publicaciones de la comunidad, MOSIX permite uso sin tarifa de licencia para fines **no comerciales** [Facebook Group - GNU/Linux 2022](https://www.facebook.com/groups/GNUAndLinux/posts/10167823624740019/). |

---

## 2. Debilidades de MOSIX

| Debilidad | Explicación detallada |
|-----------|----------------------|
| **Software propietario** | La licencia **prohíbe modificar, hacer ingeniería reversa o crear obras derivadas** del software. Contrasta con alternativas open source que permiten auditoría y contribución. [MOSIX Distributions License](https://mosix.cs.huji.ac.il/txt_distributions.html) |
| **Proyecto inactivo desde 2017** | Última versión (MOSIX-4.4.4) released el **24 de octubre de 2017** — hace más de **8 años**. Sin parches de seguridad, sin compatibilidad con kernels modernos. [MOSIX Changelog](https://mosix.cs.huji.ac.il/txt_changelog.html) |
| **Sin soporte comercial disponible** | No existe empresa ni servicio de soporte técnico oficial. La única vía es contactar a los desarrolladores académicos por email. |
| **No soporta memoria compartida** | El modelo "shared-nothing" significa que **procesos no pueden compartir memoria** directamente. Aplicaciones que requieren Shared Memory o DSM (Distributed Shared Memory) no son compatibles de forma nativa. [TU Dresden - MOSIX Algorithms PDF](https://os.inf.tu-dresden.de/Studium/DOS/SS2014/03-MOSIX.pdf) |
| **No soporta aplicaciones con threads** | Threads (hilos) de un proceso **no pueden migrar** correctamente según la documentación oficial. Esto excluye aplicaciones multithreaded modernas. [MOSIX FAQ - Pregunta 42](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html) |
| **Sistema de archivos limitado** | DFSA (Direct File System Access) no es un sistema de archivos distribuido real. No proporciona paralelismo de E/S como PVFS o Lustre. La documentación advierte que **alta E/S puede ser un cuello de botella**. [ResearchGate - MOSIX DFSA Paper](https://www.researchgate.net/publication/220406183_The_MOSIX_Direct_File_System_Access_Method_for_Supporting_Scalable_Cluster_File_Systems) |
| **Documentación técnica limitada** | Comparado con proyectos open source (SLURM, Kubernetes), la documentación de MOSIX es escasa y está dispersa en PDFs, FAQs y white papers. |
| **Depreciado por tecnologías modernas** | El paradigma de "migración de procesos a nivel kernel" fue superado por **contenedores (Docker)** y **orquestadores (Kubernetes)** que ofrecen mejor aislamiento, portabilidad y escalabilidad. |
| **Dependencia de nodos confiables** | El FAQ indica que **todos los nodos remotos deben ser confiables** — no puede haber nodos hostiles en la red. Limitación importante para entornos no confiable. [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html) |
| **Escalabilidad no probada en entornos modernos** | Si bien soporta "cientos de nodos", no hay evidencia de uso en clusters de miles de nodos como los que manejan SLURM o Kubernetes actualmente. |

---

## 3. Comparativa vs SLURM

### En qué gana MOSIX sobre SLURM

| Aspecto | Ventaja MOSIX |
|---------|--------------|
| **Migración live de procesos** | MOSIX puede migrar un proceso **en ejecución** sin reiniciarlo. SLURM solo puede re-schedule jobs completos cuando terminan o se cancelan. |
| **Single System Image completo** | MOSIX presenta el cluster como **un solo sistema** con una vista unificada de recursos. SLURM es solo un scheduler — no proporciona SSI. |
| **Transparencia para aplicaciones** | En MOSIX, las aplicaciones no necesitan saber que están en un cluster. En SLURM, el usuario debe especificar recursos, queue, tiempo máximo, etc. |
| **Sin intervención del usuario** | El balanceo de carga en MOSIX es **completamente automático**. SLURM requiere que el usuario solicite recursos explícitamente. |

### En qué pierde MOSIX contra SLURM

| Aspecto | Desventaja MOSIX |
|---------|-----------------|
| **Estado del proyecto** | SLURM está **activo** con actualizaciones frecuentes. MOSIX lleva 8+ años sin updates. [Slurm Official Site](https://slurm.schedmd.com/) |
| **Adopción en HPC** | SLURM se usa en más del **60% de las Top500 supercomputadoras** del mundo. MOSIX tiene 0% en榜单 modernas. [Top500.org](https://www.top500.org/) |
| **Soporte comercial** | SchedMD ofrece soporte comercial para SLURM. MOSIX no tiene soporte formal. |
| **Escalabilidad comprobada** | SLURM escala a miles de nodos con soporte verificado en producción. MOSIX no tiene datos de escalabilidad moderna. |
| **Memoria compartida** | SLURM puede coordinar aplicaciones que usan память compartida dentro de nodos (via OpenMPI). MOSIX no soporta esto. |
| ** Ecosistema moderno** | SLURM se integra con MPI, GPUs, containers, y herramientas de monitoreo modernas. MOSIX no tiene ecosistema activo. |
| **Licencia** | SLURM es **GPL** (open source). MOSIX es propietario con restricciones. |

### Resumen

| Criterio | MOSIX | SLURM |
|----------|-------|-------|
| Migración live | ✅ Sí | ❌ No |
| Single System Image | ✅ Sí | ❌ No |
| Estado activo | ❌ No | ✅ Sí |
| Soporte comercial | ❌ No | ✅ SchedMD |
| Adopción HPC Top500 | ❌ 0% | ✅ >60% |
| Memoria compartida | ❌ No | ✅ Sí (via MPI) |

**Veredicto:** SLURM es la opción **estándar de facto** para HPC moderno. MOSIX tiene ventajas conceptuales (migración, SSI) pero está obsoleto en la práctica.

---

## 4. Comparativa vs Kubernetes

### En qué gana MOSIX sobre Kubernetes

| Aspecto | Ventaja MOSIX |
|---------|--------------|
| **Migración a nivel de proceso** | MOSIX migra procesos individuales (con su estado completo). Kubernetes migra **containers completos** (más pesado). |
| **Single System Image real** | MOSIX presenta un cluster como **un solo computador** con visión unificada de CPU, memoria y procesos. Kubernetes tiene vistas parciales (cada pod es independiente). |
| **Simplicidad conceptual** | MOSIX no requiere aprender Docker, Helm, Operators, YAML, etc. El modelo de "migración automática" es conceptualmente más simple. |
| **Sin contenedores** | No requiere dockerizar aplicaciones. Ejecuta binarios Linux nativos directamente. |

### En qué pierde MOSIX contra Kubernetes

| Aspecto | Desventaja MOSIX |
|---------|------------------|
| **Ecosistema y comunidad** | Kubernetes tiene la **comunidad más grande** del mundo cloud-native (CNCF). MOSIX tiene documentación académica limitada. [Kubernetes Official](https://kubernetes.io/) |
| **Portabilidad** | Containers son **portables** entre entornos. MOSIX requiere el mismo kernel/arquitectura en todos los nodos. |
| **Aislamiento** | Kubernetes aísla aplicaciones en containers con namespaces Linux. MOSIX aísla procesos pero con menos capas de protección. |
| **Stateful workloads** | Kubernetes tiene PersistentVolumes, StatefulSets, CSI para storage. MOSIX tiene limitaciones de E/S documentadas. |
| **Orquestación avanzada** | Kubernetes ofrece auto-scaling, rolling updates, service mesh, ingress, RBAC. MOSIX solo tiene migración y balanceo. |
| **Adopción cloud** | Kubernetes es el estándar en **cloud público, edge computing, y microservicios**. MOSIX no tiene presencia en ningún cloud moderno. |
| **Herramientas de monitoreo** | Kubernetes tiene Prometheus, Grafana, K9s, y cientos de herramientas de observabilidad. MOSIX tiene monitores limitados. |

### Comparativa técnica

| Criterio | MOSIX | Kubernetes |
|----------|-------|------------|
| Abstracción | Nivel SO (procesos) | Nivel contenedor |
| Migración live | ✅ Sí (procesos) | ❌ Limitada (no live migration de pods) |
| Single System Image | ✅ Sí | ❌ Parcial |
| Aislamiento | Sandbox (procesos) | Containers con namespaces/cgroups |
| Storage | Limitado (DFSA) | PVC, CSI, volúmenes distribuidos |
| Estado activo | ❌ Inactivo (2017) | ✅ Muy activo |
| Comunidad | Academia (limitada) | CNCF (masiva) |
| Curva de aprendizaje | Media | Alta |

**Veredicto:** Kubernetes dominó el mercado de orquestación moderna. MOSIX es académicamente interesante pero no es competitivo en entornos cloud-native o de producción moderna.

---

## 5. Comparativa vs OpenMPI

> **Nota importante:** OpenMPI y MOSIX resuelven **problemas diferentes**. OpenMPI es una librería de comunicación para cómputo paralelo. MOSIX es un sistema de gestión de clusters. La comparación es conceptual.

### En qué gana MOSIX sobre OpenMPI

| Aspecto | Ventaja MOSIX |
|---------|--------------|
| **Transparencia de ubicación** | En MOSIX, el usuario no sabe (ni necesita saber) dónde corre su proceso. OpenMPI requiere que el usuario/config determine el mapping de procesos. |
| **Balanceo automático** | MOSIX redistribuye carga dinámicamente. OpenMPI tiene rank ordering pero no balanceo automático de procesos ya asignados. |
| **No requiere código especial** | OpenMPI requiere que las aplicaciones usen funciones MPI (`MPI_Send`, `MPI_Recv`, etc.). MOSIX no requiere cambios al código. |
| **Migración post-inicio** | Un proceso MOSIX puede migrar después de iniciado. En OpenMPI, los ranks están fijos desde el `MPI_Comm_spawn`. |

### En qué pierde MOSIX contra OpenMPI

| Aspecto | Desventaja MOSIX |
|---------|------------------|
| **Comunicación inter-procesos** | OpenMPI está **diseñado específicamente** para comunicación eficiente entre procesos paralelos (message passing). MOSIX no tiene un equivalente a MPI. |
| **Rendimiento en cómputo paralelo** | OpenMPI es el **estándar de facto** para HPC paralelo con implementaciones optimizadas para InfiniBand, OmniPath, RDMA. |
| **Memoria compartida distribuida** | OpenMPI puede usar память compartida dentro de nodos. MOSIX no puede compartir память entre procesos. |
| **Adopción en HPC** | OpenMPI se usa en **prácticamente todos** los clusters HPC modernos. MOSIX tiene presencia histórica cero en HPC actual. [OpenMPI Official](https://www.open-mpi.org/) |
| **Estandarización** | MPI es un **estándar internacional** (MPI Forum). OpenMPI es una implementación de ese estándar. MOSIX no tiene estandarización. |

### Resumen

| Criterio | MOSIX | OpenMPI |
|----------|-------|---------|
| Propósito | Gestión de cluster | Comunicación paralela |
| Modelo de código | Ningún cambio | Requiere API MPI |
| Migración dinámica | ✅ Sí | ❌ No |
| Balanceo automático | ✅ Sí | ❌ Limitado |
| Memoria compartida | ❌ No | ✅ Sí (intra-nodo) |
| Adopción HPC | ❌ Ninguna actual | ✅ Universal |

**Veredicto:** Son soluciones complementarias, no substitutos. OpenMPI maneja comunicación paralela. MOSIX maneja migración de procesos. En HPC real, SLURM + OpenMPI es la combinación estándar.

---

## 6. Comparativa vs PBS Professional

### En qué gana MOSIX sobre PBS Pro

| Aspecto | Ventaja MOSIX |
|---------|--------------|
| **Migración live** | MOSIX puede migrar procesos en ejecución. PBS Pro, como scheduler de jobs, solo puede manejar jobs cuando están en queue o terminados. |
| **Single System Image** | MOSIX presenta un solo sistema. PBS Pro también es solo un scheduler — los usuarios ven nodos individuales, no un sistema unificado. |
| **Costo de licencia** | PBS Pro es **comercial** (Altair). El licenciamiento tiene costo significativo. MOSIX, aunque propietario, históricamente permitió uso sin tarifa para no comerciales. |
| **Transparencia para el usuario** | En MOSIX, el usuario ejecuta `mosrun ./programa` y el sistema decide dónde va. PBS Pro requiere definir scripts de job con recursos, queue, tiempos. |

### En qué pierde MOSIX contra PBS Pro

| Aspecto | Desventaja MOSIX |
|---------|------------------|
| **Soporte comercial** | PBS Pro tiene **soporte oficial de Altair** con actualizaciones, patches y servicio técnico. MOSIX no tiene soporte. |
| **Estado del proyecto** | PBS Pro está **activo y en desarrollo** continuo. MOSIX está abandonado. [Altair PBS Professional](https://www.altair.com/pbs-professional/) |
| **Features empresariales** | PBS Pro ofrece advance reservation, fairshare, dependencias de jobs, arrays de jobs, integración con schedulers de terceros. MOSIX tiene funcionalidades más básicas. |
| **Adopción** | PBS Pro se usa en **instituciones académicas y empresas** que quieren soporte comercial sin SLURM. MOSIX no tiene adopción actual. |
| **Escalabilidad probada** | PBS Pro tiene casos de uso en clusters grandes. La documentación de escalabilidad de MOSIX es limitada. |

### Comparativa técnica

| Criterio | MOSIX | PBS Pro |
|----------|-------|---------|
| Tipo | Cluster OS (SSI) | Job scheduler |
| Migración live | ✅ Sí | ❌ No |
| Single System Image | ✅ Sí | ❌ No |
| Soporte comercial | ❌ No | ✅ Altair |
| Estado | Inactivo (2017) | ✅ Activo |
| Costo licencia | ⚠️ Histórico sin cargo (no verificado) | ✅ Comercial |
| Features avanzadas | ❌ Limitadas | ✅ Completas |

**Veredicto:** PBS Pro es una alternativa comercial sólida a SLURM, con soporte activo. MOSIX tiene el concepto de SSI que ni SLURM ni PBS ofrecen, pero está completamente abandonado.

---

## 7. Por qué MOSIX está en un TP de Fundamentos de Sistemas Operativos

### Contexto pedagógico

MOSIX se asigna en cursos de Sistemas Operativos por razones **históricas y conceptuales**, no porque sea tecnología vigente para usar en producción:

#### 7.1 Pionero en migración de procesos

MOSIX fue el **primer sistema operativo** en demostrar migración preemptiva funcional de procesos en un cluster Linux (1999). Este concepto es fundamental para entender cómo los sistemas distribuidos puedenbalancear carga dinámicamente.

> "El paper de 1998 sobre MOSIX fue citado 488 veces en la academia" — ScienceDirect [citado en investigación original]

#### 7.2 Single System Image (SSI)

El concepto de que un cluster de computadoras pueda presentarse como **un único sistema operativo** con una vista unificada de recursos es relevante hasta hoy:

- **Cloud computing moderno**: La ilusión de recursos infinitos proviene de estos conceptos
- **Containers y Kubernetes**: El Service Discovery y load balancing son descendientes conceptuales del SSI
- **Edge computing**: Agregar nodos sin cambiar aplicaciones

#### 7.3 Algoritmos clásicos de balanceo de carga

Los algoritmos de **Memory Ushering** y balanceo de carga de MOSIX son ejemplos clásicos que se enseñan en cursos de sistemas distribuidos:

- ¿Cómo detectar que un nodo está saturado?
- ¿Cuándo migrar un proceso?
- ¿Qué métricas usar (CPU, memoria, velocidad de red)?

#### 7.4 Evidencia de evolución tecnológica

Estudiar MOSIX ayuda a responder: **¿Por qué evolucionó la tecnología de clusters hacia contenedores y schedulers?**

| Período | Tecnología | Enfoque |
|---------|-----------|---------|
| 1990s-2000s | Beowulf, MOSIX | Clusters de PCs, migración de procesos a nivel kernel |
| 2003+ | SLURM, PBS | Job scheduling profesional, re-scheduling en lugar de migración |
| 2010s+ | Kubernetes, Docker | Contenedores, microservices, orquestación |
| 2020s+ | K8s + Slurm hybrid | HPC cloud-native, contenedores en supercomputadoras |

#### 7.5 Comparación instructiva

MOSIX permite comparar:
- **Modelo de procesos vs contenedores**: Migración a nivel kernel vs aislamiento a nivel OS
- **SSI completo vs scheduler parcial**: Un sistema operativo distribuido vs un administrador de jobs
- **Código abierto vs propietario**: La diferencia en evolución cuando la comunidad puede contribuir

#### 7.6 Referencias académicas para el TP

- [Teaching Parallel and Distributed Computing - TCPP Curriculum](https://tcpp.cs.gsu.edu/curriculum/sites/default/files/Teaching%20Parallel%20and%20Distributed%20Computing%20Using%20a%20Cluster%20Computing%20Portal.pdf)
- [Cluster Computing in the Classroom - IEEE](https://clouds.cis.unimelb.edu.au/papers/cc-ieeeedu.pdf)
- [Scalable Cluster Computing with MOSIX for LINUX - VT University](https://courses.cs.vt.edu/~cs5204/fall05-kafura/Papers/Migration/mosix.pdf)

---

## 8. Evolución Histórica: MOSIX → SLURM → Kubernetes

### Línea temporal

```
1977-1979: MOS (Version 0)
  ├── PDP-11 + Unix v6
  ├── Primer proyecto de migración de procesos
  └── Demostró ganancias aún con enlaces lentos

1981-1983: MOS (Version 1)
  ├── Primer sistema multicomputadora funcional
  └── Unix v7 en PDP-11s

1988-1989: MOSIX (primer sistema con ese nombre)
  ├── NS32532 cluster de 16 nodos
  └── Origen del nombre actual

1991-1993: MOSIX v6
  ├── BSD/OS cluster de 8 equipos 486 + 32 Pentium
  └── Con Myrinet (red de alta velocidad)

1998-1999: MOSIX v7 (Linux)
  ├── Primera versión para Linux
  ├── Cluster de 64 nodos x86 con Myrinet
  └── Mayor difusión académica

2001: openMosix fork (Moshe Bar)
  ├── Bifurcación cuando MOSIX se volvió propietario
  ├── Código abierto hasta 2008
  └── LinuxPMI continuó desarrollo

2014: MOSIX-4
  └── Ya no requiere parche de kernel

2017: MOSIX-4.4.4 (último release)
  └── Proyecto esencialmente abandonado
```

### Evolución del paradigma

```
┌─────────────────────────────────────────────────────────────────────┐
│                    EVOLUCIÓN DE CLUSTER COMPUTING                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  MOSIX (1999-2017)              SLURM (2003-presente)              │
│  ┌─────────────────┐            ┌─────────────────────┐            │
│  │ Single System    │            │ Job Scheduler       │            │
│  │ Image completo  │            │ + Resource Manager │            │
│  │                 │            │                     │            │
│  │ Migración de    │            │ Jobs re-scheduled   │            │
│  │ procesos live   │            │ cuando terminan    │            │
│  │                 │    ────>   │                     │            │
│  │ Balanceo auto   │            │ Fairshare, queues  │            │
│  │ a nivel kernel  │            │ a nivel job        │            │
│  └─────────────────┘            └─────────────────────┘            │
│         │                              │                           │
│         ▼                              ▼                           │
│  Propietario (2017+)           GPL (SchedMD + comunidad)            │
│  Sin desarrollo                Dominio en Top500 (>60%)            │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Kubernetes (2014-presente)                                         │
│  ┌───────────────────────────────────────┐                         │
│  │ Container Orchestration               │                         │
│  │                                       │                         │
│  │ Containers (Docker)                    │                         │
│  │ Pods → Deployments → Services         │                         │
│  │                                       │                         │
│  │ Service mesh, ingress, RBAC           │                         │
│  │ CSI para storage, CNI para red        │                         │
│  └───────────────────────────────────────┘                         │
│         ▲                                                           │
│         │                                                           │
│  Contenedores reemplazaron migración de procesos como              │
│  la abstracción dominante para distribuir cargas de trabajo        │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Comparación de épocas

| Aspecto | Era MOSIX (1999-2010) | Era SLURM (2003-presente) | Era Kubernetes (2014-presente) |
|---------|------------------------|---------------------------|-------------------------------|
| **Abstracción** | Proceso (a nivel kernel) | Job (a nivel scheduler) | Contenedor (a nivel aplicación) |
| **Migración** | Live (preemptive) | Re-scheduling (al terminar job) | Voluntaria (pod redespliegue) |
| **Aislamiento** | Sandbox (proceso) | Nodo (job) | Container (namespace) |
| **Red** | MPI tradicional | MPI + redes RDMA | Service mesh (Istio) |
| **Storage** | NFS/DFSA | GPFS, Lustre | CSI (Persistent Volumes) |
| **Escalabilidad** | Cientos de nodos | Miles de nodos | Miles de pods |
| **Modelo** | Single System Image | Resource Manager + Scheduler | Orchestrator + Control plane |
| **Licencia típica** | Propietaria | GPL | Apache 2.0 |

### Por qué cambió el paradigma

1. **Migración de procesos es pesada**: Migrar un proceso con su contexto de memoria consume red y tiempo. Migrar un contenedor con su filesystem es más eficiente.

2. **El kernel Linux evolucionó**: Las features de containers (cgroups, namespaces) hicieron innecesario parchear el kernel para aislar cargas de trabajo.

3. **Comunidad open source**: SLURM tiene cientos de contribuidores. Kubernetes tiene miles. MOSIX tiene un equipo académico pequeño.

4. **Cloud native**: Las aplicaciones modernas se construyen como microservicios en containers. El modelo de "proceso Linux corriendo en cualquier nodo" no escala a arquitecturas de microservicios.

5. **Portabilidad**: Un container corre en cualquier cluster Kubernetes. Un proceso MOSIX requiere nodos con kernel compatible y MOSIX instalado.

---

## 9. Tabla Comparativa Resumen

| Criterio | MOSIX | SLURM | Kubernetes | OpenMPI | PBS Pro |
|----------|:-----:|:-----:|:----------:|:-------:|:-------:|
| **Migración live** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Single System Image** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Licencia open source** | ❌ | ✅ | ✅ | ✅ | ❌ |
| **Estado activo (2026)** | ❌ | ✅ | ✅ | ✅ | ✅ |
| **Soporte comercial** | ❌ | ✅ | ✅ | ❌ | ✅ |
| **Adopción HPC Top500** | ❌ | ✅ >60% | ▲ Creciente | ✅ | ▲ |
| **Memoria compartida** | ❌ | ✅ | ✅ | ✅ | ✅ |
| **Threads soportados** | ❌ | ✅ | ✅ | ✅ | ✅ |
| **Checkpoint/Restart** | ✅ | ✅ | ✅ (CRI) | ✅ (CRIU) | ✅ |
| **Para educación/conceptos** | ✅ | ⚠️ | ❌ | ❌ | ❌ |
| **Para producción HPC** | ❌ | ✅ | ⚠️ | ✅ | ✅ |
| **Curva de aprendizaje** | Media | Media-Alta | Alta | Alta | Alta |

---

## 10. Conclusión

**MOSIX es históricamente significativo pero técnicamente obsoleto para uso en producción.**

### Cuándo es útil MOSIX

- ✅ **Contexto académico/educativo**: Entender migración de procesos y SSI
- ✅ **Historia de sistemas distribuidos**: Comprender la evolución hacia containers
- ✅ **Comparar paradigmas**: Proceso vs job vs contenedor

### Cuándo NO usar MOSIX

- ❌ **Producción HPC moderna**: Usar SLURM + OpenMPI
- ❌ **Cloud-native / microservicios**: Usar Kubernetes
- ❌ **Aplicaciones con threads o memoria compartida**: No es compatible
- ❌ **Proyectos nuevos**: No hay soporte ni comunidad

### Resumen ejecutivo

| Si necesitás... | Usá... |
|----------------|--------|
| Job scheduling HPC clásico | **SLURM** |
| Orquestación cloud-native | **Kubernetes** |
| Comunicación MPI paralela | **OpenMPI** |
| Soporte empresarial comercial | **PBS Pro (Altair)** |
| Estudiar migración de procesos (históricamente) | **MOSIX** (contexto educativo) |

---

## Fuentes

1. [History of MOSIX - Hebrew University](https://mosix.cs.huji.ac.il/txt_history.html)
2. [MOSIX Distributions & License](https://mosix.cs.huji.ac.il/txt_distributions.html)
3. [MOSIX Changelog - Last update 2017](https://mosix.cs.huji.ac.il/txt_changelog.html)
4. [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)
5. [Wikipedia - MOSIX](https://en.wikipedia.org/wiki/MOSIX)
6. [Wikipedia - OpenMosix](https://en.wikipedia.org/wiki/OpenMosix)
7. [TU Dresden - MOSIX Algorithms PDF](https://os.inf.tu-dresden.de/Studium/DOS/SS2014/03-MOSIX.pdf)
8. [MOSIX DFSA Paper - Springer](https://link.springer.com/article/10.1023/B:CLUS.0000018563.68085.4b)
9. [Slurm Workload Manager](https://slurm.schedmd.com/)
10. [Top500 - Slurm adoption](https://www.top500.org/)
11. [Kubernetes Official Documentation](https://kubernetes.io/)
12. [OpenMPI Official Site](https://www.open-mpi.org/)
13. [PBS Professional - Altair](https://www.altair.com/pbs-professional/)
14. [Teaching Parallel and Distributed Computing - TCPP Curriculum](https://tcpp.cs.gsu.edu/curriculum/sites/default/files/Teaching%20Parallel%20and%20Distributed%20Computing%20Using%20a%20Cluster%20Computing%20Portal.pdf)
15. [Cluster Computing in the Classroom - IEEE](https://clouds.cis.unimelb.edu.au/papers/cc-ieeeedu.pdf)
16. [Facebook Group - Best distro for cluster computing 2022](https://www.facebook.com/groups/GNUAndLinux/posts/10167823624740019/) (referencia comunidad no oficial)

---

## Nota Académica — Fundamentos de SO

**Conceptos de la materia relacionados:**

- **§1.1 — Objetivos de un SO (máquina extendida vs gestor de recursos)**: MOSIX implementa un Single System Image (SSI) completo, presentándose como **máquina extendida** — el cluster se oculta detrás de la abstracción de un único sistema. Decisión de diseño: transparencia total vs control explícito. SLURM es más bien un "gestor de recursos" donde el usuario especifica qué necesita. Esta dualidad ilustra los dos extremos del espectro.

- **§2.5 — Algoritmos de scheduling**: MOSIX usa **balanceo de carga dinámico** con métricas de CPU y memoria. Su algoritmo de Memory Ushering decide proactivamente cuándo migrar un proceso antes de OOM. Esto es un scheduler distribuido con decisiones en cada nodo. Trade-off: migración overhead vs mejora de rendimiento. Comparado con schedulers centralizados (SLURM), muestra alternativas arquitectónicas.

- **§5.3 — Algoritmos de reemplazo de páginas**: El concepto de Memory Ushering en MOSIX anticipa kekurangan de memoria y migra procesos **antes** de que ocurra page fault. Analogico a un "OPT anticipado" — no espera el fault, predice. Esto contrasta con estrategias reactivas (FIFO, LRU) vistas en clase.

- **§3.6 — Métodos de asignación de espacio (shared-nothing)**: MOSIX no soporta memoria compartida entre nodos. Su modelo "shared-nothing" es similar a sistemas distribuídos sin DSM. Trade-off: simplifica el diseño del sistema (no coherencia de caché) pero limita aplicaciones que necesitan shared memory. Comparar con arquitecturas NUMA donde memoria está físicamente distribuida pero lógicamente compartida.

- **§1.4 — Arquitectura de SO**: MOSIX fue un intento de crear un SO distribuido a nivel kernel — la migración de procesos livedentro del kernel Linux (requería parches). Esto es análogo a un microkernel donde servicios viven en espacios de usuario, pero MOSIX llevó la migración al nivel más bajo. La evolución hacia contenedores (Kubernetes) muestra cómo la comunidad prefirió aislamiento a nivel aplicación (containers) sobre modificación del kernel.

*Documento creado para Fundamentos de Sistemas Operativos — Universidad — Mayo 2026*
*Basado en investigación de TPs/TP_Especial_Zephyr_MOSIX/MOSIX/investigacion.md*