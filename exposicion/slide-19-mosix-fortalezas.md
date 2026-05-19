# Slide 19 — MOSIX: Fortalezas y Debilidades

> **Material de exposición** | Zephyr OS vs MOSIX — TP Especial FSO

---

## 1. 🎤 Qué Decir (Speaking Notes)

### Apertura (15 segundos)

> "MOSIX fue un proyecto ambicioso que intentaba algo radical: que un cluster de computadoras parezca una sola máquina. Durante casi 40 años de investigación, demostró que la migración transparente de procesos era técnicamente viable. Pero como vamos a ver, ser pionero no garantiza supervivencia."

### Las fortalezas (30 segundos)

> "Las fortalezas de MOSIX son reales y significativas. Primero: **migración transparente de procesos**. Cualquier programa Linux podía ejecutarse sin modificaciones — el sistema decidía automáticamente en qué nodo correrlo. Segundo: **Single System Image**, es decir, el cluster se presenta como un único sistema lógico; `ps` muestra procesos de todos los nodos, `top` muestra la carga total. Tercero: fue **pionero en migración preemptiva funcional en 1999**, algo que nadie había logrado en producción."

### Las debilidades — el golpe de honestidad (40 segundos)

> "Ahora viene la parte difícil. MOSIX tiene **tres problemas fundamentales**. Primero: **proyecto inactivo desde octubre de 2017**, hace más de 8 años. Sin parches, sin actualizaciones, sin soporte. Segundo: **licencia propietaria restrictiva** que prohíbe modificaciones y creaciones derivadas. Y tercero: **solo soporta x86_64** — no hay soporte para ARM64, RISC-V, ni otras arquitecturas modernas."

### La comparativa final (20 segundos)

> "Frente a esto, SLURM — que es open source y se mantiene activamente — controla más del 60% de las Top500 supercomputadoras del mundo. Kubernetes, con su enfoque de contenedores, se volvió el estándar para cloud. MOSIX no compite con estas soluciones: fue superado por alternativas más pragmáticas."

---

## 2. 📌 Puntos Clave

### Fortalezas

| Fortaleza                           | Qué significa                                       | Por qué importa                  |
| ----------------------------------- | --------------------------------------------------- | -------------------------------- |
| **Migración transparente**          | Procesos migran en ejecución sin que la app lo sepa | Zero-code-change porting         |
| **Single System Image**             | Cluster = una máquina lógica                        | No necesitás saber de clusters   |
| **Pionero en migración preemptiva** | Primer sistema funcional en 1999                    | Demostró viabilidad del concepto |

### Debilidades

| Debilidad                   | Impacto real                                 | Consecuencia                     |
| --------------------------- | -------------------------------------------- | -------------------------------- |
| **Inactivo desde 2017**     | Sin parches de seguridad                     | Inutilizable en producción       |
| **Licencia propietaria**    | No se puede auditar ni contribuir            | Dependencia del equipo académico |
| **Solo x86_64**             | Sin soporte ARM64/RISC-V                     | Obsoleto arquitecturalmente      |
| **No soporta threads**      | Aplicaciones modernas no funcionan           | Incompatible con software actual |
| **Competidores dominantes** | SLURM >60% Top500, Kubernetes estándar cloud | Cero adopción actual             |

---

## 3. 🔗 Relación con FSO

### §1.4 — Arquitecturas de SO

MOSIX intentó crear un **Sistema Operativo Distribuido a nivel kernel**. La migración vivía dentro del kernel Linux parcheado — un enfoque elegante pero frágil.

**Evolución arquitectónica que muestra MOSIX:**

```
1990s: Kernel patches (MOSIX) → "todo en el kernel"
2000s: Kernel modules (LinuxPMI) → "módulo cargable"
2010s: Containers (cgroups/namespaces) → "aislamiento en usuario"
2020s: Kubernetes + SLURM → "orquestación a nivel aplicación"
```

**Trade-off clave:** La decisión de meter la migración en el kernel permitió transparencia total, pero también acoplamiento estrecho con versiones específicas del kernel. Cuando el proyecto quedó sin recursos, no pudo mantenerse al día con la evolución del kernel Linux.

### §2.5 — Scheduling y Balanceo de Carga Distribuido

MOSIX implementaba un **scheduler distribuido** con **Memory Ushering**: migraba procesos **antes** de que ocurra OOM, anticipando problemas en lugar de reaccionar.

| Concepto FSO               | Aplicación en MOSIX               |
| -------------------------- | --------------------------------- |
| Scheduler preventivo       | Memory Ushering anticipa OOM      |
| Balanceo de carga          | Cada nodo monitorea CPU y memoria |
| Overhead de context switch | Migración tiene costo (red + CPU) |

