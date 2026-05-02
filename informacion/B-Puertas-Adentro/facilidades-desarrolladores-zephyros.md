# Facilidades para Desarrolladores — Zephyr OS

> **Nota sobre fuentes:** Toda la información de este documento fue recopilada de fuentes públicas verificadas de la documentación oficial de Zephyr Project y artículos técnicos reconocidos. Para el Trabajo Práctico Especial de Fundamentos de Sistemas Operativos.

---

## 1. Lenguajes de Programación

Zephyr OS está diseñado primordialmente para sistemas embebidos con recursos restringidos, lo cual determina las choices de lenguajes:

| Lenguaje | Uso | Detalles |
|----------|-----|----------|
| **C** | Kernel y aplicaciones | El lenguaje principal del proyecto. Todo el kernel y la mayoria de las APIs de sistema estan escritas en C. Permite acceso de bajo nivel al hardware manteniendo portabilidad. |
| **Python** | Scripts de build y herramientas | Usado extensivamente en el sistema de build (CMake wrappers), en la herramienta **West**, y en scripts de configuracion. No se usa para aplicaciones finales en el dispositivo. |

> *Fuente: [Zephyr Documentation — Language Support](https://docs.zephyrproject.org/latest/develop/languages/index.html)*

---

## 2. APIs Disponibles

Zephyr provee múltiples niveles de APIs para distintos casos de uso:

### 2.1 API POSIX-like

Zephyr implementa un subconjunto de la API POSIX estándar, lo que facilita la portabilidad de aplicaciones existentes de otros sistemas operativos:

- `open()`, `close()`, `read()`, `write()` para archivos
- `socket()` para networking
- `pthread_*` para threading (parcial)
- `select()`, `poll()` para I/O multiplexing

### 2.2 API Nativa de Zephyr

Para funcionalidades específicas del OS que no tienen equivalente POSIX:

- **Kernel API**: Para creación de threads, synchronization, timers
- **Device Driver API**: Para interactuar con hardware via device tree
- **Driver APIs específicas**: I2C, SPI, GPIO, PWM, ADC, etc.

### 2.3 APIs de Alto Nivel

Abstracciones que simplifican el desarrollo:

- **Sensor API**: Para interfacing con sensores de manera uniforme
- **Shell API**: Para crear interfaces de línea de comandos
- **Logging API**: Sistema de logging estructurado
- **Storage API**: Para flash/filesystems (LittleFS, FAT FS, NVS)

### 2.4 PSA Crypto API

Para cryptographic operations, Zephyr implementa la **Platform Security Architecture (PSA) Crypto API**, que provee una interfaz unificada para:

- Cifrado simétrico y asimétrico
- Hashing (SHA-256, etc.)
- Firmas digitales
- Secure storage

> *Fuente: [Zephyr Documentation — API Status](https://docs.zephyrproject.org/latest/develop/api/index.html)*

---

## 3. Zephyr SDK — Kit de Desarrollo

El **Zephyr SDK** es el kit de desarrollo oficial del proyecto y es altamente recomendado (甚至 requerido en algunos casos).

### 3.1 Componentes del SDK

| Componente | Descripción |
|------------|-------------|
| **Toolchains** | Compiladores y herramientas para todas las arquitecturas soportadas (GNU y LLVM/Clang) |
| **QEMU** | Emulador que permite ejecutar y probar aplicaciones Zephyr sin hardware físico |
| **OpenOCD** | On-Chip Debugger para debugging de hardware real via JTAG/SWD |
| **Extensiones de debug** | Soporte para GDB y otros debuggers |

### 3.2 Arquitecturas Soportadas por el SDK

El Zephyr SDK incluye toolchains para todas las arquitecturas que Zephyr soporta:

- **ARC** (32-bit y 64-bit; ARCv1, ARCv2, ARCv3)
- **ARM** (32-bit y 64-bit; ARMv6, ARMv7, ARMv8; A/R/M Profiles)
- **Microblaze** (32-bit)
- **MIPS** (32-bit y 64-bit)
- **RISC-V** (32-bit y 64-bit; RV32I, RV32E, RV64I)
- **RX** (Renesas)
- **SPARC** (32-bit y 64-bit)
- **x86** (32-bit y 64-bit)
- **Xtensa** (Tensilica)

### 3.3 Variantes del SDK Bundle

El SDK se distribuye en tres variantes:

| Variante | Host Tools | Toolchains |
|----------|-----------|------------|
| `gnu` | Sí | GNU (Binutils, GCC, GDB) para todas las arquitecturas |
| `llvm` | Sí | LLVM/Clang |
| `minimal` | Sí | Ninguno (solo host tools) |

### 3.4 Instalación y Uso

El SDK funciona en Linux, macOS y Windows. Se instala extrayendo el bundle y ejecutando el script de setup:

```bash
# Ejemplo en Linux
wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v1.0.1/zephyr-sdk-1.0.1_linux-x86_64_gnu.tar.xz
tar xvf zephyr-sdk-1.0.1_linux-x86_64_gnu.tar.xz
cd zephyr-sdk-1.0.1 && ./setup.sh
```

El SDK se puede instalar en múltiples ubicaciones y el sistema de build automáticamente detecta la instalación.

> *Fuente: [Zephyr SDK Documentation](https://docs.zephyrproject.org/latest/develop/toolchains/zephyr_sdk.html)*

---

## 4. CMake Build System

Zephyr utiliza **CMake** como sistema de build, lo que provee portabilidad entre sistemas operativos.

### 4.1 Características Principales

| Feature | Descripción |
|---------|-------------|
| **Multi-plataforma** | Funciona en Linux, macOS y Windows |
| **Out-of-tree builds** | Soporta builds separados del código fuente |
| **Incremental builds** | Solo recompila lo necesario |
| **Cross-compilation** | Soporte nativo para cross-compiling |
| **Integración con IDEs** | Genera archivos para CLion, VSCode, etc. |

### 4.2 Estructura del Build

```
myapp/
├── CMakeLists.txt          # Configuración principal
├── prj.conf                # KConfig — configuración de features
├── boards/                 # Definiciones de board (opcional)
├── src/                    # Código fuente
└── build/                  # Directorio de build (fuera del tree)
```

### 4.3 Flujo de Build Típico

```bash
west build -b <board> <app>
# Ejemplo:
west build -b nrf52840dk_nrf52840 my_app
```

> *Fuente: [Zephyr Documentation — Build System](https://docs.zephyrproject.org/latest/build/index.html)*

---

## 5. Kconfig + Devicetree — Sistema de Configuración

Zephyr utiliza dos sistemas complementarios para configurar el sistema de forma granular:

### 5.1 KConfig

Sistema de configuración basado en texto que permite:

- **Habilitar/deshabilitar features** del kernel y subsistemas
- **Configurar parámetros** (tamaños de buffers, timeouts, etc.)
- **Dependencias automáticas** entre opciones
- **Validación** de configuraciones inválidas

Ejemplo de `prj.conf`:
```
CONFIG_GPIO=y
CONFIG_UART_INTERRUPT_DRIVEN=y
CONFIG_LOG_DEFAULT_LEVEL=4
```

### 5.2 Devicetree

Sistema de descripción de hardware basado en árboles (sintaxis similar a Device Tree de Linux):

- **Describe el hardware** real: CPUs, memorias, periféricos, interrupts
- **Separación hardware/software**: El mismo código puede correr en boards diferentes
- **Overlays**: Permite modificar la configuración para casos específicos

Ejemplo simplificado:
```dts
&uart0 {
    status = "okay";
    current-speed = <115200>;
};
```

### 5.3 Relación KConfig — Devicetree

| Aspecto | KConfig | Devicetree |
|---------|---------|------------|
| **Qué configura** | Features del software | Hardware del sistema |
| **Cuándo se procesa** | Compilación | Compilación + generación de headers |
| **Sintaxis** | `CONFIG_X=y` | Estructura de árbol `.dts` |
| **Ejemplo** | Habilitar driver I2C | Describir qué芯片 I2C hay en el board |

> *Fuente: [Zephyr Documentation — Kconfig](https://docs.zephyrproject.org/latest/build/kconfig/index.html), [Devicetree](https://docs.zephyrproject.org/latest/build/dts/index.html)*

---

## 6. West — Meta-herramienta de Gestión

**West** es la navaja suiza del ecosistema Zephyr. Es una herramienta multi-propósito escrita en Python.

### 6.1 Funcionalidades Principales

| Comando | Función |
|---------|---------|
| `west init` | Inicializa un workspace de Zephyr |
| `west update` | Descarga/actualiza repositorios del proyecto |
| `west build` | Compila aplicaciones Zephyr |
| `west flash` | Flashea el firmware en el dispositivo |
| `west debug` | Inicia debugging con GDB/OpenOCD |
| `west manifest` | Gestiona archivos de manifiesto (repos) |
| `west list` | Lista todos los proyectos en el workspace |

### 6.2 Sistema de Workspaces

Un "workspace" de West es un directorio que contiene:

- El manifest (archivo YAML que define todos los repos)
- Los repositorios descargados (projects)
- Configuración global (`west.yml`)

### 6.3 Extensibilidad

West es extensible: se pueden escribir **extension commands** en Python para agregar funcionalidad custom.

> *Fuente: [West Documentation](https://docs.zephyrproject.org/latest/develop/west/index.html)*

---

## 7. Documentación

Zephyr cuenta con una de las documentaciones más completas entre los RTOS open source:

### 7.1 Documentación Oficial

| Recurso | URL | Descripción |
|---------|-----|-------------|
| **docs.zephyrproject.org** | [https://docs.zephyrproject.org/latest/](https://docs.zephyrproject.org/latest/) | Portal principal de documentación |
| **API Documentation** | [https://docs.zephyrproject.org/latest/doxygen/html/index.html](https://docs.zephyrproject.org/latest/doxygen/html/index.html) | Doxygen API reference completa |
| **Samples and Demos** | [https://docs.zephyrproject.org/latest/samples/index.html](https://docs.zephyrproject.org/latest/samples/index.html) | Ejemplos de código para cada subsystem |
| **Kconfig Options** | [https://docs.zephyrproject.org/latest/kconfig.html](https://docs.zephyrproject.org/latest/kconfig.html) | Referencia de todas las opciones CONFIG_ |

### 7.2 Recursos Comunitarios

| Recurso | Descripción |
|---------|-------------|
| **Zephyr Project Wiki** | Artículos contribuidos por la comunidad |
| **GitHub Discussions** | Foro activo para preguntas |
| **Discord Server** | Canal de chat en tiempo real |
| **Mailing Lists** | Zephyr-users y Zephyr-devel |
| **Stack Overflow** | Tag `zephyr` para preguntas técnicas |

### 7.3 Getting Started

El flujo típico para nuevos desarrolladores es:

1. Instalar dependencias (`sudo apt install device-tree-compiler`)
2. Instalar West (`pip3 install west`)
3. Inicializar workspace (`west init -l .`)
4. Descargar repos (`west update`)
5. Compilar ejemplo (`west build -b <board> samples/hello_world`)
6. Flash y probar

> *Fuente: [Zephyr Getting Started Guide](https://docs.zephyrproject.org/latest/develop/getting_started/index.html)*

---

## 8. Más de 1000 Boards Soportadas

Zephyr soporta una de las más amplias variedades de hardware entre los RTOS, con más de 1000 boards oficialmente soportadas.

### 8.1 Arquitecturas y Familias Principales

| Arquitectura | vendors / Families | Ejemplos de Boards |
|--------------|-------------------|-------------------|
| **ARM Cortex-M** | Nordic, STM32, NXP, TI, Infineon, Renesas, etc. | nRF52840 DK, STM32L475 Disco, FRDM-K64F |
| **ARM Cortex-R** | Texas Instruments, Renesas | TMS570LC4355 Hercules, RZ/N1 |
| **ARM Cortex-A** | NXP, TI, Broadcom, STMicro | i.MX6ULL, BeagleBone AI-64 |
| **RISC-V** | Espressif, SiFive, Renesas, Antmicro | ESP32-C6, SiFive HiFive1, RISC-V Virt |
| **x86** | Intel, PC Engines, QEMU | Apollo Lake, x86 QEMU |
| **Xtensa** | Espressif (ESP32 family) | ESP32, ESP32-S2, ESP32-S3 |
| **ARC** | Synopsys | ARC EM Starter Kit, IoT DK |
| **MIPS** | various | Generic MIPS boards |
| **SPARC** | Gaisler | GR716 |
| **RX** | Renesas | Renesas RX65N |

### 8.2 Vendors con Mayor Soporte

```
Nordic Semiconductor    →  ~50+ boards (nRF52, nRF53, nRF91 series)
STMicroelectronics      →  ~100+ boards (STM32 family completo)
NXP Semiconductors      →  ~80+ boards (Kinetis, LPC, i.MX)
Espressif              →  ~30+ boards (ESP32 family)
Texas Instruments      →  ~40+ boards (CC13xx, CC26xx, Tiva)
Raspberry Pi Foundation →  ~10+ boards (RP2040, RP2350)
```

### 8.3 Boards Populares para Desarrollo

| Board | Microcontroller | Arquitectura | Uso Típico |
|-------|-----------------|--------------|------------|
| **nRF52840 DK** | nRF52840 (ARM Cortex-M4) | ARM | BLE IoT, desarrollo general |
| **STM32L475 Disco** | STM32L475VG (ARM Cortex-M4) | ARM | Prototyping, sensores |
| **ESP32 DevKitC** | ESP32 (Xtensa) | Xtensa | Wi-Fi, BLE, IoT |
| **FRDM-K64F** | MK64F (ARM Cortex-M4) | ARM | Industrial, Ethernet |
| **nRF9160 DK** | nRF9160 (ARM Cortex-M33) | ARM | LTE-M, NB-IoT, cellular |
| **BeagleV-Fire** | JH7100 (RISC-V) | RISC-V | AI edge, Linux-capable |

### 8.4 Agregar Nueva Board

Si el hardware no está soportado, Zephyr provee guías para portar el sistema a nuevas boards. El proceso involve:

1. Crear directorio en `boards/`
2. Definir archivos de board (`.defconfig`, `.dts`)
3. Documentar en el archivo `index.rst`

> *Fuente: [Zephyr Supported Boards](https://docs.zephyrproject.org/latest/boards/index.html)*

---

## 9. Stack de Conectividad

Zephyr incluye uno de los stacks de conectividad más completos de cualquier RTOS, integrado nativamente en el sistema.

### 9.1 Bluetooth Low Energy (BLE)

| Aspecto | Detalle |
|---------|---------|
| **Versiones** | BLE 4.2, 5.0, 5.1, 5.2, 5.3 |
| **Roles** | Central, Peripheral, Observer, Broadcaster |
| **Features** | GATT, GAP, Security Manager, L2CAP, ATT |
| **Profiles** | HIDS, HOG, Heart Rate, Battery Service, etc. |
| **Stack** | Controller + Host (HCI) |

### 9.2 Wi-Fi

- **Modes**: Station (STA), Access Point (AP), Monitor
- **Stacks**: Native Zephyr Wi-Fi stack + lwIP para TCP/IP
- **Drivers**: Soporte para chips ESP32, Realtek RTL8722, etc.

### 9.3 Thread (IEEE 802.15.4 + IPv6)

- Protocolo de mesh de bajo consumo
- Soporte completo de Thread stack
- Integración con OpenThread
- Ideal para home automation

### 9.4 802.15.4 (Raw)

- MAC/PHY para redes de bajo rate
- Base para Thread, Zigbee, etc.
- 6LoWPAN para compression de IPv6 sobre 802.15.4

### 9.5 LoRa y LoRaWAN

- **LoRa**: API para enviar packets raw directamente
- **LoRaWAN**: Stack completo para conexión a redes LoRaWAN
- Chips soportados: Semtech SX1276, etc.

### 9.6 Cellular (LTE-M, NB-IoT, 2G/3G)

- **Modem support**: nRF9160, Sequans, u-blox
- **Protocolos**: MQTT, LWM2M, HTTPS
- **AT commands**: Interface para modems

### 9.7 CAN Bus

- **Protocolo**: CAN 2.0 (Classic) y CAN-FD
- **Drivers**: MCP2515 (external), FDCAN (integrated)
- **APIs**: SocketCAN-style interface

### 9.8 Ethernet

- **100/1000 Mbps** Ethernet PHY support
- **TCP/IP stack**: lwIP integrado
- **Protocolos**: DHCP, DNS, mDNS, LLMNR
- **Applications**: HTTP Server, MQTT client, etc.

### 9.9 Resumen Visual del Stack

```
┌─────────────────────────────────────────────┐
│           Application Layer                  │
│   (MQTT, CoAP, HTTP, WebSocket, etc.)        │
├─────────────────────────────────────────────┤
│           Transport Layer                    │
│         (TCP, UDP, TLS/DTLS)                │
├─────────────────────────────────────────────┤
│           Network Layer                      │
│        (IPv4, IPv6, 6LoWPAN)                 │
├─────────────────────────────────────────────┤
│         Connectivity Layer                   │
│  Ethernet │ Wi-Fi │ BLE │ Thread │ LoRa │  │
│     CAN    │  Cellular   │ 802.15.4         │
├─────────────────────────────────────────────┤
│         Hardware / PHY Layer                 │
│    (Ethernet PHY, RF transceivers, etc.)    │
└─────────────────────────────────────────────┘
```

### 9.10 Múltiples Interfaces Simultáneas

Zephyr puede configurarse para soportar **múltiples tecnologías de conectividad simultáneamente**:

```bash
# Ejemplo en KConfig
CONFIG_NETWORKING=y
CONFIG_ETH_ZEPHYR=y          # Ethernet
CONFIG_WIFI=y                # Wi-Fi
CONFIG_BT=y                  # Bluetooth
CONFIG_LORA=y                # LoRa
```

> *Fuente: [Zephyr Connectivity Documentation](https://docs.zephyrproject.org/latest/services/connectivity/index.html), [Networking Overview](https://docs.zephyrproject.org/latest/services/networking/overview.html), [LoRa/LoRaWAN](https://docs.zephyrproject.org/latest/connectivity/lora_lorawan/index.html)*

---

## 10. Licencia Apache 2.0

Zephyr utiliza la **Apache License 2.0** para todo su código, lo que lo hace extremamente accesible para uso comercial.

### 10.1 Características de Apache 2.0

| Aspecto | Detalle |
|---------|---------|
| **Permisividad** | Permite uso comercial, modificación, distribución |
| **Sin copyleft** | No requiere que el código derivado sea open source |
| **Patent grant** | Otorga licencia de patentes a contribuidores |
| ** trademark** | Nombres del proyecto no pueden usarse sin permiso |
| **Compatible** | Compatible con GPL v2 y v3 |

### 10.2 Implicaciones para Desarrolladores

```
✅ Puedes usar Zephyr en productos comerciales sin pagar regalías
✅ Puedes modificar el código y no publicar los cambios
✅ Puedes distribuir Zephyr con productos propietarios
✅ No hay "viral" efecto — tu código no se convierte en open source
✅ Requiere reconocimiento de版权 y disclaimer
⚠️ Si patentes código,别人puede usar tu implementación bajo la licencia
```

### 10.3 Comparación con Otras Licencias RTOS

| Licencia | Copyleft? | Uso Comercial? | Regalías? |
|----------|-----------|-----------------|-----------|
| **Apache 2.0** (Zephyr) | No | Sí | No |
| **MIT** (FreeRTOS) | No | Sí | No |
| **LGPL 2.1** (RIOT OS) | Débil (solo para linking) | Sí | No |
| **GPL v2** (Linux) | Sí fuerte | restricted | No |
| **Proprietaria** (VxWorks) | N/A | Sí (caro) | Sí |

### 10.4 Componentes con Licencias Diferentes

Algunos componentes third-party dentro de Zephyr pueden tener licencias diferentes:

- **mbedTLS**: Apache 2.0
- **LittleFS**: BSD 2-clause
- **FatFS**: FatFS license (libre)
- **lwIP**: BSD (modificado)

> *Fuente: [Zephyr Licensing](https://docs.zephyrproject.org/latest/LICENSING.html)*

---

## 11. Herramientas Adicionales de Desarrollo

### 11.1 QEMU — Emulación

QEMU viene incluido en el Zephyr SDK y permite:

- Ejecutar aplicaciones Zephyr sin hardware real
- Testing en arquitecturas diferentes a la development machine
- Debugging con GDB conectado a QEMU
- CI/CD pipelines para tests automatizados

```bash
# Ejemplo: correr hello_world en QEMU x86
west build -b qemu_x86 samples/hello_world
west build -t run
```

### 11.2 OpenOCD — Debugging Real

Para debugging en hardware real:

- Soporte JTAG y SWD
- Compatible con J-Link, ST-Link, CMSIS-DAP, etc.
- Integration con GDB para debugging symbol-by-symbol

### 11.3 Testing Framework

Zephyr incluye un framework de testing completo:

- **Twister**: Test runner principal
- ** pytest-based**: Para tests de integración
- **Google Test (gtest)**: Para tests unitarios en C

```bash
# Ejecutar todos los tests para una board
west twister -b <board>
```

---

## 12. Resumen — Herramientas del Desarrollador Zephyr

```
┌─────────────────────────────────────────────────────────┐
│                  DEVELOPER TOOLCHAIN                    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────┐   ┌─────────────┐   ┌─────────────┐  │
│  │   Zephyr    │   │    CMake    │   │    West     │  │
│  │    SDK      │   │   Build     │   │  Meta-tool  │  │
│  │ (Toolchains │   │  System     │   │ (Repos,     │  │
│  │  QEMU, OCD) │   │             │   │  Flash, DB) │  │
│  └─────────────┘   └─────────────┘   └─────────────┘  │
│                                                         │
│  ┌─────────────────────────────────────────────────┐    │
│  │              Kconfig + Devicetree              │    │
│  │         (Configuración granular)               │    │
│  └─────────────────────────────────────────────────┘    │
│                                                         │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐       │
│  │    APIs    │  │   Docs     │  │   +1000    │       │
│  │ POSIX/Nat. │  │  official  │  │   Boards   │       │
│  │  High-lvl  │  │   site     │  │  support   │       │
│  └────────────┘  └────────────┘  └────────────┘       │
│                                                         │
│  ┌──────────────────────────────────────────────┐     │
│  │   Connectivity Stack: BLE, Wi-Fi, Thread,     │     │
│  │   LoRa, Cellular, CAN, Ethernet               │     │
│  └──────────────────────────────────────────────┘     │
│                                                         │
│  ┌──────────────────────────────────────────────┐     │
│  │   License: Apache 2.0 (no royalties)         │     │
│  └──────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────┘
```

---

## Fuentes

1. **Zephyr SDK Documentation**
   [docs.zephyrproject.org/latest/develop/toolchains/zephyr_sdk.html](https://docs.zephyrproject.org/latest/develop/toolchains/zephyr_sdk.html)

2. **West Documentation**
   [docs.zephyrproject.org/latest/develop/west/index.html](https://docs.zephyrproject.org/latest/develop/west/index.html)

3. **Supported Boards and Shields**
   [docs.zephyrproject.org/latest/boards/index.html](https://docs.zephyrproject.org/latest/boards/index.html)

4. **Connectivity Services**
   [docs.zephyrproject.org/latest/services/connectivity/index.html](https://docs.zephyrproject.org/latest/services/connectivity/index.html)

5. **Networking Overview**
   [docs.zephyrproject.org/latest/services/networking/overview.html](https://docs.zephyrproject.org/latest/services/networking/overview.html)

6. **LoRa and LoRaWAN**
   [docs.zephyrproject.org/latest/connectivity/lora_lorawan/index.html](https://docs.zephyrproject.org/latest/connectivity/lora_lorawan/index.html)

7. **Zephyr Licensing**
   [docs.zephyrproject.org/latest/LICENSING.html](https://docs.zephyrproject.org/latest/LICENSING.html)

8. **Language Support**
   [docs.zephyrproject.org/latest/develop/languages/index.html](https://docs.zephyrproject.org/latest/develop/languages/index.html)

9. **Build System**
   [docs.zephyrproject.org/latest/build/index.html](https://docs.zephyrproject.org/latest/build/index.html)

10. **API Status and Guidelines**
    [docs.zephyrproject.org/latest/develop/api/index.html](https://docs.zephyrproject.org/latest/develop/api/index.html)

---

*Documento preparado para el Trabajo Práctico Especial de Fundamentos de Sistemas Operativos. Última actualización: mayo 2026.*

---
## Nota Académica — Fundamentos de SO
**Conceptos de la materia relacionados:**

- **§1.8 — Llamadas al sistema (syscalls)**: Zephyr implementa un subconjunto de la API POSIX estándar (`open()`, `close()`, `read()`, `write()`, `socket()`) que expone a las aplicaciones. Estas funciones son el mecanismo clásico de interfaz entre programas de usuario y servicios del kernel — la aplicación hace una llamada al sistema, el kernel ejecuta el servicio y devuelve el resultado.

- **§1.8 — Interfaz POSIX como puerta al kernel**: La capa POSIX de Zephyr actúa como intermediario: cuando una aplicación llama a `read(fd, buffer, len)`, el kernel verifica el fd, accede al recurso correspondiente (archivo, socket, device), y retorna los datos. Sin esta capa, cada aplicación debería invocar syscalls directamente.

- **§1.7 — Transición usuario→kernel vía syscalls**: Detrás de cada función POSIX en Zephyr hay una transición via software interrupt (en arquitecturas x86: `int 0x80` o `syscall`). El registro `EAX` indica el número de syscall; `EBX`, `ECX`, `EDX` contienen los argumentos. En Zephyr, esto se abstrae para mantener portabilidad.

- **API nativa Zephyr vs. syscalls**: Las APIs nativas del kernel (`k_thread_create()`, `k_mutex_init()`) no son POSIX ni usan syscalls tradicionales — son funciones compiladas directamente en la imagen del sistema. Esto es común en RTOS embebidos donde el modelo de syscalls UNIX no es apropiado por overhead.