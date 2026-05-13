# 7. Seguridad

## Enfoque general

Zephyr OS está diseñado para sistemas embebidos restringidos donde la seguridad debe ser verificable estáticamente y immutable en runtime. Su modelo se basa en hardware dedicado (MPU) y firmware signed. MOSIX, en cambio, fue diseñado para clusters HPC cerrados donde todos los nodos pertenecen a una misma organización y la confianza mutua es un prerequisito operativo.

---

## Zephyr OS

### Aislamiento por hardware (MPU)

Zephyr utiliza una **Memory Protection Unit (MPU)** para imponer restricciones de acceso a memoria a nivel de hardware. A diferencia de una MMU, la MPU no implementa memoria virtual ni paginación — solo permite o niega acceso a regiones ya mapeadas en memoria física.

| Región | Permisos | Propósito |
|--------|----------|-----------|
| Código/Flash | Read + Execute, No Write | Memoria de programa |
| Datos/RAM | Read + Write, No Execute | Variables y heap |
| Periféricos | Read + Write, No Execute | Registros de hardware |

La configuración de la MPU solo puede realizarse en **modo privilegiado** (kernel mode). En ARM se usan instrucciones `MRC/MCR`; en x86 se usan registros `MSR`. El código de usuario no puede modificar la configuración.

### Modo dual de operación

Zephyr implementa dos niveles de privilegio:

- **Kernel mode (privilegiado):** acceso completo a hardware, configuración de MPU, ejecución de instrucciones privilegiadas.
- **User mode (no privilegiado):** restricciones MPU activas, acceso limitado a regiones designadas, instrucciones privilegiadas generan una excepción (trap).

La transición entre modos es gestionada por el kernel. En cada *context switch*, la MPU se reconfigura automáticamente según el *memory domain* del thread entrante.

### ARM TrustZone

En plataformas ARM que lo soportan, Zephyr soporta **Secure / Non-Secure worlds** a través de ARM TrustZone. Esto divide la ejecución en dos mundos:

- **Secure World:** código de confianza que accede a recursos sensibles (criptografía, claves, *root of trust*).
- **Non-Secure World:** aplicaciones normales que solo acceden a la parte no segura de la memoria y periféricos.

### Criptografía integrada

Zephyr expone la **PSA Crypto API** (Platform Security Architecture, diseñada por Arm) como interfaz estandarizada de criptografía. Esta API ofrece portabilidad entre plataformas, *opacity* de claves (nunca se exponen directamente) y *cryptographic agility* (soporte para algoritmos futuros sin cambiar la API).

El backend criptográfico es **mbedTLS**, mantenido por Trusted Firmware. Zephyr incluye configuraciones predefinidas:

- `config-ccm-psk-tls1_2.h` → TLS 1.2 con AES-CCM
- `config-mini-tls1_2.h` → TLS 1.2 mínimo
- `config-coap.h` → Para protocolos CoAP/DTLS

TLS 1.2 es la versión mínima obligatoria; versiones anteriores (SSL 3.0, TLS 1.0, TLS 1.1) son rechazadas por vulnerabilidades conocidas.

### Secure Boot + MCUboot

La cadena de confianza de Zephyr verifica cada componente antes de ejecutarlo:

```
HARDWARE (RoT - immutable)
    ↓
ROM Bootloader (first-stage, immutable)
    ↓
MCUboot (bootloader portable)
    ↓
ZEPHYR KERNEL + APLICACIONES
```

MCUboot utiliza criptografía asimétrica (RSA-2048, RSA-3072, ECDSA P-256) para verificar firmas de firmware. El proceso: el binario se firma en *build time* con clave privada; la clave pública está embebida en MCUboot; en *boot time* se recalcula el hash del firmware y se compara con la firma descifrada.

El mecanismo de **A/B partitioning** (dual-bank) permite actualizaciones atómicas: nuevo firmware se descarga al slot inactivo, se verifica la firma, se intercambian slots y si falla se hace *rollback* al anterior. Un contador de imágenes previene *rollback* a versiones antiguas con vulnerabilidades conocidas.

### Stack protection

Zephyr implementa **stack guards** mediante *canaries* (valores especiales colocados entre buffers y return addresses). Antes de cada retorno de función o context switch, el runtime verifica que el canary no haya sido modificado.

Adicionalmente, las regiones de stack se marcan como **no-ejecutables** (`MPU_XN`):

```c
MPU_REGION(stack_region, stack_base, stack_size, MPU_RW | MPU_XN);
```

