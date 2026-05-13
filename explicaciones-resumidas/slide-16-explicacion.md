# slide-16-explicacion.md — MOSIX: Facilidades para Desarrolladores (Resumen)

## 1. Filosofía Central

MOSIX permite ejecutar aplicaciones Linux estándar en un cluster **sin modificar el código**. El desarrollador escribe aplicaciones normales, las compila con herramientas estándar, y MOSIX distribuye y balancea automáticamente los procesos entre nodos. No requiere APIs propietarias ni librerías especiales.

---

## 2. API POSIX — Compatibilidad Total

MOSIX **no modifica la interfaz de syscalls**. Se inserta en el kernel a nivel del scheduler, interceptando decisiones de migración *después* de que el kernel procesó las llamadas estándar.

| syscall | Función | Comportamiento en MOSIX |
|---------|---------|------------------------|
| `fork()` | Crear proceso hijo | Proceso migrable automáticamente |
| `exec()` | Cargar programa | ELF estándar sin cambios |
| `read()`/`write()` | E/S de archivos | Igual que Linux estándar |

**No requiere librerías especiales** — las aplicaciones se compilan y linkeditan exactamente como en Linux normal.

---

## 3. Ejecutables ELF Estándar

ELF (Executable and Linkable Format) es el formato de ejecutables en Linux. MOSIX acepta estos archivos directamente, sin conversión ni flags de compilación especiales.

**Migración transparente**: un proceso puede moverse entre nodos durante su ejecución sin que la aplicación lo perciba. MOSIX transfiere el estado completo (registros CPU, tabla de páginas de memoria, descriptores abiertos) al nodo destino.

---

## 4. `mosrun` — Iniciar Procesos Migrables

```
mosrun [opciones] comando [argumentos]
```

**Opciones principales:**

| Opción | Descripción |
|--------|-------------|
| `-k maxjobs` | Limita jobs concurrentes |
| `-h` | Ayuda |
| `-v` | Modo debug |

**Ejemplo:**
```bash
mosrun -k 8 ./aplicacion param1 param2
```

**Mecanismo**: `mosrun` marca el PCB del proceso como "migrable". El scheduler de MOSIX monitorea carga de CPU, memoria y red; cuando detecta desbalance, migra el proceso automáticamente. Todo ocurre sin intervención del desarrollador.

---

## 5. Herramientas de Monitoreo

### `mosmon` — Monitor en Tiempo Real
Muestra carga de CPU, memoria disponible, procesos por nodo y migraciones activas. Es un "dashboard" continuo del cluster.

### `mosps` — Procesos del Cluster
Similar a `ps` de Linux, pero lista procesos en **todos los nodos**:

```
PID     NODO    USUARIO   COMANDO          ESTADO
1234    node1   juan      ./app             MIGRABLE
5678    node2   maria     python test.py    MIGRABLE
```

### `mostat` — Estadísticas Agregadas
Muestra nodos activos, carga promedio, memoria total disponible y cantidad total de procesos.

**Conexión con FSO**: estas herramientas acceden al kernel via `/proc/hpc` (filesystem virtual procfs). Cuando un proceso lee este "archivo", el kernel genera la información dinámicamente — no existe en disco.

---

## 6. Integración con SLURM

**SLURM** (Simple Linux Utility for Resource Management) es un workload manager open source usado en >60% de las supercomputadoras Top500. Gestiona jobs, colas, asignación de nodos y priorización.

**MOSIX + SLURM**: SLURM decide qué job corre en qué nodo; MOSIX optimiza recursos moviendo procesos dentro del cluster.

**Limitaciones**: no es integración nativa, requiere configuración manual, documentación limitada.

---

## 7. Limitaciones Importantes

| Aspecto | Limitación |
|---------|------------|
| **Threads** | No se migran automáticamente — permanecen en el mismo nodo |
| **Memoria compartida** | No soportada (ni System V ni POSIX shared memory) |
| **Modelo** | Shared-nothing (memoria distribuida) |
| **IPC** | Pipes y sockets: buenos. Message queues y semaphores: variables. Shared memory: no soportado |
| **Memoria grande** | Genera tráfico de red significativo durante migración |
| **IPSec** | Cuidado con conexiones encriptadas al migrar |

**Alternativas sugeridas**: MPI (paso de mensajes) para aplicaciones paralelas que requieren comunicación entre nodos.

---

## 8. Glosario Rápido

- **POSIX**: Estándar IEEE 1003 que define la interfaz entre aplicaciones y SO
- **Syscall**: Llamada al sistema para solicitar servicios del kernel
- **ELF**: Formato estándar de ejecutables en Linux
- **ABI**: Application Binary Interface — define cómo binarios interactúan con el SO
- **PCB**: Process Control Block — estructura del kernel con información del proceso
- **Scheduler**: Planificador que decide qué proceso usa la CPU
- **/proc/hpc**: Filesystem virtual de MOSIX con info del cluster
- **HPC**: High Performance Computing
- **IPC**: Inter-Process Communication (pipes, sockets, colas, memoria compartida)
- **Shared-nothing**: Arquitectura donde cada nodo tiene memoria propia

---

## 9. Resumen de Facilidades

| Facilidades para Desarrolladores | Detalle |
|--------------------------------|---------|
| API POSIX estándar | `fork()`, `exec()`, `read()`, `write()` sin cambios |
| Sin recompilación | Ejecutables ELF estándar funcionan directamente |
| Sin librerías especiales | No requiere linkedición con librerías de MOSIX |
| `mosrun` | Inicia procesos migrables para balanceo automático |
| Monitoreo | `mosmon`, `mosps`, `mostat` para observar el cluster |
| Integración SLURM | Posible usar ambos sistemas juntos |
| Multi-lenguaje | C/C++, Fortran, Python, Java, Go, Rust, Perl, Ruby |

---

*Resumen — Fundamentos de Sistemas Operativos — Mayo 2026*