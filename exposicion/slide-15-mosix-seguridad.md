# Slide 15 — MOSIX: Seguridad

## 🎤 Qué decir (Speaking Notes)

"Pasemos a la seguridad en MOSIX. A diferencia de Zephyr, que usa hardware dedicado como la MPU para proteger memoria, MOSIX implementa un modelo basado en **confianza mutua entre nodos del cluster** y **sandboxing**."

"En un cluster MOSIX, todos los nodos se presuponen **confiables**. No hay authentication ni encryption entre nodos internos. Esto es una decisión de diseño deliberada: MOSIX prioriza el rendimiento de la migración de procesos sobre la seguridad perimetral. Si un nodo está comprometido, todo el cluster está comprometido."

"El módulo de kernel corre en **modo privilegiado** — tiene acceso total al hardware, puede manipular PCB de otros procesos, y accede a memoria de cualquier proceso en cualquier nodo. Esto es necesario para que la migración funcione: para mover un proceso de Nodo A a Nodo B, el módulo debe poder extraer el estado completo del proceso, incluyendo registros de CPU, tablas de páginas, y descriptores de archivo."

---

## 📌 Puntos Clave

| Concepto                | Descripción                                                                                                                |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| **Sandbox**             | Cada proceso corre en un entorno aislado dentro del cluster. El proceso no tiene acceso directo a recursos de otros nodos. |
| **Confianza mutua**     | Los nodos del cluster se presuponen confiables. No hay autenticación entre nodos para migración.                           |
| **Kernel module**       | MOSIX opera como módulo de kernel Linux, corriendo en modo privilegiado (ring 0).                                          |
| **Migración de PCB**    | Para migrar un proceso, el módulo accede al Process Control Block completo.                                                |
| **Sin cifrado interno** | El tráfico de migración entre nodos no está cifrado por defecto.                                                           |

---

## 🔗 Relación con FSO

### §1.5 — Modo Dual de Operación

MOSIX opera **completamente en modo kernel**:

```
Proceso de usuario
       ↓ (syscall o señal)
Kernel Linux + Módulo MOSIX ← Modo kernel, instrucciones privilegiadas
       ↓
Manipulación de PCB, migración
```

El módulo MOSIX ejecuta **instrucciones privilegiadas** (§1.6) que un proceso de usuario jamás podría ejecutar:

- `schedule()` — decidir qué proceso corre en cada nodo
- `migrate_process()` — transferir contexto de CPU entre nodos
- `read/write_page_tables()` — acceder a tablas de páginas de otros procesos
- `access_process_memory()` — leer/escribir memoria arbitraria de cualquier proceso

### §2.3 — PCB (Process Control Block)

La migración de MOSIX depende del PCB completo:

| Campo del PCB           | Migrado | Por qué                                     |
| ----------------------- | ------- | ------------------------------------------- |
| PID                     | ✅      | Identificador único global                  |
| Estado                  | ✅      | El proceso se pausa, migra, y se reanuda    |
| Registros CPU           | ✅      | Contexto de ejecución                       |
| Contador de programa    | ✅      | Donde continúa tras migración               |
| Tablas de páginas       | ⚠️      | Se transfieren o se referencian remotamente |
| Descriptores de archivo | ⚠️      | DFSA maneja archivos abiertos               |
| Prioridad               | ✅      | Para scheduling en nodo destino             |

### §2.5 — Scheduling Distribuido

MOSIX implementa scheduling a **nivel de cluster**, no solo de CPU individual. El scheduler de cada nodo:

1. Evalúa carga local (cola de procesos listos)
2. Consulta carga de nodos vecinos (latencia de red)
3. Decide migrar procesos CPU-bound si otro nodo tiene menor carga
4. Usa **Memory Ushering** para anticipar OOM y migrar proactivamente

---

## ⚠️ Cosas a tener en cuenta

### Contraste con Zephyr

| Aspecto                    | Zephyr OS                   | MOSIX                                |
| -------------------------- | --------------------------- | ------------------------------------ |
| **Modelo de seguridad**    | MPU + modo dual (hardware)  | Sandbox + confianza mutua (software) |
| **Nivel de privilegio**    | User mode + Supervisor mode | Solo modo kernel                     |
| **Aislamiento**            | Por MPU regions (memoria)   | Por nodo (procesos)                  |
| **Autenticación**          | No aplica (single-core)     | No existe entre nodos                |
| **Superficie de ataque**   | Microcontrolador limitado   | Cluster entero                       |
| **Respuesta a compromiso** | Reset del dispositivo       | Todo el cluster comprometido         |

### Implicaciones prácticas

1. **MOSIX requiere red privada confiable**: El tráfico de migración y memoria entre nodos no está cifrado. Si alguien sniffea la red del cluster, puede ver estado de procesos migrando.

2. **Un nodo comprometido = cluster comprometido**: Sin aislamiento fuerte, un proceso malicioso en un nodo puede manipular procesos en otros nodos a través del módulo MOSIX.

3. **Depreciación de seguridad por rendimiento**: En 2017 (última versión), MOSIX eligió rendimiento sobre seguridad. Esto es aceptable para clusters de investigación aislados, pero inaceptable para producción moderna.

4. **El módulo de kernel es código de alta confianza**: Corre en ring 0 con acceso total. Un bug en el módulo puede causar kernel panic en todos los nodos.

---

## ⏱️ Tiempo Estimado

**60-90 segundos**

- Introducción al modelo de seguridad (20s)
- Explicación del módulo kernel y modo privilegiado (25s)
- Conexión con FSO: PCB y scheduling (20s)
- Contraste con Zephyr (15s)
- Mención del estado actual (10s)

---

## 🎯 Frase para cerrar la sección

_"MOSIX priorizó rendimiento sobre seguridad, lo cual tiene sentido en el contexto de clusters de investigación académica de los 90s y 2000s. Pero en 2017, cuando salió la última versión, ya existían soluciones HPC con seguridad robusta. Esto resume por qué MOSIX quedó obsoleto: no solo dejó de desarrollarse, sino que su modelo de seguridad no evolucionó con la industria."_

---

_Nota para la presentación: Tener preparado el diagrama de migración de PCB para mostrar visualmente qué campos se transfieren entre nodos durante la migración._
