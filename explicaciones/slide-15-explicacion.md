# Slide 15 — Explicación: Facilidades para Desarrolladores Zephyr

## Contexto y Propósito

Esta slide presenta el ecosistema de herramientas que Zephyr Project ofrece a los desarrolladores para crear aplicaciones sobre el RTOS. El objetivo es doble: (1) mostrar que Zephyr proporciona una toolchain profesional y completa, comparable a la de sistemas operativos de producción, y (2) demostrar que la curva de aprendizaje es suavizada por herramientas maduras, APIs estándares (POSIX) y documentación extensiva.

Desde la perspectiva de Fundamentos de Sistemas Operativos (§1.8 — Llamadas al Sistema), esta slide ilustra cómo un RTOS moderno implementa la interfaz entre aplicaciones de usuario y el kernel, adoptando el patrón histórico de syscalls que UNIX popularizó hace décadas. La diferencia fundamental es que en un RTOS embebido el overhead de la transición usuario→kernel debe minimizarse, y la capa POSIX es frecuentemente un subconjunto o una abstracción sobre mecanismos internos optimizados.

---

## 1. West Build System

### ¿Qué es?

**West** es la meta-herramienta central del ecosistema Zephyr, escrita en Python. Su nombre proviene del proyecto "West" que originalmente desarrolló Nordic Semiconductor como alternativa a la herramienta de build de Google's Buildroot. Fue adoptada como herramienta oficial del proyecto Zephyr y resuelta como "the swiss army knife" del ecosistema.

### ¿Por qué existe?

