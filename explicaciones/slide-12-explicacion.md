# Slide 12 — Explicación: MOSIX — Administración del Procesador

## Propósito de la Slide

Esta slide presenta cómo MOSIX extiende los conceptos tradicionales de administración del procesador (del ámbito de un único nodo/SO) al ámbito de un cluster completo. El núcleo conceptual es que **la migración preemptiva de procesos funciona como un scheduler distribuido**, donde el PCB (Process Control Block) es serializado y transferido entre nodos, permitiendo que un proceso continúe su ejecución en otro nodo como si nunca se hubiera movido.

La slide se estructura en dos bloques principales: a la izquierda, un **diagrama de migración de proceso** que ilustra el ciclo serializa → transfiere → reconstruye → continúa; a la derecha, tres tarjetas que detallan las capacidades del sistema: **Load Balancing multi-paramétrico**, **Multi-programación a nivel cluster**, y **Efecto Convoy evitado**.

---

## 1. Migración de Proceso — El Ciclo Completo

### 1.1 Contexto y necesidad

En un sistema operativo tradicional (§2.3 del temario), cada proceso tiene un PCB que vive exclusivamente en el nodo donde se creó. Cuando el scheduler de corto plazo (§2.4) selecciona un proceso, el dispatcher (§2.8) realiza un cambio de contexto y el proceso continúa ejecutándose en el mismo nodo.

MOSIX rompe esta restricción: permite que un proceso en estado "running" sea **migrado** de un nodo a otro durante su ejecución. Esto no es un simple cambio de contexto local — es una operación distribuida que involucra serializar el estado completo del proceso, transferirlo por la red, y reconstruirlo en el nodo destino.

### 1.2 El diagrama: serializa → transfiere → reconstruye → continúa

El diagrama de la slide muestra el flujo completo de migración:

```mermaid
flowchart LR
    A["NODO A (origen)<br/><br/>PCB + mem<br/><small>en ejecución</small>"] --> B["1. Serializa<br/><small>Checkpoint: PCB + memoria<br/>+ archivos + sockets</small>"]
    B --> C["2. Transfiere<br/><small>Por red al nodo destino</small>"]
    C --> D["NODO B (destino)<br/><br/>espacio vacío"]
    D --> E["3. Reconstruye<br/><small>Reconstruye PCB + mem<br/>en nodo destino</small>"]
    E --> F["4. Continúa<br/><small>Proceso en ejecución<br/>en Nodo B</small>"]
```

El flujo ilustra las cuatro etapas: **ejecución en origen → serializa → transfiere por red → reconstruye y continúa en destino**.

```
NODO A (origen)                 NODO B (destino)
┌─────────────┐                ┌─────────────┐
│  PCB + mem  │                │   espacio   │
│ en ejecución│                │  (vacío)   │
└─────────────┘                └─────────────┘
       │                              ▲
       ▼                              │
  ┌─────────┐                  ┌───────────┐
  │serializa│                  │reconstruye│
  └─────────┘                  └───────────┘
       │                              ▲
       ▼                              │
  ════════transfer═══▶              │
  (red)                               │
                               ┌───────────┐
                               │ continúa  │
                               │  (PCB+mem)│
                               └───────────┘
```

#### Etapa 1: Serializa (en Nodo A)

El nodo origen realiza un **checkpoint** del proceso: vuelca el estado completo del PCB a un formato serializado. Esto incluye, según la investigación MOSIX:

- **Estado de CPU**: registros del procesador, contador de programa (PC), flags de condición, stack pointer.
- **Memoria del proceso**: el espacio de direcciones completo del proceso (heap, stack, código, datos).
- **Descriptores de archivos abiertos**: todos los archivos que el proceso tiene abiertos en ese momento.
- **Estado de conexiones de red**: sockets activos y sus estados.
- **Cualquier otro contexto necesario**: señales pendientes, información de threads (si aplica), estado de pipes, FIFOs, etc.

