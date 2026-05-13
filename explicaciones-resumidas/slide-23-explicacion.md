# Slide 23 — Resumen: Zephyr OS — Casos de Uso

## ¿Qué es Zephyr OS?

Zephyr es un **sistema operativo de tiempo real (RTOS)** diseñado específicamente para **microcontroladores (MCU)** con recursos extremadamente limitados. Fue creado para dispositivos que necesitan conectividad wireless, seguridad robusta y largo ciclo de vida.

---

## Conceptos Clave de Zephyr

### Como "Máquina Extendida"
Zephyr **oculta la complejidad del hardware** subyacente. El desarrollador escribe código contra APIs genéricas (POSIX-like o nativas de Zephyr) sin necesidad de conocer los detalles del microcontrolador específico (Nordic, NXP, STM, etc.).

### Como "Gestor de Recursos"
En sistemas embebidos, los recursos son escasos: bytes de flash, ciclos de CPU, energía de batería. Zephyr gestiona:
- **Scheduling**: scheduler preemptive con prioridades configurables
- **Memoria**: protección mediante MPU, dominios de memoria
- **Conectividad**: stacks wireless integrados (BLE, Wi-Fi, Thread, 802.15.4, LoRa, Cellular)
- **E/S**: drivers para CAN, LIN, I2C, SPI, UART

### Arquitectura Microkernel
Solo las funcionalidades esenciales viven en el kernel (modo privilegiado):
- Scheduler de threads, gestión de interrupciones, sincronización básica (semáforos, mutexes, spinlocks), IPC

**Fuera del kernel** (modo usuario o módulos): stacks de networking, file systems, drivers, servicios de seguridad.

Esta separación permite configuración granular: un dispositivo que solo necesita BLE no carga el stack Wi-Fi, reduciendo el footprint a **~4 KB de flash**.

---

## Casos de Uso

### 1. Wearables (Audífonos como Oticon More)
- **Requisitos**: memoria muy limitada (256-512 KB flash), BLE, procesamiento de audio en tiempo real, consumo mínimo, fiabilidad crítica
- **Cómo Zephyr lo resuelve**: kernel configurable (~4 KB mínimo), stack BLE integrado, scheduler preemptive, PSA Crypto para datos biométricos
- **Hilos concurrentes**: procesamiento de audio (máxima prioridad), conectividad BLE, gestión de batería, interfaz de usuario

### 2. Industrial (GARDENA — sistemas de riego)
- **Requisitos**: lifecycle de 10-20 años, entornos hostiles (temperaturas, humedad, vibraciones), comunicación robusta (CAN bus, 802.15.4), almacenamiento confiable
- **Cómo Zephyr lo resuelve**: versiones LTS (Long Term Support), gobernanza neutral (Linux Foundation), LittleFS (tolerante a fallas), NVS (datos de configuración)
- **Dato**: 52% de organizaciones usan Zephyr en productos por 5-10+ años

### 3. Médico (HealthyPi Move — ECG wearable)
- **Requisitos**: seguridad de datos, fiabilidad, BLE, footprint mínimo
- **Cómo Zephyr lo resuelve**: tamaño configurable (~4 KB), PSA Crypto API, secure boot, aislamiento de hilos
- **Limitación**: Zephyr **no tiene certificaciones pre-certificadas** (IEC 61508, ISO 26262). Apropiado para monitoreo personal, no para diagnóstico clínico que requiera certificación regulatoria.

### 4. Transporte (Scooters, GPS Trackers, cerraduras BLE)
- **Requisitos**: conectividad múltiple (BLE + Wi-Fi/cellular + GPS), consumo ultra-bajo (semanas/meses con una carga), resistencia física, actualizaciones OTA
- **Cómo Zephyr lo resuelve**: soporte multi-protocolo, tickless idle y deep sleep, +1,000 boards soportadas, portabilidad cross-vendor
- **Scheduling ejemplo**: control de motor (máxima prioridad) → gestión de batería → comunicación BLE → logging de trayectos

### 5. Energía (Vestas — turbinas eólicas)
- **Requisitos**: lifecycle de 20-30 años, ambiente hostil (-40°C a +80°C), confiabilidad crítica, mantenimiento remoto
- **Cómo Zephyr lo resuelve**: gobernanza neutral, LTS3, multi-protocolo (802.15.4 + cellular), portabilidad para cambiar de proveedor de MCU sin reescribir software

### 6. Consumer (Framework Laptop 13 DIY)
- **Requisitos**: firmware de gestión de batería con rendimiento rápido, consumo optimizado, actualizaciones fáciles, debugging
- **Cómo Zephyr lo resuelve**: configurabilidad exacta del kernel, POSIX compatibility, herramientas de tracing, open source

---

## El Denominador Común: ~4 KB de Flash

Zephyr puede funcionar en dispositivos con solo **~4 KB de memoria flash**. Esto es posible gracias a:
1. **Configuración granular**: kernel se compila solo con lo necesario
2. **Arquitectura microkernel**: funcionalidades esenciales en el kernel
3. **Linking estático**: sin overhead de interpretación en runtime
4. **Devicetree**: configuración de hardware en tiempo de compilación

**Comparación de footprint**:
| RTOS | Mínimo |
|------|--------|
| Zephyr | ~4 KB |
| FreeRTOS | ~6 KB |
| ThreadX | ~2 KB (sin seguridad) |
| Linux embebido | ~4 MB |

---

## Conexión con Fundamentos de Sistemas Operativos

| Concepto FSO | Cómo se aplica en Zephyr |
|--------------|---------------------------|
| **Máquina Extendida** | APIs genéricas que ocultan hardware específico |
| **Gestor de Recursos** | Arbitrar entre hilos que compiten por CPU, memoria y energía limitados |
| **Multiprogramación Embebida** | Múltiples hilos concurrentes (audio + BLE + UI en wearables; sensado + comunicación + logging en industrial) |

---

## Glosario Rápido

- **MCU**: Microcontrolador (CPU + memoria + periféricos en un chip)
- **BLE**: Bluetooth Low Energy — comunicación wireless de bajo consumo
- **Real-time constraints**: restricciones temporales donde un resultado tardío es tan malo como uno incorrecto
- **PSA Crypto API**: API de criptografía estandarizada para IoT
- **Secure Boot**: garantiza que solo firmware firmado se ejecuta
- **LittleFS**: file system tolerante a fallas para flash
- **NVS**: almacenamiento simple para datos de configuración
- **SMP/AMP**: procesamiento simétrico/asimétrico multi-core
- **MPU**: unidad de protección de memoria
- **LTS**: versiones con soporte extendido (2+ años)
- **OTA**: actualizaciones de firmware via wireless
- **802.15.4**: estándar wireless de bajo consumo para redes de sensores

---

## ¿Por qué Zephyr es ideal para estos casos?

| Caso de Uso | Factor determinante |
|-------------|---------------------|
| Wearables | Footprint mínimo, BLE integrado |
| Industrial | LTS, gobernanza neutral, LittleFS |
| Médico | Seguridad robusta, configurabilidad |
| Transporte | Multi-protocolo, bajo consumo |
| Energía | Lifecycle largo, portabilidad |
| Consumer | Open source, debugging |

**Todos comparten**: dispositivos con recursos limitados que requieren conectividad, confiabilidad y soporte a largo plazo. Zephyr fue diseñado específicamente para este nicho de IoT embebido.

---

*Fuente: TP Especial Zephyr MOSIX — Fundamentos de Sistemas Operativos, Mayo 2026*
