# slide-16-explicacion.md — MOSIX: Facilidades para Desarrolladores

---

## 1. Introducción y Contexto

Esta slide presenta las **facilidades que MOSIX proporciona a los desarrolladores de software** que desean ejecutar sus aplicaciones en un cluster sin modificaciones. A diferencia de otros middlewares de clustering que requieren código específico o librerías especializadas, MOSIX está diseñado para que cualquier ejecutable Linux estándar pueda beneficiarse de la migración automática de procesos y el balanceo de carga entre nodos.

La filosofía central de MOSIX es la **transparencia total**: el desarrollador escribe aplicaciones Linux normales, las compila con las herramientas estándar del sistema, y MOSIX se encarga de distribuirlas y balancearlas automáticamente entre los nodos del cluster. No hay necesidad de aprender APIs propietarias, linkeditar librerías especiales, ni recompilar con flags específicos.

---

## 2. API POSIX Estándar — Compatibilidad con Aplicaciones Linux Existentes

### 2.1 ¿Qué significa "API POSIX" en este contexto?

**POSIX (Portable Operating System Interface)** es un estándar internacional (IEEE 1003) que define la interfaz entre aplicaciones y el sistema operativo. Cuando una aplicación Linux se ajusta a POSIX, significa que utiliza llamadas al sistema (syscalls) estándar para interactuar con el kernel: operaciones de procesos (`fork()`, `exec()`, `exit()`, `wait()`), operaciones de archivos (`open()`, `read()`, `write()`, `close()`), y otras funciones fundamentales del sistema.

MOSIX **no modifica ni extiende esta interfaz**. El módulo de MOSIX se inserta en el kernel de Linux a nivel del scheduler (planificador de CPU), interceptando decisiones de migración después de que las syscalls estándar ya fueron procesadas por el kernel. Esto significa que:

- Una aplicación que llama `fork()` obtiene exactamente el mismo comportamiento de creación de procesos que en Linux estándar
- La función `exec()` carga el programa igual que siempre
- Operaciones de E/S como `read()` y `write()` funcionan idénticamente

La diferencia es que MOSIX puede decidir migrar el proceso resultante a otro nodo del cluster basándose en condiciones de carga, pero esa decisión ocurre **después** de que el kernel completó la syscall — la aplicación no percibe cambio alguno en el comportamiento del sistema.

### 2.2 Syscalls estándar mencionadas en la slide

| Syscall | Función | Comportamiento en MOSIX |
|---------|---------|------------------------|
| `fork()` | Crear proceso hijo | Crea proceso migrable automáticamente |
| `exec()` | Reemplazar imagen de proceso | Programa ejecutable standard ELF |
| `read()` | Leer de descriptor de archivo | Funciona igual, sin cambios |
| `write()` | Escribir a descriptor de archivo | Funciona igual, sin cambios |

### 2.3 Sin librerías especiales de linkedición

Un punto crucial es que MOSIX **no requiere linkedición con librerías especiales**. En otros sistemas de clustering, a veces es necesario linkeditar con una librería cliente que expone funciones de comunicación o migración. MOSIX no tiene nada de eso — las aplicaciones se compilan y linkeditan exactamente como lo harían para un sistema Linux normal. El módulo de MOSIX en el kernel intercepta las operaciones del scheduler sin que la aplicación lo sepa.

---

## 3. Sin Recompilación — Ejecutables ELF Estándar

### 3.1 Formato ELF

ELF (Executable and Linkable Format) es el formato estándar de ejecutables en Linux. Cuando un desarrollador compila su código con gcc, clang, o cualquier otro compilador, el resultado es un archivo ELF ejecutable. MOSIX acepta estos archivos directamente, sin conversión ni procesamiento especial.

La cadena de herramientas estándar de Linux (gcc, make, CMake, etc.) produce ejecutables que funcionan directamente en un cluster MOSIX. No hay pasos adicionales, no hay configuración de build especial, no hay flags de compilación requeridos.

### 3.2 Por qué esto es importante para adopción

