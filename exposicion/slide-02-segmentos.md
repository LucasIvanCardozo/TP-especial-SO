# Slide 02 — Posicionamiento de Mercado

## 🎤 Qué decir

Empezá señalando el gráfico: "Este diagrama es la clave de toda la presentación. Zephyr y MOSIX parecen no tener nada en común, y técnicamente no compiten en el mismo mercado. Pero именно por eso los comparamos: porque nos permiten estudiar cómo las restricciones del hardware determinan las decisiones de diseño de un sistema operativo."

 Señalá los ejes:
- **Eje vertical (Y)**: recursos de hardware — medimos cuánta RAM, CPU y almacenamiento puede gestionar el sistema
- **Eje horizontal (X)**: escala de uso — desde un chip individual hasta un cluster de investigación

Zephyr está en el **extremo inferior izquierdo** (recursos limitados, escala chica), MOSIX en el **extremo superior derecho** (recursos abundantes, escala grande).

---

## 📌 Puntos Clave

1. **Zephyr es un RTOS para IoT embebido**: Diseñado para correr en microcontroladores con desde ~4 KB de RAM. Compite con FreeRTOS y ThreadX, no con MOSIX.

2. **MOSIX es un Cluster OS para HPC**: Diseñado para gestionar clusters de cientos de nodos con GB de RAM por nodo. Compite con SLURM y Kubernetes, no con Zephyr.

3. **Ambos son sistemas operativos, pero de categorías radicalmente diferentes**: Esto ilustra que "sistema operativo" no es un producto único — es una familia de soluciones organizadas alrededor de constraints de hardware y objetivos de aplicación.

4. **La comparación es académica**: El valor no está en elegir "cuál es mejor", sino en entender cómo cada dominio determina decisiones de diseño (arquitectura del kernel, gestión de memoria, scheduling).

---

## 🔗 Relación con FSO

| Concepto del Temario | Cómo se manifiesta aquí |
|----------------------|------------------------|
| **§1.1 — Máquina extendida** | Zephyr abstrae hardware heterogéneo de MCUs; MOSIX extiende un cluster hacia una única máquina virtual (SSI) |
| **§1.1 — Gestor de recursos** | Zephyr administra CPU y memoria en 4 KB; MOSIX distribuye procesos entre cientos de nodos |
| **§1.4 — Arquitectura microkernel** | Zephyr implementa microkernel (kernel mínimo, ~4 KB footprint) |
| **§1.4 — Overlay sobre kernel** | MOSIX opera como capa sobre Linux — arquitectura híbrida no estándar |
| **§1.2 — Generaciones de SO** | MOSIX nació en los '90s (era de clusters); Zephyr en 2016 (era de IoT) |

---

## ⚠️ Cosas a tener en cuenta

**Decir:**
- "No compiten entre sí — son soluciones para problemas completamente distintos"
- "La comparación nos enseña que el diseño de un SO depende del hardware destino y el dominio de aplicación"

**NO decir:**
- "Vamos a ver cuál es mejor" — no tiene sentido comparar un RTOS de 4 KB con un cluster OS
- "MOSIX sigue activo" — está inactivo desde 2017
- "Zephyr corre en servidores" — está diseñado para microcontroladores

**Transición sugerida:**
"Para entender cómo llegamos a estas diferencias, veamos primero la historia de cada producto. Empecemos por Zephyr..."

---

## ⏱️ Tiempo estimado

**60-90 segundos**

- 15 seg: explicar el gráfico y los ejes
- 30 seg: presentar cada producto y su posición
- 15 seg: explicar por qué la comparación es académica
- 15 seg: transición a la historia de Zephyr
