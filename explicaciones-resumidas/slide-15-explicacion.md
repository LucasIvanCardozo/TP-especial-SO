# Slide 15 — Resumen: Facilidades para Desarrolladores Zephyr

## Overview

Zephyr ofrece un ecosistema completo de herramientas para desarrollo embedded: **West** (meta-build tool), **CMake + KConfig** (sistema de build y configuración), **DeviceTree** (descripción de hardware), **Zephyr SDK** (toolchains), y una **API POSIX-like** con stack de networking integrado.

---

## 1. West — Meta-herramienta de build

**¿Qué es?** Herramienta central en Python que unifica gestión de repositorios, build, flash y debug en un solo comando.

**Problema que resuelve:** Zephyr son múltiples repositorios Git (kernel + libs). Sin West, cada uno debía gestionarse manualmente.

**Comandos principales:**
```bash
west init -l myapp      # Inicializar workspace
west update             # Descargar repos del manifiesto
west build -b <board>   # Compilar para board específica
west flash              # Grabar firmware al dispositivo
west debug              # Debug con GDB + OpenOCD
```

El archivo `west.yml` define qué repositorios conforman el workspace.

---

## 2. CMake + KConfig

### CMake
Sistema de build estándar de la industria (usado por LLVM, KDE, etc.). Genera archivos nativos del SO host (Ninja, Make).

| Aspecto | make simple | CMake |
|---------|-------------|-------|
| Cross-compilation | Manual | Soporte nativo |
| Multi-plataforma | Solo Unix | Linux, macOS, Win |
| IDE integration | Ninguna | CLion, VSCode |
| Paralelismo | manual | Ninja por defecto |

### KConfig
Sistema de configuración heredado del kernel de Linux. Genera macros `#define CONFIG_X` usadas en compilación condicional.

**Ejemplo `prj.conf`:**
```
CONFIG_BT=y
CONFIG_LOG=y
CONFIG_LOG_DEFAULT_LEVEL=4
CONFIG_MAIN_STACK_SIZE=2048
```

**Propósito:** En >1000 boards y múltiples arquitecturas (ARM, RISC-V, x86), KConfig permite habilitar features sin overhead runtime si no se usan. Valida dependencias automáticamente.

---

## 3. DeviceTree

**¿Qué es?** Formato de descripción de hardware en forma de árbol. Archivos `.dts` describen periféricos, direcciones de memoria, pines e IRQs.

**Problema que resuelve:** El mismo driver debe funcionar en Nordic nRF52840, STM32, ESP32 — cada uno con registros y direcciones distintas. DeviceTree abstrae el hardware.

**Sintaxis ejemplo:**
```dts
&uart0 {
    status = "okay";
    current-speed = <115200>;
    tx-pin = <6>;
    rx-pin = <8>;
};
```

**Flujo:**
1. Seleccionar `.dts` para la board (ya existe para las 1000+ boards soportadas)
2. CMake invoca `dtc` (DeviceTree Compiler)
3. Se genera `devicetree.h` con macros `DT_NODELABEL()`, `DT_PROP()`
4. El driver usa estas macros para interactuar con el hardware

**Componentes:** `.dts` (base), `.dtsi` (includes), `.overlay` (modificaciones), `.dtso` (shields reutilizables).

---

## 4. Zephyr SDK

**¿Qué es?** Bundle con todas las toolchains para compilar Zephyr en cualquier arquitectura.

| Componente | Uso |
|------------|-----|
| GCC/Binutils/GDB | Compilación default para la mayoría |
| LLVM/Clang | Alternativa a GCC |
| QEMU | Emulación para testing sin hardware |
| OpenOCD | Debugging en hardware real via JTAG/SWD |
| Ninja | Generador de build paralelo |

**¿Por qué bundle?** En embedded, cross-compilación es la norma. El host (x86_64 Linux) compila para ARM Cortex-M4, RISC-V, Xtensa — cada uno necesita su propio compilador, linker y debugger.

**QEMU:** Permite ejecutar firmware sin hardware. Ideal para desarrollo inicial, CI/CD y debugging visual.

**OpenOCD:** Puente entre GDB y el hardware (JTAG/SWD). Permite breakpoints, lectura/escritura de registros, step-through.

