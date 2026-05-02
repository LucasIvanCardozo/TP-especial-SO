# Facilidades para Desarrolladores — MOSIX

MOSIX proporciona un conjunto de herramientas y utilidades que permiten a los desarrolladores utilizar el cluster sin necesidad de modificar sus aplicaciones. Este documento describe las facilidades disponibles para el desarrollo y ejecución de programas en un cluster MOSIX.

---

## 1. Modelo de Desarrollo: Sin Modificaciones Requeridas

Una de las características principales de MOSIX es que **no requiere modificación del código de las aplicaciones** para utilizar sus capacidades de migración y balanceo de carga. Las aplicaciones Linux estándar se ejecutan sin recompilación ni linkedición con librerías especiales.

**Características clave:**
- Las aplicaciones se ejecutan sin modificaciones
- No requiere recompilación del código fuente
- No requiere linkedición con librerías especiales de MOSIX
- Compatible con ejecutables Linux estándar (ELF)

**Fuente:** [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)

---

## 2. `mosrun` — Iniciar Procesos Migrables

El comando `mosrun` es la herramienta principal para iniciar procesos que pueden ser migrados dinámicamente entre nodos del cluster.

### Sintaxis Básica

```bash
mosrun [opciones] comando [argumentos]
```

### Características Principales

- **Migración dinámica:** Los procesos iniciados con `mosrun` pueden migrar dinámicamente entre nodos del cluster basándose en la disponibilidad de recursos (carga de CPU, memoria libre)
- **Límite de concurrencia:** `mosrun` puede ejecutar hasta un número máximo de comandos concurrentemente (`maxjobs`), y cuando un proceso termina, se inicia uno nuevo automáticamente
- **Procesos migrables:** A diferencia de ejecutar un comando directamente, los procesos iniciados con `mosrun` son elegibles para migración automática

### Ejemplo de Uso

```bash
# Iniciar un proceso migrable
mosrun ./mi_aplicacion

# Iniciar múltiples procesos con límite
mosrun -k 8 ./mi_aplicacion param1 param2

# Ver estado de procesos migrables
mosps
```

### Opciones Comunes

| Opción | Descripción |
|--------|-------------|
| `-k maxjobs` | Número máximo de jobs concurrentes |
| `-h` | Mostrar ayuda |
| `-v` | Modo verboso |