Esta serialización es el equivalente, a nivel distribuido, de lo que ocurre cuando un SO tradicional salva el contexto de un proceso durante un context switch, pero amplificado porque debe incluir memoria completa y no solo registros de CPU.

#### Etapa 2: Transfiere (a través de la red)

El estado serializado se transmite por la red del nodo A al nodo B. Este paso introduce una sobrecarga (overhead) proporcional al tamaño del espacio de memoria del proceso. MOSIX debe considerar este costo antes de decidir una migración — un proceso con un espacio de memoria muy grande puede no ser candidato óptimo si el tiempo de transferencia supera el beneficio de ejecutarse en un nodo más rápido.

#### Etapa 3: Reconstruye (en Nodo B)

El nodo destino recibe los datos serializados y reconstruye el PCB y el espacio de memoria del proceso. Esto es análogo a lo que hace un sistema de checkpoint/restart tradicional, pero el proceso se reconstruye en una máquina física diferente.

#### Etapa 4: Continúa (en Nodo B)

Una vez reconstruido, el proceso retoma su ejecución exactamente desde el punto donde fue serializado. Desde la perspectiva del proceso, no hubo interrupción — el PC, los registros y el estado de memoria son coherentes. Esta continuidad es transparente para la aplicación.

### 1.3 Checkpoint/Restart en detalle

El mecanismo de checkpoint/restart es la base técnica que permite la migración. Según la investigación:

**¿Qué se serializa en un checkpoint?**

| Componente | Descripción |
|------------|-------------|
| Registros de CPU | PC, stack pointer, registros de propósito general, flags |
| Espacio de direcciones | Contenido completo de memoria del proceso |
| Descriptores de archivo | Tabla de archivos abiertos con sus offsets |
| Estado de red | Sockets abiertos, buffers de red pendientes |
| Señales pendientes | Máscara de señales, cola de señales pendientes |
| Metadata del proceso | PID original, padre, prioridad, quantum usado |

**¿Para qué sirve?**

1. **Recuperación ante fallos**: Si un nodo falla, los procesos pueden reiniciarse en otro nodo desde el último checkpoint.
2. **Mantenimiento sin interrupciones**: Permite apagar nodos para mantenimiento sin perder trabajo en progreso.
3. **Balanceo de carga avanzado**: Facilita la migración de procesos largos.
4. **Tolerancia a desconexiones**: Procesos que pierden conexión con su nodo original pueden continuar en otro.

**Limitaciones conocidas**:

- No todas las aplicaciones soportan checkpoint/restart de forma limpia (aplicaciones con estado complejo o dependiente de hardware específico).
- Guardar checkpoints introduce overhead en la ejecución.
- MOSIX presenta limitaciones con aplicaciones que usan threads de POSIX.

---

## 2. Load Balancing Multi-Paramétrico

### 2.1 Relación con §2.1 y §2.4 del temario

El temario FSO establece en §2.1 que el scheduling surge de la necesidad de:

- Maximizar utilización de CPU
- Maximizar throughput
- Minimizar tiempo de turnaround
- Minimizar tiempo de respuesta
- Equidad entre procesos

MOSIX lleva estos objetivos al nivel del cluster. Pero mientras un scheduler tradicional opera dentro de un único nodo, MOSIX debe tomar decisiones distribuidas: ¿en qué nodo conviene ejecutar cada proceso?

La sección §2.4 del temario describe tres niveles de schedulers:

| Nivel | Frecuencia | Función |
|-------|-------------|---------|
| Largo plazo (job admission) | Segundos a minutos | Controla grado de multiprogramación, decide qué procesos ingresan al sistema |
| Medio plazo (swapping) | Segundos | Mover procesos entre memoria principal y disco |
| Corto plazo (CPU scheduling) | Milisegundos | Seleccionar siguiente proceso a ejecutar en CPU |

