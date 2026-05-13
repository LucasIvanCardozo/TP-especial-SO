# Slide 04 — Resumen: La Empresa MOSIX

## ¿Qué es MOSIX?

MOSIX es un proyecto de investigación universitaria para crear un **cluster de computadoras que parezca una única máquina** (Single System Image). Fue desarrollado por la Hebrew University of Jerusalem entre 1977 y 2017.

---

## 1. Origen: Hebrew University of Jerusalem

- **Universidad**: Hebrew University of Jerusalem (fundada en 1918)
- **Investigador principal**: Prof. Amnon Barak
  - 71 publicaciones, ~1.662 citas
  - Investigación en sistemas distribuidos y paralelos
- **Grupo**: Distributed Systems Research Group

Israel tiene alta concentración de empresas tecnológicas (Intel, IBM, Microsoft, Google tienen centros de I+D allí), lo que impulsa la investigación en sistemas distribuidos.

---

## 2. Cronología de MOSIX

| Período | Hito |
|---------|------|
| 1977-1979 | Inicio en PDP-11/45 con Unix v6 — primera demostración de migración de procesos |
| 1981-1983 | MOS (antecesor de MOSIX) — cluster de 5 PDP-11 |
| 1988-1989 | Primer cluster llamado "MOSIX" — 16 nodos NS32532 |
| 1991-1993 | MOSIX v6 — cluster de 8 equipos 486 y 32 Pentium con Myrinet |
| 1998-1999 | MOSIX v7 — primera versión para Linux 2.2, cluster de 64 nodos |
| 1999 | Transición definitiva a Linux (por su crecimiento y licencia GPL) |
| 2001 | **MOSIX se vuelve propietario** — código cerrado |
| 2002 | Moshe Bar crea **openMosix** (fork open source) |
| 2004-2006 | MOSIX-2 / v10 — soporte para multiclusters y grids |
| 2007 | openMosix discontinuado |
| 2014 | MOSIX-4 — **ya no requiere parche de kernel** (funciona como módulo) |
| Oct 2017 | Último release: **MOSIX-4.4.4** |
| Post-2017 | Sin desarrollo activo ni soporte |

---

## 3. Modelo de Licencia

MOSIX es **software propietario** con licencia restrictiva que **prohíbe**:
- ❌ Modificar el software
- ❌ Realizar ingeniería reversa
- ❌ Crear obras derivadas
- ❌ Las contribuciones son propiedad del Prof. Amnon Barak

**Comparación con alternativas:**

| Aspecto | MOSIX | openMosix (fork GPL) | Kubernetes |
|---------|-------|---------------------|------------|
| Código fuente disponible | No | Sí | Sí |
| Modificar/crear derivados | No | Sí | Sí |
| Uso comercial | Restringido | Sí | Sí |
| Último release | 2017 | ~2008 | Activo |

**openMosix**: Fork creado en 2002 cuando MOSIX se volvió propietario. Desarrollado hasta 2008. Continuó la visión open source pero está discontinuado.

---

## 4. Single System Image (SSI) — Concepto Central

**Definición**: Un cluster que aparece como **una única máquina lógica** para usuarios y aplicaciones.

En un sistema SSI:
- Un único sistema de archivos
- Procesos pueden ejecutarse en cualquier nodo sin solicitud explícita
- Memoria de todos los nodos parece compartida (aunque está distribuida)
- No es necesario saber qué nodo ejecuta qué proceso

**Relación con objetivos del SO** (§1.1 del temario):
- **Máquina extendida**: SSI oculta la complejidad de múltiples computadoras
- **Gestor de recursos**: MOSIX migra procesos, balancea carga, distribuye memoria

---

## 5. Cluster OS vs RTOS

### RTOS (Real-Time Operating System)
- **Objetivo**: Tiempo de respuesta garantizado y predecible
- **Características**: Determinismo, latencia predecible, prioridad fija
- **Ejemplos**: FreeRTOS, VxWorks, QNX
- **Uso**: Sistemas embebidos críticos (automotriz, aeroespacial, médico)

### Cluster OS
- **Objetivo**: Computación de alto rendimiento (HPC)
- **Características**: SSI, migración de procesos dinámica, balanceo de carga
- **Ejemplos**: MOSIX, openMosix, SLURM

### Diferencias clave

| Aspecto | RTOS | Cluster OS |
|---------|------|------------|
| Objetivo primario | Determinismo temporal | Alto throughput |
| Migración de procesos | No o fija | Sí, dinámica |
| Latencia | Predecible | Variable |
| Aplicaciones | Embebido crítico | HPC, computación científica |

**MOSIX es Cluster OS, no RTOS** porque:
- No garantiza tiempo real
- Optimiza throughput, no determinismo
- Usa balanceo de carga (no priority fixed scheduling)
- Apunta a clusters de workstations/servers

---

## 6. Conexión con el Temario FSO

| Tema del Temario | Relación con MOSIX |
|-----------------|-------------------|
| §1.1 — Máquina extendida/gestor de recursos | SSI + migración de procesos |
| §1.2 — Generaciones de SO | Nació en 4ª gen (clusters, Linux) |
| §1.4 — Arquitecturas de SO | Opera como capa sobre kernel Linux (módulo/overlay) |
| §1.5 — Modo dual | Migración requiere modo kernel |
| §2 — Administración del procesador | Scheduling distribuido (decide dónde ejecutar cada proceso) |

---

## 7. Estado Actual (2026)

| Indicador | Estado |
|-----------|--------|
| Último release | MOSIX-4.4.4 (oct 2017) — más de 8 años |
| Desarrollo activo | ❌ No |
| Soporte/comunidad | ❌ No |
| Compatibilidad kernel moderno | Limitada (hasta Linux 4.X) |

**Tecnologías que lo reemplazaron:**
- **SLURM**: Job scheduling (>60% de Top500)
- **Kubernetes**: Orquestación de contenedores
- **OpenMPI**: Comunicación MPI

**No recomendado para producción** por: falta de soporte, incompatibilidad con contenedores, licencia restrictiva.

**Aún valioso como**:
- Caso de estudio de evolución de arquitecturas distribuidas (40 años)
- Ejemplo de SSI
- Lección sobre decisiones de licenciamiento

---

## 8. Glosario

- **HPC (High Performance Computing)**: Uso de múltiples computadoras para resolver problemas intensivo
- **SSI (Single System Image)**: Cluster que parece una única máquina
- **Migración de procesos**: Mover un proceso en ejecución entre nodos sin que lo note
- **Balanceo de carga**: Distribuir trabajos dinámicamente para evitar nodos sobrecargados
- **Cluster OS**: SO que administra un cluster como sistema unificado

---

## Síntesis

MOSIX (1977-2017) demuestra:
1. Investigación académica puede producir tecnología operativa real
2. Las decisiones de licenciamiento tienen consecuencias a largo plazo (cierre 2001 → openMosix)
3. Los paradigmas cambian: contenedores reemplazaron migración a nivel kernel
4. El concepto de SSI sigue válido aunque implementado de formas diferentes

---

*Resumen para Fundamentos de Sistemas Operativos — Mayo 2026*