---

## 5. API POSIX-like + Stack de Networking

### API POSIX en Zephyr
Subconjunto de la API POSIX para portar aplicaciones desde Linux/FreeBSD con modificaciones mínimas.

**Syscalls soportadas:**
| Función | Descripción |
|---------|-------------|
| `open/close/read/write` | Acceso a archivos/dispositivos |
| `socket/bind/listen/accept/connect` | Networking |
| `select/poll` | I/O multiplexing |

**§1.8 — Cómo funciona una syscall en Zephyr (ejemplo ARM Cortex-M):**

```
Aplicación → read(fd, buf, len)
    → Biblioteca C (newlib)
    → svc 0x01 (Supervisor Call — excepción)
    → Kernel Zephyr recibe número syscall + argumentos
    → Ejecuta handler (ej: do_sys_open)
    → Retorna resultado a usuario
```

**¿Por qué "POSIX-like" y no POSIX completo?**
- Memoria limitada: sin MMU, no hay memoria virtual
- Sin procesos separados: una única imagen de firmware con múltiples threads
- Overhead: implementar todas las syscalls tiene costo en código y runtime

### Stack de Networking
Stack de conectividad nativo integrado en el kernel.

```
CAPAS:
┌──────────────────────────────┐
│ Application: MQTT, CoAP, HTTP│
├──────────────────────────────┤
│ Transport:   TCP, UDP, TLS  │
├──────────────────────────────┤
│ Network:     IPv4, IPv6      │
├──────────────────────────────┤
│ Connectivity: Ethernet, Wi-Fi│
│ BLE, Thread, LoRa, Cellular, │
│ CAN                              │
└──────────────────────────────┘
```

**Tecnologías soportadas:**
- **BLE**: 4.2 a 5.3, roles Central/Peripheral
- **Wi-Fi**: Station, AP, Monitor (ESP32, RTL8722)
- **Thread**: IEEE 802.15.4 + IPv6 (de Nest/Google)
- **Cellular**: LTE-M, NB-IoT (nRF9160, Sequans)
- **Ethernet**: 10/100/1000 Mbps, DHCP, DNS
- **CAN**: CAN 2.0 y CAN-FD, interfaz SocketCAN

---

## 6. Documentación y Comunidad

**docs.zephyrproject.org** ofrece:
- Getting Started Guide
- Build System (CMake, KConfig, West, Devicetree)
- API Reference (Doxygen)
- Hardware Support (boards, SoCs, drivers)
- Samples and Demos

**Recursos:** GitHub Discussions, Discord, Mailing lists (zephyr-users, zephyr-devel), Stack Overflow (`zephyr-rtos`).

**Governance:** Proyecto de la Linux Foundation con board formal, procesos abiertos (TODOs, PRs, issues públicos) y releases cada 2-3 meses.

---

## 7. Flujo Completo de Desarrollo

```
1. west init -l myapp
   → Crea workspace, descarga west.yml

2. west update
   → Descarga repos del manifiesto

3. west build -b <board> my_app
   → CMake ejecuta boilerplate.cmake
   → Procesa KConfig (CONFIG_*)
   → Compila Devicetree (.dts → devicetree.h)
   → Invoca toolchain (gcc/arm-none-eabi-gcc)
   → Genera .elf, .bin, .hex

4. west flash
   → OpenOCD programa flash via JTAG/SWD

5. west debug
   → OpenOCD lanza GDB server
   → Developer puede breakpoint, step, inspect
```

---

## 8. Relación KConfig ↔ DeviceTree

| Aspecto | KConfig | DeviceTree |
|---------|---------|------------|
| **Describe** | Features de software | Hardware (periféricos, pines, IRQs) |
| **Genera** | `#define CONFIG_X` | `devicetree.h` con macros |
| **Sintaxis** | `CONFIG_X=y` en `.conf` | Árbol en `.dts`/`.overlay` |
| **Quién lo escribe** | Developer de app | Vendor de board/SoC |
| **Ejemplo** | `CONFIG_I2C=y` | `&i2c0 { status = "okay"; }` |

---

*Resumen preparado para el TP Especial de Fundamentos de Sistemas Operativos, UNMDP. Mayo 2026.*