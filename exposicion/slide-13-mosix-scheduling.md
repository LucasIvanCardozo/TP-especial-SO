# Slide 13 — MOSIX: Administración del Procesador

## 🎤 Qué decir (Speaking Notes)

**Apertura sugerida:**

"Ahora vamos a ver cómo MOSIX aborda la administración del procesador, que es radicalmente diferente a lo que vimos en Zephyr. Mientras Zephyr tiene scheduling local en un único microcontrolador, MOSIX implementa lo que se llama **scheduling distribuido**: la capacidad de migrar procesos completos entre nodos de un cluster."

**Desarrollo:**

"En un cluster MOSIX, cuando un nodo se satura o tiene poca memoria disponible, el sistema puede **migrar un proceso en ejecución** a otro nodo del cluster que tenga más recursos. Esto es posible porque MOSIX opera como una extensión del kernel Linux, con acceso privilegiado al estado completo del proceso."

"La migración involucra transferir el **PCB completo** — que según el temario de FSO (§2.3) contiene el PID, estado del proceso, contador de programa, registros de CPU, información de scheduling, y contexto de memoria — más toda la memoria del proceso, de un nodo a otro."

"Visualmente, el flujo es así: un proceso corre en el Nodo A. Cuando MOSIX detecta que otro nodo tiene mejor disponibilidad de recursos, inicia la migración. El PCB se empaqueta y envía por la red al Nodo B, donde se reinstala y el proceso continúa ejecutándose como si nada hubiera pasado."

---

## 📌 Puntos Clave

| Concepto                   | Explicación                                                                                        |
| -------------------------- | -------------------------------------------------------------------------------------------------- |
| **Scheduling distribuido** | El scheduler no elige solo el siguiente thread local; puede mover procesos completos a otros nodos |
| **PCB transferido**        | El Process Control Block viaja por la red al nodo destino                                          |
| **Memoria incluida**       | En MOSIX-4, el proceso migrado lleva toda su memoria (no shared-nothing puro en la práctica)       |
| **Transparencia**          | La aplicación no se entera de la migración; ve el mismo PID, los mismos archivos abiertos          |
| **Preemptive migration**   | La migración puede ser iniciada por el sistema sin que el proceso lo solicite                      |

---

## 🔗 Relación con FSO (§2)

### §2.3 — PCB (Process Control Block)

El **PCB** es la estructura de datos central que mantiene el estado completo de un proceso. MOSIX migra el PCB completo:

| Campo del PCB             | Qué ocurre en migración                             |
| ------------------------- | --------------------------------------------------- |
| PID                       | Se preserva — mismo identificador en destino        |
| Estado                    | Se actualiza a "Running" en el nodo destino         |
| PC (Contador de programa) | Se copia y continúa ejecutando                      |
| Registros de CPU          | Se restauran en destino                             |
| Información de scheduling | Se recalcula en el nuevo nodo                       |
| Descriptor de archivos    | Se redirigen via DFSA si apuntan a archivos remotos |
| Contextos de memoria      | Se copian los frames de memoria                     |

### §2.1 — Objetivos del Scheduler

En MOSIX, los objetivos del scheduler (§2.1) se extienden al contexto distribuido:

| Objetivo clásico              | Implementación en MOSIX                         |
| ----------------------------- | ----------------------------------------------- |
| Maximizar utilización de CPU  | Balancear carga entre nodos del cluster         |
| Maximizar throughput          | Migrar procesos CPU-bound a nodos con CPU libre |
| Minimizar tiempo de respuesta | Considerar latencia de red en decisiones        |
| Equidad                       | Considerar recursos disponibles en cada nodo    |

### §2.4 — Tipos de Schedulers

MOSIX añade un **scheduler distribuido** que opera a nivel de cluster, por encima de los schedulers locales de Linux en cada nodo:

- **Scheduler de largo plazo**: Decide cuántos procesos crear en cada nodo
- **Scheduler medio plazo**: Migra procesos entre nodos para balance de carga
- **Scheduler de corto plazo**: Linux local en cada nodo selecciona el thread a ejecutar

---

## ⚠️ Cosas a tener en cuenta

### Diferencia fundamental con Zephyr

| Aspecto                    | Zephyr OS                                  | MOSIX                                         |
| -------------------------- | ------------------------------------------ | --------------------------------------------- |
| **Ámbito del scheduling**  | Local — un solo MCU                        | Distribuido — cluster entero                  |
| **Decisión de scheduling** | Prioridad estática, cooperativo/preemptive | Balanceo de carga dinámico                    |
| **Migración**              | No existe — un thread corre en un solo núcleo   | Sí — proceso completo migra entre nodos       |
| **Overhead**               | Mínimo — context switch local              | Alto — transferencia de PCB + memoria por red |
| **Latencia**               | Microsegundos                              | Milisegundos (depende de la red)              |

### Complexity added

La migración de procesos introduce complejidad significativa:

- **Estado consistente**: ¿Qué pasa con archivos abiertos, sockets de red, pipes durante la migración?
- **Latencia de red**: La migración toma tiempo proporcional al tamaño de memoria del proceso
- **Coherencia de caché**: ¿Se invalida la caché del nodo destino?
- **Debugging**: Un proceso puede estar "partido" entre dos nodos durante la migración

---

## ⏱️ Tiempo estimado

**60-90 segundos** (es una slide técnica, no de mucho texto)

---

## 💡 Preguntas anticipadas del docente

**P: "¿La migración no tiene mucho overhead?"**
R: "Sí, la migración no es gratis. Tarda desde milisegundos hasta segundos dependiendo del tamaño de memoria del proceso y la velocidad de la red. Por eso MOSIX usa **Memory Ushering** — intenta migrar proactivamente ANTES de que la memoria se agote, para evitar migraciones de emergencia que serían más disruptivas."

**P: "¿Cómo sabe MOSIX cuándo migrar?"**
R: "MOSIX monitorea constantemente: carga de CPU de cada nodo, memoria disponible, velocidad de red entre nodos. Usa algoritmos de balanceo de carga que consideran estos factores. Si un nodo está saturado y otro tiene recursos libres, inicia la migración."

---

## 🔤 Glosatorio de términos

| Término                         | Definición                                                                                               |
| ------------------------------- | -------------------------------------------------------------------------------------------------------- |
| **PCB (Process Control Block)** | Estructura de datos del kernel que mantiene el estado completo de un proceso (§2.3)                      |
| **Scheduling distribuido**      | Forma de scheduling donde las decisiones se toman considerando múltiples nodos de un cluster             |
| **Migración de proceso**        | Transferencia de un proceso en ejecución de un nodo a otro                                               |
| **Memory Ushering**             | Algoritmo de MOSIX que migra proactivamente procesos antes de OOM                                        |
| **Single System Image (SSI)**   | Tecnología que hace que un cluster aparezca como una única máquina — el scheduler ve recursos unificados |
