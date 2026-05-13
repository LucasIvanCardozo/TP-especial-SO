# Slide 12 — MOSIX: Administración del Procesador (Resumen)

## Propósito

MOSIX extiende la administración del procesador de un único nodo/SO a un **cluster completo**. Su concepto central: la **migración preemptiva de procesos funciona como un scheduler distribuido**, donde el PCB se serializa y transfiere entre nodos, permitiendo que un proceso continúe en otro nodo como si nunca se hubiera movido.

---

## 1. Migración de Procesos

### El Ciclo Completo

```
NODO A (origen)                              NODO B (destino)
┌──────────────┐                            ┌──────────────┐
│ PCB + memoria │                            │    vacío      │
│ (en ejecución)│                            │              │
└──────┬───────┘                            └──────▲───────┘
       │                                           │
       ▼          1. Serializa                     │
   ┌────────┐  ───────────────────►   ┌───────────┐
   │ chekcnt │       2. Transfiere    │ reconstruye│
   └────────┘     (por red)           └───────┬─────┘
                                             │
                                    3. Continúa
                                    (proceso en B)
```

### Etapas

| Etapa | Qué ocurre |
|-------|-----------|
| **1. Serializa** | Se crea un checkpoint: estado completo del PCB (registros CPU, contador de programa, stack pointer), espacio de memoria completo (heap, stack, código, datos), descriptores de archivos abiertos, sockets activos, señales pendientes |
| **2. Transfiere** | El estado serializado cruza la red hacia el nodo destino. El costo es proporcional al tamaño de la memoria del proceso |
| **3. Reconstruye** | El nodo destino recibe los datos y reconstruye el PCB y espacio de memoria |
| **4. Continúa** | El proceso retoma ejecución exactamente desde el punto de serialización. Es transparente para la aplicación |

### Checkpoint/Restart

| Componente | Qué incluye |
|------------|-------------|
| Registros de CPU | PC, stack pointer, registros generales, flags |
| Espacio de direcciones | Contenido completo de memoria |
| Descriptores de archivo | Tabla de archivos abiertos con offsets |
| Estado de red | Sockets abiertos, buffers pendientes |
| Señales pendientes | Máscara y cola de señales |
| Metadata | PID, padre, prioridad, quantum usado |

**Usos**: recuperación ante fallos, mantenimiento sin interrupciones, balanceo de carga.

**Limitaciones**: no todas las aplicaciones soportan checkpoint/restart limpio; overhead en la ejecución; limitaciones con threads POSIX.

---

## 2. Load Balancing Multi-Paramétrico

MOSIX evalúa **múltiples parámetros** simultáneamente para decidir dónde ejecutar cada proceso:

| Parámetro | Mide |
|-----------|------|
| Velocidad de CPU | MHz/GHz del procesador |
| Carga actual | Procesos ejecutándose |
| Memoria disponible | RAM libre |
| Latencia de red | Retraso entre nodos |
| Número de cores | CPUs lógicos disponibles |

No es FCFS ni Round Robin. Es un algoritmo **adaptativo** que monitorea continuamente el estado global del cluster:

1. Cada nodo monitorea su propia carga
2. Los nodos intercambian estadísticas
3. Se detectan desbalances (sobrecargados vs. disponibles)
4. Se seleccionan procesos candidatos
5. Se ejecutan las migraciones

La migración es **preemptiva**: el sistema mueve procesos sin que el proceso lo solicite, sin intervención del usuario, y sin que la aplicación lo sepa.

### Relación con schedulers del temario

La migración combina los tres niveles:

- **Largo plazo**: decide en qué nodo se размещает cada proceso nuevo
- **Medio plazo**: "memory ushering" — mueve procesos entre nodos por presión de memoria
- **Corto plazo**: evalúa constantemente si procesos deben migrar

---

## 3. Multi-Programación a Nivel Cluster (SSI)

MOSIX presenta el cluster como una **única máquina con N CPUs lógicas** (Single System Image). Las aplicaciones se ejecutan **sin modificaciones ni recompilación**. El usuario lanza procesos como en un sistema normal, y MOSIX decide internamente dónde ejecutarlos.

---

## 4. Efecto Convoy Evitado

**El problema original**: un proceso CPU-bound largo monopoliza la CPU, procesos cortos quedan esperando detrás, el throughput global cae.

**Cómo MOSIX lo evita**:
- Detecta procesos CPU-bound que monopolizan un nodo
- Migra esos procesos a nodos menos cargados o más rápidos
- Los nodos sobrecargados quedan disponibles para procesos interactivos/I/O-bound

**Ventaja sobre soluciones tradicionales**:
- No depende de quantum fijo (no hay trade-off quantum vs. overhead)
- No necesita conocer a priori la duración de los procesos (a diferencia de SJF)
- Opera a nivel de nodos físicos completos

---

## 5. Conexión con Conceptos FSO

| Concepto | Aplicación en MOSIX |
|----------|---------------------|
| **§2.1 — Scheduling** | Multiprogramación a nivel cluster; maximiza utilización global de todas las CPUs |
| **§2.3 — PCB** | Se serializa y transfiere completo entre nodos (checkpoint/restart) |
| **§2.4 — Schedulers** | Migración combina largo plazo ( размещение), medio plazo (memory ushering), corto plazo (evaluación continua) |
| **§2.5 — Algoritmos** | Balanceo de carga dinámico multi-paramétrico (no FCFS ni Round Robin) |
| **§2.6 — Efecto convoy** | Mitigado migrando procesos CPU-bound a otros nodos |
| **§2.7 — Quantum óptimo** | Considera el trade-off: no migra si el overhead supera el beneficio |
| **§2.8 — Dispatcher** | La migración es un "context switch" entre nodos (mucho más costoso que local) |

---

## 6. Limitaciones

1. No soporta memoria compartida entre procesos ni threads POSIX
2. No todas las aplicaciones serializan limpiamente
3. Procesos con mucha memoria generan tráfico significativo durante migración
4. El algoritmo debe evaluar si el costo de migración supera el beneficio
5. Soporte limitado para CPUs multinúcleo dentro de un nodo

---

## Glosario

- **PCB Transfer**: serialización del PCB completo (estado CPU, memoria, archivos, red) para transferirlo entre nodos
- **Checkpoint/Restart**: salvar el estado completo de un proceso y recuperarlo en otro nodo
- **Load Balancing**: distribución de carga entre nodos, multi-paramétrico y continuo
- **Multi-Programming**: mantener múltiples procesos en memoria simultáneamente, extendido al cluster
- **Effect Convoy**: proceso CPU-bound que monopoliza CPU causando que procesos cortos esperen
- **Preemptive Migration**: mover un proceso sin que lo solicite y sin intervención del usuario

---

## Idea Central

> La migración preemptiva de MOSIX es un **scheduler distribuido** que usa checkpoint/restart para transferir estado de procesos, logra balanceo de carga multi-paramétrico, y evita el efecto convoy mediante decisiones automáticas del sistema.