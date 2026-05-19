# Slide 6: Zephyr OS — Características Generales

> Notas de exposición para la presentación del TP Especial de Evaluación

---

## 1. 🎤 Qué Decir (Speaking Notes)

### Apertura (15 segundos)

"Zephyr es un RTOS — un Sistema Operativo de Tiempo Real — diseñado específicamente para sistemas embebidos. A diferencia de Linux o Windows que corren en tu computadora, Zephyr está pensado para funcionar en chips muy pequeños, con recursos extremely limitados."

### Punto clave: Footprint de ~4 KB (25 segundos)

"Acá viene lo más impresionante: Zephyr puede funcionar con apenas **4 kilobytes de RAM**. Para que tengan una referencia, una página web promedio ocupa más de 2 megabytes. 4 KB es ridículamente pequeño.

¿Cómo es posible? Zephyr no tiene todas las funcionalidades de un sistema operativo de escritorio. No tiene un desktop environment, no tiene gráficos pesados, no tiene un navegador. Tiene lo mínimo indispensable: scheduling de tareas, manejo básico de memoria, y comunicación entre hilos.

Esto permite que Zephyr corra en microcontroladores de 32 bits que tienen desde 16 KB hasta 256 KB de RAM total. Estamos hablando de chips que cuestan entre 50 centavos y 5 dólares."

### Arquitectura del Kernel (30 segundos)

"Respecto a la arquitectura interna, Zephyr usa un **kernel monolítico unificado**. Acá hay que explicar qué significa esto, porque es un poco técnico.

El temario de FSO habla de arquitecturas de sistemas operativos: kernels monolíticos, microkernels, sistemas por capas. Zephyr está en un punto intermedio interesante.

Por un lado, sigue la filosofía del **microkernel**: el kernel solo tiene lo esencial — scheduling, manejo de interrupciones, y comunicación entre procesos. Todo lo demás — drivers, sistema de archivos, stack de red, Bluetooth — corre como módulos separados.

Pero a diferencia de microkernels puros como MINIX o QNX, en Zephyr todos estos componentes se compilan en una **única imagen binaria**. No hay separación de procesos a nivel de protección. Todo termina en el mismo dominio de privilegio.

¿Por qué esta decisión? Por eficiencia. En un microcontrolador de 64 KB de RAM, el overhead de mantener procesos separados con su propia memoria sería prohibitivo. La solución de Zephyr es compilar todo junto, pero mantener modularidad lógica mediante namespaces y dominios de memoria."

### Cierre (15 segundos)

"En resumen: Zephyr logra ser ultra-compacto gracias a un kernel minimalista que prioriza lo esencial sobre lo accesorio, y lo hace de forma que puede correr en el hardware más restrictivo que puedan imaginar."

---

## 2. 📌 Puntos Clave

| Concepto                        | Qué enfatizar                                                                                                                                                                   |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **RTOS**                        | No es un sistema operativo general. Está diseñado para responder en tiempos determinísticos — crítico para aplicaciones como airbags, sensores médicos, controles industriales. |
| **Footprint ~4 KB**             | No es marketing. Es el tamaño real del kernel mínimo. Un microcontrolador Cortex-M0+ con 16 KB de RAM puede correr Zephyr.                                                      |
| **Kernel monolítico unificado** | Híbrido entre microkernel (filosofía minimalista) y monolítico (imagen binaria única). No encaja 100% en ninguna categoría del temario.                                         |
| **Sistemas embebidos**          | Hardware destino: microcontroladores, no microprocesadores. Diferencia fundamental con MOSIX que apunta a clusters.                                                             |

---

## 3. 🔗 Relación con FSO

### §1.4 — Arquitecturas de SO

Zephyr es un caso híbrido que ilustra cómo las categorías teóricas del temario no son mutuamente excluyentes en la práctica:

| Arquitectura del temario | Zephyr                                                                |
| ------------------------ | --------------------------------------------------------------------- |
| **Monolítica**           | No exactamente: hay modularidad lógica pero no separación de procesos |
| **Por capas**            | No explícitamente                                                     |
| **Microkernel**          | **Sí en filosofía**: kernel mínimo, servicios en espacio de usuario   |
| **Cliente-Servidor**     | Modelo de servicios: los subsistemas exportan interfaces              |

**Pregunta para la exposición**: ¿Por qué Zephyr no es un microkernel puro como MINIX? Porque MINIX tiene drivers corriendo como procesos de usuario con IPC real. Zephyr compila todo estáticamente en una imagen — el aislamiento es lógico, no de protección.

### §1.1 — Máquina Extendida