**La migración de procesos en MOSIX combina características de los tres niveles**:

- **Como scheduler de largo plazo**: Decide en qué nodo se размещает cada proceso nuevo del cluster.
- **Como scheduler de medio plazo**: Ejecuta "memory ushering" — mueve procesos entre nodos para balancear memoria (cuando un nodo tiene presión de memoria).
- **Como scheduler de corto plazo distribuido**: Evalúa constantemente si procesos en ejecución deberían migrar a nodos más adecuados.

### 2.2 Múltiples parámetros de decisión

MOSIX no usa un único criterio (por ejemplo, solo carga de CPU). El algoritmo de decisiónevalúa una **combinación de parámetros**:

| Parámetro | ¿Qué mide? | Decisión asociada |
|-----------|------------|-------------------|
| **Velocidad de CPU** | MHz/GHz del procesador | Migra a nodos más rápidos si el actual es lento |
| **Carga actual** | Cantidad de procesos ejecutándose | Evita nodos sobrecargados, busca nodos con menor carga |
| **Memoria disponible** | RAM libre en cada nodo | "Memory ushering" — migra procesos que requieren mucha memoria a nodos con más RAM |
| **Latencia de red** | Retraso de comunicación entre nodos | Considera el costo de transferir el estado del proceso |
| **Número de cores** | CPUs lógicos disponibles | Distribuye carga entre nodos con más capacidad paralela |

Este enfoque multi-paramétrico es análogo a un scheduler por prioridad multidimensional, donde cada dimensión representa un recurso del cluster. No es FCFS ni Round Robin clásico — es un algoritmo adaptativo que evalúa constantemente el estado global del cluster.

### 2.3 Monitoreo continuo

Cada nodo del cluster participa en el monitoreo:

1. **Recolección de información**: Cada nodo monitorea su propia carga (CPU, memoria, procesos en ejecución).
2. **Intercambio de estado**: Los nodos comparten estadísticas de carga con sus vecinos o con un nodo administrador.
3. **Evaluación comparativa**: Se comparan las cargas relativas de todos los nodos.
4. **Identificación de desbalance**: Se detectan nodos sobrecargados y nodos con capacidad disponible.
5. **Selección de procesos candidatos**: Se eligen procesos que se beneficiarían de la migración.
6. **Ejecución de migración**: Los procesos seleccionados son transferidos.

### 2.4 Migración preemptiva automática

La migración es **preemptiva**: el sistema puede mover un proceso incluso sin que el procesolo solicite, sin que el usuario intervenga, y sin que la aplicación lo sepa. Esto es distinto de la migración cooperative (donde el proceso debe cooperar activamente).

La preemptividad es clave para el balanceo de carga efectivo: si esperara a que los procesos自愿mente cedan la CPU, nodos sobrecargados permanecerían sobrecargados.

---

## 3. Multi-Programación a Nivel Cluster

### 3.1 Single System Image (SSI)

MOSIX presenta el cluster completo como una **única máquina con N CPUs lógicas**. Desde la perspectiva del usuario y las aplicaciones, no hay múltiples nodos — hay un único sistema operativo que gestiona múltiples procesadores.

Esto es una extensión directa del concepto de multiprogramación (§2.1 del temario): donde un SO tradicional mantiene múltiples procesos en memoria simultaneamente para mantener la CPU ocupada, MOSIX distribuye procesos entre nodos para mantener todos los nodos ocupados.

### 3.2 Transparencia al usuario

Las aplicaciones se ejecutan **sin modificaciones ni recompilación**. El usuario lanza procesos como si estuviera en un sistema normal, y MOSIX decide internamente dónde ejecutarlos. Esta transparencia es posible porque:

- El proceso ve su entorno habitual (/proc, archivos, sockets).
- El PCB migrado mantiene todos los descriptores y estados.
- No hay llamadas al sistema especiales para migración.

---

## 4. Efecto Convoy Evitado — Relación con §2.6

