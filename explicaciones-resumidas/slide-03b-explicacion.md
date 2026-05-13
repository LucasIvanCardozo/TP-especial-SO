# slide-03b — Zephyr OS: Segmento de Mercado

## Resumen

Este slide presenta el **posicionamiento comercial y adopción global de Zephyr OS**, organizado en tres bloques visuales:

- **Panel izquierdo**: 7 segmentos de mercado con presencia activa
- **Panel derecho**: métricas cuantitativas de adopción (datos 2026)
- **Panel inferior**: productos comerciales que ya utilizan Zephyr

**Objetivo**: demostrar que Zephyr es un RTOS comercialmente viable, no un proyecto académico.

---

## Segmentos de Mercado

### 1. IoT — Sensores y Dispositivos Conectados
Dispositivos que sensing y transmiten datos con mínima potencia. Ejemplos: sensores industriales, smart meters, nodos distribuidos.
- **Diferenciador clave**: puede correr en MCUs con solo **4 KB de RAM** (Linux requiere >1 MB)
- Zephyr abstrae la complejidad del hardware (drivers, timers, stacks BLE)

### 2. Sistemas Embebidos — Microcontroladores (MCUs)
 chips que integran CPU + memoria + periféricos en un solo integrado.
- CPU 8/16/32 bits, usualmente sin MMU (solo MPU limitada)
- RAM: 1 KB–2 MB; Flash: 16 KB–2 MB
- Periféricos: GPIO, UART, SPI, I2C, Timer
- **Zephyr soporta +1,000 boards** (ARM Cortex-M, RISC-V, x86, ARC, Tensilica)

### 3. Wearables — Smartwatches y Audífonos
Requieren consumo ultra-bajo para autonomía de días/semanas.
- Mantener conexión BLE activa + procesar datos de sensores + mostrar info
- Baterías de 50-500 mAh
- **Ejemplo real**: *Oticon More* — audífono médico que procesa audio en tiempo real adaptándose al ambiente

### 4. Industrial — Controladoras y Automatización
PLCs, sistemas SCADA, controladoras de fábrica.
- **Determinismo temporal**: respuesta garantizada en ≤X ms (no "lo antes posible")
- **Fiabilidad**: funcionamiento sin intervención por años
- Conectividad: CAN bus, Modbus, EtherCAT, Thread
- **Dato**: 52% de organizaciones planea dar soporte a Zephyr por 5-10+ años
- Competencia directa con VxWorks y QNX, pero sin costo de regalías

### 5. Dispositivos Médicos — ECG y Monitores
Requieren certificación regulatoria (FDA, CE) y trazabilidad determinista.
- Adquirir señales bioeléctricas a frecuencia fija → procesar en tiempo real → almacenar/transmitir vía BLE
- **Certificación IEC 62304** (estándar para software médico)
- **Ejemplo**: *HealthyPi Move* — ECG portable con Zephyr

### 6. Transporte — Scooters, Cerraduras BLE, GPS
Dispositivos de micromovilidad y posicionamiento.
- Bajo consumo, comunicación wireless (BLE, GPS), PCB mínima
- **Cerraduras BLE para Airbnb**: verifican credenciales y accionan motor con MCU de 32 KB flash + stack BLE completo

### 7. Sostenibilidad — Turbinas Eólicas y Paneles Solares
**Caso más ambicioso**: turbinas eólicas *Vestas*.
- Una turbina tiene cientos de sensores (vibración, temperatura, viento) → terabytes de datos/año
- Zephyr corre en los **blade controllers** donde el determinismo temporal ajusta el ángulo de ataque
- Zephyr actúa como **gestor de recursos**: administra CPU, memoria y red de múltiples sensores

---

## Adopción Global (Panel Derecho)

| Métrica | Dato |
|---------|------|
| Organizaciones usando Zephyr en Norteamérica | 70% |
| Organizaciones usando Zephyr en Europa | 62% |
| Planea aumentar adopción | 69% |
| Contribuidores globales | 3,000+ (1,100 únicos en 2024, +50% primeros contribuidores) |
| Boards soportadas | 1,000+ |

**Arquitecturas soportadas**:
- ARM Cortex-M (STM32, LPC/NXP, Kinetis)
- RISC-V (SiFive, ESP32-C, RX65N)
- x86 (Intel Quark)
- ARC (Synopsys)
- Tensilica (Cadence Xtensa)

**Fuente**: "Zephyr Turns 10" — Linux Foundation Research (marzo 2026), encuesta a 413 profesionales.

---

## Productos Comerciales

| Producto | Sector | Relevancia |
|----------|--------|------------|
| **Vestas Wind Turbines** | Energía | Control de alta complejidad en ambiente hostil |
| **Google Chromebook** | Consumer | Componentes embebidos con Zephyr (adopción orgánica) |
| **Framework Laptop 13** | Notebook | En subsistema de firmware/embedded controller |
| **Oticon More** | Médico | Dispositivo regulado; procesamiento de audio en tiempo real |
| **GARDENA Smart Irrigation** | Industrial | Válvulas, sensores de humedad, comunicación wireless |
| **Tenstorrent Blackhole** | AI/HPC | Firmware del host controller del acelerador PCIe |

---

## Glosario de Términos Clave

