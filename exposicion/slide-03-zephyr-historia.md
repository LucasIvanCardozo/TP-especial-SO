# Slide 03 — Zephyr OS: Historia, Gobernanza y Mercado

## 🎤 Guía de Exposición (Qué decir)

### Apertura (10 seg)

"Esta slide cuenta la historia de Zephyr. Y algo importante: Zephyr no apareció de la nada en 2016. Su código tiene más de 25 años de desarrollo comercial atrás."

---

### La Historia del Código (30 seg)

**Nacimiento en los '90:**

"En los años 90, la empresa belga **Eonic Systems** creó **Virtuoso RTOS** — un sistema operativo de tiempo real para **DSPs** (procesadores de señal digital), que son chips especializados en procesar audio, telecomunicaciones, imágenes."

**Adquisición por Wind River:**

"En 2001, **Wind River** — una de las empresas más importantes en RTOS del mundo, creadora de **VxWorks** — compró Eonic Systems. Virtuoso pasó a ser parte de Wind River."

Aquí pueden mencionar: VxWorks se usa en sondas espaciales, sistemas de control aéreo, equipos médicos. Es un RTOS de alta gama.

**Liberación como Rocket RTOS:**

"En noviembre de 2015, Wind River tomó una decisión estratégica: liberar Virtuoso como **Rocket RTOS**, libre de regalías — o sea, gratis para usar y vender productos con él. ¿El tamaño? Apenas **4 KB**. Comparado con los 200 KB de VxWorks."

"¿Por qué? El mercado de **IoT** estaba explotando, y VxWorks era demasiado grande para microcontroladores."

---

### Nacimiento de Zephyr (15 seg)

"En febrero de 2016, Wind River **donó** el código de Rocket a la **Linux Foundation**, naciendo oficialmente **Zephyr Project**."

"La donación es clave: cuando donás a Linux Foundation, **el código deja de pertenecer a una empresa**. Pertenece al proyecto."

"Las empresas fundadoras fueron: **Intel, Wind River, Synopsys y NXP**."

---

### Por qué Linux Foundation (15 seg)

"¿Por qué no donarlo a Amazon o Google? **Neutralidad.**

Imaginá que fabricás dispositivos médicos que deben funcionar 20 años. No querés depender de que Amazon cambie de opinión, suba precios, o abandone el proyecto."

"**Linux Foundation** es una organización sin fines de lucro que:

- No es dueña del código — lo administra
- Ninguna empresa domina
- Las empresas miembros votan las decisiones

Zephyr no es parte del kernel Linux. Son proyectos distintos que comparten la misma fundación."

---

### Segmento de Mercado (15 seg)

"¿Dónde se usa Zephyr? **IoT embebido.**"

"El mercado de IoT incluye:

- **Wearables**: smartwatches, auriculares
- **Sensores industriales**: monitoreo de temperatura, presión, vibración
- **Dispositivos médicos**: glucómetros, oxímetros, monitores cardíacos
- **Automoción**: ECUs, sensores de ruedas
- **Hogar inteligente**: cerraduras, termostatos, iluminación"

"Zephyr compite con **FreeRTOS** (Amazon) y **ThreadX** (Microsoft). La diferencia: Zephyr es neutral — no pertenece a ninguna big tech."

---

### Gobernanza (10 seg)

"La estructura tiene tres niveles:

- **Governing Board**: define políticas y estrategia
- **TSC** (Technical Steering Committee): decide lo técnico
- **Security Committee**: maneja vulnerabilidades"

---

### Crecimiento Actual (10 seg)

"Desde 2016 hasta hoy:

- **3.000+ contribuyentes** (personas que escriben código)
- **1.000+ placas** soportadas (diferentes microcontroladores donde corre)
- **70%** de organizaciones en Norteamérica lo usan comercialmente"

"Los miembros actuales incluyen Qualcomm, Volkswagen, Renesas, ZEISS."

---

### Transición (5 seg)

"Contexto histórico listo. Ahora veamos cómo funciona Zephyr por dentro, empezando por su kernel..."

---

## 📝 Glosario Rápido

| Término | Significado |
|---------|-------------|
| **RTOS** | Sistema Operativo de Tiempo Real — responde en tiempos garantizados |
| **DSP** | Procesador de Señal Digital — chip especializado en audio, telecomunicaciones |
| **Footprint** | Memoria mínima que ocupa el SO (~4 KB en Zephyr) |
| **Libre de regalías** | Lo usás gratis, sin pagar por cada unidad vendida |
| **Donar código** | Transferir la propiedad al proyecto (ya no es de la empresa) |
| **Linux Foundation** | Organización neutral que hospeda proyectos open source |
| **Contribuyentes** | Personas que escriben código para el proyecto |
| **Placas** | Placas de desarrollo con microcontroladores donde corre Zephyr |
| **VxWorks** | RTOS estrella de Wind River (~200 KB) |
| **Vendor lock-in** | Dependencia de un proveedor — Zephyr lo evita |
| **IoT embebido** | Dispositivos dedicados a una tarea + conectados a internet |
| **HPC** | Computación de Alto Rendimiento — (para MOSIX, no Zephyr) |

---

## 📌 Puntos Clave

1. **El código tiene más de 25 años** de desarrollo comercial
2. **Wind River = empresa líder en RTOS** (VxWorks)
3. **Rocket = Virtuoso liberado** (~4 KB, libre de regalías)
4. **Zephyr = Rocket donado** a Linux Foundation (2016)
5. **Linux Foundation = neutralidad**, ninguna empresa domina
6. **Mercado: IoT embebido** (wearables, industriales, médicos, automoción)
7. **3.000+ contribuyentes, 1.000+ placas**, uso comercial masivo

---

## ⚠️ Errores a Evitar

| ❌ NO decir | ✅ Decir |
|-------------|----------|
| "Zephyr usa código de Linux" | "Zephyr es un proyecto separado bajo Linux Foundation" |
| "Linux Foundation es Linux" | "Linux Foundation hospeda proyectos, no es el kernel Linux" |
| "Wind River creó Zephyr" | "Wind River donó el código, Zephyr pertenece al proyecto" |
| "En 2016 había 3.000 contribuyentes" | "En 2016 había 4 empresas fundadoras. En 2026 hay miles de contribuyentes" |

---

## 🔗 Relación con FSO

| Concepto | Cómo se manifiesta |
|----------|-------------------|
| **§1.2 — Generaciones** | Zephyr combina traits de 3ª gen (RTOS, tiempo real) con 4ª gen (open source, Linux) |
| **§1.4 — Microkernel** | Zephyr implementa microkernel (kernel mínimo, servicios en usuario) |
| **§1.4 — Arquitectura** | Zephyr ≠ Linux (monolítico). Zephyr ≈ MINIX, QNX (microkernel) |

---

## ⏱️ Tiempo Total: 75-90 segundos

- 10 seg: apertura
- 30 seg: historia del código
- 15 seg: nacimiento de Zephyr
- 15 seg: por qué Linux Foundation
- 15 seg: segmento de mercado
- 10 seg: gobernanza
- 10 seg: crecimiento actual
- 5 seg: transición