### 4.1 El problema original (§2.6 del temario)

El efecto convoy ocurre cuando:

1. Un proceso CPU-bound largo monopoliza la CPU.
2. Procesos cortos (generalmente interactivos o I/O-bound) quedan esperando detrás del proceso largo.
3. El throughput global cae porque los procesos rápidos no pueden avanzar.
4. Aparece un "convoy" de procesos esperando detrás del líder.

**Soluciones tradicionales** (del temario): Round Robin, SJF, colas multinivel.

### 4.2 Cómo MOSIX evita el convoy

En un cluster MOSIX, el efecto convoy se mitiga mediante migración preemptiva:

- **Procesos CPU-bound que monopolizan un nodo** son detectados.
- El sistema migra esos procesos a **nodos menos cargados o más rápidos**.
- Los nodos originalmente sobrecargados quedan disponibles para procesos interactivos/I/O-bound.
- Ya no hay un "líder" que monopolice un nodo específico — todos los nodos colaboran.

Este mecanismo es análogo a tener un scheduler global que observa el cluster completo y balancea la carga antes de que se formen convoyes. Es más efectivo que las soluciones tradicionales porque:

1. No depende de un quantum fijo (no existe el trade-off quantum vs. overhead de §2.7).
2. No necesita conocer a priori la duración de los procesos (a diferencia de SJF).
3. Opera a nivel de nodos físicos, no de CPUs lógicos individuales.

---

## 5. Conexión con Conceptos del Temario FSO

| Concepto FSO (§) | Aplicación en MOSIX |
|-----------------|---------------------|
| **§2.1 — Necesidad del scheduling** | MOSIX lleva la multiprogramación al nivel del cluster. Maximiza utilización global del cluster (todas las CPUs), no solo del nodo local. |
| **§2.3 — PCB** | El PCB completo (registros, memoria, archivos abiertos, estado de red) es serializado y transferido entre nodos. El checkpoint/restart es la serialización del estado de un proceso. |
| **§2.4 — Tipos de schedulers** | La migración tiene características de scheduler de largo plazo (job admission → decide размещение), medio plazo (memory ushering → swapping entre nodos), y corto plazo (evaluación continua de dónde ejecutar). |
| **§2.5 — Algoritmos de scheduling** | MOSIX usa balanceo de carga dinámico multi-paramétrico, no FCFS ni Round Robin clásico. Es parecido a un algoritmo de prioridad multidimensional. |
| **§2.6 — Efecto convoy** | MOSIX mitiga el convoy migrando procesos CPU-bound a otros nodos, evitando que monopolicen un nodo y bloqueen procesos rápidos. |
| **§2.7 — Quantum óptimo** | La migración tiene overhead (transferencia de estado por red). MOSIX considera este trade-off: no migra si el costo supera el beneficio. |
| **§2.8 — Dispatcher** | La migración implica un "context switch" entre nodos, mucho más costoso que un context switch local (involucra transferir estado de memoria completo por la red). |

---

## 6. Glosario de Términos

### PCB Transfer (Transferencia de PCB)
El Process Control Block es la estructura de datos del kernel que representa un proceso (§2.3 del temario). En MOSIX, cuando un proceso migra, su PCB completo (estado de CPU, memoria, archivos abiertos, conexiones de red) se serializa, transfiere por la red, y se reconstruye en el nodo destino. Es la base de la migración preemptiva.

### Checkpoint/Restart
Mecanismo que permite salvar el estado completo de un proceso en ejecución (checkpoint) y posteriormente recuperarlo (restart), ya sea en el mismo nodo o en uno diferente. En MOSIX, el checkpoint/restart es lo que permite la migración: serializar el estado completo para poder reconstruirlo en otro nodo.

### Load Balancing
Técnica de distribución de carga de trabajo entre múltiples nodos de un cluster. En MOSIX, es multi-paramétrico: evalúa CPU, memoria, latencia de red y número de cores para decidir dónde ejecutar cada proceso. Es dinámico y continuo, no estático.

