# Slide 1 — Portada

---

## 🎤 Qué decir

"Buenas a todos. Somos el grupo [nombres]. Hoy vamos a presentar nuestro Trabajo Práctico Especial de Evaluación, donde vamos a comparar dos sistemas operativos que no pueden ser más distintos entre sí: **Zephyr OS** y **MOSIX**."

Pausa breve, dejar que el público lea el título.

"Son productos de categorías completamente distintas — los vamos a comparar bajo la misma lupa de Fundamentos de Sistemas Operativos para ver qué decisiones de diseño tomó cada uno, cómo resuelven los mismos problemas fundamentales de un SO, y qué nos dice esto sobre la materia."

---

## 📌 Puntos Clave

- **Zephyr OS** es un RTOS open source para microcontroladores IoT, creado en 2016 bajo Linux Foundation. Footprint mínimo: ~4 KB.
- **MOSIX** es un sistema operativo de cluster para HPC, nacido en 1977 en la Hebrew University of Jerusalem. Proyecto **inactivo desde 2017**.
- La comparación no es fair-play: compiten en segmentos radicalmente diferentes. Esto es parte del análisis.
- La presentación cubre §1 a §5 del temario: introducción, scheduling, archivos, memoria y memoria virtual.

---

## 🔗 Relación con FSO

Esta portada encarna los dos objetivos de un SO (§1.1):

| Objetivo | Zephyr OS | MOSIX |
|---------|-----------|-------|
| **Máquina extendida** | Oculta complejidad de hardware heterogéneo de MCUs tras API unificada | Cluster aparece como una única máquina (SSI) |
| **Gestor de recursos** | Administra CPU/memoria restringida de microcontroladores | Migra procesos dinámicamente entre nodos del cluster |

También introduce el concepto de **arquitecturas de SO** (§1.4): Zephyr usa arquitectura microkernel; MOSIX opera como extensión/overlay sobre Linux.

---

## ⚠️ Cosas a tener en cuenta

- **No se emocionen con la diferencia "uno es activo, el otro inactivo" todavía** — eso viene después. Ahora solo planten el paralelo.
- Si el tribunal pregunta por qué comparar productos tan distintos, la respuesta es: "Porque la comparación nos obliga a entender los fundamentos sin el sesgo de un 'ganador obvio'."
- Presentación grupal: si hay más de un presentador, aclaren quién habla en cada slide. En la portada, uno solo presenta el equipo.
- **Timing**: No se extending demasiado en la intro. 45-60 segundos máximo. El tribunal quiere llegar al contenido técnico.

---

## ⏱️ Tiempo estimado

**45-60 segundos**

---

## 🗣️ Notas para práctica

Frase clave para memorizar:

> "Comparamos un RTOS de 4 KB que corre en microcontroladores con un sistema de cluster que administraba supercomputadoras. A pesar de sus diferencias, ambos son sistemas operativos que deben resolver los mismos problemas fundamentales."

