# Slide 16 — Zephyr OS: Facilidades para Desarrolladores

---

## 1. 🎤 Qué decir (Speaking Notes)

**Apertura sugerida:**

> "Zephyr no solo es un RTOS técnico, también tiene un ecosistema de desarrollo muy completo. Hay tres componentes principales que hacen que desarrollar para Zephyr sea accesible: el toolchain, el sistema de build, y las APIs."

**Toolchain completo (build, flash, debug):**

> "El toolchain de Zephyr soporta las arquitecturas más comunes: ARM Cortex-M, RISC-V, x86, y más. Para compilar se usa GCC o Clang. Para flashear el firmware al microcontrolador, Zephyr se integra con herramientas como J-Link, OpenOCD y pyOCD. Y para debugging, usa GDB — el debugger estándar de Linux. Todo esto funciona de forma integrada."

**West Build System:**

> "West es la herramienta central de build de Zephyr. Es una meta-tool escrita en Python que maneja varias funciones: descarga y mantiene las dependencias del proyecto, configura el sistema con Kconfig, compila con CMake y Ninja, y finalmente flashea el firmware. La ventaja es que con un solo comando — `west build` — se hace todo el flujo completo desde cero."

**API POSIX-like:**

> "Zephyr provee una API estilo POSIX para las operaciones más comunes: gestión de archivos, threads, sockets. Esto facilita la迁移 de código desde Linux. No es POSIX compliant al 100%, pero la mayoría de las funciones como `open()`, `read()`, `write()`, `pthread_create()` están disponibles."

---

## 2. 📌 Puntos Clave

| Herramienta       | Función                   | Dato interesante                                            |
| ----------------- | ------------------------- | ----------------------------------------------------------- |
| **West**          | Meta-tool de build        | Hecha en Python, maneja múltiples repos (zephyr, hal, etc.) |
| **Kconfig**       | Configuración del sistema | Genera `.config` con opciones de features, drivers, tamaño  |
| **DeviceTree**    | Descripción de hardware   | Describe perifericos sin cambiar código C                   |
| **CMake + Ninja** | Compilación               | Builds incrementales rápidos                                |
| **GDB / OpenOCD** | Debug                     | Funciona con hardware real y QEMU                           |
| **J-Link**        | Flashing                  | Muy usado en la industria                                   |

**Flujo de desarrollo típico:**

```
1. west init ~/zephyrproject      # Clonar repos
2. west update                    # Descargar dependencias
3. west build -b nucleo_f401 app  # Compilar para placa Nucleo-F401
4. west flash                     # Grabar firmware
5. west debug                     # Depurar con GDB
```

---

## 3. 🔗 Relación con FSO

### §1.8 — Llamadas al Sistema

La API POSIX-like de Zephyr implementa un subconjunto de las syscalls que vimos en la materia:

- `fork()` / `vfork()` — creación de procesos (aunque en Zephyr son threads)
- `exec()` — ejecutar nuevo programa
- `open()`, `read()`, `write()`, `close()` — operaciones de archivos

Esto conecta directamente con el concepto de **interfaz entre usuario y kernel** del temario.

### §2.3 — PCB y Estados de Procesos

Cuando debuggeás con GDB, estás manipulando el estado de un proceso (registros, PC, memoria). El debugger se conecta al target via OpenOCD/J-Link y puede leer/escribir el PCB del proceso que está corriendo en el microcontrolador.

### §3.4 — Operaciones sobre Archivos

El VFS de Zephyr (que vieron en la slide 8) implementa las operaciones de archivos: `create`, `delete`, `open`, `close`, `read`, `write`. West usa estas operaciones internamente para manejar los archivos de configuración del proyecto.

### §4.4 — Paginación (relación débil)

En sistemas embebidos sin MMU, Zephyr no usa paginación tradicional. Pero los conceptos de **memoria virtual** y **direccionamiento** que vimos en FSO aplican cuando Zephyr corre en boards con MPU: la MPU configura regiones de memoria con permisos, similar a las tablas de páginas pero simplificado.

---

## 4. ⚠️ Cosas a tener en cuenta

**Para la exposición:**

- ✅ Mencionar que West unifica todo el flujo — no hace falta usar makefiles a mano
- ✅ Explicar Kconfig como "el menú de opciones de Linux kernel"
- ✅ DeviceTree es similar a tener drivers genéricos configurables por archivos de texto
- ✅ La API POSIX-like reduce la curva de aprendizaje para devs Linux
- ⚠️ **No entrar en detalles técnicos de CMake o Ninja** — son detalles de implementación
- ⚠️ **No explicar Kconfig en profundidad** — mencionar que existe y para qué sirve
- ⚠️ **Evitar mencionar todas las arquitecturas** — solo decir "las principales"

**Pregunta probable:**

> "¿Cómo se programa en Zephyr?"

**Respuesta sugerida:**

> "Se programa en C, como la mayoría de los sistemas embebidos. Zephyr provee una API estándar para threads, timers, interrupciones, y comunicación. El código se estructura en módulos (boards, drivers, aplicación) que se configuran con Kconfig y DeviceTree."

---

## 5. ⏱️ Tiempo estimado

| Sección                         | Tiempo           |
| ------------------------------- | ---------------- |
| Apertura y contexto             | 10 segundos      |
| Toolchain (build, flash, debug) | 15 segundos      |
| West build system               | 20 segundos      |
| API POSIX-like                  | 10 segundos      |
| **Total**                       | **~55 segundos** |

---

## 6. 📝 Notas rápidas para recordar

```
ZEPHYR TOOLCHAIN:
- GCC/Clang → compilar
- OpenOCD/J-Link/pyOCD → flashear
- GDB → debuggear

WEST = meta-tool Python:
- west init     → clone repos
- west update   → download deps
- west build    → compilar
- west flash    → grabar
- west debug    → debugear

DEVICE TREE = descripción de hardware en texto
KCONFIG = menú de features como Linux kernel
```

---

_Notas de exposición generadas para Slide 16 — TP Especial Zephyr vs MOSIX_
_Fundamentos de Sistemas Operativos — Mayo 2026_
