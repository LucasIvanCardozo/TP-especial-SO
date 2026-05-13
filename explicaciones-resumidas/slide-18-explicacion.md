# Slide 18 — Resumen: MOSIX — Fortalezas y Debilidades

## ¿Qué es MOSIX?

MOSIX es un **Sistema Operativo de Cluster** (Cluster OS) desarrollado en la Hebrew University of Jerusalem. Su objetivo principal era convertir un grupo de computadoras (cluster) en un único sistema lógico mediante **Single System Image (SSI)**.

A diferencia de schedulers como SLURM, MOSIX funcionaba como una **extensión del kernel Linux** que permitía la **migración preemptiva de procesos**: mover procesos en ejecución de un nodo a otro sin que la aplicación lo percibiera.

---

## Fortalezas de MOSIX

### 1. Migración Transparente de Procesos
- Un proceso en ejecución podía moverse de un nodo a otro de forma preemptiva (el sistema lo decidía solo)
- Funcionaba así: el nodo origen detectaba que otro tenía menos carga → se copiaba el estado del proceso → se reanudaba en el destino como si nunca hubiera cambiado
- **No requería cambios en el código de la aplicación**: cualquier binario ELF de Linux funcionaba

### 2. Single System Image (SSI)
- El cluster se presentaba como un solo sistema operativo
- `ps` mostraba procesos de todos los nodos
- `top` mostraba la carga agregada del cluster
- El usuario no necesitaba saber en qué nodo corría su proceso

### 3. Zero-Code-Change Porting
- Binarios Linux compilados funcionaban sin recompilación ni librerías especiales
- Un `python mi_script.py` o un executable compilado con `gcc` funcionaba tal cual
- Se ejecutaba con `mosrun ./mi_programa` y MOSIX decidía dónde ejecutarlo

### 4. Tecnología Pionera (1999)
- **Primer sistema operativo de cluster** en demostrar migración preemptiva funcional
- Paper seminal de Bar et al. (1998-1999) demostró viabilidad en clusters de PCs con Myrinet
- Antes de MOSIX: clusters gestionados manualmente con `rsh`/`ssh`, migración era solo teoría

### Cronología histórica:
- 1977-1979: MOS (primera versión, PDP-11)
- 1988-1989: MOSIX (cluster de 16 nodos)
- 1998-1999: MOSIX v7 para Linux (64 nodos con Myrinet)
- 2001: openMosix fork (MOSIX se volvió propietario)
- 2017: Última versión (MOSIX-4.4.4)

---

## Debilidades de MOSIX

### 1. Inactivo desde octubre 2017
- Sin parches de seguridad para kernels modernos
- Sin compatibilidad con kernels 5.x o 6.x
- Sin soporte oficial ni comunidad activa

### 2. Código Propietario
- Prohibía modificar, hacer ingeniería reversa o crear obras derivadas
- En 2001, Moshe Bar bifurcó el código para crear **openMosix** (open source)
- openMosix sobrevivió hasta 2008, luego continuado como **LinuxPMI** hasta ~2012
- **Moraleja**: las soluciones open source sobreviven a sus creadores; las propietarias mueren cuando desaparece el financiamiento

### 3. Solo x86_64
- Sin soporte para ARM64 (Apple Silicon, AWS Graviton), RISC-V, POWER, SPARC
- Limitación crítica en 2026 donde ARM64 domina clouds públicos

### 4. Sin Soporte para Threads
- Podía migrar procesos individuales, pero **no threads dentro de un proceso**
- Aplicaciones multithread (servidores web, bases de datos, frameworks de ML) no eran compatibles

### 5. Competidores Modernos lo Superaron
- **SLURM**: >60% de Top500 supercomputadoras, open source, funciona a nivel usuario (no requiere parches de kernel)
- **Kubernetes**: estándar para cloud computing, contenedores portable entre clouds
- Ambos resuelven problemas más simples pero de forma más robusta

---

## Comparativa con Otras Soluciones

| Aspecto | MOSIX | SLURM | Kubernetes |
|---------|-------|-------|------------|
| **Migración live** | ✅ Sí | ❌ No | ❌ No |
| **Single System Image** | ✅ Completo | ❌ No | ❌ No |
| **Licencia** | Propietaria | GPL | Apache 2.0 |
| **Adopción Top500** | 0% | >60% | N/A |
| **Threads** | ❌ No | ✅ Sí | ✅ Sí |
| **Estado** | Inactivo (2017) | Activo | Muy activo |

**¿Por qué ganó SLURM sobre MOSIX?**
1. Modelo más simple: no necesita modificar el kernel
2. Open source: la comunidad puede contribuir
3. Enfoque pragmático: re-scheduling cuando el job termina
4. Integración nativa con MPI

---

## Conexión con la Evolución de Sistemas

### Evolución arquitectónica:

| Período | Tecnología | Enfoque |
|---------|------------|---------|
| 1990s | MOSIX (kernel patches) | "Todo en el kernel" |
| 2000s | LinuxPMI (kernel modules) | "Módulo cargable" |
| 2010s | Containers (cgroups/namespaces) | "Aislamiento en espacio de usuario" |
| 2020s | Kubernetes + SLURM hybrid | "Orquestación a nivel aplicación" |

La tendencia fue desde soluciones kernel-level hacia soluciones user-level porque **es más fácil mantener y actualizar software que corre en espacio de usuario**.

### ¿Por qué cambiaron los paradigmas?
1. **Migración de procesos es pesada**: copiar todo el espacio de direcciones, estado de CPU, descriptores de archivos
2. **Kernel Linux evolucionó**: cgroups y namespaces hicieron innecesario parchear el kernel
3. **Comunidad open source**: SLURM tiene cientos de contribuidores, Kubernetes miles

---

## Glosario Rápido

- **SSI (Single System Image)**: El cluster se presenta como un solo sistema con visión unificada de recursos
- **Migración preemptiva**: El sistema decide migrar un proceso sin que el proceso lo solicite
- **Memory Ushering**: Algoritmo de MOSIX que anticipa problemas de memoria migrando procesos antes del page fault
- **Cluster OS**: Software que gestiona múltiples nodos como un sistema integrado (ej: MOSIX)
- **Job Scheduler**: Solo asigna recursos a jobs (ej: SLURM, PBS)
- **Orquestador**: Gestiona ciclo de vida de aplicaciones distribuidas (ej: Kubernetes)

---

## ¿Qué usar en producción (2026)?

| Necesidad | Tecnología |
|-----------|------------|
| HPC clásico | SLURM + OpenMPI |
| Cloud-native / microservicios | Kubernetes |
| Contenedores en HPC | SLURM + Docker/Kubernetes |
| Aprender migración de procesos | MOSIX (contexto académico) |

---

## Conclusión

MOSIX fue un sistema innovador que resolvió un problema difícil (migración transparente) con una solución elegante pero frágil (parches de kernel). La evolución hacia containers y schedulers demuestra que **la industria prefiere soluciones pragmáticas a elegantes**: SLURM no hace migración live, pero funciona y se mantiene. Kubernetes no proporciona SSI, pero es portable y escalable.

**Patrón común**: el diseño "perfecto" que requiere control total del sistema suele ser superado por soluciones "imperfectas" que funcionan dentro de los límites del ecosistema existente.