Esto significa que aunque un atacante escriba código *shell* en el stack, la CPU generará una excepción al intentar ejecutarlo.

### Modelo de permisos

Zephyr **no provee DAC** (Discretionary Access Control) ni RBAC (Role-Based Access Control). El aislamiento se limita a:

- Separación kernel/user mode via MPU.
- Memory domains que comparten regiones específicas entre grupos de threads.
- Filtrado de syscalls en modo usuario.

No existe un sistema de permisos tipo Unix (propietario/grupo/otros) para recursos del kernel.

### Certificaciones

Zephyr obtuvo la certificación **OpenSSF Gold Badge** en 2018-03-10, siendo uno de los primeros proyectos en lograrlo (Gold Badge mantenido y actualizado hasta 2024-06-05). Entre los requisitos: 90% de *statement coverage* en tests, 80% de *branch coverage*, auditoría externa por NCC Group (2020), TLS 1.2 mínimo obligatorio, y *two-person code review* documentado.

---

## MOSIX

### Modelo de confianza mutua

MOSIX asume que **todos los nodos del cluster son mutuamente confiables**. No es una configuración opcional ni graduable: el sistema no tiene mecanismos para verificar la integridad de nodos ni para aislar procesos de nodos no-confiables.

Según la documentación oficial:

> *"All remote nodes must be trustworthy... guest applications will not be modified during execution, and no hostile equipment will be connected to the LAN."*

Esto lo hace inapropiado para entornos multi-tenant, clouds públicos o nodos externos de terceros.

### Sandboxing a nivel de kernel

MOSIX se implementa como un **Loadable Kernel Module (LKM)** que corre dentro del kernel de Linux en modo privilegiado. Esto le permite:

- Acceder a hardware y memoria.
- Interceptar syscalls antes de que el kernel las procese.
- Controlar tablas del sistema.

Cuando un proceso guest (migrado) hace una syscall:

```
Proceso guest → Módulo MOSIX (intercepta) → ¿Es peligrosa?
                                               → SÍ: la bloquea/redirige
                                               → NO: la pasa al kernel normal
```

El aislamiento es **lógico/programático**, no basado en virtualización por hardware (VT-x/AMD-V) ni contenedores (namespaces/cgroups).

### Sandbox para procesos guest

El sandbox aísla procesos guest del nodo host:

| El proceso guest | Puede | No puede |
|------------------|-------|----------|
| Ejecutar su código normalmente | ✅ | |
| Usar CPU/memoria asignada | ✅ | |
| Acceder archivos del nodo origen (via DFSA) | ✅ | |
| Acceder archivos locales del nodo host | | ❌ |
| Modificar configuración del SO host | | ❌ |
| Instalar software o cargar módulos | | ❌ |
| Ver procesos del nodo host | | ❌ |
| Ejecutar syscalls peligrosas (mount, chroot, ptrace, syslog) | | ❌ |

**DFSA (Direct File System Access)** permite acceso transparente a archivos del nodo de origen mientras el proceso corre en otro nodo.

### UID unificado (SSI)

MOSIX implementa **Single System Image (SSI)**: el cluster se presenta como una sola máquina. Todos los nodos comparten el mismo UID/GID numérico — el UID "1000" en nodo A es el mismo UID "1000" en nodo B. No hay mapeo de UIDs entre nodos.

Los permisos efectivos se calculan **localmente** en cada nodo según las reglas de Linux estándar.

### Checkpoint/Restart

Cuando un proceso migra, se transfiere su contexto de ejecución completo: UID efectivo/real, GIDs suplementarios, capabilities, directorio de trabajo, descriptores de archivos abiertos, umask, límites de recursos, señales pendientes y estado de memoria.

**Limitación crítica:** los archivos de checkpoint **no están cifrados por defecto**. Contienen toda la memoria del proceso (contraseñas en texto claro, claves, datos sensibles). Está diseñado para clusters HPC donde los nodos son de confianza mutua.

### Comparación del modelo de seguridad

| Aspecto | Zephyr OS | MOSIX |
|---------|-----------|-------|
| **Aislamiento base** | Hardware (MPU) | Lógico (kernel module) |
| **Modo dual** | Sí (kernel/user) | Sí (kernel/proceso guest) |
| **Seguridad criptográfica** | PSA Crypto API + mbedTLS + Secure Boot | No disponible |
| **Verificación de firmware** | Firmas asimétricas + rollback protection | No disponible |
| **Control de acceso** | MPU regions (sin DAC/RBAC) | UID unificado + permisos locales |
| **Confianza en nodos** | N/A (dispositivo único) | Requerida (todos los nodos) |
| **Entornos multi-tenant** | Compatible | Incompatible |
| **Certificaciones** | OpenSSF Gold Badge | No aplica |