Antes de West, Zephyr (heredado de Intel's '行程' Quark SE) utilizaba un sistema de build basado en CMake directo. Sin embargo, la gestión de múltiples repositorios (el kernel principal + bibliotecas adicionales como LittleFS, mbedTLS, etc.) era manual y propensa a errores. West unifica:

- **Gestión de repositorios múltiples**: Zephyr no es un monolito; está organizado en múltiples repositorios Git (zephyr, hal_*, lib, etc.). West maneja elcheckout y actualización de todos ellos mediante un archivo de manifiesto YAML.
- **Build + Flash + Debug**: Un solo comando (`west`) para todo el flujo de desarrollo, en lugar de invocar CMake, luego un programador, luego un debugger por separado.
- **Extensibilidad**: West permite escribir "extension commands" en Python para agregar funcionalidad custom.

### ¿Cómo se usa?

```bash
# Inicializar workspace (solo primera vez)
west init -l myapp

# Descargar/actualizar todos los repos del manifiesto
west update

# Compilar una aplicación para una board específica
west build -b nrf52840dk_nrf52840 my_app

# Flashear el firmware al dispositivo
west flash

# Iniciar debugging con GDB + OpenOCD
west debug

# Abrir consola serial
west espressif monitor   # o west zephyr-debug
```

El archivo de manifiesto `west.yml` define qué repositorios conforman el workspace:

```yaml
# west.yml ejemplo
manifest:
  self:
    path: my-zephyr-workspace
  projects:
    - name: zephyr
      url: https://github.com/zephyrproject-rtos/zephyr
    - name: hal_nordic
      url: https://github.com/nrfconnect/sdk-hal_nordic
```

### Conexión con §1.8

West no es una syscall ni forma parte del kernel; es una herramienta de espacio de usuario que orchestration el proceso de build. Sin embargo, el producto final de West —el firmware compilado— contiene las syscalls que la aplicación invocará en runtime. West es puramente una herramienta de desarrollo, no un componente del sistema runtime.

---

## 2. CMake + Kconfig

### CMake

**CMake** es el sistema de build que Zephyr utiliza internamente para compilar el kernel, bibliotecas y aplicaciones. No es una invención de Zephyr; es una herramienta estándar de la industria (usada por LLVM, KDE, Blender, etc.) que genera archivos de build nativos del sistema operativo host (Makefiles en Linux, Ninja en Windows, proyectos de IDE).

#### ¿Por qué CMake y no Make directo?

| Aspecto | make simple | CMake |
|---------|-------------|-------|
| Cross-compilation | Manual y propenso a errores | Soporte nativo con toolchains |
| Multi-plataforma | Solo Unix-like | Linux, macOS, Windows |
| IDE integration | Ninguna | CLion, VSCode, Eclipse |
| Out-of-tree builds | Soportado pero incómoda | Primera clase |
| Paralelismo | `make -j4` | Ninja por defecto con parallel jobs |

#### Estructura de un proyecto Zephyr con CMake

```
myapp/
├── CMakeLists.txt          # Archivo principal de build
│                         # Define: nombre del proyecto, SDK mínimo,
│                         # fuentes, dependencias con Zephyr
├── prj.conf               # Configuraciones KConfig para esta app
├── app.overlay            # Overlays de Devicetree (opcional)
└── src/
    └── main.c             # Código de la aplicación
```

El `CMakeLists.txt` típico:

```cmake
cmake_minimum_required(VERSION 3.20.0)
include($ENV{ZEPHYR_BASE}/cmake/app/boilerplate.cmake)
project(my_app)

FILE(GLOB app_sources src/*.c)
target_sources(app PRIVATE ${app_sources})
```

### KConfig

**KConfig** es el sistema de configuración que Zephyr hereda del kernel de Linux. Es un lenguaje declarativo para definir opciones de configuración que pueden ser habilitadas, deshabilitadas o ajustadas mediante valores numéricos o string.

#### ¿Por qué existe?

En un RTOS como Zephyr que debe correr en más de 1000 boards distintas, con múltiples arquitecturas (ARM, RISC-V, x86, Xtensa, etc.), y soporta cientos de features opcionales (stack de red, BLE, cryptographic APIs, filesystems), es imposible mantener una única configuración. KConfig permite:

- **Seleccionar features** en tiempo de compilación (no runtime overhead si no se usa)
- **Validar dependencias** automáticamente (si CONFIG_BT=y requiere CONFIG_NETWORKING=y)
- **Generar headers C** con `#define CONFIG_X 1` que el código fuente utiliza para compilación condicional
- **Documentar opciones** con ayuda texto

#### Ejemplo de prj.conf

```
# Habilitar Bluetooth
CONFIG_BT=y
CONFIG_BT_PERIPHERAL=y

# Configurar logger
CONFIG_LOG=y
CONFIG_LOG_DEFAULT_LEVEL=4

# Tamaño de stack para threads de usuario
CONFIG_MAIN_STACK_SIZE=2048

# Filesystem
CONFIG_FAT_FILESYSTEM_ELM=y
CONFIG_DISK_DRIVERS=y
```

#### Conexión con §1.8 (Syscalls)

KConfig y CMake operan exclusivamente en tiempo de compilación. Generan el firmware que luego se ejecutará. La configuración resultante se "fija" en el binary final; no hay syscalls involucradas en el proceso de build.

Sin embargo, las opciones CONFIG_ habilitan o deshabilitan código que maneja syscalls. Por ejemplo, si `CONFIG_POSIX_API=y` entonces el código que implementa las funciones POSIX (`open`, `read`, etc.) se compila; si es `n`, esas funciones no existen en la imagen.

---

## 3. DeviceTree

### ¿Qué es?

**DeviceTree** (formalmente "Open Firmware Device Tree") es un formato de descripción de hardware estructurado en forma de árbol. Zephyr lo adoptó del kernel de Linux para describir el hardware sin necesidad de recompilar el kernel o escribir código específico por board.

La sintaxis se parece a esto:

```dts
/* nrf52840dk_nrf52840.dts */
&uart0 {
    status = "okay";
    current-speed = <115200>;
    tx-pin = <6>;
    rx-pin = <8>;
};

&i2c0 {
    status = "okay";
    sda-pin = <26>;
    scl-pin = <27>;
};
```

### ¿Por qué existe?

**El problema fundamental**: Imaginen escribir un driver para el UART de un SoC Nordic nRF52840. Ese mismo driver, en esencia, debería funcionar en un STM32 de STMicroelectronics o en un ESP32 de Espressif. Los periféricos hacen lo mismo (recibir/transmitir bytes por un puerto serie), pero los registros de hardware, las direcciones de memoria y las señales de interrupción son completamente diferentes.

**Sin DeviceTree**: El driver tendría código conditional por cada SoC soportado, o existiría una capa de abstracción manual que cada developer debería mantener.

**Con DeviceTree**: El hardware se describe en un archivo `.dts`. El driver consulta el Devicetree para encontrar el UART, extraer su dirección base, velocidad, pines, e IRQ. El mismo driver compilado funciona en cualquier board cuyo Devicetree declare un UART compatible.

### Componentes del sistema DeviceTree en Zephyr

| Componente | Función |
|------------|---------|
| `.dts` | Archivo de descripción del árbol de dispositivo base |
| `.dtsi` | Archivos de inclusión (SoC, CPU, generícos) |
| `.overlay` | Modificaciones al árbol para una aplicación específica |
| `.dtso` |Fragmentos de Devicetree reutilizables (shields) |
| `dtc` (DeviceTree Compiler) | Compila `.dts` → `.dtb` (binary blob) |
| `devicetree.h` | Header C generado que el código fuente incluye |

### ¿Cómo funciona en la práctica?

1. El desarrollador escribe o selecciona un `.dts` para su board (ya existe para las 1000+ boards soportadas)
2. CMake invoca al compilador de Devicetree (`dtc`) durante el build
3. Se genera un header `devicetree.h` con macros como `DT_NODELABEL(uart0)`, `DT_PROP(uart0, current_speed)`
4. El código del driver usa estas macros para interacts con el hardware real

```c
// Ejemplo de uso en driver UART
#include <zephyr/device.h>
#include <zephyr/devicetree.h>

#define UART_NODE DT_NODELABEL(uart0)

static const structuart_config uart_cfg = {
    .current_speed = DT_PROP(UART_NODE, current_speed),
    .parity = DT_PROP_OR(UART_NODE, parity, UART_LTE_PAR_NONE),
};
```

### ¿Por qué es crucial para embedded?

1. **Separación software/hardware**: El mismo binary puede targetear boards diferentes si tienen el mismo Devicetree (o similar), sin recompilar.
2. **Productividad**: Los fabricantes de boards proveen los archivos `.dts`; los desarrolladores de aplicaciones raramente necesitan escribirlos.
3. **Flexibilidad**: Un `.overlay` permite modificar la configuración sin tocar los archivos base (por ejemplo, deshabilitar un periférico que no se usa, o cambiar pins).
4. **Reutilización de drivers**: Un driver escrito contra las macros del Devicetree funciona en cualquier SoC que proporcione la descripción adecuada.

### Relación KConfig ↔ Devicetree

| Aspecto | KConfig | Devicetree |
|---------|---------|------------|
| **¿Qué describe?** | Features de software (drivers, subsistemas, opciones) | Hardware (periféricos, direcciones, pines, IRQs) |
| **Procesamiento** | Compilación (genera macros `#define CONFIG_X`) | Compilación (genera header `devicetree.h`) |
| **Sintaxis** | `CONFIG_X=y` en archivos `.conf` | Estructura de árbol en archivos `.dts`/`.dtsi`/`.overlay` |
| **Tipicamente谁来 escribe** | Developer de aplicación | Vendor de board o SoC |
| **Ejemplo** | `CONFIG_I2C=y` habilita el subsistema I2C en el build | `&i2c0 { status = "okay"; }` describe qué hardware I2C existe |

---

## 4. Zephyr SDK

### ¿Qué es?

El **Zephyr SDK** es un bundle que contiene todas las toolchains necesarias para compilar Zephyr para cualquier arquitectura soportada. No es estrictamente requerido —uno puede usar toolchains externas (como la GNU ARM Embedded Toolchain)— pero es la opción recomendada y, para algunas arquitecturas, la única que funciona correctamente.

### Componentes del SDK

| Componente | Descripción | Uso típico |
|------------|-------------|------------|
| **GNU Toolchains** | GCC, Binutils (ld, as), GDB para todas las arquitecturas | Build default para la mayoría de usuarios |
| **LLVM/Clang** | Compilador Clang, lld, lldb | Desarrollo que prefiere LLVM |
| **QEMU** | Emulador de sistemas completos | Testing sin hardware, CI/CD |
| **OpenOCD** | On-Chip Debugger | Debugging en hardware real via JTAG/SWD |
| **Ninja** | Generador de build (alternativa a Make) | Builds paralelos más rápidos |
| **DeviceTree Compiler** | `dtc` | Compilación de Devicetree |

### ¿Por qué el SDK existe como bundle?

Porque en sistemas embebidos, cross-compilación es la norma. El host (PC) ejecuta x86_64 Linux, pero el target puede ser ARM Cortex-M4 (nRF52840), RISC-V (ESP32-C6), o Xtensa (ESP32). Cada arquitectura necesita su propio compilador, linker, y debugger. El SDK proporciona todos estos toolchains preconstruidos y verificados para trabajar juntos, evitando al desarrollador la complejidad de obtener y configurar toolchains individuales.

### QEMU en el SDK

QEMU (Quick Emulator) permite ejecutar firmware Zephyr sin hardware físico. Esto es invaluable para:

- **Desarrollo inicial** cuando el hardware aún no llegó
- **CI/CD**: tests automatizados que no requieren flashear dispositivos reales
- **Debugging visual**: observar el comportamiento sin un debugger de hardware
- **Arquitecturas múltiples**: probar builds de ARM en una máquina x86

```bash
# Compilar para QEMU x86
west build -b qemu_x86 samples/hello_world

# Ejecutar (automáticamente lanza QEMU)
west build -t run
```

### OpenOCD en el SDK

OpenOCD (Open On-Chip Debugger) es el puente entre GDB y el hardware de debugging (JTAG o SWD). Permite:

- Poner breakpoints en código running
- Leer/escribir registros de CPU
- Examinar memoria
- Step-through instrucciones
- Programar flash memory

```bash
# Debugging con OpenOCD + GDB
west build -b nrf52840dk_nrf52840 my_app
west debug
```

Internamente, `west debug` lanza OpenOCD en background, conecta GDB al target, y carga el symbol file del firmware.

---

## 5. API POSIX-like + Stack de Networking

### API POSIX en Zephyr

Zephyr implementa un **subconjunto de la API POSIX** para facilitar la portabilidad de aplicaciones existentes. Esto es particularmente valioso porque permite portar código escrito para Linux, FreeBSD, u otros sistemas POSIX con modificaciones mínimas.

#### Llamadas al sistema POSIX que Zephyr soporta

| Función | Descripción | Conexión §1.8 |
|---------|-------------|----------------|
| `open(path, flags, mode)` | Abre archivo o dispositivo | **Syscall** — transición usuario→kernel |
| `close(fd)` | Cierra descriptor | **Syscall** |
| `read(fd, buf, len)` | Lee datos | **Syscall** |
| `write(fd, buf, len)` | Escribe datos | **Syscall** |
| `socket(domain, type, protocol)` | Crea socket | **Syscall** |
| `bind(sockfd, addr, addrlen)` | Asocia socket a dirección | **Syscall** |
| `listen(sockfd, backlog)` | Marca socket como pasivo | **Syscall** |
| `accept(sockfd, addr, addrlen)` | Acepta conexión entrante | **Syscall** |
| `connect(sockfd, addr, addrlen)` | Conecta a peer | **Syscall** |
| `select(nfds, readfds, writefds, exceptfds, timeout)` | I/O multiplexing | **Syscall** |
| `poll(fds, nfds, timeout)` | Espera eventos en descriptores | **Syscall** |

#### §1.8 — La syscall como mecanismo de transición

Cuando una aplicación en Zephyr llama a `read(fd, buffer, len)`, ocurre lo siguiente:

1. **Espacio de usuario**: La aplicación ejecuta `read()` — una función de la biblioteca C de Zephyr (newlib o picolibc).
2. **Transición**: La biblioteca C ejecuta una instrucción de llamada al sistema. En arquitecturas x86, esto puede ser `int 0x80` (interrupción software) o `syscall` (instrucción más moderna). En ARM, es `svc 0` (Supervisor Call).
3. **Modo kernel**: El CPU pasa a modo privilegiado. El kernel de Zephyr recibe el número de syscall (en un registro, e.g., `EAX/R0`) y los argumentos (`EBX/ECX/EDX` o `R1/R2/R3`).
4. **Dispatch**: El kernel lookup la tabla de syscalls y ejecuta el handler correspondiente.
5. **Retorno**: El resultado vuelve a espacio de usuario y la aplicación continúa.

```
Aplicación (usuario)
    ↓  read(fd, buf, len)
Biblioteca C (newlib)
    ↓  syscall (int 0x80 / svc / syscall)
Kernel Zephyr
    ↓  handler_read(fd, buffer, len)
    ↓  accede al recurso (archivo, socket, device)
    ↓  copia datos a buffer del usuario
    ↑
    ↑
Kernel Zephyr (retorno)
    ↑
syscall return
    ↑
Biblioteca C
    ↑
Aplicación (continúa)
```

#### ¿Por qué "POSIX-like" y no POSIX completo?

Un RTOS para microcontroladores tiene constraints que Linux no tiene:

- **Memoria limitada**: No hay MMU (Memory Management Unit) para implementar memoria virtual. El concepto de "archivo en disco" no existe — los archivos suelen ser dispositivos de almacenamiento flash.
- **Sin procesos separados**: Zephyr típicamente corre una única imagen de firmware con múltiples threads. El modelo de procesos UNIX no aplica.
- **Overhead**: Implementar todas las syscalls POSIX tiene overhead de código y runtime. Zephyr prioriza las más usadas.
- **RTOS-specific features**: Muchas funcionalidades de Zephyr (como el scheduler cooperativo, real-time timers, o DeviceTree) no tienen equivalente POSIX.

### Stack de Networking

Zephyr incluye uno de los stacks de conectividad más completos de cualquier RTOS open source. No es un agregados de librerías; es un stack nativo integrado en el kernel.

#### Capas del stack

```
┌─────────────────────────────────────────────────────────┐
│                   Application Layer                      │
│         MQTT  │  CoAP  │  HTTP  │  WebSocket            │
├─────────────────────────────────────────────────────────┤
│                   Transport Layer                       │
│            TCP  │  UDP  │  TLS  │  DTLS                │
├─────────────────────────────────────────────────────────┤
│                    Network Layer                         │
│              IPv4  │  IPv6  │  6LoWPAN                 │
├─────────────────────────────────────────────────────────┤
│                 Connectivity Layer                       │
│  Ethernet │ Wi-Fi │ BLE │ Thread │ LoRa │ Cellular │ CAN│
├─────────────────────────────────────────────────────────┤
│                    PHY / Hardware                        │
└─────────────────────────────────────────────────────────┘
```

#### Tecnologías soportadas

**Bluetooth Low Energy (BLE)**
- Versiones 4.2, 5.0, 5.1, 5.2, 5.3
- Roles: Central, Peripheral, Observer, Broadcaster
- Protocols: GATT, GAP, ATT, L2CAP, SMP
-stack: Controller + Host (separados o combinados)

**Wi-Fi**
- Modes: Station (STA), Access Point (AP), Monitor
- Chips: ESP32 (Espressif), RTL8722 (Realtek)
- Stack TCP/IP: lwIP integrado

**Thread / 802.15.4**
- Basado en IEEE 802.15.4 + IPv6
- Thread stack (de Nest/Google) integrado
- 6LoWPAN para compresión de headers IPv6

**LoRa / LoRaWAN**
- PHY raw para LoRa
- Stack LoRaWAN completo para conexión a gateways

**Cellular (LTE-M, NB-IoT)**
- Modems: nRF9160, Sequans, u-blox
- Protocolos: MQTT, LWM2M, HTTPS

**Ethernet**
- 10/100/1000 Mbps
- TCP/IP stack lwIP
- DHCP, DNS, mDNS

**CAN Bus**
- CAN 2.0 y CAN-FD
- Interface estilo SocketCAN

#### ¿Por qué integrado y no externo?

En un RTOS de producción, tener el stack de red integrado ofrece ventajas sobre agregar una librería externa:

1. **Single image**: Todo el firmware es un único binary; no hay que integrar libs externas.
2. **Configuración unificada**: KConfig habilita/deshabilita features de red; no hay que linkear libs opcionales.
3. **Memoria compartida**: El allocator del kernel y el stack de red comparten el heap; no hay fragmentation.
4. **Consistencia de API**: Las mismas APIs POSIX (`socket()`, `bind()`, `connect()`) operan sobre cualquier tecnología de conectividad.

---

## 6. Documentación y Comunidad

### docs.zephyrproject.org

Zephyr maintains una de las documentaciones más completas entre RTOS open source. La documentación está versionada (latest + versiones anteriores) y categorizada:

| Sección | Contenido |
|---------|-----------|
| **Getting Started Guide** | Instalación, primer proyecto, conceptos básicos |
| **Build System** | CMake, Kconfig, West, Devicetree en profundidad |
| **API Reference** | Doxygen-generated docs para todas las APIs |
| **Hardware Support** | Boards, SoCs, drivers |
| **Samples and Demos** | Ejemplos funcionales para cada subsystem |
| **Contributing** | Como enviar patches, código de conducta, governance |

### Recursos comunitarios

| Recurso | Descripción |
|---------|-------------|
| **GitHub Discussions** | Foro oficial para preguntas técnicas |
| **Discord** | Canal en tiempo real para la comunidad |
| **Mailing Lists** | zephyr-users (para usuarios), zephyr-devel (para desarrollo) |
| **Stack Overflow** | Tag `zephyr-rtos` con miles de preguntas |
| **Zephyr Project Wiki** | Artículos contribuidos por usuarios |

### Comunidad y Governance

Zephyr es un proyecto de la Linux Foundation. Esto significa:

- **A governance formal**: Board de proyectos, technical steering committee
- **Process abiertos**: TODOs, PRs, issues visibles públicamente
- **Release regulares**: Versiones cada 2-3 meses con soporte de LTS para variantes chosen

---

## 7. Nota Académica §1.8 — API POSIX como Interfaz Stable

La nota al pie de la slide conecta este contenido con el temario de FSO. Aquí se profundiza:

### §1.8 — Llamadas al Sistema en Zephyr

La sección §1.8 del temario define las syscalls como "la interfaz entre programas de usuario y servicios del kernel". En Zephyr, esta definición se aplica con matices:

1. **Zephyr no es UNIX**: No hay MMU, no hay procesos separados (en el sentido tradicional), no hay archivos en un filesystem de disco.

2. **La API POSIX es una abstracción**: Cuando una aplicación llama a `open("/dev/tty0", O_RDWR)`, Zephyr internamente traduce esto a una llamada al driver del UART correspondiente, usando el subsistema de devices.

3. **syscall ≠ llamada al sistema hardware**: En CPUs sin MMU (como ARM Cortex-M), la "transición a modo kernel" no implica cambio de página de memoria ni cambio de contexto de proceso. Zephyr usa CPU modes (Thumb/Privileged) para separar código kernel de aplicación.

4. **Modelo de RTOS vs. GPOS**: En un General Purpose OS (Linux, Windows), cada syscall implica overhead de validación (permisos, ownership, límites). En un RTOS como Zephyr, las syscalls son más directas porque el contexto de seguridad es más simple (single application, trusted firmware).

### Transición Usuario→Kernel en Zephyr (arquitectura ARM Cortex-M como ejemplo)

```
// En espacio de usuario (aplicación)
int fd = open("/dev/uart0", O_RDWR);

// La biblioteca C (newlib) compila esto a:
svc 0x01  // Supervisor Call — genera excepción

// El vector de excepción en el kernel de Zephyr redirected a:
// arch/arm/core/syscalls.c
_syscall_error_t z_vsyscall_open(const char *path, int flags, int mode)
{
    // Validación minima, luego llama al subsystem
    return do_sys_open(path, flags, mode);
}
```

---

## 8. Glosario de Términos

### West
Meta-herramienta de Python que gestina repositorios, build, flash, debug y console. Es el entry point para toda interacción con Zephyr. [Documentación oficial](https://docs.zephyrproject.org/latest/develop/west/index.html)

### CMake
Sistema de build declarative que genera archivos de build nativos (Ninja, Make). Zephyr lo usa para coordinar compilacion de kernel, drivers, y aplicaciones. [cmake.org](https://cmake.org/)

### KConfig
Sistema de configuración basado en texto heredado del kernel de Linux. Define opciones `CONFIG_X` que se generan como macros `#define` en tiempo de compilación. [Documentación Zephyr](https://docs.zephyrproject.org/latest/build/kconfig/index.html)

### Devicetree
Lenguaje de descripción de hardware en forma de árbol. Archivos `.dts` describen CPUs, memorias, periféricos, y sus direcciones e interrupciones. Se compilan a un header C (`devicetree.h`) que drivers y aplicaciones consultan. [Documentación Zephyr](https://docs.zephyrproject.org/latest/build/dts/index.html)

### Zephyr SDK
Bundle de toolchains mantenido por el proyecto Zephyr. Incluye compiladores GCC y Clang para todas las arquitecturas soportadas, QEMU para emulación, y OpenOCD para debugging en hardware. [Documentación Zephyr](https://docs.zephyrproject.org/latest/develop/toolchains/zephyr_sdk.html)

### POSIX-like API
Subconjunto de la interfaz POSIX estándar (open, close, read, write, socket, etc.) que Zephyr implementa. Permite portabilidad de aplicaciones existentes. "Like" porque no es 100% POSIX-compliant — es un subconjunto optimizado para embedded. [API Status](https://docs.zephyrproject.org/latest/develop/api/index.html)

### QEMU
Emulador de sistemas que Zephyr SDK incluye. Permite ejecutar aplicaciones Zephyr sin hardware físico. Ideal para testing y CI/CD. [qemu.org](https://www.qemu.org/)

### OpenOCD
On-Chip Debugger open source. Permite debugging de hardware real via interfaces JTAG o SWD. Conecta GDB con el target físico. [openocd.org](http://openocd.org/)

### Networking Stack
Stack de conectividad integrado en Zephyr. Soporta Ethernet, Wi-Fi, BLE, Thread, LoRa, Cellular, y CAN. Implementa capas de transporte (TCP/UDP), red (IP), y aplicación (MQTT, CoAP). [Documentación](https://docs.zephyrproject.org/latest/services/networking/overview.html)

---

## 9. Relación entre Herramientas — Flujo Completo de Desarrollo

Para entender cómo todas estas herramientas se combinan en la práctica:

```
1. west init -l myapp
   └── Crea workspace, descarga west.yml
   └── Inicializa Python virtual environment con west

2. west update
   └── Descarga repos del manifiesto (zephyr core + HALs)

3. west build -b <board> my_app
   ├── CMakeListsRunner detecta app
   ├── CMake ejecuta boilerplate.cmake
   │   ├── Incluye Zephyr KConfig system
   │   ├── Procesa prj.conf (CONFIG_*)
   │   ├── Compila Devicetree (.dts → devicetree.h)
   │   └── Invoca toolchain del Zephyr SDK
   │       ├── gcc/arm-none-eabi-gcc (o clang)
   │       ├── Linker combina kernel + app
   │       └── Genera binary .elf y .bin/.hex
   └── Ninja (o Make) orchestra paralelismo

4. west flash
   └── OpenOCD conecta a hardware
   └── Programa flash via JTAG/SWD

5. west debug
   └── OpenOCD lanza GDB server
   └── GDB conecta, carga symbols
   └── Developer puede breakpoint, step, inspect memory
```

---

## 10. Fuentes y Referencias

- [Zephyr SDK Documentation](https://docs.zephyrproject.org/latest/develop/toolchains/zephyr_sdk.html)
- [West Documentation](https://docs.zephyrproject.org/latest/develop/west/index.html)
- [CMake Build System](https://docs.zephyrproject.org/latest/build/index.html)
- [Kconfig in Zephyr](https://docs.zephyrproject.org/latest/build/kconfig/index.html)
- [Devicetree Documentation](https://docs.zephyrproject.org/latest/build/dts/index.html)
- [Zephyr API Status](https://docs.zephyrproject.org/latest/develop/api/index.html)
- [Networking Overview](https://docs.zephyrproject.org/latest/services/networking/overview.html)
- [Connectivity Services](https://docs.zephyrproject.org/latest/services/connectivity/index.html)
- [Getting Started Guide](https://docs.zephyrproject.org/latest/develop/getting_started/index.html)

---

*Explicación preparada para el Trabajo Práctico Especial de Fundamentos de Sistemas Operativos, UNMDP. Última actualización: mayo 2026.*