### Multi-Programming (Multi-Programación)
Capacidad de mantener múltiples procesos en memoria simultáneamente para maximizar la utilización de CPU. MOSIX extiende este concepto al nivel del cluster: múltiples procesos distribuidos entre nodos, con el cluster visto como una única máquina con N CPUs.

### Effect Convoy (Efecto Convoy)
Fenómeno donde un proceso CPU-bound largo monopoliza la CPU, causando que procesos cortos queden esperando detrás, reduciendo el throughput global (§2.6 del temario). En MOSIX, se evita migrando procesos CPU-bound a nodos menos cargados.

### Preemptive Migration (Migración Preemptiva)
Capacidad de mover un proceso de un nodo a otro sin que el proceso lo solicite y sin intervención del usuario. Es la base del balanceo de carga automático en MOSIX: el sistema decide y ejecuta la migración sin esperar a que el proceso ceda la CPU.

---

## 7. Limitaciones de la Migración en MOSIX

Según la investigación disponible, las limitaciones conocidas son:

1. **Aplicaciones con threads**: MOSIX no soporta memoria compartida entre procesos y tiene limitaciones con threads de POSIX.
2. **Aplicaciones con estado complejo**: No todas las aplicaciones serializan de forma limpia.
3. **Sobrecarga de red**: Procesos con grandes espacios de memoria generan tráfico significativo durante la migración.
4. **Costo de migración vs. beneficio**: El algoritmo debe evaluar si el overhead de transferir el estado supera el beneficio de ejecutarse en otro nodo.
5. **Soporte multinúcleo**: Información limitada sobre optimización para CPUs multinúcleo dentro de un nodo individual.

---

## 8. Resumen de Relaciones Clave

```
┌─────────────────────────────────────────────────────────────┐
│                    MOSIX CLUSTER                             │
│                                                             │
│  Nodo A          Nodo B          Nodo C                      │
│  ┌─────┐         ┌─────┐         ┌─────┐                    │
│  │ P1  │◄──────►│ P2  │         │ P3  │                    │
│  │PCB  │ migra   │PCB  │         │PCB  │                    │
│  │+mem │         │+mem │         │+mem │                    │
│  └─────┘         └─────┘         └─────┘                    │
│       │                                       ▲              │
│       ▼  balanceo multi-paramétrico:          │              │
│  CPU + memoria + latencia_red                  │              │
│                           ┌───────────────────┘              │
│                           │  cluster cómo                     │
│                           │  única máquina                     │
│                           │  con N CPUs                       │
│                           │  (§2.1 multi-                      │
│                           │   programación)                  │
│                           │                                  │
│  ¿convoy? ─── migra ────► evitado por                       │
│  (§2.6)         CPU-       preemptive                        │
│                 bound      migration                         │
└─────────────────────────────────────────────────────────────┘
```

La migración preemptiva de MOSIX es, en esencia, un **scheduler distribuido de largo y mediano plazo** que utiliza el PCB serializado (checkpoint/restart, §2.3) como mecanismo de transferencia de estado, logra balanceo de carga multi-paramétrico (§2.1, §2.4, §2.5), y evita el efecto convoy (§2.6) mediante decisiones de migración tomadas por el sistema sin intervención del usuario.

---

## Fuentes

- [Scalable cluster computing with MOSIX for LINUX](https://www.researchgate.net/publication/2808168_Scalable_cluster_computing_with_MOSIX_for_LINUX)
- [The NOW MOSIX and its Preemptive Process Migration Scheme](https://yuval.yarom.org/pdfs/mosix.pdf)
- [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)
- [Performance of PVM with the MOSIX Preemptive Process Migration](https://dl.acm.org/doi/10.5555/857173.857265)
- Temario FSO — Fundamentos de Sistemas Operativos, UNMDP
