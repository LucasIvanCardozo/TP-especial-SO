# Slide 20 — Notas de Exposición: Zephyr OS — Difusión y Presencia

> **Slide objetivo**: Zephyr OS — Difusión y Presencia  
> **Contexto**: Adopción global creciente — ecosistema maduro  
> **Duración sugerida**: 45-60 segundos

---

## 1. 🎤 Qué Decir (Speaking Notes)

### Introducción al Ecosistema Zephyr

"Zephyr no es solo un proyecto de código — es un ecosistema vivo con adopción real en la industria."

### Métricas Clave para Destacar

"Numeremos los números que muestra la slide:

- **3,000+ contribuyentes** globales — no es un proyecto de una sola empresa, tiene comunidad real
- **1,000+ placas soportadas** — desde microcontroladores de 8 bits hasta sistemas embebidos complejos
- **LTS activo** — Zephyr ofrece soporte a largo plazo para productos de ciclo de vida largo, algo crítico en IoT industrial y médico
- **69% planea aumentar uso** — la adopción no solo es presente, es creciente"

### Conexión con el Pitch

"Esto contrasta totalmente con lo que vimos de MOSIX. Mientras MOSIX tiene cero actividad desde 2017, Zephyr está en plena expansión. Y estos números no son marketing — son datos de la Linux Foundation Research de 2026."

### Cierre

"Zephyr pasó de ser un proyecto de Wind River a ser un estándar de facto en IoT embebido. La diferencia fundamental: open source con gobernanza neutral y comunidad activa."

---

## 2. 📌 Puntos Clave para la Exposición

| Métrica                      | Qué significa                    | Por qué importa                         |
| ---------------------------- | -------------------------------- | --------------------------------------- |
| **3,000+ contributors**      | Comunidad global activa          | No depende de una sola empresa          |
| **1,000+ boards**            | Soporte masivo de hardware       | Ahorra trabajo de portación a fabricantes           |
| **LTS activo**               | Versiones con 2+ años de soporte | Confianza para productos de ciclo largo |
| **69% crecimiento planeado** | Trajectory positiva              | Indica relevancia continua              |

### Productos Comerciales Reales

Mencionar algunos casos de uso documentados:

- **Vestas Wind Turbines** — energía eólica
- **Oticon More** — audífonos avanzados
- **GARDENA** — riego inteligente
- **Framework Laptop** — laptop modular
- **HealthyPi Move** — ECG wearable

### Gobernanza Neutral

"Zephyr opera bajo la Linux Foundation — una organización sin fines de lucro. Esto significa que ninguna empresa controla el proyecto. Si Intel, Qualcomm o cualquier otro abandona, Zephyr sigue."

---

## 3. 🔗 Relación con FSO

### §1.1 — Gestión de Recursos vs Máquina Extendida

Zephyr como **máquina extendida** para IoT:

- Oculta la complejidad de hardware heterogéneo (ARM, RISC-V, x86, etc.)
- Presenta API unificada a desarrolladores
- Múltiples placas diferentes parecen "la misma máquina" para el programador

### §1.2 — 5ta Generación (Móvil y Nube)

Zephyr es producto de la 5ta generación:

- **Internet of Things** como elemento distintivo
- Open source bajo organización neutral
- Cloud computing como contexto de uso (dispositivos conectados)

### §1.4 — Modelo Cliente-Servidor (Gobernanza)

La gobernanza de Zephyr es **cliente-servidor**:

- **Governing Board** → define estrategia
- **TSC (Technical Steering Committee)** → decisiones técnicas
- **Working Groups** → grupos especializados (security, connectivity, etc.)

Esto no es arquitectura de SO, pero ilustra cómo modelos organizacionales reflejan principios de sistemas: separación de concerns, jerarquía de decisiones.

---

## 4. ⚠️ Cosas a Tener en Cuenta

### ✅ Hacer

- **Mencionar los números específicos**: 3,000+, 1,000+, 69% — estos datos son de la Linux Foundation Research
- **Contrast con MOSIX**: Esta slide cierra la sección de Zephyr, preparar el contraste con la slide siguiente de MOSIX
- **Mencionar casos de uso comerciales**: Dar credibility con productos reales
- **Destacar la gobernanza**: "Linux Foundation" no es "Wind River" — esto importa para adopción

### ❌ Evitar

- **No inventar números**: Usar solo los de la slide (3,000+, 1,000+, 69%)
- **No prometer qué viene**: Esta slide habla del estado actual, no de roadmap
- **No mezclar con MOSIX todavía**: El contraste viene en la slide 21 (MOSIX Diffusion)

### 🎯 Para el Docente

Preguntas probables:

- **"Zephyr compite con FreeRTOS?"** — Sí, pero Zephyr tiene más soporte institucional y más boards
- **"Por qué tener LTS si es open source?"** — Productos IoT tienen ciclos de 10-20 años; LTS asegura que no rompan con updates

---

## 5. ⏱️ Tiempo Estimado

| Sección               | Tiempo   | Contenido                                           |
| --------------------- | -------- | --------------------------------------------------- |
| Introducción          | 10s      | "Zephyr no es solo código, es un ecosistema vivo"   |
| Métricas              | 20s      | Los cuatro números clave (3,000+, 1,000+, LTS, 69%) |
| Productos comerciales | 10s      | 2-3 ejemplos concretos                              |
| Contraste implícito   | 10s      | "Esto contrasta con lo que veremos de MOSIX"        |
| **Total**             | **~50s** | Slide de cierre de sección Zephyr                   |

---

## 6. 📝 Script Suggested

```
"Zephyr OS no es solo un RTOS — es un ecosistema con adopción real
en la industria. Los números lo demuestran: más de tres mil contribuyentes
globales, soporte para más de mil placas diferentes, versiones LTS activas,
y casi el setenta por ciento de las organizaciones planean aumentar su uso.

 casos de uso comerciales como Vestas, Oticon o GARDENA demuestran
que Zephyr no es solo un proyecto académico, sino una tecnología
que está en productos reales hoy.

 Esto contrasta marcadamente con lo que vamos a ver a continuación
sobre MOSIX."
```

---

_Archivo generado para exposición del TP Especial — Fundamentos de Sistemas Operativos_
_Universidad Nacional de Mar del Plata — Mayo 2026_