La barrera de entrada para usar MOSIX es extremadamente baja. Un equipo de desarrollo que ya tiene aplicaciones Linux funcionando puede desplegar esas mismas aplicaciones en un cluster MOSIX sin cambiar una sola línea de código. Esto hace que MOSIX sea atractivo para organizaciones que no quieren reescribir o modificar aplicaciones existentes.

### 3.3 Migración transparente entre nodos

La "migración transparente" significa que un proceso puede moverse de un nodo a otro durante su ejecución, y la aplicación no lo percibe. Desde la perspectiva de la aplicación:

- La migración no genera errores
- No se pierden conexiones abiertas (excepto consideraciones de red específicas)
- El espacio de direcciones del proceso se mantiene coherente
- Las llamadas al sistema continúan funcionando normalmente

Internamente, MOSIX transferirá el estado del proceso (registros CPU, tabla de páginas de memoria, descriptores de archivos abiertos) al nodo destino, y la ejecución continuará como si nada hubiera pasado.

---

## 4. `mosrun` — La Herramienta para Iniciar Procesos Migrables

### 4.1 Concepto fundamental

`mosrun` es el comando principal para iniciar procesos que serán elegibles para migración automática. Cuando un usuario ejecuta un comando directamente (por ejemplo, `./mi_aplicacion`), ese proceso se ejecuta en el nodo local y **no es migrable** — el scheduler de MOSIX no lo moverá a otro nodo. En cambio, cuando se ejecuta `mosrun ./mi_aplicacion`, el proceso resultante tiene la marca de "migrable" y MOSIX puede moverlo según las condiciones del cluster.

### 4.2 Sintaxis y uso

```bash
mosrun [opciones] comando [argumentos]
```

**Opciones principales:**

| Opción | Descripción |
|--------|-------------|
| `-k maxjobs` | Limita el número máximo de jobs concurrentes |
| `-h` | Muestra ayuda |
| `-v` | Modo verboso (para debugging) |

**Ejemplos de uso:**

```bash
# Iniciar un proceso migrable simple
mosrun ./aplicacion

# Ejecutar con límite de 8 jobs concurrentes
mosrun -k 8 ./aplicacion param1 param2

# Combinar con pipes y redirección estándar de Linux
mosrun ./app < input.txt > output.txt
```

### 4.3 Mecanismo interno

Cuando `mosrun` lanza un proceso, marca una bandera interna en el PCB (Process Control Block) del proceso indicando que es migrable. El scheduler de MOSIX monitorea continuamente las condiciones de todos los nodos (carga de CPU, memoria disponible, tráfico de red) y cuando detecta que un nodo está sobrecargado o que otro nodo tiene recursos disponibles, puede decidir migrar procesos migrables.

La decisión de migración ocurre en el scheduler, no en el espacio de usuario. El desarrollador no necesita invocar ninguna función especial ni manejar eventos de migración — todo ocurre automáticamente.

### 4.4 Relación con `mosps`

`mosps` es el comando para ver procesos activos en el cluster. Muestra información similar a `ps` estándar (PID, usuario, comando, etc.) pero con información adicional de MOSIX: en qué nodo está corriendo cada proceso, si está en migración, estado del proceso migrable.

---

## 5. Herramientas HPC de Monitoreo (mosmon, mosps, mostat)

### 5.1 `mosmon` — Monitor en Tiempo Real

`mosmon` proporciona una vista en vivo del estado del cluster. Muestra información como:

- **Carga de CPU por nodo**: porcentaje de uso de procesador
- **Memoria disponible**: RAM libre en cada nodo
- **Procesos en ejecución**: cuántos procesos está manejando cada nodo
- **Migraciones activas**: procesos que están siendo transferidos en ese momento

Es análogo a tener un "dashboard" del cluster actualizado continuamente. Un administrador puede observar cómo se distribuyen los procesos y si hay nodos sobrecargados o subutilizados.

### 5.2 `mosps` — Lista de Procesos del Cluster

Similar al comando `ps` de Linux, pero extendido para el contexto de cluster:

- Lista todos los procesos en todos los nodos (no solo el nodo local)
- Muestra en qué nodo está corriendo cada proceso
- Indica el estado de migración (migrable, en migración, fijo)
- Permite filtrar por nodo, usuario, estado