---

# 8. Facilidades para Desarrolladores

## Enfoque general

Zephyr OS ofrece un ecosistema completo orientado al desarrollo embedded, con herramientas modernas de build, configuración declarativa de hardware y documentación exhaustiva. MOSIX, en cambio, adopta un enfoque *drop-in*: el código Linux estándar funciona sin cambios en el cluster, sin necesidad de tooling especial más allá de una utilidad para marcar procesos como migrables.

---

## Zephyr OS

### West — Meta-build tool

**West** es la herramienta central en Python que unifica gestión de repositorios, build, flash y debug en un solo flujo. Zephyr se compone de múltiples repositorios Git (kernel + librerías + boards); sin West, cada uno debería gestionarse manualmente.

```bash
west init -l myapp      # Inicializar workspace
west update             # Descargar repos del manifiesto
west build -b <board>  # Compilar para board específica
west flash             # Grabar firmware al dispositivo
west debug             # Debug con GDB + OpenOCD
```

El archivo `west.yml` define qué repositorios conforman el workspace.

### CMake + KConfig

**CMake** es el sistema de build que genera archivos nativos del SO host (Ninja por defecto). Comparado con Make simple: soporte nativo de *cross-compilation*, multiplataforma (Linux, macOS, Windows), integración con IDEs (CLion, VSCode) y paralelismo automático.

**KConfig** (heredado del kernel de Linux) genera macros `#define CONFIG_X` usadas en compilación condicional. Permite habilitar features sin overhead runtime si no se usan, y valida dependencias automáticamente:

```
CONFIG_BT=y
CONFIG_LOG=y
CONFIG_LOG_DEFAULT_LEVEL=4
CONFIG_MAIN_STACK_SIZE=2048
```

### Device Tree

**Device Tree** es un formato de descripción declarativa del hardware. Archivos `.dts` describen periféricos, direcciones de memoria, pines e IRQs. El mismo driver funciona en Nordic nRF52840, STM32, ESP32 sin cambios en el código fuente.

```dts
&uart0 {
    status = "okay";
    current-speed = <115200>;
    tx-pin = <6>;
    rx-pin = <8>;
};
```

El flujo: se selecciona el `.dts` correspondiente a la board → CMake invoca `dtc` (DeviceTree Compiler) → se genera `devicetree.h` con macros `DT_NODELABEL()`, `DT_PROP()` → el driver usa estas macros para abstraer el hardware.

Componentes: `.dts` (base), `.dtsi` (includes), `.overlay` (modificaciones), `.dtso` (shields reutilizables).

### API POSIX-like

Zephyr implementa un **subconjunto de la API POSIX** para portar aplicaciones desde Linux/FreeBSD con modificaciones mínimas:

| Función | Descripción |
|---------|-------------|
| `open/close/read/write` | Acceso a archivos/dispositivos |
| `socket/bind/listen/accept/connect` | Networking |
| `select/poll` | I/O multiplexing |

**¿Por qué "POSIX-like" y no POSIX completo?** En microcontroladores sin MMU: memoria limitada (sin memoria virtual), sin procesos separados (una única imagen con múltiples threads), y overhead de implementar todas las syscalls.

### Zephyr SDK

El **Zephyr SDK** es un *bundle* con todas las toolchains para compilar Zephyr en cualquier arquitectura:

| Componente | Uso |
|-----------|-----|
| GCC/Binutils/GDB | Compilación default |
| LLVM/Clang | Alternativa a GCC |
| QEMU | Emulación para testing sin hardware |
| OpenOCD | Debugging via JTAG/SWD en hardware real |
| Ninja | Generador de build paralelo |

QEMU permite ejecutar firmware sin hardware real (útil para desarrollo inicial y CI/CD). OpenOCD actúa como puente entre GDB y el hardware (JTAG/SWD), permitiendo breakpoints, lectura/escritura de registros y *step-through*.

### Documentación

**docs.zephyrproject.org** ofrece: Getting Started Guide, documentación del sistema de build (CMake, KConfig, West, Devicetree), API Reference (Doxygen), soporte de hardware (boards, SoCs, drivers), samples y demos. Recursos adicionales: GitHub Discussions, Discord, *mailing lists* (zephyr-users, zephyr-devel) y Stack Overflow.

