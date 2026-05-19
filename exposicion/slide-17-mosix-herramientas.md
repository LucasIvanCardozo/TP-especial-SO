# Slide 17 — MOSIX: Facilidades para Desarrolladores

## 🎤 Qué Decir (Speaking Notes)

**Apertura (10 segundos):**
"MOSIX tiene una filosofía muy clara: cero fricción para el desarrollador. La idea central es que puedas tomar cualquier aplicación Linux que ya tengas funcionando y ejecutarla en el cluster sin modificar una sola línea de código."

**Desarrollo principal (35 segundos):**

"MOSIX no te obliga a aprender ninguna API proprietaria ni a linkeditar librerías especiales. Funciona con el estándar POSIX — las mismas llamadas al sistema que usarías en cualquier Linux: `fork()` para crear procesos, `exec()` para ejecutar programas, `read()` y `write()` para operaciones de archivos."

"La clave de esta transparencia está en que MOSIX opera a nivel del scheduler del kernel. Las syscalls se ejecutan exactamente igual que en Linux standard, pero después, cuando el scheduler decide dónde ejecutar el proceso, MOSIX puede migrarlo a otro nodo del cluster si conviene. La aplicación no se entera."

"Las herramientas que MOSIX provee para esto son bastante directas: `mosrun` para lanzar procesos migrables, `mosmon` para ver la carga del cluster en tiempo real, `mosps` para listar procesos distribuidos, y `mostat` para estadísticas."

**Cierre (15 segundos):**
"Es importante notar que MOSIX maneja procesos, no threads — los threads de un proceso quedan en el mismo nodo. También tiene integración posible con SLURM, el workload manager que usan más del 60% de las supercomputadoras Top500, aunque esta integración requiere configuración manual."

---

## 📌 Puntos Clave

| Concepto                 | Explicación                                                                                              |
| ------------------------ | -------------------------------------------------------------------------------------------------------- |
| **Transparencia total**  | Cualquier ejecutable ELF estándar funciona sin recompilación ni librerías especiales                     |
| **API POSIX estándar**   | `fork()`, `exec()`, `read()`, `write()` operan idénticamente a Linux                                     |
| **Migración automática** | El scheduler decide migrar procesos basándose en carga de CPU, memoria y red                             |
| **Herramientas clave**   | `mosrun` (iniciar procesos migrables), `mosmon` (monitoreo), `mosps` (procesos), `mostat` (estadísticas) |
| **Integración SLURM**    | Posible combinación con el workload manager estándar de HPC                                              |

---

## 🔗 Relación con FSO

### §1.8 — Llamadas al Sistema

La transparencia de MOSIX depende directamente del concepto de syscalls (§1.8). La cadena es:

```
Aplicación → syscall fork() → Kernel Linux estándar → MOSIX scheduler decide migrar
```

MOSIX **no modifica** la interfaz de syscalls. Opera después de que el kernel procesa cada llamada. Las aplicaciones ven exactamente el mismo comportamiento que en Linux.

### §1.7 — Interrupciones de Software

Cuando un proceso ejecuta `fork()` o cualquier syscall, genera una interrupción de software (`syscall` en x86-64). El kernel maneja esta interrupción y MOSIX se inserta en ese flujo a nivel del scheduler.

### §2.3 — PCB (Process Control Block)

MOSIX marca ciertos procesos como "migrables" usando una bandera en el PCB. El scheduler de MOSIX monitorea el estado de todos los nodos y decide cuándo migrar basándose en:

- Carga de CPU por nodo
- Memoria disponible
- Latencia de red entre nodos

### §1.4 — Arquitecturas de SO

MOSIX es una **extensión de kernel Linux** — opera como una capa sobre el kernel existente. Esto es diferente de un sistema monolítico puro o un microkernel. El modelo es un "overlay" que extiende las capacidades del scheduler sin modificar el kernel base.

### /proc/hpc como procfs dinámico

Las herramientas de monitoreo (`mosmon`, `mosps`, `mostat`) acceden a información del cluster a través de `/proc/hpc`. Este es un filesystem virtual (procfs) que genera datos dinámicamente cuando se lee — similar a `/proc/meminfo` o `/proc/cpuinfo`.

---

## ⚠️ Cosas a Tener en Cuenta

### Comparación con Zephyr (herramientas de desarrollo)

| Aspecto                      | MOSIX                                                | Zephyr                                                    |
| ---------------------------- | ---------------------------------------------------- | --------------------------------------------------------- |
| **Curva de aprendizaje**     | Muy baja (usa herramientas Linux estándar)           | Pronunciada (West, Kconfig, Devicetree)                   |
| **Modificaciones de código** | Ninguna requerida                                    | Puede requerir configuración específica                   |
| **Toolchain**                | gcc, make, CMake estándar                            | Toolchain específico del proyecto (Zephyr SDK o external) |
| **Debugging**                | gdb normal, conectado al nodo donde corre el proceso | West + OpenOCD + J-Link, debugging embebido               |
| **Documentación**            | Limitada (FAQ, tutorial, guía de admin)              | Exhaustiva (docs.zephyrproject.org)                       |
| **Comunidad activa**         | No (proyecto inactivo desde 2017)                    | Sí (3000+ contribuyentes)                                 |

### Limitaciones de MOSIX

1. **No migra threads automáticamente**: los threads de un proceso permanecen juntos en el mismo nodo
2. **No soporta memoria compartida entre nodos**: modelo shared-nothing
3. **Documentación limitada**: menos recursos disponibles que proyectos activos
4. **Proyecto inactivo**: sin soporte ni actualizaciones desde 2017

### Contexto práctico

Si ya tenés una aplicación Linux corriendo, MOSIX permite "levantar" el cluster sin cambios. Pero si necesitás debugging avanzado, monitoreo detallado, o soporte activo, Zephyr tiene un ecosistema más robusto.

---

## ⏱️ Tiempo Estimado

**45-60 segundos** para esta slide.

- Apertura: 10s
- Desarrollo: 35s
- Cierre: 15s

---

## 🎯 Tips para la Presentación

- **Mencionar `mosrun`** como la herramienta estrella — es lo que hace que un proceso sea migrable
- **Contrastá con Zephyr**: donde Zephyr requiere aprender West y Kconfig, MOSIX usa herramientas Linux estándar
- **Acentuá la transparencia**: "compilás tu programa con gcc, lo ejecutás con mosrun, y MOSIX se encarga del resto"
- **Nota sobre SLURM**: mencionar que es el estándar en supercomputadoras (60%+ de Top500) muestra que MOSIX se pensó para entornos HPC reales
