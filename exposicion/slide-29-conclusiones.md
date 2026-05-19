# 🎤 Notas de Exposición — Slide 29: Conclusiones y Recomendaciones

## 1. 🎤 Qué decir (Speaking Notes)

**Entrada** (primeros 15 segundos):

> "Para cerrar esta presentación, queremos dejarles los aprendizajes clave y nuestras recomendaciones finales sobre estos dos productos."

**Desarrollo** (45-60 segundos):

"Esta comparativa nos enseñó algo fundamental: **no existe el mejor sistema operativo en abstracto**. Todo depende del contexto, de los constraints de hardware, y del problema que necesitás resolver.

**Zephyr OS** demostró cómo diseñar un SO moderno para el mundo IoT: con apenas 4 KB de footprint, soporta más de mil placas diferentes, tiene una comunidad de tres mil contribuyentes activos, y está siendo usado por empresas como Oticon en audífonos inteligentes, Vestas en turbinas eólicas, y hasta en notebooks modulares. Es un proyecto vivo, con gobernanza abierta bajo la Linux Foundation, y con soporte LTS corporativo.

**MOSIX**, por otro lado, nos mostró la historia de un proyecto de investigación ambicioso que nació en 1977 en Jerusalén. Su concepto de Single System Image y migración transparente de procesos fue revolucionario para su época. Pero el mundo cambió: Kubernetes, contenedores, y orquestadores modernos dejaron atrás el paradigma de migración a nivel kernel. El proyecto está inactivo desde 2017, y no recomendamos su uso en producción.

**La conclusión práctica**: si estás diseñando un producto IoT embebido, Zephyr es una opción seria a considerar. Si necesitás computación distribuida en clusters HPC, las herramientas actuales como SLURM o Kubernetes son el camino."

**Cierre** (10 segundos):

> "Gracias por la atención. Abrimos el turno de preguntas."

---

## 2. 📌 Puntos Clave

| Punto                             | Detalle                                                                                                              |
| --------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| **1. No hay "mejor SO"**          | Todo depende del contexto y los constraints                                                                          |
| **2. Zephyr = IoT activo**        | RTOS open source, 4KB–MB footprint, 1000+ boards, 3000+ contribuyentes, uso comercial real                           |
| **3. MOSIX = historia académica** | Proyecto de investigación 1977-2017, abandonado, relevancia histórica pero no productiva                             |
| **4. Filosofías opuestas**        | Zephyr optimiza para latencia y determinismo en MCU; MOSIX optimizaba para throughput en clusters                    |
| **5. Lecciones de FSO**           | Cada concepto del temario (scheduling, memoria, archivos) tiene implementación concreta y diferente en cada producto |

---

## 3. 🔗 Relación con FSO

Esta slide sintetiza cómo los conceptos teóricos del temario se manifiestan en sistemas reales:

| Concepto FSO (§)        | En Zephyr                                | En MOSIX                                      |
| ----------------------- | ---------------------------------------- | --------------------------------------------- |
| **§1.4 — Arquitectura** | Kernel monolítico unificado configurable | Overlay/SSI sobre Linux                       |
| **§2.5 — Scheduling**   | Preemptive + cooperative (configurable)  | Migración preemptiva entre nodos              |
| **§3.6 — Archivos**     | LittleFS (wear leveling), FAT, NVS       | DFSA (acceso transparente a archivos remotos) |
| **§4.4 — Memoria**      | MPU-based protection, demand paging      | Shared-nothing, Memory Ushering               |
| **§5.6 — Thrashing**    | No aplica (sin swap en MCU)              | Memory Ushering como prevención proactiva     |

**Mensaje para la comisión**: Los temas del temario no son abstractos. Cada decisión de diseño en Zephyr y MOSIX responde a los mismos principios que estudiaron: cómo administrar CPU, memoria, y almacenamiento cuando los recursos son extremadamente limitados (Zephyr) o distribuidos (MOSIX).

---

## 4. ⚠️ Cosas a Tener en Cuenta

### Para vos como expositor:

- **No digas "Zephyr es mejor que MOSIX"** — eso sería como comparar un auto de carrera con un camión de mudanzas. Son productos para problemas completamente diferentes.
- **Resalta la vigencia de Zephyr** — mencioná al menos 2-3 casos de uso comerciales reales (Oticon More, Vestas, Framework Laptop).
- **Sé honesto sobre MOSIX** — no lo descartes bruscamente. Decí que fue un proyecto de investigación valioso que anticipation concepts que hoy usan Kubernetes y SLURM.
- **Conectar con el temario es tu punto extra** — si un docente pregunta qué aprendimos, la respuesta es: cómo los conceptos teóricos de scheduling, memoria y archivos se traducen en decisiones concretas de diseño.

### Para el momento de preguntas:

- Si preguntan "cuál usarían ustedes", la respuesta correcta es: **Zephyr para IoT embebido, y para HPC moderno directamente Kubernetes/SLURM** — MOSIX no está recomendado para producción.
- Si preguntan sobre diferencias técnicas específicas, remití a las slides anteriores (comparativa técnica slide 28).
- Si preguntan sobre la investigación, mencioná que se usó documentación oficial, Wikipedia para contexto histórico, y Linux Foundation Research para datos de adopción.

---

## 5. ⏱️ Tiempo Estimado

| Sección                             | Tiempo | Acumulado |
| ----------------------------------- | ------ | --------- |
| Entrada + presentación del tema     | 15 seg | 0:15      |
| Desarrollo - mensaje central        | 30 seg | 0:45      |
| Zephyr - resumen de fortalezas      | 15 seg | 1:00      |
| MOSIX - contexto histórico + estado | 15 seg | 1:15      |
| Conclusión práctica + recomendación | 15 seg | 1:30      |
| Cierre + transición a preguntas     | 10 seg | 1:40      |

**Total recomendado**: 1:30 – 2:00 minutos

**Nota**: Esta es una de las slides más importantes de toda la presentación. Es lo que la comisión recuerda al final. No la subestimes.

---

## 📋 Checklist de Preparación

- [ ] Tenés 2-3 ejemplos comerciales de Zephyr en la punta de la lengua
- [ ] Podés explicar en una frase por qué MOSIX está abandonado
- [ ] Tenés lista la comparativa con Kubernetes/SLURM por si preguntan
- [ ] Estás preparado para decir qué herramientas usarían Uds. para cada caso

---

_Material de exposición preparado para el TP Especial: Zephyr OS vs MOSIX_
_Fundamentos de Sistemas Operativos — UNMDP — Mayo 2026_
