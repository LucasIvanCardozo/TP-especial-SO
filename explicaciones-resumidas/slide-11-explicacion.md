# Resumen: Administración del Procesador en Zephyr OS

## Estados de Thread

Zephyr implementa 5 estados equivalentes a la teoría de SO:

| Estado | Descripción | Equivalente FSO |
|--------|-------------|-----------------|
| **READY** | Listo para ejecutar, esperando en run queue | LISTO |
| **RUNNING** | Ejecutándose en CPU | EJECUTANDO |
| **SLEEPING** | Bloqueado esperando evento (E/S, timer) | BLOQUEADO |
| **TERMINATED** | Finalizó su ejecución | Término |
| **SUSPENDED** | Pausado temporalmente | Estado especial |

### Transiciones principales

- **READY → RUNNING**: Scheduler elige el thread de mayor prioridad y le otorga CPU
- **RUNNING → SLEEPING**: Thread llama a `k_sleep()`, `k_yield()` o inicia E/S bloqueante
- **SLEEPING → READY**: Evento completado (interrupción E/S, timeout)
- **RUNNING → READY**: Hilo de mayor prioridad desaloja al actual (preemption)
- **RUNNING → TERMINATED**: Thread completa su función y retorna
- **RUNNING → SUSPENDED**:Otro thread lo pausa con `k_thread_suspend()`

---

## k_thread = PCB Simplificado

En SO clásico, el PCB (Process Control Block) contiene: PID, estado, PC, registros, planificación, memoria, archivos, accounting.

En Zephyr, `k_thread` cumple la misma función pero simplificada (sin paginación ni memoria virtual completa):

| Campo k_thread | Función |
|----------------|---------|
| Stack pointer | Salvado de SP/PC en context switch |
| Priority | Planificación (negativo = cooperativo, ≥0 = preemptivo) |
| State | READY, RUNNING, SLEEPING, etc. |
| Stack area | Stack propio del thread |

---

## Políticas de Scheduling

### Cooperative (hilos cooperativos)
- **Prioridad**: valores negativos (-1, -2, -3...)
- **Comportamiento**: retiene CPU hasta que la libere voluntariamente (`k_yield()`, `k_sleep()`, esperando mutex)
- **Sin desalojo involuntario**: no hay timer que le quite la CPU
- **Uso**: tareas que no pueden ser interrumpidas (drivers, operaciones atómicas)

### Preemptive (hilos preemptivos)
- **Prioridad**: valores no negativos (0, 1, 2, 3...)
- **Comportamiento**: si llega un hilo de mayor prioridad, el scheduler lo pone en RUNNING inmediatamente, desalojando al actual
- **Uso**: tareas de tiempo real con deadline

### Hybrid (híbrido)
- Cooperativos y preemptivos coexisten en la misma aplicación
- Un preemptivo de baja prioridad puede coexistir con un cooperativo de alta prioridad

---

## Priority-Based sin Round Robin

Zephyr usa scheduling **priority-based** (no Round Robin):

- **No hay time-slicing**: No existe timer que interrumpa para darle quantum a otro de igual prioridad
- **FIFO por prioridad**: El scheduler mantiene colas FIFO por nivel. El primero encolado es el primero en ejecutar
- **Determinismo**: En sistemas de tiempo real, el comportamiento predecible es más importante que la equidad

### Comparación con algoritmos clásicos (§2.5)

| Algoritmo | Zephyr? |
|-----------|---------|
| FCFS | No |
| SJF/SRTF | No |
| Round Robin | **NO** — sin quantum clásico |
| Priority-based | **SÍ** |
| Colas multinivel | No exactamente — solo colas por prioridad |

### Consecuencias de no tener Round Robin
- **Starvation posible**: hilo de baja prioridad podría nunca ejecutarse si siempre hay de mayor prioridad
- **Sin fair sharing**: threads de igual prioridad no comparten CPU equitativamente
- **Predictible**: scheduler completamente determinista

---

## Sin Quantum Clásico

En sistemas con Round Robin, cada proceso recibe un quantum (time slice). Zephyr **NO tiene esto** para threads de igual prioridad:

- **No time-slicing**: entre threads de igual prioridad no hay rotación automática
- **Syscalls como function calls**: No hay `int 0x80` ni cambio de modo usuario/kernel — se llama directamente al kernel
- **Single address space**: Kernel y apps comparten el mismo espacio de direcciones

### Dispatcher eficiente
Las funciones del dispatcher se cumplen, pero con overhead reducido:
- Context switch solo entre threads (salvar/restaurar registros, stack pointer)
- Sin cambio de modo kernel/user (syscalls son invocaciones directas)

---

## Priority Inheritance (Herencia de Prioridad)

**Problema**: Inversión de prioridad — hilo de alta prioridad (H) queda esperando un mutex que tiene un hilo de baja prioridad (L), mientras uno de prioridad media (M) ejecuta.

**Solución en Zephyr**: Priority inheritance

1. H intenta acquire mutex que ya tiene L
2. Scheduler detecta que L sostiene el mutex y eleva la prioridad de L a la de H
3. L ahora tiene alta prioridad y puede ejecutar rápidamente, liberando el mutex
4. L libera mutex → prioridad vuelve a la original
5. H acquire mutex y continúa

---

## Conexión con Temario FSO

| Tema §2 | Contenido |
|---------|-----------|
| §2.1 | Scheduling para cumplir objetivos de tiempo real (minimizar latencia) |
| §2.2 | 5 estados = extensión del modelo clásico de 3 estados |
| §2.3 | k_thread ≈ PCB simplificado |
| §2.5 | Priority-based scheduling (no Round Robin) |
| §2.6 | En cooperativo: convoy si un hilo retiene CPU innecesariamente |
| §2.7 | Zephyr NO tiene quantum clásico — no hay time-slicing automático |
| §2.8 | Dispatcher con overhead reducido por single address space |

---

## Resumen de Características Principales

1. **5 estados**: READY → RUNNING → SLEEPING + TERMINATED + SUSPENDED
2. **k_thread ≈ PCB simplificado**: sin paginación/memoria virtual
3. **Priority-based**: mayor prioridad siempre primero, sin Round Robin
4. **Híbrido**: cooperativo (< 0) y preemptivo (≥ 0) coexisten
5. **Sin quantum clásico**: no hay time-slicing automático
6. **Single address space**: syscalls son function calls directos
7. **Priority inheritance**: evita inversión de prioridad

Estas decisiones reflejan las prioridades de Zephyr como RTOS para embebidos: determinismo, overhead mínimo, eficiencia de recursos.