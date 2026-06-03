# Slide 05 — MOSIX: Historia, Origen y Mercado

## 🎤 Guía de Exposición (Qué decir)

### Apertura (10 seg)

"A diferencia de Zephyr, que tiene respaldo corporativo de la Linux Foundation, MOSIX nació y creció en un ámbito puramente académico: el laboratorio del Profesor Amnon Barak en la Hebrew University of Jerusalem."

---

### Origen Académico (15 seg)

"MOSIX fue desarrollado por el **Grupo de Investigación en Sistemas Distribuidos** de la **Hebrew University of Jerusalem**, en Israel."

"El líder fue el **Profesor Amnon Barak**, quien dirigió el desarrollo desde los años 70 hasta 2017."

"Esto es clave: MOSIX **no fue diseñado para venderse como producto comercial**. Nació para estudiar y demostrar conceptos de sistemas operativos distribuidos, especialmente la **migración preemptiva de procesos**."

---

### Línea de Tiempo (25 seg)

"MOSIX tiene más de **40 años de historia**:

| Período | Evento | Detalle |
|---------|--------|---------|
| **1977** | Primeros experimentos | En PDP-11, una minicomputadora de los años 70 con apenas 8 KB de RAM |
| **1988-1989** | Nace MOSIX | Cluster de 16 nodos |
| **1998-1999** | Transición a Linux | Reescriben MOSIX para funcionar sobre Linux. Permiten cluster de 64 nodos |
| **2001** | Se vuelve propietario | Código cerrado con licencia restrictiva (nunca fue open source) |
| **2014** | No requiere parche | Funciona como módulo de kernel — se instala sin modificar Linux |
| **Oct 2017** | Último release | MOSIX-4.4.4 — proyecto inactivo desde entonces |

---

### Segmento de Mercado (15 seg)

"MOSIX apuntaba al mercado de **HPC** (Computación de Alto Rendimiento):

- Investigación científica
- Clusters universitarios
- Simulaciones de gran escala
- Supercomputadoras (Top500)

**Competidores de la época:**
- SLURM (gestor de clusters)
- Kubernetes moderno (contenedores)
- MPI (Message Passing Interface)

**Hoy está superado** por tecnologías como Kubernetes y contenedores, que ofrecen capacidades similares con mayor flexibilidad."

---

### Por qué quedó inactivo (10 seg)

"La respuesta: el paradigma cambió.

MOSIX funcionaba a nivel de **kernel** — migraba procesos directamente entre nodos. Esto es incompatible con **contenedores** (Docker, Kubernetes), que son el estándar actual.

Los contenedores aislan aplicaciones a nivel de SO, no a nivel de kernel. MOSIX no podía adaptarse a ese modelo."

---

### Transición (5 seg)

"Ahora que entendemos el origen de ambos sistemas, veamos cómo están diseñados internamente. Empezamos por el kernel de Zephyr..."

---

## 📝 Glosario Rápido

| Término | Significado |
|---------|-------------|
| **HPC** | Computación de Alto Rendimiento — resolver problemas grandes con muchos nodos |
| **PDP-11** | Minicomputadora de los años 70 (4-64 KB RAM) — hardware donde empezó MOSIX |
| **Migración preemptiva** | Mover un proceso en ejecución de un nodo a otro sin interrumpirlo |
| **Cluster** | Grupo de computadoras conectadas trabajando juntas |
| **Nodo** | Cada computadora individual dentro del cluster |
| **SSI** | Single System Image — cluster que parece una sola máquina |
| **Módulo de kernel** | Código que se carga al kernel de Linux para extenderlo (como un plugin) |
| **Parche de kernel** | Modificación al código de Linux — antes MOSIX lo necesitaba, ahora no |

---

## 📌 Puntos Clave

1. **Origen puramente académico** — laboratorio universitario, no empresa
2. **+40 años de historia** (1977-2017)
3. **Profesor Amnon Barak** — líder del proyecto
4. **NUNCA fue open source** — siempre fue propietario
5. **Mercado: HPC** — clusters de investigación, supercomputadoras
6. **En 2014 se volvió más fácil de instalar** — funciona como módulo sin parche
7. **Inactivo desde 2017** — superado por Kubernetes y contenedores
8. **Modelo de kernel** vs **modelo de contenedores** — incompatibilidad

---

## ⚠️ Errores a Evitar

| ❌ NO decir | ✅ Decir |
|-------------|----------|
| "MOSIX compite con Zephyr" | "No compiten — son para mercados distintos" |
| "MOSIX sigue activo" | "Inactivo desde octubre 2017" |
| "MOSIX era open source" | "Nunca fue open source — siempre propietario" |
| "MOSIX funcionaba con contenedores" | "Funcionaba a nivel de kernel, incompatible con contenedores" |
| "openMosix es lo mismo que MOSIX" | "openMosix fue un fork en 2002 — alternativa open source que también está discontinuada" |

---

## 🔗 Relación con FSO

| Concepto | Cómo se manifiesta |
|----------|-------------------|
| **§1.4 — Arquitectura** | MOSIX opera como overlay sobre Linux (híbrida) |
| **§2.1 — Scheduling** | Scheduling distribuido: migra procesos entre nodos |
| **§2.3 — Procesos** | Migración preemptiva: PCB se transfiere entre nodos |
| **§1.3 — Distribuidos** | Cada nodo tiene CPU, memoria, disco propios (shared-nothing) |
| **§1.2 — Generaciones** | Nació en era de clusters (4ª gen), quedó obsoleto en era de contenedores (5ª gen) |

---

## ⏱️ Tiempo Total: 60-80 segundos

- 10 seg: apertura
- 15 seg: origen académico
- 25 seg: línea de tiempo
- 15 seg: segmento de mercado
- 10 seg: por qué quedó inactivo
- 5 seg: transición