Zephyr actúa como máquina extendida para hardware heterogéneo de microcontroladores. El programador de un sensor BLE no quiere programar registros de periféricos ARM Cortex-M directamente. Zephyr le presenta una API unificada.

### §2.1 — Scheduling

Zephyr soporta múltiples políticas de scheduling (cooperativo, preemptive, híbrido) que se eligen en tiempo de compilación. Esto conecta con los algoritmos del temario: FCFS, Round Robin, por prioridad.

### §4.1-4.3 — Administración de Memoria

La memoria de Zephyr no tiene paginación completa porque la mayoría de microcontroladores no tienen MMU. Usan MPU (Memory Protection Unit) para protección de regiones — una versión simplificada de las tablas de páginas.

---

## 4. ⚠️ Cosas a Tener en Cuenta

### Explicar "4 KB" con contexto

No basta con decir "4 KB". Hay que dar perspectiva:

- **4 KB** = 4.096 bytes
- Un microcontrolador típico (STM32) tiene 64-256 KB de RAM total
- Zephyr puede ocupar desde 4 KB hasta varios MB, dependiendo de qué features se habilitan
- 4 KB es el kernel mínimo nuclo — sin drivers, sin filesystem, sin networking

### No confundir con Linux embebido

Zephyr NO es Linux. Linux embebido requiere típicamente 256 MB a 2 GB de RAM. Zephyr llena el gap para dispositivos que no pueden correr ni siquiera Buildroot.

### Diferencia con FreeRTOS

FreeRTOS es el competidor más directo de Zephyr. FreeRTOS fue creado por Amazon y tiene un modelo diferente: es más fragmentado, requiere agregar cada feature manualmente. Zephyr integra todo con una configuración unificada via Kconfig.

### Parafrasear, no recitar

Si el profesor pregunta sobre microkernel, no reciten la definición del temario. Digán: "Zephyr tiene la filosofía del microkernel — kernel mínimo, servicios afuera — pero difiere en que compila todo en una imagen. Esto es un tradeoff entre minimalismo y eficiencia."

---

## 5. ⏱️ Tiempo Estimado

| Sección                        | Tiempo                         |
| ------------------------------ | ------------------------------ |
| Apertura + contexto RTOS       | 15 segundos                    |
| Footprint de 4 KB con ejemplos | 25 segundos                    |
| Arquitectura del kernel        | 30 segundos                    |
| Cierre + conexión con MOSIX    | 15 segundos                    |
| **Total**                      | **85 segundos (~1.5 minutos)** |

**Buffer**: +20 segundos si hay preguntas sobre la diferencia entre microkernel/monolítico.

---

## 6. 💡 Tips para la Exposición

### Frases clave para memorizar

- "4 KB de RAM — caben en un microcontrolador de 50 centavos"
- "Kernel mínimo que prioriza lo esencial sobre lo accesorio"
- "Híbrido entre microkernel y monolítico — un tradeoff de diseño, no una categoría rígida"

### Posibles preguntas del profesor

| Pregunta                            | Respuesta sugerida                                                                                                                                                  |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ¿Por qué no es un microkernel puro? | Porque no hay separación de procesos. Todo compila en una imagen. El aislamiento es lógico, no de protección. Overhead de IPC en un MCU de 64 KB sería prohibitivo. |
| ¿Qué pasa si un driver falla?       | Depende de la config. En user mode, un fault no crashea el kernel. En supervisor mode, sí puede comprometer el sistema.                                             |
| ¿Cómo se compara con FreeRTOS?      | FreeRTOS es más modular pero más fragmentado. Zephyr integra todo con Kconfig unificado y tiene mejor soporte para IoT nativo (BLE, 802.15.4).                      |

### Qué NO decir

- ~~"Zephyr es exactamente un microkernel"~~ → Es un hñibrido
- ~~"4 KB es el tamaño completo"~~ → Es el mínimo, la config típica es mayor
- ~~"Zephyr compite con Linux"~~ → No, Linux requiere 256 MB mínimo

---

## 7. 📚 Fuentes para Profundizar

- [Zephyr Project Documentation — Getting Started](https://docs.zephyrproject.org/latest/develop/getting_started/index.html)
- [Zephyr at 10 — Linux Foundation Research](https://www.linuxfoundation.org/blog/zephyr-at-10-a-decade-of-open-source-embedded-innovation)
- [Wikipedia — Zephyr (operating system)](<https://en.wikipedia.org/wiki/Zephyr_(operating_system)>)

---

_Notas creadas para el TP Especial de Evaluación — Zephyr OS vs MOSIX_
_Fundamentos de Sistemas Operativos — UNMDP — Mayo 2026_
