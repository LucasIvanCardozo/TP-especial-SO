# Slide 02 — Posicionamiento de Mercado

## 🎤 Guía de Exposición (Qué decir)

### Apertura (10 seg)

"Esta slide es clave: Zephyr y MOSIX parecen no tener nada en común. Y técnicamente tienen razón — no compiten entre sí. Pero por eso los comparamos: para entender cómo el hardware determina el diseño de un sistema operativo."

### El gráfico (15 seg)

"Miren el diagrama:

- **Eje vertical (Y)** = Recursos de hardware: cuánta RAM, CPU y almacenamiento puede gestionar
- **Eje horizontal (X)** = Escala de uso: desde un chip individual hasta un cluster de investigación

Zephyr está **abajo a la izquierda** (poco hardware, escala chica).
MOSIX está **arriba a la derecha** (mucho hardware, escala grande).

Son extremos opuestos."

### Presentación de Zephyr (15 seg)

"**Zephyr es un RTOS para IoT embebido.**

¿Qué significa eso?

- **RTOS** = Sistema operativo de tiempo real. Garantiza respuesta en tiempos exactos, no "rápido" sino "determinístico". Ejemplo: el airbag de un auto debe desplegarse en exactamente 5 milisegundos, ni antes ni después.
- **IoT** = Internet of Things, objetos conectados a internet (sensores, wearables, dispositivos inteligentes).
- **IoT embebido** = dispositivos dedicados (para una tarea específica) que además se conectan a internet.

Zephyr corre en **microcontroladores** — chips pequeños con recursos muy limitados. Su footprint es de apenas **~4 KB de RAM**. Para que se den una idea: 4 KB es la memoria de una calculadora común."

### Presentación de MOSIX (15 seg)

"**MOSIX es un Cluster OS para HPC.**

- **HPC** = Computación de Alto Rendimiento (High Performance Computing). Es cuando necesitás resolver problemas tan grandes que una sola máquina no puede — entonces usás muchas juntas.
- **Cluster OS** = Sistema operativo que gestiona un cluster como si fuera una sola máquina.
- **Nodo** = Cada computadora individual dentro del cluster. Básicamente un servidor o PC.
- **SSI (Single System Image)** = MOSIX hacía que 100 servidores aparecieran como una sola máquina ante el usuario.

Un cluster HPC puede tener **cientos de nodos**, cada uno con GB de RAM. Estamos hablando de recursos mil veces mayores que Zephyr."

### Por qué los comparamos (10 seg)

"¿Por qué comparar un SO de 4 KB con uno que maneja cientos de servidores?

**La comparación es académica.** El valor no está en elegir "cuál es mejor", sino en entender algo fundamental: **"sistema operativo" no es un producto único**. Es una familia de soluciones donde el hardware y el dominio de aplicación determinan cada decisión de diseño."

### Cierre y transición (10 seg)

"Para entender cómo llegamos a estas diferencias tan grandes, veamos la historia de cada producto. Empezamos por Zephyr..."

---

## 📝 Glosario Rápido (para consulta durante la exposición)

| Término | Significado |
|---------|-------------|
| **RTOS** | Sistema Operativo de Tiempo Real — responde en tiempos garantizados (ej: airbag) |
| **IoT** | Internet of Things — objetos cotidianos conectados a internet |
| **IoT embebido** | Dispositivos dedicados a una tarea + conexión a internet |
| **Footprint** | Memoria RAM mínima que necesita el SO para correr (~4 KB) |
| **HPC** | Computación de Alto Rendimiento — resolver problemas grandes con muchos equipos |
| **Cluster** | Grupo de computadoras conectadas trabajando juntas |
| **Nodo** | Cada computadora individual dentro del cluster |
| **SSI** | Single System Image — cluster que parece una sola máquina |

---

## 📌 Puntos Clave a Mencionar

1. **No compiten entre sí** — son para problemas completamente distintos
2. **Zephyr** = hacer mucho con muy poco (minimalismo, ~4 KB)
3. **MOSIX** = unir mucho para parecer uno solo (distribución, SSI)
4. **El diseño de un SO depende del hardware destino y el dominio de aplicación**

---

## ⚠️ Errores a Evitar

| ❌ NO decir | ✅ Decir |
|-------------|----------|
| "Vamos a ver cuál es mejor" | "La comparación es académica" |
| "MOSIX sigue activo" | "Está inactivo desde 2017" |
| "Zephyr corre en servidores" | "Zephyr corre en microcontroladores" |

---

## 🔗 Relación con FSO

| Concepto del Temario | Cómo se manifiesta aquí |
|----------------------|------------------------|
| **§1.1 — Máquina extendida** | Zephyr abstrae hardware de MCUs; MOSIX extiende un cluster hacia SSI |
| **§1.1 — Gestor de recursos** | Zephyr administra CPU en 4 KB; MOSIX distribuye procesos entre nodos |
| **§1.4 — Arquitectura microkernel** | Zephyr implementa microkernel mínimo (~4 KB footprint) |
| **§1.4 — Overlay sobre kernel** | MOSIX opera como capa sobre Linux |
| **§1.2 — Generaciones de SO** | MOSIX nació en era de clusters; Zephyr en era de IoT |

---

## ⏱️ Tiempo Estimado: 60-90 segundos

- 10 seg: apertura
- 15 seg: gráfico y ejes
- 15 seg: Zephyr
- 15 seg: MOSIX
- 10 seg: por qué comparamos
- 10 seg: transición