El proyecto es parte de la Linux Foundation, con board formal, procesos abiertos (PRs, issues públicos) y *releases* cada 2-3 meses.

---

## MOSIX

### Compatibilidad POSIX total

MOSIX **no modifica la interfaz de syscalls**. Se inserta en el kernel a nivel del *scheduler*, interceptando decisiones de migración *después* de que el kernel procesó las llamadas estándar. Las aplicaciones se compilan y *linkeditan* exactamente como en Linux normal.

| syscall | Función | Comportamiento en MOSIX |
|---------|---------|------------------------|
| `fork()` | Crear proceso hijo | Proceso migrable automáticamente |
| `exec()` | Cargar programa | ELF estándar sin cambios |
| `read()`/`write()` | E/S de archivos | Igual que Linux estándar |

**No requiere librerías especiales** — no hay `libmosix` ni nada equivalente. El código que corre en Linux estándar corre sin cambios en el cluster MOSIX.

### Ejecutables ELF estándar

MOSIX acepta ejecutables en formato **ELF** directamente, sin conversión ni flags de compilación especiales. La migración es transparente: un proceso puede moverse entre nodos durante su ejecución sin que la aplicación lo perciba.

### `mosrun` — Procesos migrables

```
mosrun [opciones] comando [argumentos]
```

`mosrun` marca el PCB del proceso como "migrable". El *scheduler* de MOSIX monitorea carga de CPU, memoria y red; cuando detecta desbalance, migra el proceso automáticamente. Todo ocurre sin intervención del desarrollador.

```bash
mosrun -k 8 ./aplicacion param1 param2
```

`-k maxjobs` limita la cantidad de jobs concurrentes.

### Herramientas de monitoreo

| Herramienta | Función |
|-------------|---------|
| `mosmon` | Monitor en tiempo real: carga de CPU, memoria, procesos por nodo, migraciones activas |
| `mosps` | Lista procesos en todos los nodos del cluster (similar a `ps`) |
| `mostat` | Estadísticas agregadas: nodos activos, carga promedio, memoria total disponible |

Estas herramientas acceden al kernel via `/proc/hpc` (filesystem virtual *procfs*). Cuando un proceso lee este "archivo", el kernel genera la información dinámicamente — no existe en disco.

### Integración con SLURM

**SLURM** (Simple Linux Utility for Resource Management) es un *workload manager* open source usado en más del 60% de las supercomputadoras Top500. Gestiona jobs, colas, asignación de nodos y priorización.

MOSIX puede funcionar junto con SLURM: SLURM decide qué job corre en qué nodo; MOSIX optimiza recursos moviendo procesos dentro del cluster. La integración no es nativa y requiere configuración manual.

### Limitaciones conocidas

| Aspecto | Limitación |
|---------|------------|
| **Threads** | No se migran automáticamente — permanecen en el mismo nodo |
| **Memoria compartida** | No soportada (ni System V ni POSIX shared memory) |
| **Modelo** | Shared-nothing (memoria distribuida) |
| **IPC** | Pipes y sockets: buenos. Message queues y semaphores: variables. Shared memory: no soportado |
| **Memoria grande** | Genera tráfico de red significativo durante migración |

Para aplicaciones paralelas que requieren comunicación entre nodos, se sugiere **MPI** (paso de mensajes) como alternativa.

### Comparación de herramientas de desarrollo

| Facilidad | Zephyr OS | MOSIX |
|----------|-----------|-------|
| **Build system** | West + CMake + Ninja | Standard `gcc`/compilador Linux |
| **Configuración** | KConfig + Device Tree | `mosrun` + configuración de nodo |
| **API del SO** | Subconjunto POSIX | POSIX completa |
| **Debugging** | GDB + OpenOCD (JTAG/SWD) | GDB estándar Linux |
| **Emulación** | QEMU integrado | QEMU/KVM estándar |
| **Toolchain** | Zephyr SDK (bundled) | Ninguno especial |
| **Librerías** | mbedTLS, net stack integrado | Librerías Linux estándar |
| **Docs** | Exhaustiva (docs.zephyrproject.org) | Limitada |
| **SLURM** | No aplica | Soportado (configuración manual) |
| **Vendor lock-in** | Sí (vendor SDK) | No |

---

*Secciones 7 y 8 — Informe Comparativo Zephyr OS vs MOSIX — Fundamentos de Sistemas Operativos, UNMDP — Mayo 2026*