| Término | Definición |
|---------|------------|
| **RTOS** | Sistema operativo que garantiza respuesta dentro de un tiempo máximo estricto. Puede ser *hard real-time* (garantizado) o *soft real-time* (preferido). |
| **MCU** | Chip integrado con CPU + memoria + periféricos. Diseñado para tareas específicas con recursos limitados. |
| **IoT** | Objetos físicos con capacidades de cómputo y comunicación, conectados a internet. |
| **BLE** | Bluetooth Low Energy — protocolo optimizado para bajo consumo en dispositivos que transmiten pocos datos. |
| **Footprint** | Recursos (RAM, Flash, código) que ocupa un programa. Zephyr mínimo: ~4 KB RAM. |
| **Tickless kernel** | El scheduler no genera interrupciones periódicas cuando no hay trabajo, reduciendo consumo energético. |
| **Determinismo temporal** | El tiempo de respuesta a un evento tiene un bound conocido y garantizado. |
| **MMU** | Hardware que implementa memoria virtual (paginación). MCUs suelen tener MPU ( Memory Protection Unit) en vez de MMU completa. |
| **SMP** | Symmetric Multiprocessing — múltiples cores idénticos compartiendo memoria. Zephyr lo soporta en arquitecturas multi-core. |
| **Vendor lock-in** | Dependencia de un proveedor. Zephyr (Linux Foundation) es neutral; FreeRTOS (Amazon) y ThreadX (Microsoft) tienen lock-in. |
| **LTS** | Long Term Support — versiones con updates de seguridad por 2+ años. Crítico para productos industriales con ciclos de vida de 10-20 años. |

---

## Conexión con el Temario FSO

### §1.1 — Máquina Extendida y Gestor de Recursos

**Como máquina extendida**: Zephyr oculta la heterogeneidad del hardware de MCUs. Sin Zephyr, programar un sensor de temperatura BLE requeriría:
1. Leer datasheet del MCU específico
2. Configurar registros del clock tree
3. Escribir driver I2C desde cero
4. Implementar BLE stack a nivel de HCI
5. Manejar power management

Con Zephyr: `device_get_binding("I2C_0")` → `i2c_write()` sin conocer el hardware.

**Como gestor de recursos**: Zephyr administra CPU, memoria y periféricos. Cuando múltiples sensores compiten por I2C, el scheduler decide quién accede.

### §1.4 — Arquitectura Microkernel
- Kernel mínimo: scheduler + interrupt handling + IPC
- Servicios (file system, networking, drivers) corren como user-space threads o bibliotecas linkeadas estáticamente
- **Ventajas**: menor footprint, mayor modularidad, mejor fault isolation
- **Contraste**: Linux es monólitico

### §1.5 — Modo Dual de Operación
- **Supervisor mode**: kernel y drivers tienen acceso full a hardware
- **User mode**: aplicaciones con acceso restringido
- En sistemas con MPU, Zephyr configura regiones de memoria que previenen escritura fuera del área asignada

### §1.2 — Código Abierto (4ª Generación)
Zephyr pertenece a Linux Foundation (modelo abierto), mostrando la tendencia post-1990 de abrir código propietario.

---

## IoT Embebido vs HPC: Diferencias Fundamentales

| Aspecto | IoT Embebido (Zephyr) | HPC (Linux/UNIX) |
|---------|----------------------|-----------------|
| Hardware | MCU, 4 KB–2 MB RAM | Servidor, GB de RAM |
| Latencia | Determinista, µs–ms | No determinista, ms–s |
| Scheduling | Priority-based, preemption | Completely Fair Scheduler |
| MMU | Ausente o MPU | Presente, full paging |
| Filesystem | Minimal (LittleFS, FAT) | Full (ext4, XFS, Btrfs) |
| Networking | BLE, 802.15.4, LoRa | Ethernet, InfiniBand |
| Consumo | µW–mW | W–KW |
| Footprint OS | 4 KB–512 KB | 256 MB–2 GB |

**No se puede correr Linux en un MCU de 8 KB RAM**, ni se necesita Zephyr en un servidor con GB de RAM. Son soluciones para problemas radicalmente diferentes.

---

## Mercado RTOS: Competidores

| Competidor | Sponsor | Fortalezas |
|------------|---------|------------|
| **Zephyr** | Linux Foundation (neutral) | Open source, 1,000+ boards, comunidad grande |
| **FreeRTOS** | Amazon/AWS | Integración AWS, gran comunidad |
| **ThreadX/Azure RTOS** | Microsoft/Azure | Integración Azure |
| **VxWorks** | Wind River | 30+ años en aerospace/defense |
| **QNX** | BlackBerry | Automotive, cinema |
| **RT-Thread** | Comunidad china | Popular en China |

### Ventajas Competitivas de Zephyr

1. **Neutralidad**: no puede ser descontinuado por una sola empresa (vs. FreeRTOS/Amazon, ThreadX/Microsoft)
2. **Portabilidad**: 49% de usuarios la citan como mayor beneficio; migración entre MCUs sin reescribir código
3. **Seguridad**: Security Committee dedicado, PSA Crypto API, secure boot, OpenSSF Gold Badge
4. **Conectividad integrada**: BLE, Wi-Fi, Thread, 802.15.4, LoRa, Cellular, CAN — todos incluidos
5. **Costo cero**: sin regalías

---

## Fuentes

- Linux Foundation Research — "Zephyr at 10: A Decade of Open Source Embedded Innovation" (marzo 2026)
- "Zephyr Turns 10" announcement
- https://www.zephyrproject.org/products-running-zephyr/
- https://www.zephyrproject.org/governing-board/
- Apache License 2.0

---

*Documento preparado para el TP Especial de Fundamentos de Sistemas Operativos (UNMDP).*