Ejemplo de salida típica:

```
PID     NODO    USUARIO   COMANDO          ESTADO
1234    node1   juan      ./app             MIGRABLE
5678    node2   maria     python test.py    MIGRABLE
9012    node1   root      mosmon            FIJO
```

### 5.3 `mostat` — Estadísticas Agregadas del Cluster

`mostat` muestra estadísticas consolidadas de todo el cluster:

- **Número de nodos activos**: cuántos nodos están disponibles
- **Carga promedio**: uso medio de CPU en el cluster
- **Memoria total disponible**: suma de RAM libre en todos los nodos
- **Procesos totales**: cantidad de procesos en ejecución

Esta información es útil para administradores que necesitan reportes de utilización y capacidad.

### 5.4 Conexión con el temario de FSO

Estas herramientas acceden a información del kernel a través del filesystem virtual `/proc/hpc`. En el temario de FSO, el tema §1.7 (Interrupciones) y §1.8 (Llamadas al sistema) son relevantes aquí:

- Cuando `mosmon` lee información del cluster, genera syscalls de lectura (`read()`)
- El kernel intercepta estas lecturas y consulta las estructuras internas de MOSIX
- `/proc/hpc` es un filesystem virtual (procfs) similar a `/proc/meminfo` o `/proc/cpuinfo`
- La información no existe como archivo en disco, sino que el kernel la genera dinámicamente en respuesta a operaciones de lectura

---

## 6. Compatibilidad con SLURM

### 6.1 ¿Qué es SLURM?

**SLURM** (Simple Linux Utility for Resource Management) es un workload manager open source ampliamente utilizado en clusters HPC (High Performance Computing). Es el scheduler dominante en supercomputadoras — más del 60% de las Top500 supercomputadoras del mundo usan SLURM.

SLURM proporciona:
- **Gestión de jobs**: queue de trabajos, asignación de recursos
- **Scheduling de prioridad**: decide qué job se ejecuta cuando
- **Asignación de nodos**: reserva nodos para jobs específicos
- **Control de recursos**: limita CPU, memoria, tiempo de ejecución por job

### 6.2 Integración con MOSIX

La slide menciona que es posible usar SLURM y MOSIX juntos. Esto significa que:

1. **SLURM** se encarga de la gestión de jobs y la asignación de nodos a nivel de cluster (decidir qué job corre en qué nodo, gestionar colas de espera, priorizar trabajos)
2. **MOSIX** proporciona migración dinámica de procesos dentro del cluster (mover procesos entre nodos para optimizar carga, balancear recursos)

La integración no es automática ni nativa — requiere configuración manual y no hay documentación extensa sobre cómo implementarla. La idea es que SLURM proporciona la capa superior de scheduling de jobs, mientras MOSIX optimiza la utilización de recursos a nivel de proceso.

### 6.3 Limitaciones de la integración

- **No es nativa**: SLURM y MOSIX fueron diseñados independientemente
- **Configuración manual requerida**: no hay un script automático de integración
- **Documentación limitada**: la combinación específica de ambos sistemas no está bien documentada
- **Alternativas modernas**: para nuevos proyectos HPC, se recomienda usar directamente SLURM sin MOSIX, ya que SLURM tiene soporte comercial activo y comunidad de desarrollo grande

---

## 7. Documentación Limitada

MOSIX tiene menos documentación disponible que otros sistemas como Zephyr. Los recursos disponibles son:

- **FAQ oficial**: respuestas a preguntas comunes
- **Tutorial**: guía de introducción al sistema
- **Guía del administrador**: documentación para administración del cluster

Sin embargo, la documentación es menos extensiva que la de proyectos más activos. Esto es una consideración práctica para equipos que evalúan MOSIX como tecnología.

---

## 8. Conexión con el Temario de FSO

### 8.1 §1.8 — Llamadas al Sistema: Interfaz Usuario-Kernel

La nota académica en la slide conecta directamente con el tema §1.8 del temario. El concepto clave es que MOSIX **no modifica la interfaz de syscalls**. Las aplicaciones usan las mismas llamadas al sistema que usarían en un Linux estándar:

