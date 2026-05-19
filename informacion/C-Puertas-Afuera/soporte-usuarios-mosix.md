# Posibilidad de Soporte a Usuarios — MOSIX

> **Nota:** Este documento describe el ecosistema de soporte disponible para MOSIX. Dado que MOSIX es un proyecto de investigación de la Hebrew University of Jerusalem que dejó de tener actualizaciones activas en 2017, el soporte es extremadamente limitado. La información aquí presentada refleja el estado actual (Mayo 2026).

---

## 1. Documentación Oficial Disponible

### 1.1 Documentos Técnicos

MOSIX cuenta con varios documentos oficiales publicados por el grupo de investigación de la Hebrew University of Jerusalem:

| Documento                       | Descripción                                                 | Enlace                                                                 |
| ------------------------------- | ----------------------------------------------------------- | ---------------------------------------------------------------------- |
| **MOSIX FAQ**                   | Preguntas frecuentes sobre instalación, configuración y uso | [FAQ Official](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html) |
| **MOSIX Administrator's Guide** | Guía completa para administradores de clusters              | [Guide.pdf](http://www.mosix.cs.huji.ac.il/pub/Guide.pdf)              |
| **MOSIX White Paper**           | Introducción general y arquitectura del sistema             | [White Paper](http://www.mosix.cs.huji.ac.il/pub/MOSIX_wp.pdf)         |
| **MOSIX Changelog**             | Historial de cambios por versión                            | [Changelog](https://mosix.cs.huji.ac.il/txt_changelog.html)            |
| **Historia de MOSIX**           | Línea temporal del proyecto desde 1977                      | [History](https://mosix.cs.huji.ac.il/txt_history.html)                |

### 1.2 Sitio Web Oficial

El sitio oficial de MOSIX (http://www.mosix.org/) permanece accesible pero **no se actualiza desde octubre de 2017**. El sitio incluye:

- Página principal con descripción general
- Sección de descargas (MOSIX-4.4.4, octubre 2017)
- Documentación técnica
- Información de contacto (mosix@cs.huji.ac.il)

**Fuente:** [MOSIX Official Site](http://www.mosix.org/)

### 1.3 Limitaciones de la Documentación

⚠️ **Importante:** La documentación oficial presenta las siguientes limitaciones:

- **No cubre casos de uso modernos** (contenedores, Kubernetes, GPUs)
- **No hay guías para kernels Linux modernos** (el último release soporta hasta Linux 4.X)
- **No existe documentación API formal** para desarrolladores
- **Los ejemplos pueden no funcionar** en distribuciones Linux actuales

---

## 2. Publicaciones Académicas

### 2.1 Publicaciones Principales del Equipo MOSIX

El Prof. Amnon Barak y su equipo han publicado numerosos papers académicos sobre MOSIX. A continuación, los más relevantes:

| Publicación                                                                                              | Año  | Descripción                                         |
| -------------------------------------------------------------------------------------------------------- | ---- | --------------------------------------------------- |
| **"The MOSIX Multicomputer Operating System for High Performance Cluster Computing"** — ScienceDirect    | 1997 | Paper fundacional de la arquitectura MOSIX          |
| **"Scalable Cluster Computing with MOSIX for LINUX"** — Columbia University                              | 1998 | paper seminal con 488+ citas académicas             |
| **"The MOSIX Direct File System Access Method for Supporting Scalable Cluster File Systems"** — Springer | 2004 | paper sobre el sistema DFSA                         |
| **"The MOSIX Algorithms for Managing Cluster, Multi-Clusters, GPU"** — TU Dresden                        | 2011 | Descripción detallada de los algoritmos de balanceo |

**Fuente:** [Amnon Barak en ResearchGate](https://www.researchgate.net/scientific-contributions/Amnon-Barak-8110256), [ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S0167739X9700037X)

### 2.2 Disponibilidad de Papers

- **Acceso parcial:** Algunos papers están disponibles gratuitamente en los sitios de las universidades
- **ScienceDirect:** Acceso limitado (paywall en muchos casos)
- **ResearchGate:** El Prof. Barak tiene 71 publicaciones con 1662 citas — varias disponibles
- **PDFs directos:** La Hebrew University distribuye algunos papers desde mosix.cs.huji.ac.il/pub/

**Ejemplo de paper disponible:**

- [The MOSIX Algorithms for Managing Cluster, Multi-Clusters, GPU (PDF)](https://os.inf.tu-dresden.de/Studium/DOS/SS2011/05-MOSIX.pdf)

### 2.3 Uso Académico Contemporáneo

MOSIX se sigue mencionando en contextos académicos como:

- **Casos de estudio** en cursos de sistemas operativos distribuidos
- **Referencia histórica** para comparar con tecnologías modernas (SLURM, Kubernetes)
- **Papers sobre migración de procesos** lo citan como trabajo pionero

**Fuente:** [Teaching Parallel and Distributed Computing - TCPP Curriculum](https://tcpp.cs.gsu.edu/curriculum/sites/default/files/Teaching%20Parallel%20and%20Distributed%20Computing%20Using%20a%20Cluster%20Computing%20Portal.pdf)

---

## 3. Foros y Comunidad

### 3.1 Comunidad Activa

**Estado: Prácticamente inexistente**

| Canal                        | Disponibilidad                                                     | Estado       |
| ---------------------------- | ------------------------------------------------------------------ | ------------ |
| **Foros dedicados de MOSIX** | ❌ No existen foros activos                                        | —            |
| **Stack Overflow**           | ❌ Menos de 20 preguntas con tag "mosix", la mayoría sin respuesta | Inactivo     |
| **Spiceworks Community**     | ⚠️ Un hilo de 2026 sobre configuración, sin respuestas oficiales   | Muy limitado |
| **Reddit**                   | ⚠️ Mención ocasional en hilos de HPC histórico                     | Casi nada    |
| **Twitter @MOSIX_cluster**   | ❌ Cuenta sin actividad reciente                                   | Inactivo     |

**Fuente:** [Spiceworks Community - Configuring a MOSIX Cluster](https://community.spiceworks.com/t/configuring-a-mosix-cluster/1249164/)

### 3.2 Intento de Contacto Comunitario en 2026

Una búsqueda reciente (Feb 2026) en Spiceworks mostró:

> _"I just want to share hardware resources from my main computer, and while exploring I came across MOSIX. The problem is that I cannot find..."_ — Pregunta sin respuesta oficial.

Esto ilustra la **falta de soporte comunitario activo** paraMOSIX en 2026.

### 3.3 fork Histórico: openMosix

El fork open source **openMosix** (discontinuado en 2008) tuvo su propia comunidad, pero:

- El proyecto está oficialmente terminado desde marzo de 2008
- Quedan algunos recursos históricos en SourceForge
- No hay actividad significativa desde hace más de 15 años

**Fuente:** [openMosix en SourceForge](https://openmosix.sourceforge.net/)

### 3.4 Conclusión sobre Comunidad

> **No hay comunidad activa de soporte para MOSIX.** Cualquier problema técnico probablemente no recibirá respuesta de otros usuarios o de los desarrolladores originales.

---

## 4. Soporte Comercial

### 4.1 Estado del Soporte Comercial

**NO HAY soporte comercial disponible para MOSIX.**

| Aspecto                         | Detalle                             |
| ------------------------------- | ----------------------------------- |
| **Empresa comercial**           | ❌ No existe                        |
| **Partners oficiales**          | ❌ No hay ningún partner o reseller |
| **Soporte técnico profesional** | ❌ No disponible                    |
| **Contratos de mantenimiento**  | ❌ No disponibles                   |
| **Certificaciones**             | ❌ No existen                       |

**Fuente:** [MOSIX Distributions - Licensing](https://mosix.cs.huji.ac.il/txt_distributions.html)

### 4.2 Información Histórica de Precios

Según documentación histórica de **USENIX (2000)**, existía pricing para un cluster de producción:

| Concepto                                 | Costo histórico (USD, año 2000) |
| ---------------------------------------- | ------------------------------- |
| Licencia inicial (cluster de producción) | ⚠ $61,141.25 → LSF, no MOSIX    |
| Mantenimiento anual                      | $16,835.00                      |

> ⚠️ **ADVERTENCIA:** Esta información es **obsoleta y no verificable en 2026**. No hay garantía de que estos valores tengan relación con cualquier modelo actual, si es que existe alguno.

**Fuente:** [USENIX Documentation 2000 - Historical pricing](https://www.usenix.org/02/archive/highlights/html/mosix.html)

### 4.3 Modelo Actual de Licenciamiento

Según la página oficial de distribuciones:

- MOSIX usa una **licencia propietaria restrictiva**
- La licencia indica: _"You are not allowed to modify or reverse-engineer THE PRODUCT"_
- **Sin garantía** de ningún tipo
- **Ley aplicable:** Israel

Un mensaje en foros sugiere que _"MOSIX no longer requires a license fee for non-commercial use"_, pero **esto no está verificado oficialmente** y debe confirmarse directamente con los desarrolladores.

> **Recomendación:** Contactar a mosix@cs.huji.ac.il para información actualizada sobre licenciamiento.

---

## 5. GitHub y Código Abierto

### 5.1 Repositorios GitHub Relacionados

**NO existe un repositorio oficial de MOSIX en GitHub.**

| Repositorio                                       | Descripción                                                                      | Estado                                     |
| ------------------------------------------------- | -------------------------------------------------------------------------------- | ------------------------------------------ |
| [kurhula/mosix](https://github.com/kurhula/mosix) | Repositorio NO oficial con código fuente MOSIX-4.4.3 para instalación automática | **Inactivo** (3 commits, último hace años) |
| [moshix](https://github.com/moshix)               | Usuario de GitHub con diferentes proyectos (no relacionado con MOSIX)            | Irrelevante                                |
| **openMosix**                                     | Fork histórico open source, ahora archivado                                      | Discontinuado desde 2008                   |

### 5.2 Características del Repositorio No-Oficial

El repositorio [kurhula/mosix](https://github.com/kurhula/mosix) tiene:

- ⭐ **2 estrellas**
- 🍴 **2 forks**
- 📝 **3 commits**
- 📦 **Sin releases publicados**

> **Nota:** Este repositorio **NO es oficial** y no está afiliado con la Hebrew University o el Prof. Barak. Su código no recibe actualizaciones.

### 5.3 Código Fuente

- El código fuente de MOSIX **NO es open source**
- La licencia **prohíbe** ingeniería reversa y modificación
- Historicalmente, el fork **openMosix** fue la alternativa open source (discontinuado)

---

## 6. Actualizaciones y Mantenimiento

### 6.1 Estado de Actualizaciones

**NO HAY actualizaciones activas desde octubre de 2017.**

| Aspecto                                   | Estado                                                              |
| ----------------------------------------- | ------------------------------------------------------------------- |
| **Última versión estable**                | MOSIX-4.4.4 (24 de octubre de 2017)                                 |
| **Última actualización de documentación** | 2017 o anterior                                                     |
| **Parches de seguridad**                  | ❌ Ninguno desde 2017                                               |
| **Compatibilidad con kernels modernos**   | ⚠️ Limitada (soporta hasta Linux 4.X según documentación histórica) |
| **Desarrollador principal**               | Prof. Amnon Barak (Hebrew University) — sin actualización activa    |

**Fuente:** [MOSIX Changelog](https://mosix.cs.huji.ac.il/txt_changelog.html)

### 6.2 Implicaciones de la Inactividad

Para usuarios potenciales en 2026:

| Problema                                 | Impacto                                                                   |
| ---------------------------------------- | ------------------------------------------------------------------------- |
| **Sin parches de seguridad**             | Riesgo significativo si se usa en producción                              |
| **Sin soporte para kernels modernos**    | Puede no funcionar en distribuciones Linux actuales (Ubuntu 22.04+, etc.) |
| **Sin soporte para arquitectura ARM**    | Limitado a x86/x86_64                                                     |
| **Sin soporte para containers modernos** | Docker, Kubernetes no tienen integración nativa                           |
| **Obsolescencia tecnológica**            | SLURM, Kubernetes dominan el mercado HPC actual                           |

### 6.3 Comparación: Proyecto Activo vs Inactivo

| Característica               | MOSIX (Inactivo) | SLURM (Activo)             | Kubernetes (Activo) |
| ---------------------------- | ---------------- | -------------------------- | ------------------- |
| **Última actualización**     | Octubre 2017     | Diaria                     | Diaria              |
| **Parches de seguridad**     | ❌               | ✅                         | ✅                  |
| **Soporte kernels modernos** | ⚠️ Limitado      | ✅                         | ✅                  |
| **Comunidad activa**         | ❌               | ✅ Miles de contribuidores | ✅ Massive          |

**Fuente:** [Top500 Supercomputers - Slurm adoption](https://www.top500.org/)

---

## 7. Contacto Directo

### 7.1 Información de Contacto

| Método                | Detalle               |
| --------------------- | --------------------- |
| **Email**             | mosix@cs.huji.ac.il   |
| **Sitio web**         | http://www.mosix.org/ |
| **Hebrew University** | mosix.cs.huji.ac.il   |

### 7.2 Consideraciones sobre el Contacto

> ⚠️ **IMPORTANTE:** Contactar a mosix@cs.huji.ac.il es la **única vía de soporte directo**, pero:

- **No hay garantía de respuesta** — el proyecto está abandonado desde 2017
- **Tiempo de respuesta desconocido** — pueden pasar semanas o no haber respuesta
- **Sin soporte formal** — es un proyecto de investigación, no un producto comercial
- **La cuenta puede seguir activa** pero sin personal dedicado al soporte

### 7.3 Qué Esperar al Contactar

Basado en la información disponible:

| Situación                        | Respuesta probable                            |
| -------------------------------- | --------------------------------------------- |
| **Preguntas técnicas complejas** | Probablemente sin respuesta                   |
| **Problemas de instalación**     | Documentación existente puede ayudar          |
| **Licenciamiento comercial**     | Posible respuesta (si hay persona disponible) |
| **Reportes de bugs**             | Inútil — no hay desarrollo activo             |

---

## 8. Comparación con Alternativas Activas

### 8.1 Soporte Disponible en Alternativas

| Sistema              | Soporte Comercial      | Comunidad Activa    | GitHub                                                               | Actualizaciones |
| -------------------- | ---------------------- | ------------------- | -------------------------------------------------------------------- | --------------- |
| **MOSIX**            | ❌ No hay              | ❌ Casi inexistente | ⚠️ No oficial (archivado)                                            | ❌ Desde 2017   |
| **SLURM**            | ✅ SchedMD             | ✅ Muy activa       | ✅ [slurm.schedmd.com](https://github.com/SchedMD/slurm)             | ✅ Constantes   |
| **Kubernetes**       | ✅ CNCF + multi-vendor | ✅ Massive          | ✅ [kubernetes/kubernetes](https://github.com/kubernetes/kubernetes) | ✅ Diarias      |
| **PBS Professional** | ✅ Altair              | ✅ Activa           | ❌ Propietario                                                       | ✅ Constantes   |
| **OpenMPI**          | ❌ Comunidad           | ✅ Activa           | ✅ [open-mpi/hwloc](https://github.com/open-mpi/hwloc)               | ✅ Regulares    |

### 8.2 ¿Por Qué Elegir una Alternativa?

Si el objetivo es tener **soporte activo y comunidad**:

| Necesidad                   | Recomendación                                |
| --------------------------- | -------------------------------------------- |
| Job scheduling HPC          | **SLURM** (SchedMD ofrece soporte comercial) |
| Orquestación moderna        | **Kubernetes** (CNCF, múltiples vendors)     |
| Cómputo paralelo MPI        | **OpenMPI** (comunidad activa)               |
| Soporte empresarial         | **PBS Professional** (Altair)                |
| Estudio histórico/educativo | **MOSIX** (con contexto de obsolescencia)    |

### 8.3 Ecosistema de Soporte: SchedMD (SLURM) vs MOSIX

**SchedMD (mantenedor de SLURM):**

- Empresa dedicada al soporte de SLURM
- Documentación exhaustiva y actualizada
- Respuesta a issues en GitHub
- Slack/Canal de comunidad activo
- Certificaciones disponibles

**MOSIX:**

- Sin empresa ni equipo de soporte
- Documentación desactualizada desde 2017
- Email sin garantía de respuesta
- Sin canales modernos (Slack, Discord, etc.)

---

## 9. Resumen Ejecutivo

### 9.1 Estado del Soporte MOSIX

| Aspecto                  | Valoración                            |
| ------------------------ | ------------------------------------- |
| Documentación oficial    | ⚠️ Existente pero desactualizada      |
| Publicaciones académicas | ✅ Abundantes (contexto histórico)    |
| Foros/Comunidad          | ❌ Prácticamente inexistente          |
| Soporte comercial        | ❌ NO HAY                             |
| GitHub/código abierto    | ❌ NO HAY (es propietario)            |
| Actualizaciones activas  | ❌ NO (desde octubre 2017)            |
| Contacto directo         | ⚠️ mosix@cs.huji.ac.il (sin garantía) |

### 9.2 Recomendación

> **Para uso en producción o proyectos modernos:** MOSIX **no es recomendado** debido a la falta total de soporte activo, actualizaciones de seguridad y compatibilidad con tecnologías actuales.
>
> **Para fines educativos/académicos:** MOSIX sigue siendo útil como **caso de estudio histórico** de migración de procesos y sistemas distribuidos, pero debe entenderse como tecnología obsoleta.

### 9.3 Alternativas con Soporte Activo

| Si necesitas funcionalidad similar a MOSIX... | Considera...                  |
| --------------------------------------------- | ----------------------------- |
| Migración de procesos en cluster              | SLURM + scripts de migración  |
| Single System Image                           | Kubernetes (con limitaciones) |
| Balanceo de carga automático                  | SLURM, Kubernetes, Mesos      |
| Comunidad y soporte activo                    | SLURM, Kubernetes             |

---

## 10. Fuentes

1. [MOSIX Official Site](http://www.mosix.org/)
2. [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)
3. [MOSIX Administrator's Guide](http://www.mosix.cs.huji.ac.il/pub/Guide.pdf)
4. [MOSIX Distributions - Licensing](https://mosix.cs.huji.ac.il/txt_distributions.html)
5. [MOSIX Changelog](https://mosix.cs.huji.ac.il/txt_changelog.html)
6. [MOSIX History](https://mosix.cs.huji.ac.il/txt_history.html)
7. [ResearchGate - Amnon Barak](https://www.researchgate.net/scientific-contributions/Amnon-Barak-8110256)
8. [GitHub - kurhula/mosix (NO oficial)](https://github.com/kurhula/mosix)
9. [Spiceworks Community - MOSIX Thread 2026](https://community.spiceworks.com/t/configuring-a-mosix-cluster/1249164/)
10. [Slurm Workload Manager](https://slurm.schedmd.com/)
11. [Top500 Supercomputers](https://www.top500.org/)
12. [USENIX Documentation 2000 - Historical pricing (obsoleto)](https://www.usenix.org/02/archive/highlights/html/mosix.html)

---

## Nota Académica — Fundamentos de SO

**Conceptos de la materia relacionados:**

- **§1.1 — La documentación como recurso:** MOSIX ilustra el otro lado del espectro: sin soporte activo, un SO se vuelve inútil. La gestión de recursos no solo implica técnología — implica mantener documentación actualizada, security patches, y canales de soporte. La última versión de MOSIX (2017) con documentación para Linux 4.X demuestra que incluso recursos académicos excelentes no sobreviven sin mantenimiento continuo. La recomendación de contactar mosix@cs.huji.ac.il con "sin garantía de respuesta" evidencia que un SO sin comunidad es simplemente un research project abandonado.

- **§1.2 — Ciclo de vida de tecnologías de SO:** MOSIX peaked durante la era Beowulf (1999-2010), cuando clusters de PCs eran la forma más accesible de HPC. Su obsolescencia enseña que tecnologías de una generación pueden quedar obsoletas no por fallas técnicas sino por evolución del ecosistema. SLURM y Kubernetes reemplazaron a MOSIX no porque fueran mejores en todos los aspectos, sino porque resolvieron problems diferentes (job scheduling vs. migración de procesos). Entender cuándo usar qué herramienta es parte de la gestión de recursos.

- **§1.4 — El rol de la licencia en la adopción:** La licencia propietaria de MOSIX contrast explicitly con el modelo open source de alternativas. El paper de Columbia University (1998) con 488+ citas muestra que MOSIX tuvo relevancia académica — pero sin GPL que permitiera fork activos (como openMosix que duró hasta 2008), el desarrollo se estancó. La lección: la licencia de un SO influencia directamente su capacidad de generar comunidad y mantenimiento a largo plazo.

---

_Documento preparado para Fundamentos de Sistemas Operativos — Mayo 2026_
_Basado en investigación existente y búsqueda web complementaria_
