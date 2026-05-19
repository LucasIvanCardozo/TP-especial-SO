# La Empresa Detrás de MOSIX

MOSIX es un proyecto de **investigación académica** desarrollado dentro del ámbito universitario, no una empresa comercial en el sentido tradicional. A continuación se detalla todo lo relacionado con la organización, historia y modelo de negocio detrás de MOSIX.

---

## ¿Qué Organización o Académico Está Detrás?

### El Grupo de Investigación

MOSIX es desarrollado y mantenido por el **Grupo de Investigación en Sistemas Distribuidos** ([Distributed Systems Research Group](https://www.cs.huji.ac.il/~amnon)) del **Instituto de Ciencia de la Computación** de la **Hebrew University of Jerusalem** (Universidad Hebrea de Jerusalén), Israel.

### El Investigador Principal: Prof. Amnon Barak

El fundador y líder del proyecto es el **Prof. Amnon Barak**, profesor del Instituto de Ciencia de la Computación de la Hebrew University of Jerusalem.

**Trayectoria académica relevante:**

- Ha publicado más de **71 trabajos de investigación** con aproximadamente **1,662 citas** ([ResearchGate](https://www.researchgate.net/scientific-contributions/Amnon-Barak-8110256))
- Áreas de investigación: sistemas paralelos y distribuidos, algoritmos para gestión adaptativa de recursos en clouds, sistemas distribuidos de alto rendimiento
- En 1986 fue appointed como el primer Director del **German-Israeli Foundation (GIF)** para la cooperación científica bilateral ([GIF](https://www.gif.org.il/2022/07/19/gif-remembers-its-first-director-dr-amnon-barak/))
- Entre sus proyectos destacados se encuentran: FFMK (Fast and Fault-Tolerant Microkernel-Based System for Exascale Computing)

**Perfil académico:**

- [Perfil oficial en HUJI](https://www.cs.huji.ac.il/~amnon)
- [DBLP - Registro de publicaciones](https://dblp.org/pid/b/AmnonBarak)

### Propiedad Intelectual

- Los derechos de autor de MOSIX están registrados bajo la figura del **Prof. Amnon Barak** como único propietario intelectual
- **MOSIX®** es una **marca registrada**
- El sitio oficial indica que todos los derechos están reservados

### Información de Contacto

- **Sitio oficial:** [mosix.org](http://www.mosix.org/)
- **Sitio técnico (HUJI):** [mosix.cs.huji.ac.il](http://mosix.cs.huji.ac.il/)
- **Email de contacto:** mosix@cs.huji.ac.il (según documentación)
- **Twitter oficial:** @MOSIX_cluster (mencionado en documentación)

---

## Historia y Origen Completo (1977–Hoy)

### Cronología Detallada

MOSIX tiene una de las historias más largas en computación distribuida, con desarrollo continuo desde 1977 hasta aproximadamente 2017:

| Período                   | Versión                  | Plataforma                        | Detalles                                                                                                                |
| ------------------------- | ------------------------ | --------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **1977–1979**             | MOS (Version 0)          | PDP-11/45 + PDP-11/10 (Unix v6)   | Primer proyecto de migración de procesos. Demostró ganancias de rendimiento incluso con enlaces de comunicación lentos. |
| **1981–1983**             | MOS (Version 1)          | PDP-11/45 + 4 PDP-11/23 (Unix v7) | Primer sistema operativo multicomputadora funcional.                                                                    |
| **1987–1988**             | NSMOS                    | NS32332                           | Puerto a arquitectura National Semiconductor 32000.                                                                     |
| **1988–1989**             | MOSIX                    | NS32532 cluster (16 nodos)        | Primer sistema con el nombre "MOSIX".                                                                                   |
| **1991–1993**             | MOSIX v6                 | BSD/OS (cluster de 486/Pentium)   | Cluster con 8 equipos 486 y 32 Pentium PCs conectados por Myrinet.                                                      |
| **1998–1999**             | MOSIX v7                 | Linux 2.2                         | Primera versión para Linux. Cluster de 64 nodos x86 con Myrinet.                                                        |
| **1999**                  | MOSIX se enfoca en Linux | Linux                             | A partir de aquí, todas las versiones se desarrollan sobre kernel Linux.                                                |
| **2003**                  | MOSIX v9                 | Linux 2.4/2.6                     | Cluster con cientos de estaciones de trabajo.                                                                           |
| **2004–2006**             | MOSIX v10 (MOSIX-2)      | Linux 2.6                         | Gestión de multiclusters y grids.                                                                                       |
| **2014**                  | MOSIX-4                  | Linux 3.X/4.X                     | **Ya no requiere parche de kernel.**                                                                                    |
| **24 de octubre de 2017** | MOSIX-4.4.4              | Linux 3.X/4.X                     | **Último release oficial hasta la fecha.**                                                                              |

### Hitos Importantes

1. **1977:** Primeros experimentos con migración de procesos en PDP-11 — **43 años de historia**
2. **1999:** Transición definitiva a Linux como plataforma base
3. **2001:** Moment clé — MOSIX se vuelve software propietario
4. **2002:** Moshe Bar crea **openMosix** como fork open source
5. **2014:** Cambio arquitectural majeur — versión que ya no requiere parche de kernel (funciona como módulo/overlay)
6. **2017:** Último release (MOSIX-4.4.4) — **hace más de 8 años a mayo de 2026**

### Trayectoria Investigadora

El proyecto ha evolucionado a lo largo de décadas manteniendo su enfoque en:

- Migración preemptiva de procesos
- Balanceo de carga automático
- Single System Image (SSI)
- Gestión de múltiples clusters y grids

**Fuentes:**

- [History of MOSIX - Hebrew University](https://mosix.cs.huji.ac.il/txt_history.html)
- [Wikipedia: MOSIX](https://en.wikipedia.org/wiki/MOSIX)

---

## ¿Es Open Source? Modelo de Licencia

### Respuesta Corta: **NO es Open Source**

MOSIX es **software propietario** distribuido bajo una **licencia restrictiva propia**. No es open source en el sentido convencional.

### Términos de la Licencia

Según el texto oficial de la licencia publicado en el sitio de MOSIX:

> _"The following license applies to most parts of the MOSIX package... MOSIX SOFTWARE LICENSE AGREEMENT... You are not allowed to modify or reverse-engineer THE PRODUCT."_

**Características clave de la licencia:**

- ✅ Uso permitido bajo los términos de la licencia
- ❌ **Prohibido:** modificar el software
- ❌ **Prohibido:** realizar ingeniería reversa
- ❌ **Prohibido:** crear obras derivadas
- ❌ Las contribuciones son propiedad intelectual del propietario (Amnon Barak)
- 📍 Ley aplicable: Israel
- ⚠️ **Sin garantía** de ningún tipo

### Modelo de Distribución

- **Descarga:** Disponible desde el sitio oficial
- **Costo:** [Información no disponible públicamente] — algunos foros mencionan que "no hay tarifa de licencia para uso no comercial", pero **no es información oficial verificable**
- **Contacto para licenciamiento:** mosix@cs.huji.ac.il (se recomienda contactar directamente)

### Comparación con Licencias Open Source

| Aspecto                      | MOSIX       | GPL (openMosix original) | Apache 2.0 (Kubernetes) |
| ---------------------------- | ----------- | ------------------------ | ----------------------- |
| Código fuente disponible     | ❌ No       | ✅ Sí                    | ✅ Sí                   |
| Permiso para modificar       | ❌ No       | ✅ Sí                    | ✅ Sí                   |
| Permiso para crear derivados | ❌ No       | ✅ Sí                    | ✅ Sí                   |
| Requisito de código abierto  | ❌ No       | ✅ Sí                    | ✅ Sí                   |
| Uso comercial                | Restringido | ✅ Sí                    | ✅ Sí                   |

### Estado de la Licencia en 2026

**Información no disponible públicamente** sobre cambios recientes a la política de licenciamiento. La última documentación visible data de 2017.

**Fuentes:**

- [MOSIX Distributions - Licensing](https://mosix.cs.huji.ac.il/txt_distributions.html)
- [Wikipedia: MOSIX](https://en.wikipedia.org/wiki/MOSIX)

---

## Fork Histórico: openMosix

### Origen del Fork

En **2001**, cuando el equipo de MOSIX decidió volver el software propietario (cerrar el código), **Moshe Bar** tomó la última versión libre disponible y creó el proyecto **openMosix** como una bifurcación (fork) open source.

### Cronología de openMosix

| Fecha                   | Evento                                                                                                                        |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| **2001**                | MOSIX se vuelve propietario                                                                                                   |
| **Febrero 2002**        | Lanzamiento oficial de openMosix                                                                                              |
| **2002–2007**           | Período activo de desarrollo                                                                                                  |
| **17 de julio de 2007** | Anuncio oficial de discontinuación ([Slashdot](https://linux.slashdot.org/story/07/07/17/2342252/openmosix-is-shutting-down)) |
| **Marzo 2008**          | Cierre oficial del proyecto                                                                                                   |
| **Post-2008**           | **LinuxPMI** continúa el desarrollo del código de openMosix                                                                   |

### Características de openMosix

- **Licencia:** GPL (código abierto)
- **Objetivo:** Mantener viva la funcionalidad de migración de procesos en clusters Linux
- **Diferencia clave:** Permitía modificación y creación de derivados (a diferencia de MOSIX)
- **Estado actual:** **Discontinuado** — sin actividad desde 2008

### El Legado: LinuxPMI

Después del cierre de openMosix, el proyecto **LinuxPMI** continuó desarrollando el código heredado. Sin embargo, según publicaciones recientes en foros especializados, **LinuxPMI también está discontinuado** a fecha de 2025.

> _"OpenMosix, OpenSSI, Kerrighed, LinuxPMI all seem to be dead, and i figured the original Mosix Project (which went closed source years ago)..."_ — Comentario en Facebook, febrero 2025

### Tabla Comparativa: MOSIX vs openMosix

| Aspecto                    | MOSIX              | openMosix        |
| -------------------------- | ------------------ | ---------------- |
| **Licencia**               | Propietaria        | GPL              |
| **Desarrollador original** | Amnon Barak (HUJI) | Moshe Bar (fork) |
| **Código modificable**     | ❌ No              | ✅ Sí            |
| **Último release**         | 2017 (4.4.4)       | ~2008            |
| **Estado**                 | Inactivo           | Discontinuado    |
| **Requiere parche kernel** | Sí (hasta 2014)    | Sí               |

**Fuentes:**

- [Wikipedia: OpenMosix](https://en.wikipedia.org/wiki/OpenMosix)
- [OpenMosix Is Shutting Down - Slashdot](https://linux.slashdot.org/story/07/07/17/2342252/openmosix-is-shutting-down)

---

## Soporte Comercial Disponible

### Respuesta: **No Hay Soporte Comercial Formal**

**No se encontró evidencia de una empresa comercial dedicada al soporte de MOSIX.** El proyecto permanece como una iniciativa de investigación académica sin una estructura comercial.

### Soporte Disponible

| Tipo de Soporte             | Disponible       | Detalles                                               |
| --------------------------- | ---------------- | ------------------------------------------------------ |
| **Documentación oficial**   | ✅ Sí            | FAQs, guías técnicas, manuales PDF                     |
| **Foros de comunidad**      | ⚠️ Limitado      | Información histórica en línea, sin actividad reciente |
| **Lista de correo**         | ⚠️ No verificada | Información no disponible públicamente                 |
| **Soporte comercial**       | ❌ No            | No existe empresa comercial dedicada                   |
| **GitHub / Código abierto** | ❌ No            | No hay repositorio público                             |
| **Actualizaciones activas** | ❌ No            | Último release: octubre 2017                           |
| **Soporte académico**       | ✅ Parcial       | Publicaciones académicas, papers técnicos              |

### Recursos Documentales Disponibles

El sitio oficial ofrece:

- [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)
- [MOSIX Administrator's Guide (PDF)](http://www.mosix.cs.huji.ac.il/pub/Guide.pdf)
- [MOSIX White Paper (PDF)](http://www.mosix.cs.huji.ac.il/pub/MOSIX_wp.pdf)
- Lista de publicaciones académicas técnicas

### Historial de Precios (Obsoleto)

Según documentación histórica de **USENIX (2000)**, existían estos valores para un cluster de producción:

> ⚠ **$61,141.25 USD** correspondía a **LSF** (Load Sharing Facility), no a MOSIX. MOSIX era gratuito para uso académico en 2000.

⚠️ **ESTA INFORMACIÓN ES OBSOLETA Y NO VERIFICABLE EN 2026.** No hay confirmación de que estos precios sigan vigentes o que el soporte aún esté disponible.

### Recomendación

Para información actualizada sobre licenciamiento o soporte, se recomienda contactar directamente a los desarrolladores en: **mosix@cs.huji.ac.il**

---

## Estado Actual del Proyecto (Mayo 2026)

### Veredicto: **Proyecto Esencialmente Inactivo**

| Indicador                         | Estado                              |
| --------------------------------- | ----------------------------------- |
| **Último release**                | MOSIX-4.4.4 (24 de octubre de 2017) |
| **Antigüedad del último release** | Más de **8 años**                   |
| **Desarrollo activo**             | ❌ No                               |
| **Soporte comercial**             | ❌ No                               |
| **Sitio web funcional**           | ✅ Sí (pero sin actualizaciones)    |
| **Documentación actualizada**     | ❌ No                               |

### Análisis de Actividad

**Uso histórico documentado:**

- Un post de **LinkedIn (2022)** menciona que Mike Kemelmakher (VP Product en Majestic Labs) diseñó y administró clusters HPC basados en Linux y MOSIX, indicando uso en entornos de producción historically
- Un post de **Facebook (diciembre 2022)** indica que MOSIX "tiene buena reputación y no hay tarifa de licencia para uso no comercial"
- **No se encontraron casos de uso en producción documentados después de 2017**

### Posicionamiento en el Ecosistema HPC Moderno

MOSIX ha sido **superdado por tecnologías modernas**:

| Tecnología     | Tipo                             | Estado     | Adopción HPC     |
| -------------- | -------------------------------- | ---------- | ---------------- |
| **MOSIX**      | Migración de procesos (nivel SO) | Inactivo   | Nula (histórico) |
| **SLURM**      | Job scheduling                   | Muy activo | >60% Top500      |
| **Kubernetes** | Orquestación de contenedores     | Muy activo | Creciente        |
| **OpenMPI**    | Comunicación MPI                 | Muy activo | Muy amplia       |

### ¿Tiene Sentido Usar MOSIX en 2026?

**NO, por las siguientes razones:**

1. ❌ **Sin soporte activo:** 8+ años sin actualizaciones de seguridad ni compatibilidad con kernels modernos
2. ❌ **Modelo obsoleto:** La migración de procesos a nivel kernel es incompatible con el paradigma moderno de contenedores
3. ❌ **Sin memoria compartida:** Limitación crítica para aplicaciones HPC modernas
4. ❌ **Licencia restrictiva:** Contrasta con alternativas open source con soporte comercial activo
5. ❌ **Sin comunidad:** No hay foros activos ni soporte de comunidad

**SÍ, solo para contextos académicos/educativos:**

- Caso de estudio histórico de migración de procesos
- Introducción a conceptos de Single System Image (SSI)
- Entendimiento de la evolución tecnológica hacia contenedores

### Conclusión Final sobre el Estado del Proyecto

MOSIX es un **proyecto de investigación históricamente significativo pero técnicamente obsoleto**. Representa una era de cluster computing anterior a los contenedores y orchestrators modernos. Para uso académico e histórico sigue siendo relevante como material de estudio; para implementación en producción moderna, **no se recomienda**.

**Fuentes:**

- [MOSIX Official Site](http://www.mosix.org/)
- [MOSIX Changelog - Last update 2017](https://mosix.cs.huji.ac.il/txt_changelog.html)
- [Wikipedia - MOSIX](https://en.wikipedia.org/wiki/MOSIX)
- [Facebook Group - Best distro for cluster computing 2022](https://www.facebook.com/groups/GNUAndLinux/posts/10167823624740019/)

---

## Resumen Ejecutivo

| Aspecto                      | Detalle                                                                         |
| ---------------------------- | ------------------------------------------------------------------------------- |
| **Organización responsable** | Grupo de Investigación en Sistemas Distribuidos, Hebrew University of Jerusalem |
| **Investigador principal**   | Prof. Amnon Barak                                                               |
| **Tipo de proyecto**         | Investigación académica (no empresa comercial)                                  |
| **Origen**                   | 1977 (como MOS), evolución continua hasta 2017                                  |
| **Modelo de licencia**       | Propietario restrictivo (sin modificaciones ni derivados)                       |
| **Fork open source**         | openMosix (2002-2008), luego LinuxPMI (discontinuado)                           |
| **Soporte comercial**        | No disponible                                                                   |
| **Último release**           | MOSIX-4.4.4 (octubre 2017)                                                      |
| **Estado actual**            | Inactivo (sin desarrollo desde 2017)                                            |
| **Relevancia actual**        | Histórica/académica (no recomendada para producción)                            |

---

## Fuentes

1. [History of MOSIX - Hebrew University](https://mosix.cs.huji.ac.il/txt_history.html)
2. [Wikipedia: MOSIX](https://en.wikipedia.org/wiki/MOSIX)
3. [Wikipedia: OpenMosix](https://en.wikipedia.org/wiki/OpenMosix)
4. [MOSIX Distributions - Licensing](https://mosix.cs.huji.ac.il/txt_distributions.html)
5. [MOSIX Official Site](http://www.mosix.org/)
6. [MOSIX Changelog](https://mosix.cs.huji.ac.il/txt_changelog.html)
7. [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)
8. [MOSIX Administrator's Guide](http://www.mosix.cs.huji.ac.il/pub/Guide.pdf)
9. [MOSIX White Paper](http://www.mosix.cs.huji.ac.il/pub/MOSIX_wp.pdf)
10. [Prof. Amnon Barak - HUJI](https://www.cs.huji.ac.il/~amnon)
11. [Amnon Barak - DBLP](https://dblp.org/pid/b/AmnonBarak)
12. [Amnon Barak - ResearchGate](https://www.researchgate.net/scientific-contributions/Amnon-Barak-8110256)
13. [OpenMosix Is Shutting Down - Slashdot](https://linux.slashdot.org/story/07/07/17/2342252/openmosix-is-shutting-down)
14. [USENIX Documentation 2000 - Historical pricing (obsoleto)](https://www.usenix.org/02/archive/highlights/html/mosix.html)

---

_Documento elaborado para Fundamentos de Sistemas Operativos — Mayo 2026_
_Basado en investigación existente y fuentes oficiales de MOSIX y publicaciones académicas._

---

## Nota Académica — Fundamentos de SO

**Conceptos de la materia relacionados:**

- **§1.1 — Máquina Extendida (gestor de recursos)**: MOSIX implementa el concepto de **Single System Image (SSI)** — transparently haciendo que un cluster de computadoras aparezca como una única máquina. Esto materializa la noción de SO como gestor de recursos: MOSIX migra procesos entre nodos, balancea carga, y distribuye memoria de forma transparente al usuario. El concepto de "máquina extendida" se lleva al extremo: extiende un cluster heterogeneous hacia una única máquina virtualizada a nivel de SO.

- **§1.1 — Gestor de Recursos**: MOSIX fue pionera en **migración preemptiva de procesos** — moviendo procesos en ejecución entre nodos sin interrumpirlos. Esto representa una forma avanzada de gestión de recursos donde el SO (MOSIX) decide dinámicamente dónde ejecutar cada proceso basándose en carga, disponibilidad de memoria, y latencia de red. Es un caso de estudio de gestión adaptativa de recursos.

- **§1.4 — Arquitectura Monolítica vs Distribuida**: MOSIX opera como una **capa sobre el kernel Linux** (parche o módulo desde 2014). Académicamente, esto lo posiciona como una arquitectura híbrida: no es microkernel puro ni monolítico tradicional, sino un "overlay" que extiende las capacidades del kernel. Estudiar MOSIX ayuda a entender cómo se construyen funcionalidades de SO sobre abstracciones existentes sin modificar el kernel base — contraste con cómo LinuxPMI/LKM permiten loadable kernel modules.

- **§1.4 — Arquitecturas de SO (evolución histórica)**: La cronología de MOSIX (1977-2017) es un caso de estudio de evolución de arquitecturas de SO. Comenzó en PDP-11 (8-bit, arquitectura simple), evolucionó con NS32332, luego x86, y finalmente migró a Linux (1999). Esta trayectoria refleja los cambios generacionales del temario §1.2: desde sistemas batch/tiempo compartido hacia sistemas distribuidos modernos.

- **§1.5 — Modo Dual (kernel vs usuario)**: La migración de procesos a nivel kernel en MOSIX involucra zonas críticas donde el código corre en **modo kernel** para manipular estado de procesos. El modelo de MOSIXdepende de que el kernel Linux provea primitives de bajo nivel (schedule, migrate) accesibles solo en modo privilegiado. Entender MOSIX ilumina cómo funciona la transición kernel↔user en contextos de clustering.

- **§1.2 — Generaciones de SO (4ª y 5ª)**: MOSIX nació en la era de la 4ª generación (1980s-1990s: microprocesadores, clusters, UNIX) y se volvió obsoleto en la era de la 5ª generación (móvil, nube, contenedores). Su obsolescencia (2017+) se debe a que el paradigma de migración de procesos a nivel kernel fue superado por contenedores y orchestrators (Kubernetes). Esto conecta directamente con la evolución generacional del temario.