```
Aplicación → syscall fork() → Kernel Linux estándar → MOSIX scheduler decide migrar
```

El scheduler de MOSIX se inserta en el kernel después de que las syscalls estándar ya fueron manejadas. La diferencia está en decisiones internas del scheduler, no en la interfaz que ven las aplicaciones.

### 8.2 ABI POSIX estable

La **ABI (Application Binary Interface)** de Linux es estable — las aplicaciones compiladas hoy funcionan en kernels de mañana. MOSIX aprovecha esto: al no modificar la ABI, cualquier ejecutable ELF puede correr en un cluster MOSIX sin recompilación. La estabilidad de la ABI es lo que permite la transparencia.

### 8.3 §1.7 — Interrupciones de Software (syscalls)

Cuando un proceso hace `fork()`, genera una interrupción de software (`int 0x80` en arquitecturas antiguas, `syscall` en x86-64). Esta interrupción transfiere control al kernel. MOSIX se inserta en ese flujo a nivel del scheduler — después de que el kernel maneja la interrupción, MOSIX puede decidir migrar el proceso resultante.

### 8.4 /proc/hpc como procfs dinámico

La interfaz `/proc/hpc` es un filesystem virtual (procfs). En el temario, el tema de sistemas de archivos (§3) cubre cómo los archivos son colecciones de datos con metadatos. En `/proc`, estos "archivos" no existen en disco — el kernel los genera dinámicamente cuando procesos hacen `read()` sobre ellos:

```
cat /proc/hpc/nodes → syscall read() → kernel intercepta → consulta estructuras MOSIX → genera output
```

Esto es análogo a cómo funciona `/proc/meminfo` (información de memoria), `/proc/cpuinfo` (información del CPU), o `/proc/uptime` (tiempo de actividad del sistema).

---

## 9. Limitaciones Importantes

### 9.1 No soporte de threads

MOSIX **no migrat threads automáticamente**. Los threads dentro de un proceso permanecen en el mismo nodo — no se distribuyen entre nodos. Esto tiene implicaciones:

- Aplicaciones multiproceso pueden beneficiarse de la migración
- Aplicaciones con много threads intensive pueden no beneficiarse
- Se sugieren modelos de programación paralela distribuidos (MPI) como alternativa

### 9.2 No soporte de memoria compartida

MOSIX utiliza un modelo de **memoria distribuida** (shared-nothing). No hay soporte para:

- Shared Memory System V
- POSIX shared memory
- Memoria compartida entre procesos en diferentes nodos

Aplicaciones que requieren DSM (Distributed Shared Memory) no son compatibles. Las alternativas incluyen:
- MPI (comunicación por paso de mensajes)
- Archivos compartidos en sistema de archivos de red
- Bases de datos o servicios externos

### 9.3 Rendimiento variable de IPC

Ciertos mecanismos de IPC tienen mejor rendimiento que otros en MOSIX:

| Mecanismo IPC | Rendimiento | Notas |
|---------------|-------------|-------|
| Pipes | Bueno | Comunicación entre procesos locales |
| Sockets | Bueno | TCP/UDP sobre la red del cluster |
| Message Queues | Variable | Depende de la configuración |
| Shared Memory | **No soportado** | No hay soporte para memoria compartida |
| Semaphores | Variable | Usar con precaución |

### 9.4 Consideraciones de migración

- **Memoria grande**: procesos con mucho consumo de memoria generan tráfico de red significativo durante migración
- **E/S intensiva**: aplicaciones con alta actividad de disco/red pueden no beneficiarse de la migración
- **Conexiones de red**: procesos migrados mantienen conexiones, pero cuidado con IPSec

---

## 10. Glosario de Términos

### Términos de la slide