**Fuente:** [MOSIX Tutorial](https://mosix.cs.huji.ac.il/pub/tutorial.pdf), [Grokipedia - MOSIX](https://grokipedia.com/page/mosix)

---

## 3. `/proc/hpc` — Interfaz para Administradores y Aplicaciones

MOSIX proporciona una interfaz de sistema de archivos virtual en `/proc/hpc` que permite a los administradores y aplicaciones interactuar directamente con el cluster para consultar estados y cambiar configuraciones.

### Propósito

- **Consultar información del cluster:** Ver estado de nodos, procesos, recursos
- **Configurar parámetros:** Ajustar comportamiento de migración y balanceo de carga
- **Monitoreo en tiempo real:** Observar el rendimiento del cluster

### Estructura de `/proc/hpc`

```
/proc/hpc/
├── info          # Información general del cluster
├── nodes        # Estado de los nodos
├── processes     # Lista de procesos
└── config        # Parámetros de configuración
```

### Uso Común

```bash
# Ver información del cluster
cat /proc/hpc/info

# Ver estado de nodos
cat /proc/hpc/nodes

# Ver procesos activos
cat /proc/hpc/processes
```

### Nota sobre la Evolución de la Interfaz

En versiones anteriores de MOSIX (y en el fork openMosix), la interfaz estaba en `/proc/mosix`. Fue cambiada a `/proc/hpc` para estandarización y compatibilidad futura.

**Fuente:** [The openMosix HOWTO](https://tldp.org/HOWTO/pdf/openMosix-HOWTO.pdf), [MOSIX Administrator's Guide](http://www.mosix.cs.huji.ac.il/pub/Guide.pdf)

---

## 4. Utilidades de Instalación y Configuración Automática

MOSIX incluye herramientas para facilitar la instalación y configuración automática de nodos en el cluster.

### `mosconf` — Configuración Automática

MOSIX proporciona una herramienta que puede **detectar y configurar automáticamente los nodos participantes** en la mayoría de los clusters.

**Características:**
- Detección automática de nodos en la red
- Configuración de parámetros de red
- Sincronización de configuración entre nodos
- Script de instalación que puede instalar los binarios de MOSIX:
  - En el nodo local
  - En un directorio raíz común compartido por varios nodos del cluster

### Proceso de Instalación

1. Ejecutar el script de instalación en cada nodo
2. El script configura automáticamente la red y los parámetros de comunicación
3. Los nodos se descubren automáticamente cuando se unen al cluster

### Archivo de Mapeo

El archivo `/etc/hpc.map` (anteriormente `/etc/mosix.map`) contiene la información de los nodos del cluster, incluyendo:
- Direcciones IP de los nodos
- Identificadores únicos de nodo
- Configuración específica por nodo

**Fuente:** [MOSIX Installation and Configuration](https://mosix.cs.huji.ac.il/pub/instal-config.pdf), [MOSIX Administrator's Guide](http://www.mosix.cs.huji.ac.il/pub/Guide.pdf)

---

## 5. Monitores en Línea para Ver Estado del Cluster

MOSIX proporciona varias utilidades de monitoreo para observar el estado del cluster en tiempo real.

### `mosmon` — Monitor en Línea

`mosmon` es una herramienta de monitoreo que muestra información en tiempo real sobre:
- Carga de CPU por nodo
- Memoria disponible
- Procesos en ejecución
- Migraciones activas

### `mosps` — Lista de Procesos

Similar al comando `ps` estándar, pero muestra información específica de MOSIX:
- Procesos locales y remotos
- Nodo donde se ejecuta cada proceso
- Estado de migración

### `mostat` — Estadísticas del Cluster

Muestra estadísticas agregadas del cluster:
- Número de nodos activos
- Carga promedio
- Memoria total disponible

### Pantalla de Monitoreo Típica

```
NODO    CPU%    MEM%    PROCS    ESTADO
node1   45%     62%     12       ACTIVO
node2   78%     41%     8        ACTIVO
node3   12%     85%     3        ACTIVO
```

**Fuente:** [MOSIX Administrator's Guide](http://www.mosix.cs.huji.ac.il/pub/Guide.pdf)

---

## 6. Integración con SLURM Scheduler

MOSIX puede integrarse con **SLURM** (Simple Linux Utility for Resource Management), que es uno de los workload managers más utilizados en clusters HPC.

### ¿Qué es SLURM?

SLURM es un scheduler de trabajos open source para clusters Linux, utilizado en más del 60% de las Top500 supercomputadoras del mundo. Proporciona:
- Gestión de jobs y recursos
- Queue de trabajos
- Asignación de nodos
- Scheduling de prioridad

### Integración con MOSIX

La integración permite que SLURM gestione los jobs a nivel de cluster mientras MOSIX maneja la migración de procesos a nivel del sistema operativo. Esto puede proporcionar:
- **SLURM** maneja la asignación de recursos y scheduling de jobs
- **MOSIX** proporciona migración dinámica de procesos para optimización de carga

### Limitaciones de la Integración

- La integración no es nativa ni automática
- Requiere configuración manual específica
- Documentación limitada sobre detalles de implementación

### Alternativas Modernas

Para entornos HPC modernos, se recomienda usar directamente SLURM en lugar de MOSIX, ya que:
- SLURM tiene soporte comercial activo (SchedMD)
- Escalabilidad probada en supercomputadoras
- Comunidad activa y desarrollo continuo

**Fuente:** [Slurm Workload Manager](https://slurm.schedmd.com/), [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)

---

## 7. Lenguajes Soportados

MOSIX **no impone restricciones sobre los lenguajes de programación** que pueden utilizarse. Cualquier lenguaje que genere ejecutables Linux estándar (ELF) es compatible.

### Lenguajes Comprobadamente Compatibles

| Lenguaje | Tipo | Funciona con MOSIX |
|----------|------|---------------------|
| C/C++ | Compilado | ✅ Sí |
| Fortran | Compilado | ✅ Sí |
| Python | Interpretado | ✅ Sí |
| Java | Bytecode | ✅ Sí |
| Ruby | Interpretado | ✅ Sí |
| Go | Compilado | ✅ Sí |
| Perl | Interpretado | ✅ Sí |
| Rust | Compilado | ✅ Sí |

### Requisitos

- El código debe compilarse o interpretarse para generar ejecutables Linux estándar
- No requiere linkedición con librerías especiales de MOSIX
- Las aplicaciones deben ser ejecutables ELF estándar

### Consideraciones Especiales

- **Aplicaciones con threads:** Ver sección de limitaciones
- **Aplicaciones con memoria compartida:** Ver sección de limitaciones
- **Comunicación entre procesos:** Ciertos mecanismos de IPC tienen mejor rendimiento que otros

**Fuente:** [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)

---

## 8. Limitaciones known

MOSIX tiene varias limitaciones que los desarrolladores deben conocer antes de diseñar sus aplicaciones.

### 8.1 No Soporta Threads de la Forma Tradicional

MOSIX **no soporta aplicaciones con threads** de forma nativa. Los threads creados por una aplicación no se migran automáticamente entre nodos del cluster.

**Implicaciones:**
- Las aplicaciones multiproceso pueden migrar entre nodos
- Los threads dentro de un proceso permanecen en el mismo nodo
- Aplicaciones con Intensive use of threads pueden no beneficiarse de la migración

**Alternativas sugeridas:**
- Utilizar múltiples procesos en lugar de threads
- Diseñar aplicaciones para modelos de programación paralela distribuidos (MPI)

### 8.2 No Soporta Memoria Compartida entre Procesos

MOSIX utiliza un modelo de **memoria distribuida** (shared-nothing). No soporta memoria compartida entre procesos que corren en diferentes nodos.

**Implicaciones:**
- No hay soporte para Shared Memory (System V ni POSIX)
- Procesos en diferentes nodos no pueden compartir memoria directamente
- Aplicaciones que requieren DSM (Distributed Shared Memory) no son compatibles

**Alternativas:**
- Usar comunicación por paso de mensajes (MPI)
- Almacenar datos compartidos en el sistema de archivos
- Utilizar bases de datos o servicios externos

### 8.3 Rendimiento de IPC Variable

Ciertos mecanismos de IPC (Inter-Process Communication) tienen mejor rendimiento que otros en MOSIX:

| Mecanismo IPC | Rendimiento en MOSIX |
|---------------|----------------------|
| Pipes | Bueno |
| Sockets | Bueno |
| Message Queues | Variable |
| Shared Memory | **No soportado** |
| Semaphores | Variable |

### 8.4 Limitaciones de Migración

- **Memoria grande:** La migración de procesos con grandes espacios de memoria puede generar sobrecarga de red significativa
- **E/S intensiva:** Aplicaciones con alta E/S pueden no beneficiarse de la migración
- **Conexiones de red:** Los procesos migrados pueden usar conexiones de red, pero se debe tener cuidado con IPSec

**Fuente:** [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html), [The MOSIX Algorithms for Managing Cluster](https://os.inf.tu-dresden.de/Studium/DOS/SS2014/03-MOSIX.pdf)

---

## 9. Resumen de Herramientas Disponibles

| Herramienta | Propósito |
|-------------|----------|
| `mosrun` | Iniciar procesos migrables |
| `mosps` | Ver procesos activos |
| `mosmon` | Monitorear estado del cluster |
| `mostat` | Ver estadísticas del cluster |
| `/proc/hpc` | Interfaz de sistema para administración |
| `mosconf` | Configuración automática de nodos |
| SLURM | Scheduler de jobs (integración opcional) |

---

## 10. Fuentes

- [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)
- [MOSIX Tutorial](https://mosix.cs.huji.ac.il/pub/tutorial.pdf)
- [MOSIX Administrator's Guide](http://www.mosix.cs.huji.ac.il/pub/Guide.pdf)
- [MOSIX Installation and Configuration](https://mosix.cs.huji.ac.il/pub/instal-config.pdf)
- [The openMosix HOWTO](https://tldp.org/HOWTO/pdf/openMosix-HOWTO.pdf)
- [Grokipedia - MOSIX](https://grokipedia.com/page/mosix)
- [Slurm Workload Manager](https://slurm.schedmd.com/)

---

*Documento elaborado para Fundamentos de Sistemas Operativos — Mayo 2026*

---
## Nota Académica — Fundamentos de SO
**Conceptos de la materia relacionados:**

- **§1.8 — Llamadas al sistema: interfaz usuario-kernel**: MOSIX NO modifica la interfaz de syscalls del sistema operativo host. Las aplicaciones usan syscalls estándar de Linux (`fork()`, `exec()`, `read()`, `write()`) sin cambios. La diferencia es que MOSIX es un módulo del kernel que intercepta llamadas al scheduler y gestión de procesos internamente — el界面 entre aplicación y kernel permanece estándar POSIX.

- **§1.8 — `/proc/hpc` como interfaz de sistema**: La interfaz `/proc/hpc` es un sistema de archivos virtual (procfs) similar a `/proc` en Linux. Leer `cat /proc/hpc/nodes` genera una syscall de lectura que el kernel traduce a información del cluster. Este patrón es análogo a cómo funciona `/proc/meminfo` o `/proc/cpuinfo` — el kernel genera datos dinámicamente en respuesta a operaciones de lectura.

- **§1.7 — Interrupciones software (syscalls) y el modelo MOSIX**: En Linux, cuando un proceso hace `fork()`, genera una interrupción de software que transfiere control al kernel. MOSIX se inserta en ese flujo a nivel del scheduler del kernel (no a nivel de syscall). La migración de procesos ocurre después de que el kernel maneja la syscall `fork()` — MOSIX decide migrar el proceso resultante basándose en la carga de nodos.

- **§1.8 — Transparência de aplicaciones**: La capacidad de MOSIX de funcionar sin modificar aplicaciones demuestra que la capa de syscalls es unaABI estable. Las aplicaciones no necesitan invocar funciones especiales de MOSIX — el kernel ya maneja `fork()`, `exec()`, `exit()` estándar. MOSIX extiende el comportamiento del kernel sin cambiar la interfaz.
