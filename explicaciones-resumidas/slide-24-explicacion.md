# Resumen: MOSIX — Casos de Uso

## ¿Qué era MOSIX?

MOSIX era una tecnología (1990s-2017) que permitía convertir un cluster de computadoras en un **único sistema virtual** (Single System Image - SSI). El cluster se comportaba como una sola máquina Linux giant, distribuyendo procesos automáticamente sin que el usuario necesitara saber dónde se ejecutaban.

---

## Casos de Uso Históricos (1990s-2000s)

### 1. HPC Clusters (Investigación Científica)
Clusters de computadoras de alto rendimiento interconectadas por redes rápidas (InfiniBand/Gigabit Ethernet). MOSIX los hacía aparecer como una única máquina.

- **Apto para**: simulaciones computacionales, dinámica de fluidos (CFD), modelos climáticos
- **Característica clave**: procesos CPU-bound se beneficiaban enormemente del balanceo automático
- En redes de 1 Gbit/s, el rendimiento era "casi idéntico al de un cluster único"

### 2. Grids Académicos Universitarios
Múltiples universidades comparten recursos computacionales bajo políticas de uso conjuntas.

- **Confianza mutua**: los nodos remotos debían ser confiables porque los procesos migrados se ejecutaban en sandbox seguro
- Las instituciones combinaban recursos para problemas que ninguna podía resolver sola

### 3. Genómica y Proteómica
Análisis de secuencias de ADN y proteínas.

- **Por qué MOSIX era adecuado**:
  - Aplicaciones CPU-bound (no intensivas en E/S)
  - Análisis de días o semanas → la migración preemptiva permitía balanceo dinámico
  - Memory Ushering se adaptaba a patrones de memoria impredecibles

### 4. Dinámica Molecular
Simula el movimiento de átomos y moléculas para:
- Descubrimiento de fármacos (docking molecular)
- Ciencia de materiales
- Bioquímica (folding de proteínas)

- **Problema resuelto**: si un nodo se desconectaba o sobrecargaba, el proceso migraba sin perder estado de simulación

### 5. Predicción Meteorológica
Modelos que resuelven ecuaciones diferenciales sobre dominios 3D con alta resolución.

- MOSIX combinaba nodos de diferentes velocidades y distribuía carga proporcionalmente

### 6. Nanotecnología
Simulaciones a nivel atómico y molecular.

- **Memory Ushering era valioso**: detectaba nodos sin memoria y migraba procesos antes del swap

---

## Estado Actual (2026) — Proyecto Inactivo

| Aspecto | Situación |
|--------|-----------|
| **Última versión** | MOSIX-4.4.4 (24 octubre 2017) |
| **Actualizaciones** | Ninguna desde hace más de 8 años |
| **Parches de seguridad** | Zero — vulnerabilidades conocidas nunca cerradas |
| **Soporte comercial** | No disponible |
| **Contenedores/K8s** | Incompatible |

### ¿Por qué no es viable?

1. **Seguridad**: Sin parches desde 2017 → brechas garantizadas
2. **Incompatibilidad con contenedores**: Docker/Kubernetes usan cgroups y namespaces; la migración de procesos MOSIX rompe este aislamiento
3. **Alternativas superiores**: SLURM, Kubernetes, PBS Professional, LSF tienen desarrollo activo y soporte comercial

---

## Valor Académico (lo que se preserva)

| Concepto | Qué es | Relevancia actual |
|---------|--------|-------------------|
| **Migración Preemptiva** | Mover un proceso en ejecución de un nodo a otro sin que lo solicite | Live migration de VMs en clouds, HPC schedulers |
| **Single System Image (SSI)** | Cluster presentado como un único sistema | Kubernetes, MapReduce/Hadoop, servicios cloud |
| **Balanceo de Carga Automático** | Redistribución dinámica de procesos según carga de CPU, memoria, red | Conceptos de scheduling modernos |

---

## Conexiones con el Temario de FSO

- **§1.1 — SO como Gestor de Recursos**: MOSIX extiende gestión de CPU, memoria y red al cluster completo
- **§1.4 — Arquitecturas de SO**: Representa arquitectura distribuida donde "sistema" abarca múltiples máquinas
- **§2.1 — Multiprogramación**: El scheduling se extiende a decidir **en qué nodo** ejecutar cada proceso
- **§4.1 — Memoria Distribuida**: Memory Ushering extiende administración de memoria al contexto distribuido

---

## Glosario Rápido

- **HPC Cluster**: Conjunto de computadoras interconectadas para cómputo paralelo de alto rendimiento
- **SSI (Single System Image)**: Abstracción donde un cluster parece una sola máquina
- **Memory Ushering**: Algoritmo de MOSIX que migra procesos proactivamente antes del swapping
- **Migración Preemptiva**: Traslado de proceso en ejecución sin cooperación del proceso
- **Contenedores**: Virtualización a nivel de SO (cgroups/namespaces) — estándar actual de deployment

---

## Conclusión

MOSIX fue revolucionario en su época (1990s-2000s) por su SSI y migración preemptiva. **No debe usarse en producción** por seguridad y obsolescencia. **Su valor académico permanece**: conceptos fundamentales para sistemas distribuidos modernos.