| Término | Definición |
|---------|------------|
| **API POSIX** | Interfaz estándar de llamadas al sistema para sistemas tipo UNIX. Define funciones como `fork()`, `exec()`, `read()`, `write()` que las aplicaciones usan para interactuar con el kernel. |
| **Transparencia (migración)** | Capacidad de mover procesos entre nodos sin que la aplicación lo perciba. El proceso continúa ejecutándose normalmente después de la migración. |
| **mosrun** | Herramienta de línea de comandos para iniciar procesos migrables en un cluster MOSIX. Los procesos iniciados con mosrun son elegibles para migración automática. |
| **mosmon** | Utilidad de monitoreo en tiempo real que muestra carga de CPU, memoria y procesos en el cluster. |
| **mosps** | Comando similar a `ps` que lista procesos en todos los nodos del cluster, mostrando en qué nodo está cada uno. |
| **mostat** | Herramienta que muestra estadísticas agregadas del cluster: nodos activos, carga promedio, memoria total. |
| **SLURM** | Simple Linux Utility for Resource Management. Workload manager open source ampliamente usado en clusters HPC. Gestiona jobs, colas de trabajos, y asignación de nodos. |

### Términos adicionales relevantes

| Término | Definición |
|---------|------------|
| **Syscall** | Llamada al sistema. Mecanismo por el cual un proceso en modo usuario solicita servicios del kernel (crear procesos, abrir archivos, asignar memoria). |
| **ELF** | Executable and Linkable Format. Formato estándar de ejecutables en Linux. Define la estructura de archivos ejecutables y bibliotecas compartidas. |
| **ABI** | Application Binary Interface. Interfaz entre binarios compilados y el sistema operativo. Define cómo se pasan parámetros, qué llamadas al sistema están disponibles, etc. |
| **PCB** | Process Control Block. Estructura de datos en el kernel que contiene toda la información de un proceso (PID, estado, registros, memoria, archivos abiertos). |
| **Scheduler** | Planificador. Componente del kernel que decide qué proceso ejecuta en la CPU y por cuánto tiempo. MOSIX extiende el scheduler de Linux. |
| **/proc/hpc** | Filesystem virtual de MOSIX. Proporciona información sobre el cluster (nodos, procesos, configuración) mediante operaciones de lectura similares a `/proc` estándar. |
| **HPC** | High Performance Computing. Cómputo de alto rendimiento. Cluster de computadoras utilizadas para cálculos intensivamente paralelos. |
| **Shared-nothing** | Modelo de arquitectura donde cada nodo tiene su propia memoria y no hay memoria compartida entre nodos. |
| **IPC** | Inter-Process Communication. Mecanismos para que procesos se comuniquen: pipes, sockets, message queues, shared memory, semaphores. |

---

## 11. Resumen de Facilidades para Desarrolladores

| Facilidades | Descripción |
|-------------|-------------|
| **API POSIX estándar** | Syscalls `fork()`, `exec()`, `read()`, `write()` funcionan sin cambios |
| **Sin recompilación** | Ejecutables ELF estándar funcionan directamente |
| **Sin librerías especiales** | No requiere linkeditar con librerías de MOSIX |
| **mosrun** | Inicia procesos migrables elegibles para balanceo automático |
| **Monitoreo (mosmon/mosps/mostat)** | Herramientas HPC para observar estado del cluster |
| **Integración SLURM** | Posible usar con workload managers HPC |
| **Multi-lenguaje** | Funciona con C/C++, Fortran, Python, Java, Go, Rust, Perl, Ruby |

---

## 12. Fuentes

- [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)
- [MOSIX Tutorial](https://mosix.cs.huji.ac.il/pub/tutorial.pdf)
- [MOSIX Administrator's Guide](http://www.mosix.cs.huji.ac.il/pub/Guide.pdf)
- [MOSIX Installation and Configuration](https://mosix.cs.huji.ac.il/pub/instal-config.pdf)
- [The openMosix HOWTO](https://tldp.org/HOWTO/pdf/openMosix-HOWTO.pdf)
- [Grokipedia - MOSIX](https://grokipedia.com/page/mosix)
- [Slurm Workload Manager](https://slurm.schedmd.com/)
- [The MOSIX Algorithms for Managing Cluster](https://os.inf.tu-dresden.de/Studium/DOS/SS2014/03-MOSIX.pdf)

---

*Documento elaborado para Fundamentos de Sistemas Operativos — Mayo 2026*