# Slide 20 — MOSIX: Difusión, Declive y Valor Académico

## Contexto

MOSIX fue un proyecto de investigación del **Grupo de Sistemas Distribuidos de la Hebrew University of Jerusalem** (Prof. Amnon Barak). Buscaba convertir un cluster de PCs comunes en una "supercomputadora virtual". Aunque técnicamente funcional, quedó obsoleto frente a alternativas modernas y hoy solo tiene valor académico.

---

## Qué es MOSIX

- **Propósito**: Crear un cluster que parezca una sola computadora (Single System Image - SSI)
- **Cómo funcionaba**: Migración de procesos entre nodos — un proceso en ejecución se mueve de un nodo a otro manteniendo su estado completo
- **Innovación**: Balanceo de carga automático sin intervención del operador
- **Limitación clave**: Requería parchar el kernel de Linux (modificaciones profundas al SO)

---

## Línea de Tiempo

| Año | Evento |
|-----|--------|
| Años 1990s | Creación en Hebrew University de Jerusalem |
| 1997 | Cluster de 88 servidores Pentium II/Pro para investigación (ProtoNet/bioinformática) |
| 1999-2010 | Pico de adopción académica (Columbia, TU Dresden, Hebrew U) |
| 2002 | Fork openMosix (versión GPL) — divide la comunidad |
| 2008 | openMosix se discontinua por falta de mantenedores |
| 2014 | MOSIX-4 elimina la necesidad de parchar el kernel (ya demasiado tarde) |
| Oct 2017 | Última versión (MOSIX-4.4.4) — proyecto inactivo desde entonces |

---

## Aplicaciones Académicas Documentadas (1999-2010)

- Genómica y bioinformática (secuenciación de proteínas)
- Dinámica molecular y simulaciones nanométricas
- CFD (simulación de fluidos)
- Predicción meteorológica
- Crash testing automotriz
- Diseño de ASICs (circuitos integrados)

---

## Por qué Declinó — Razones Técnicas

### 1. Modelo Propietario sin Comunidad
- No tener licencia open source impidió formar una comunidad activa
- **Contraste**: SLURM (GPL) → comunidad fuerte + soporte comercial (SchedMD)
- **Contraste**: Kubernetes (Apache 2.0) → CNCF masiva

### 2. Incompatible con Contenedores
- MOSIX opera a nivel de **kernel** (migración de procesos)
- Docker/Kubernetes operan a nivel de **aplicación**
- Los contenedores son más ligeros y no necesitan modificar el kernel
- En 2014, el paradigma ya se había shifted hacia contenedores

### 3. Limitaciones Técnicas
- No soporta threads de forma nativa
- No ofrece memoria compartida distribuida (DSM)
- Sin acceso estándar a GPUs
-这些问题 son requisitos estándar en HPC moderno

### 4. Competencia Superior
- **SLURM**: >60% de Top500, job scheduling profesional sin modificar kernel
- **Kubernetes**: Dominio cloud-native, orquestación universal
- **MOSIX**: 0% en Top500, cero adopción en producción moderna

---

## Conceptos Clave

### Single System Image (SSI)
Un cluster que se comporta como **una única máquina**. El usuario no sabe que hay múltiples nodos. MOSIX pioneering esta idea, pero requería modificaciones invasivas al kernel.

### Migración de Procesos
Mover un proceso en ejecución de un nodo a otro，带着 su contexto completo (PCB transferred). Permite balanceo de carga automático.

### Job Scheduling vs Migración
- **MOSIX**: Migración preemptiva automática (el sistema decide)
- **SLURM**: Job scheduling profesional (el operador decide)
- **Kubernetes**: Orquestación de contenedores (deploys explícitos)

---

## Glosario

- **HPC Cluster**: Grupo de computadoras trabajando juntas como un único sistema para cómputo paralelo masivo
- **SSI (Single System Image)**: Abstracción donde un cluster parece una sola máquina
- **Top500**: Ranking semestral de las 500 supercomputadoras más poderosas del mundo (benchmark Linpack)
- **Contenedores**: Tecnología que empaqueta aplicaciones con sus dependencias para ejecución portable

---

## Valor Académico Actual

MOSIX **no es tecnología de producción** (cero casos modernos), pero sigue siendo útil en educación para entender:

1. **Concepto de SSI** — implementación real de cluster como máquina única
2. **Migración de procesos** — PCB transferido con estado completo
3. **Evolución de HPC** — Transición: Beowulf → MOSIX → SLURM → Kubernetes
4. **Lección histórica**: Una tecnología válidad académicamente puede quedar obsoleta si no tiene comunidad ni modelo de negocio viable

---

## Comparación Final

| Aspecto | MOSIX | SLURM | Kubernetes |
|---------|-------|-------|------------|
| Migración live | Sí (procesos) | No (re-scheduling) | No (experimental) |
| SSI | Sí completo | No | No |
| Licencia | Propietaria | GPL | Apache 2.0 |
| Estado | Inactivo (2017) | Activo | Activo |
| Top500 | 0% | >60% | Creciente |
| Soporte comercial | No | SchedMD | Multi-vendor |

---

## Conclusión

MOSIX fue un proyecto de investigación válido (1990-2010) que pioneering la idea de Single System Image. Sin embargo, perdió porque:
- El modelo propietario impidió formar comunidad
- La arquitectura a nivel kernel es incompatible con el paradigma de contenedores
- SLURM y Kubernetes ofrecieron alternativas superiores con comunidades activas

**Su legado**: Caso de estudio de cómo una tecnología técnicamente válida puede volverse obsoleta por factores no técnicos (modelo de negocio, comunidad, Timing).

---

*Fuente: informacion/C-Puertas-Afuera/difusion-presencia-mosix.md + slide-20.js*