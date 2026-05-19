# Slide 12 — Zephyr OS: Scheduling del Procesador

> **Notas de exposición para el presentador**
> Tema: Cómo Zephyr OS administra el procesador mediante scheduling priority-based sin quantum clásico

---

## 🎤 Qué decir (Speaking Notes)

### Apertura (~15 segundos)

"Zephyr administra el procesador de una manera diferente a lo que vemos en un Linux o Windows tradicional. No usa Round Robin con quantum fijo. En su lugar, implementa **scheduling puramente priority-based** donde el thread de mayor prioridad siempre se ejecuta primero, y **no hay rotación automática** entre threads de igual prioridad."

### Estados de Thread (~20 segundos)

"Zephyr define cinco estados para sus threads, que son una extensión del modelo clásico de tres estados que estudiamos en la materia:

- **READY**: El thread está en la run queue, esperando la CPU.
- **RUNNING**: Está ejecutándose activamente en este momento.
- **SLEEPING**: Está bloqueado, esperando un evento como E/S o un timer.
- **TERMINATED**: Ya terminó su ejecución.
- **SUSPENDED**: Pausado externamente, no puede ejecutarse.

Pueden ver las transiciones en el diagrama: un thread pasa a READY cuando inicia, de READY a RUNNING cuando el scheduler lo elige, y vuelve a READY si un thread de mayor prioridad lo desaloja — eso es lo que hace el scheduling preemptivo."

### Políticas de Scheduling (~25 segundos)

"Aquí está la diferencia clave con otros sistemas. Zephyr soporta tres políticas que pueden coexistir en la misma aplicación:

**Scheduling cooperativo**: threads con prioridad negativa. Una vez que obtienen la CPU, la retienen hasta que ellos mismos la liberen llamando a `k_yield()`, `k_sleep()`, o esperando un mutex. No hay desalojo involuntario.

**Scheduling preemptivo**: threads con prioridad no negativa. Si llega un thread de mayor prioridad, el scheduler lo pone en ejecución inmediatamente, desalojando al actual. Esto garantiza latencia de respuesta acotada para tareas de tiempo real.

**Scheduling híbrido**: la combinación de ambos. Por ejemplo, un hilo cooperativo de prioridad -1 para control de motor que no puede ser interrumpido, coexistiendo con hilos preemptivos para sensores y logging."

### Priority-Based sin Round Robin (~15 segundos)

"¿Por qué Zephyr no implementa Round Robin? La razón es determinismo. En sistemas de tiempo real, el comportamiento debe ser predecible. Round Robin introduce indeterminismo: el quantum puede agotarse en cualquier momento, causando un context switch inesperado. Zephyr prioriza la predictibilidad: threads de igual prioridad se ejecutan en orden FIFO, sin time-slicing."

### Sin Quantum Clásico (~15 segundos)

"Otra diferencia fundamental: Zephyr no tiene quantum clásico. No hay un timer que interrumpa periódicamente para dar time-slice a los procesos. Esto elimina overhead de context switch innecesario y simplifica el modelo. El 'quantum' en Zephyr es simplemente el tiempo que un thread ejecuta hasta que cede voluntariamente o es desalojado por uno de mayor prioridad."

---

## 📌 Puntos Clave

| Concepto                      | Descripción                                             |
| ----------------------------- | ------------------------------------------------------- |
| **5 Estados**                 | READY, RUNNING, SLEEPING, TERMINATED, SUSPENDED         |
| **Scheduling priority-based** | Mayor prioridad siempre primero                         |
| **Sin Round Robin**           | No hay time-slicing entre igual prioridad               |
| **Cooperativo**               | Prioridad negativa, retiene CPU hasta ceder             |
| **Preemptivo**                | Prioridad ≥ 0, puede ser desalojado por mayor prioridad |
| **Sin quantum clásico**       | No hay timer de time-slice                              |
| **Priority inheritance**      | Evita inversión de prioridad en mutexes                 |

### k_thread ≈ PCB simplificado

La estructura `k_thread` es el equivalente al PCB (§2.3):

- Stack pointer y registros salvados en context switch
- Prioridad y flags que controlan cooperative vs preemptivo
- Estado actual del thread
- Área de stack propia

**Diferencia**: No incluye tablas de páginas ni límites de memoria (no hay MMU en la mayoría de los MCUs).

---

