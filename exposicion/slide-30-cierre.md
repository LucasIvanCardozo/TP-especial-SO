# Slide 30 — Cierre

## 🎤 Qué decir (Speaking Notes)

### Apertura (5 segundos)

> "¡Muchas gracias por su atención! Con esto llegamos al final de nuestra presentación."

### Cierre principal (15 segundos)

> "A lo largo de este trabajo comparamos dos sistemas operativos de categorías radicalmente diferentes: **Zephyr OS**, un RTOS moderno para IoT y sistemas embebidos con apenas ~4 KB de footprint; y **MOSIX**, un proyecto de cluster HPC que, si bien fue históricamente significativo, lleva inactivo desde 2017."

> "Quisimos mostrar cómo los conceptos que vemos en Fundamentos de Sistemas Operativos — scheduling, memoria, archivos, seguridad — se aplican de formas completamente distintas según el contexto y las constraints del sistema."

### Apertura a preguntas (5 segundos)

> "¿Tienen alguna pregunta? Estamos abiertos a consultas sobre cualquier aspecto de la comparación o de los conceptos de la materia."

---

## 📌 Puntos Clave para Recomendar

### Fuentes oficiales de Zephyr OS

- **Web oficial**: https://zephyrproject.org
- **Documentación**: https://docs.zephyrproject.org
- **GitHub**: https://github.com/zephyrproject-rtos/zephyr
- **Governing Board**: Miembros como Qualcomm, Intel, Wind River, Renesas

### Fuentes de MOSIX (contexto histórico)

- **Web oficial**: http://www.mosix.org (inactiva desde 2017)
- **Historia académica**: mosix.cs.huji.ac.il/txt_history.html (Hebrew University)
- **Artículos de investigación**: Papers del Prof. Amnon Barak sobre migración de procesos

### Fuentes de verificación

- **Wikipedia**: Zephyr (operating system), MOSIX
- **Linux Foundation Research**: "Zephyr Turns 10" (marzo 2026)
- **Top500 Supercomputers**: Para contexto de clusters HPC modernos

---

## 🔗 Relación con el Temario FSO

Esta presentación integró conceptos de **todos los temas del temario**:

| Tema                     | Conceptos aplicados                                                                                                 |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------- |
| **§1 — Introducción**    | Arquitectura de SO (monolítico vs microkernel), modo dual kernel/usuario, instrucciones privilegiadas, system calls |
| **§2 — Procesador**      | Scheduling (priority-based en Zephyr, migración preemptiva en MOSIX), PCB, estados de proceso, quantum              |
| **§3 — Archivos**        | VFS, LittleFS (log-structured), FAT, NVS, métodos de asignación, directorios                                        |
| **§4 — Memoria**         | MPU vs MMU, paginación, memoria distribuida, Memory Ushering                                                        |
| **§5 — Memoria Virtual** | Page faults en contexto de migración, thrashing, working set                                                        |

### Conceptos transversales destacados

- **Migración de procesos**: Aplica scheduling distribuido y administración de memoria en un solo concepto
- **Single System Image (SSI)**: Ilustra cómo múltiples máquinas pueden verse como una sola
- **Trade-offs de diseño**: Cada decisión arquitectural (RTOS minimalista vs cluster HPC) refleja constraints diferentes

---

## ⚠️ Cosas a Tener en Cuenta (Preparación para Q&A)

### Preguntas probables sobre Zephyr OS

1. **"¿Por qué elegir Zephyr y no FreeRTOS?"**
   - Respuesta: Zephyr tiene governance formal (Linux Foundation), soporte LTS, 1000+ boards vs ~40 de FreeRTOS, licencia Apache 2.0 vs MIT, comunidad más activa

2. **"¿Zephyr es realmente un microkernel?"**
   - Respuesta: Es un kernel monolítico unificado (desde v1.6) pero con footprint mínimo tipo microkernel. La documentación lo llama "monolítico" pero su diseño es minimalista

3. **"¿Qué pasa si el watchdog timer vence?"**
   - Respuesta: Zephyr soporta watchdog timer que resetea el sistema si hay deadlock o crash

### Preguntas probables sobre MOSIX

1. **"¿MOSIX compite con Kubernetes?"**
   - Respuesta: No directamente. MOSIX migraba procesos a nivel de SO; Kubernetes orquesta contenedores. Son soluciones de diferentes eras para problemas parcialmente superpuestos

2. **"¿Por qué murió MOSIX?"**
   - Respuesta: Múltiples factores: licenciamiento propietario desde 2001 que mató el fork openMosix, la complejidad de mantener parches de kernel, el surgimiento de contenedores como solución más flexible, y la falta de soporte comercial

3. **"¿Se podría revivir MOSIX?"**
   - Respuesta: Teóricamente sí, pero requeriría reescribirlo como módulo moderno (tipo eBPF) y tendría que competir con SLURM, PBS, Kubernetes que ya dominan el mercado HPC

### Preguntas sobre conceptos de FSO

1. **"¿Cómo aplica el Memory Ushering si no hay memoria compartida entre nodos?"**
   - Respuesta: Cada nodo tiene su propia RAM local (modelo shared-nothing). El "ushering" migra todo el proceso a otro nodo antes de que se agote la memoria local, no comparte memoria

2. **"¿LittleFS es paginación?"**
   - Respuesta: No exactamente. Es log-structured con garbage collection y wear leveling. No hay tables de páginas ni swapping a disco. Opera directamente sobre flash

3. **"¿DFSA usa system calls interceptadas?"**
   - Respuesta: Sí, a nivel de kernel intercepta las syscalls de archivos y redirige al nodo que posee el archivo. Por eso requiere módulo de kernel privilegiado

---

## ⏱️ Tiempo Estimado

| Sección              | Tiempo           |
| -------------------- | ---------------- |
| Agradecimiento       | 5 segundos       |
| Resumen final        | 15 segundos      |
| Apertura a preguntas | 5 segundos       |
| **Total slide 30**   | **~25 segundos** |

| Actividad              | Tiempo                  |
| ---------------------- | ----------------------- |
| Q&A (si hay preguntas) | Variable (5-15 minutos) |

---

## 📋 Checklist Pre-Preguntas

- [ ] Verificar que todos los integrantes estén presentes para responder
- [ ] Tener a mano los links de documentación oficial
- [ ] Si no saben una respuesta, ofrecer buscarlo después y responder por mail
- [ ] Recordar que la nota depende de la presentación, no solo del contenido escrito

---

## 🎯 Mensaje Final para Llevar

> "Lo más importante que quisimos transmitir es que **no existe el mejor sistema operativo en abstracto** — existe el sistema operativo adecuado para un problema específico. Zephyr resuelve IoT y embebidos; MOSIX resolvió clusters HPC de su era. Los conceptos de FSO son la base para entender por qué cada uno toma las decisiones que toma."

---

_Notas de exposición para Slide 30 — Cierre_
_TP Especial: Zephyr OS vs MOSIX_
_Fundamentos de Sistemas Operativos — UNMDP_
_Mayo 2026_
