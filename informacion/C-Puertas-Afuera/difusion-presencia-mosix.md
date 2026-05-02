# Difusión y Presencia en el Mundo — MOSIX

> **Nota sobre fuentes:** Este documento se basa en información extraída del sitio oficial de MOSIX (mosix.org, mosix.cs.huji.ac.il), Wikipedia, papers académicos, documentación técnica y búsquedas web complementarias. Dado que MOSIX es un proyecto de investigación propietario con documentación limitada en línea, algunos detalles técnicos internos no están públicamente disponibles y se indica explícitamente cuando es el caso.

---

## 1. Adopción Histórica

### 1.1 Ámbito Académico y de Investigación

MOSIX tuvo su mayor difusión en el **ámbito académico y de investigación** durante las décadas de 1990 y 2000, nunca alcanzando adopción comercial significativa.

**Período de mayor uso:**
- 1999–2010: pico de adopción en universidades y centros de investigación
- Clusters beacons en universidades de Estados Unidos, Europa e Israel

**Tipo de instituciones que lo adoptaron:**
- **Universidades con departamentos de computación de alto rendimiento (HPC)**
- **Centros de investigación gubernamentales**
- **Laboratorios científicos** que requerían cómputo paralelo sin inversión en supercomputadoras comerciales

**Fuente:** [Wikipedia: MOSIX](https://en.wikipedia.org/wiki/MOSIX), [MOSIX Official Site](http://www.mosix.org/)

---

## 2. Uso en Universidades e Instituciones de Investigación

### 2.1 Hebrew University of Jerusalem (origen)

El proyecto fue desarrollado y mantenido por el **Grupo de Investigación en Sistemas Distribuidos** de la Hebrew University of Jerusalem, Israel, bajo el liderazgo del **Prof. Amnon Barak**.

La universidad utilizó MOSIX en su propio cluster de investigación:
- En 1997, el cluster escalable de la Hebrew University constaba de **88 servidores Pentium II y Pentium-Pro** conectados mediante fast Ethernet y Myrinet LANs [[1]](https://www.sciencedirect.com/science/article/abs/pii/S0167739X9700037X)
- El sistema MOSIX fue utilizado internamente para investigación en bioinformática, particularmente en el proyecto **ProtoNet** de clasificación jerárquica de proteínas [[2]](https://www.cs.huji.ac.il/~nati/PAPERS/everest.pdf)

### 2.2 Otras Instituciones Documentadas

**Columbia University:** Publicó el paper "Scalable Cluster Computing with MOSIX for LINUX" (1999) que describía la tecnología y sus aplicaciones [[3]](http://www.cs.columbia.edu/~orenl/papers/mosix4linux.pdf)

**Virginia Tech:** Utilizó MOSIX como caso de estudio en cursos de computación paralela y distribuida, publicando material educativo sobre migración de procesos [[4]](https://courses.cs.vt.edu/~cs5204/fall05-kafura/Papers/Migration/mosix.pdf)

**Technische Universität Dresden:** Documentó los algoritmos de MOSIX para gestión de clusters, multi-clusters y GPUs en material de estudio [[5]](https://os.inf.tu-dresden.de/Studium/DOS/SS2014/03-MOSIX.pdf)

### 2.3 Investigación en Parallel I/O

Un paper de 2015 documentó el uso de MOSIX en un sistema de E/S paralela escalable, mencionando que el cluster "se disfraza de laboratorio de computación durante el día, pero se transforma en una alta capacidad de cómputo durante la noche" [[6]](https://www.researchgate.net/publication/221569075_The_MOSIX_Parallel_IO_System_for_Scalable_IO_Performance)

---

## 3. Casos de Uso Mencionados en Papers

### 3.1 Aplicaciones Científicas

| Campo | Aplicación específica | Referencia |
|-------|---------------------|------------|
| **Genómica** | Secuenciación y análisis de proteínas | [[2]](https://www.cs.huji.ac.il/~nati/PAPERS/everest.pdf) |
| **Bioinformática** | Clasificación jerárquica de proteínas (ProtoNet) | [[2]](https://www.cs.huji.ac.il/~nati/PAPERS/everest.pdf) |
| **Dinámica molecular** | Simulaciones moleculares | Investigación general [[1]](https://www.sciencedirect.com/science/article/abs/pii/S0167739X9700037X) |
| **Nanotecnología** | Simulaciones a escala nanométrica | Investigación general [[1]](https://www.sciencedirect.com/science/article/abs/pii/S0167739X9700037X) |

### 3.2 Aplicaciones de Ingeniería

| Campo | Aplicación específica | Referencia |
|-------|---------------------|------------|
| **CFD (Computational Fluid Dynamics)** | Simulación de fluidos | [[1]](https://www.sciencedirect.com/science/article/abs/pii/S0167739X9700037X) |
| **Predicción meteorológica** | Modelado climático | [[1]](https://www.sciencedirect.com/science/article/abs/pii/S0167739X9700037X) |
| **Simulaciones de crash** | Pruebas de impacto automotriz | [[1]](https://www.sciencedirect.com/science/article/abs/pii/S0167739X9700037X) |
| **Diseño de ASICs** | Diseño de circuitos integrados | [[1]](https://www.sciencedirect.com/science/article/abs/pii/S0167739X9700037X) |
| **Elementos finitos asincrónicos** | Métodos numéricos para ingeniería | [[7]](https://cris.huji.ac.il/en/publications/asynchronous-parallel-discontinuous-finite-element-method/) |
| **Clustering jerárquico bioinformático** | Algoritmos de agrupamiento para análisis de datos | [[8]](https://academic.oup.com/bioinformatics/article/24/13/i41/234385) |

### 3.3 Industria Farmacéutica

MOSIX fue mencionado como adecuado para aplicaciones de la industria farmacéutica, aunque **no se encontraron casos de uso específicos documentados públicamente** — solo menciones generales en documentación y white papers.

### 3.4 Contexto Educativo

MOSIX fue utilizado como herramienta pedagógica en cursos de sistemas distribuidos. Papers como "Teaching Parallel and Distributed Computing Using a Cluster Computing Portal" documentan su uso educativo [[9]](https://tcpp.cs.gsu.edu/curriculum/sites/default/files/Teaching%20Parallel%20and%20Distributed%20Computing%20Using%20a%20Cluster%20Computing%20Portal.pdf)

---

## 4. Por qué Decayó el Uso

### 4.1 Cronología del Declive

| Período | Evento | Impacto |
|---------|--------|---------|
| **2001** | MOSIX se vuelve propietario | Bifurcación de openMosix (2002), pérdida de comunidad open source |
| **2008** | openMosix es discontinuado | Cierre definitivo del fork open source más activo |
| **2014** | MOSIX-4 elimina necesidad de parche de kernel | Intento de modernizar, pero demasiado tarde |
| **2017** | Último release (MOSIX-4.4.4) | Fin de actualizaciones |
| **2020s** | Sin adopción en producción moderna | Tecnología considerada obsoleta |

### 4.2 Razones Técnicas del Declive

1. **Modelo de migración de procesos vs contenedores:** MOSIX trabaja a nivel de kernel (migración de procesos Linux), mientras la industria evolucionó hacia contenedores (Docker) y orquestación (Kubernetes). El modelo de MOSIX es conceptualmente interesante pero incompatible con el paradigma moderno.

2. **Sin soporte para memoria compartida:** Las aplicaciones HPC modernas requieren memoria compartida distribuida (DSM) o acceso a GPUs, que MOSIX no soporta.

3. **Aplicaciones con threads:** MOSIX no soporta aplicaciones con threads de forma nativa, limitando su uso para muchas aplicaciones científicas modernas.

4. **Licencia restrictiva:** El modelo propietario impidió la formación de una comunidad de desarrollo activa, contrariamente a lo que ocurrió con SLURM (GPL) o Kubernetes (Apache 2.0).

5. **Competencia de schedulers profesionales:** SLURM y PBS Pro ofrecieron gestión de jobs más flexible y escalable sin requerir modificaciones al kernel.

6. **Ecosistema de contenedores:** Kubernetes y Docker capturaron el mercado de orquestación con comunidades masivas y soporte comercial de múltiples vendors.

### 4.3 Comparación con Evolución Tecnológica

| Período | Tecnología dominante | Enfoque |
|---------|---------------------|---------|
| **1990s-2000s** | Beowulf, MOSIX | Clusters de PCs, migración de procesos a nivel kernel |
| **2003+** | SLURM, PBS | Job scheduling profesional, gestión de recursos |
| **2010s+** | Kubernetes, Docker | Contenedores, microservicios, orquestación |
| **2020s+** | K8s + Slurm hybrid | HPC cloud-native, integración de paradigmas |

El ecosistema evolucionó mientras MOSIX permaneció estático.

**Fuente:** [Medium: Rethinking Cloud Operating Systems with Rust](https://medium.com/terasky/rethinking-cloud-operating-systems-78462455539b), [Wikipedia: Comparison of cluster software](https://en.wikipedia.org/wiki/Comparison_of_cluster_software)

---

## 5. Estado Actual de Adopción

### 5.1 Adopción en Producción Moderna

**Cero casos documentados en producción moderna.** No se encontraron implementaciones de MOSIX en entornos de producción activos después de 2017.

### 5.2 Indicadores de Inactividad

| Indicador | Estado |
|-----------|--------|
| **Última versión** | MOSIX-4.4.4 (24 de octubre de 2017) — hace más de 8 años |
| **Sitio oficial** | Disponible (mosix.org) pero sin actualizaciones |
| **Desarrollo activo** | No hay evidencia de desarrollo continuo |
| **Soporte comercial** | No disponible públicamente |
| **Comunidad activa** | No hay foros ni mailing lists activos |
| **Papers recientes** | Muy escasos posteriores a 2017 |

### 5.3 Menciones Históricas

Un post de LinkedIn de 2022 menciona que Mike Kemelmakher (VP Product en Majestic Labs) diseñó y administró clusters HPC basados en Linux y MOSIX, indicando uso histórico en entornos de producción [[10]](https://www.linkedin.com/). Un post de Facebook de diciembre 2022 indica que MOSIX "tiene buena reputación y no hay tarifa de licencia para uso no comercial" [[11]](https://www.facebook.com/groups/GNUAndLinux/posts/10167823624740019/).

**Sin embargo, no se encontraron casos de uso en producción documentados después de 2017.**

### 5.4 Contexto Educativo Actual

MOSIX sigue siendo relevante como **caso de estudio histórico** en cursos de sistemas operativos y sistemas distribuidos:

- Entiende evolución de cluster computing
- Ilustra conceptos de Single System Image (SSI)
- Compara con tecnologías modernas (SLURM, Kubernetes)
- Introduce migración de procesos preemptiva

**Fuente:** [Wikipedia: MOSIX](https://en.wikipedia.org/wiki/MOSIX), [MOSIX Official Site](http://www.mosix.org/)

---

## 6. Comparación con SLURM y Kubernetes

### 6.1 SLURM (Simple Linux Utility for Resource Management)

**SLURM** es el estándar de facto en HPC moderno, utilizado en más del **60% de las Top500 supercomputadoras** del mundo [[12]](https://arxiv.org/html/2506.19019v1).

| Aspecto | MOSIX | SLURM |
|---------|-------|-------|
| **Abstracción** | Nivel de SO (migración de procesos) | Nivel de job scheduling |
| **Single System Image** | Sí (completo) | No |
| **Migración live** | Sí (procesos migrados automáticamente) | No (re-scheduling de jobs) |
| **Licencia** | Propietaria | GPL |
| **Estado** | Inactivo (desde 2017) | Muy activo |
| **Soporte comercial** | No disponible | Sí (SchedMD) |
| **Adopción Top500** | 0% | >60% |
| **Curva de complejidad** | Media | Media-Alta |

**¿Por qué SLURM ganó?**
- GPL permite comunidad de desarrollo activa
- Soporte comercial (SchedMD) viable
- Escalabilidad probada en supercomputadoras reales
- Integración con MPI, GPUs, job arrays
- Sin modificaciones al kernel requeridas

**Fuentes:**
- [Slurm Workload Manager](https://slurm.schedmd.com/)
- [Survey of HPC in US Research Institutions (arXiv 2025)](https://arxiv.org/html/2506.19019v1)
- [CoreWeave: What is Slurm](https://www.coreweave.com/topics/what-is-slurm)

### 6.2 Kubernetes

**Kubernetes** dominan el ecosistema cloud-native y tienen adopción creciente en HPC.

| Aspecto | MOSIX | Kubernetes |
|---------|-------|------------|
| **Abstracción** | Nivel de SO (migración de procesos) | Nivel de contenedor |
| **Single System Image** | Sí (completo) | Parcial (volúmenes, red) |
| **Migración live** | Sí (procesos) | Limitada (container migration experimental) |
| **Licencia** | Propietaria | Apache 2.0 |
| **Estado** | Inactivo | Muy activo |
| **Comunidad** | Mínima | Masiva (CNCF) |
| **Soporte comercial** | No disponible | Múltiples vendors (Red Hat, Google, Amazon) |
| **Adopción HPC** | Nula (histórico) | Creciente |

**¿Por qué Kubernetes ganó?**
- Ecosistema de contenedores universal
- Orquestación de microservicios
- Hybrid cloud y edge computing
- Helm, Operators, Kubeflow para ML/HPC
- RDMA networking support

**Fuentes:**
- [Kubernetes Official Documentation](https://kubernetes.io/)
- [Dev.to: Kubernetes for HPC 2026](https://dev.to/naveens16/kubernetes-for-hpc-the-quiet-convergence-reshaping-high-performance-computing-2apb)

### 6.3 Tabla Comparativa Resumida

| Criterio | MOSIX | SLURM | Kubernetes |
|----------|-------|-------|------------|
| **Migración live** | ✅ Sí | ❌ No | ❌ Limitada |
| **Single System Image** | ✅ Sí | ❌ No | ❌ Parcial |
| **Licencia** | ⚠️ Propietaria | ✅ GPL | ✅ Apache 2.0 |
| **Estado activo** | ❌ No (2017) | ✅ Sí | ✅ Sí |
| **Soporte comercial** | ❌ No | ✅ SchedMD | ✅ Multi-vendor |
| **Adopción HPC** | ❌ 0% | ✅ >60% Top500 | ▲ Creciente |
| **Para educación/conceptos históricos** | ✅ Relevante | ⚠️ Complejo | ❌ No aplica |
| **Integración GPUs** | ❓ Sin información pública | ✅ Sí | ✅ Sí |
| **Checkpoint/Restart** | ✅ Soportado | ✅ Soportado | ✅ Kubernetes CK |

---

## 7. Resumen de Difusión

| Fase | Período | Características |
|------|---------|-----------------|
| **Pico académico** | 1999–2010 | Adopción en universidades para investigación HPC |
| **Fork open source** | 2002–2008 | openMosix mantiene comunidad, pero declina |
| **Intento de modernización** | 2014 | MOSIX-4 sin parche de kernel, demasiado tarde |
| **Inactividad** | 2017–presente | Sin releases, sin soporte comercial, cero adopción moderna |
| **Legado educativo** | 2020s | Caso de estudio histórico en cursos de SO |

**Conclusión:** MOSIX fue una tecnología relevante en el ámbito académico de 1990-2010, pero fue desplazada por alternativas open source con comunidades activas (SLURM) y paradigmas modernos (contenedores/Kubernetes). Su legado persiste únicamente como material educativo para entender la evolución de sistemas distribuidos.

---

## 8. Fuentes

1. [The MOSIX multicomputer operating system for high performance computing](https://www.sciencedirect.com/science/article/abs/pii/S0167739X9700037X) — ScienceDirect
2. [BMC Bioinformatics - ProtoNet](https://www.cs.huji.ac.il/~nati/PAPERS/everest.pdf) — Hebrew University
3. [Scalable Cluster Computing with MOSIX for LINUX](http://www.cs.columbia.edu/~orenl/papers/mosix4linux.pdf) — Columbia University
4. [MOSIX Papers - Virginia Tech](https://courses.cs.vt.edu/~cs5204/fall05-kafura/Papers/Migration/mosix.pdf)
5. [The MOSIX Algorithms for Managing Cluster - TU Dresden](https://os.inf.tu-dresden.de/Studium/DOS/SS2014/03-MOSIX.pdf)
6. [The MOSIX Parallel I/O System for Scalable I/O Performance](https://www.researchgate.net/publication/221569075_The_MOSIX_Parallel_IO_System_for_Scalable_IO_Performance)
7. [Asynchronous parallel discontinuous finite element method](https://cris.huji.ac.il/en/publications/asynchronous-parallel-discontinuous-finite-element-method/) — Hebrew University
8. [Efficient algorithms for accurate hierarchical clustering - Bioinformatics](https://academic.oup.com/bioinformatics/article/24/13/i41/234385)
9. [Teaching Parallel and Distributed Computing - TCPP Curriculum](https://tcpp.cs.gsu.edu/curriculum/sites/default/files/Teaching%20Parallel%20and%20Distributed%20Computing%20Using%20a%20Cluster%20Computing%20Portal.pdf)
10. [LinkedIn - HPC cluster experience with MOSIX](https://www.linkedin.com/) — Menciones históricas de uso en producción
11. [Facebook Group - Best distro for cluster computing 2022](https://www.facebook.com/groups/GNUAndLinux/posts/10167823624740019/)
12. [Survey of HPC in US Research Institutions (arXiv 2025)](https://arxiv.org/html/2506.19019v1)
13. [Rethinking Cloud Operating Systems with Rust - Medium](https://medium.com/terasky/rethinking-cloud-operating-systems-78462455539b)
14. [Wikipedia: Comparison of cluster software](https://en.wikipedia.org/wiki/Comparison_of_cluster_software)
15. [Wikipedia: MOSIX](https://en.wikipedia.org/wiki/MOSIX)
16. [Wikipedia: OpenMosix](https://en.wikipedia.org/wiki/OpenMosix)
17. [MOSIX Official Site](http://www.mosix.org/)
18. [MOSIX History - Hebrew University](https://mosix.cs.huji.ac.il/txt_history.html)
19. [Slurm Workload Manager](https://slurm.schedmd.com/)
20. [Kubernetes Official Documentation](https://kubernetes.io/)

---

*Documento compilado para Fundamentos de Sistemas Operativos — Mayo 2026*
*Sección "Puertas Afuera" — Difusión y Presencia en el Mundo*

---
## Nota Académica — Fundamentos de SO

**Conceptos de la materia relacionados:**

- **§1.2 — Generaciones de SO (4ª-5ª Generación):** MOSIX nació en eltransition zone entre la 4ª generación (microprocesadores, PC, UNIX inicial) y la 5ª (cloud, virtualización). El concepto de "cluster computing" que MOSIX popularizó fue un puente entre el cómputo masivocentralizado de los 80s y la distribuciócloud-native de los 2000s. Sudeclive ilustra cómo las tecnologías de una generación pueden ser desplazadas antes de que concluyan — MOSIX quedó obsoleto no por fallas técnicas sino por la evolución del paradigma (contenedores > migración de procesos a nivel kernel).

- **§1.4 — Arquitecturas (Single System Image):** MOSIX pioneeró el concepto de Single System Image (SSI) — un cluster que parece una única máquina. Este enfoque arquitectónico fue innov substitute para clusters HPC de bajo costo. Sin embargo, SSI requería modificaciones al kernel, lo que lo hacía invasivo. Arquitecturas modernas como Kubernetes prefieren modelos menos integrados (cada nodo es independiente), demostrando que la "integración total" no siempre gana.

- **§1.1 — Gestión de recursos:** MOSIX解决的问题 era cómohacer que uncluster de PCs funcione como unsupercomputadora virtual: migración preemptiva de procesos, balanceo de carga automático, acceso a archivos distribuido.Estos conceitos de gestión distribuida de recursos foreshadow tecnologías como containers orchestration y schedulers profesionales (SLURM).