## 🔗 Relación con FSO

| Concepto FSO (§)                    | Aplicación en Zephyr                                                                                                         |
| ----------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| **§2.1 — Necesidad del scheduling** | Minimizar latencia de respuesta para tareas de tiempo real                                                                   |
| **§2.2 — Estados de proceso**       | 5 estados (extensión del modelo clásico 3 estados)                                                                           |
| **§2.3 — PCB**                      | `k_thread` = PCB simplificado (sin tablas de páginas ni MMU)                                                                 |
| **§2.5 — Algoritmos**               | Implementa **priority-based scheduling** (no FCFS, no SJF, no Round Robin)                                                   |
| **§2.6 — Efecto convoy**            | Scheduling cooperativo puede causar latencia si un hilo retiene CPU innecesariamente                                         |
| **§2.7 — Quantum óptimo**           | **NO tiene quantum clásico** — no hay time-slice automático                                                                  |
| **§2.8 — Dispatcher**               | Funciones del dispatcher se cumplen, pero syscalls son function calls directos (single address space elimina cambio de modo) |

### Comparación: Zephyr vs Algoritmos del Temario

| Algoritmo del temario | Zephyr lo implementa?                       |
| --------------------- | ------------------------------------------- |
| FCFS                  | No (no hay cola global)                     |
| SJF/SRTF              | No (no estima burst)                        |
| **Round Robin**       | **NO** — sin quantum clásico                |
| **Priority-based**    | **SÍ** — scheduling por prioridad           |
| Colas multinivel      | Parcialmente — colas por nivel de prioridad |

---

## ⚠️ Cosas a Tener en Cuenta

### Para la exposición

1. **Evitar decir "no tiene scheduling"**: Zephyr SÍ tiene scheduling, pero es priority-based puro, no Round Robin.

2. **No confundir cooperative con "sin scheduler"**: El scheduler siempre está activo; cooperative solo significa que el thread decide cuándo ceder.

3. **Aclarar la diferencia con quantum**: En Linux/Windows, el quantum es fijo (ej: 4ms). En Zephyr no existe ese concepto — un thread puede ejecutar indefinidamente hasta que ceda o sea desalojado.

4. **Prioridad negativa = cooperative**: Es una convención de Zephyr. Prioridad -1, -2, -3... son cooperativos. Prioridad 0, 1, 2... son preemptivos.

5. **Single address space ≠ sin protección**: Zephyr usa MPU (Memory Protection Unit) para separar kernelspace de userspace incluso sin MMU.

### Posibles preguntas del tribunal

**P: "¿Cómo se evitan los deadlocks en Zephyr?"**
R: Zephyr provee primitivas de sincronización (mutexes, semaphores, FIFOs) y implementa priority inheritance para evitar inversión de prioridad. Pero la responsabilidad de usar bien las primitivas es del programador.

**P: "¿Qué pasa si un thread de baja prioridad nunca cede?"**
R: Puede causar starvation. Por eso se recomienda usar preemptive scheduling para tareas que deben responder a eventos, y diseñar threads cooperativos para que cedan periódicamente.

**P: "¿Cómo se compara esto con FreeRTOS?"**
R: FreeRTOS usa priority-based preemptive scheduling similar, pero con algunas diferencias en las primitivas de sincronización y soporte para user mode.

---

## ⏱️ Tiempo Estimado

| Sección                        | Tiempo                         |
| ------------------------------ | ------------------------------ |
| Apertura                       | 15 segundos                    |
| Estados de thread              | 20 segundos                    |
| Políticas de scheduling        | 25 segundos                    |
| Priority-based sin Round Robin | 15 segundos                    |
| Sin quantum clásico            | 15 segundos                    |
| **Total**                      | **~90 segundos (1.5 minutos)** |

> 💡 **Tip**: Si el tiempo es ajustado, priorizar las políticas de scheduling y la diferencia con Round Robin/quantum. Los estados de thread son más intuitivos y pueden explicarse rápido con el diagrama de la slide.

---

## 📝 Frases Clave para Memorizar

- "Scheduling puramente priority-based, sin Round Robin"
- "Prioridad negativa = cooperativo, prioridad no negativa = preemptivo"
- "No hay quantum clásico, no hay time-slicing automático"
- "k_thread es el PCB simplificado de Zephyr"
- "Single address space hace que las syscalls sean function calls directos"