**Pregunta que siempre se discute en FSO:** ¿El beneficio de migrar supera el costo de la migración? MOSIX decidió que sí — y Balance Ushering implementa esa decisión.

---

## 4. ⚠️ Cosas a Tener en Cuenta

### ⚠️ Honestidad ante el tribunal

Es fundamental ser **transparentes** sobre el estado de MOSIX. No conviene:

- ❌ Idealizar MOSIX como "mejor que SLURM"
- ❌ Ocultar que está inactivo desde 2017
- ❌ Sugerir que es una opción viable para producción

**Lo correcto:**

- ✅ Reconocer que fue innovador académicamente
- ✅ Explicar por qué fue superado por alternativas
- ✅ Ubicarlo como caso de estudio, no como tecnología a adoptar

### ⚠️ La pregunta inevitable

"¿Por qué estudiar algo que no se usa?"

**Respuesta preparada:**

> "MOSIX es un caso de estudio valioso porque ilustra el trade-off entre elegancia y pragmatismo. Su diseño era técnicamente superior en transparencia, pero soluciones más simples y mantenibles (SLURM, Kubernetes) dominaron el mercado. Entender por qué proyectos pioneros fracasan es tan importante como entender las tecnologías que sobreviven."

### ⚠️ Diferencia con Zephyr

| Aspecto      | Zephyr               | MOSIX                   |
| ------------ | -------------------- | ----------------------- |
| Estado       | Activo (2026)        | Inactivo (desde 2017)   |
| Comunidad    | 3000+ contribuyentes | Casi nula               |
| Adopción     | Comercial real       | Solo histórica          |
| Arquitectura | 15+ arquitecturas    | Solo x86_64             |
| Licencia     | Apache 2.0 (open)    | Propietaria restrictiva |

Esta slide cierra con un contraste claro: **Zephyr es un RTOS vivo y en crecimiento; MOSIX es un proyecto académico históricamente significativo pero obsoleto.**

---

## 5. ⏱️ Tiempo Estimado

| Sección                      | Tiempo                   |
| ---------------------------- | ------------------------ |
| Apertura + contexto          | 15 segundos              |
| Fortalezas                   | 30 segundos              |
| Debilidades (honestidad)     | 40 segundos              |
| Comparativa con competidores | 20 segundos              |
| **Total**                    | **~105 segundos** (1:45) |

> **Nota:** Esta slide puede generar preguntas del tribunal sobre por qué incluimos un proyecto inactivo. Tener preparada la respuesta sobre valor académico como caso de estudio.

---

## 6. 🎯 Frases Clave para Memorizar

- _"MOSIX intentó que un cluster parezca una sola máquina — Single System Image"_
- _"Pionero en migración preemptiva funcional en 1999, algo nadie había logrado"_
- _"Pero quedó inactivo desde 2017: sin parches, sin soporte, sin comunidad"_
- _"SLURM controla más del 60% de las Top500 supercomputadoras"_
- _"Ser pionero no garantiza supervivencia — el pragmatismo suele ganar"_

---

## 7. 📊 Visual que Muestra la Slide

```
┌─────────────────────────────────────────────────────────────┐
│                    MOSIX — Fortalezas y Debilidades         │
│                                                             │
│  ┌─────────────────────┐    ┌─────────────────────────────┐ │
│  │    FORTALEZAS       │    │        DEBILIDADES         │ │
│  │                     │    │                             │ │
│  │ ▸ Migración         │    │ ⚠ INACTIVO DESDE 2017      │ │
│  │   transparente     │    │   Sin parches ni updates    │ │
│  │                     │    │                             │ │
│  │ ▸ Single System     │    │ ⚠ LICENCIA PROPIETARIA      │ │
│  │   Image            │    │   No permite modificaciones  │ │
│  │                     │    │                             │ │
│  │ ▸ Zero-code-change │    │ ⚠ SOLO x86_64               │ │
│  │   porting          │    │   Sin ARM64, sin RISC-V     │ │
│  │                     │    │                             │ │
│  │ ▸ Pionero en       │    │ ⚠ COMPETIDORES DOMINAN      │ │
│  │   migración (1999)  │    │   SLURM, Kubernetes         │ │
│  └─────────────────────┘    └─────────────────────────────┘ │
│                                                             │
│  Comparativa: OpenMPI │ TORQUE │ Kubernetes │ SLURM         │
│  Veredicto: Proyecto histórico, no recomendado para         │
│            producción en 2026                               │
└─────────────────────────────────────────────────────────────┘
```

---

_Material preparado para exposición del TP Especial de Fundamentos de Sistemas Operativos — UNMDP_
