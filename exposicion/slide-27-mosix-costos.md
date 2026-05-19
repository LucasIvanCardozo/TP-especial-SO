# Slide 27 — MOSIX Costos: Notas de Exposición

## 🎤 Qué Decir (Speaking Notes)

**Entrada**: "Volvemos a MOSIX, ahora para hablar de costos. Y acá hay que ser muy claros."

**Desarrollo principal**:

- MOSIX tuvo un modelo de **licencia propietaria restrictiva**. A diferencia de Zephyr con Apache 2.0, MOSIX prohibía explícitamente la modificación del código, el reverse engineering y la creación de derivados.
- El pricing histórico documentado era de aproximadamente **61.000 dólares estadounidenses** por licencia inicial, más un mantenimiento anual de casi 17.000 dólares.
- Esta combinación — código cerrado más precio alto más mantenimiento exclusivo del vendor — es el modelo tradicional de software empresarial de los '90s y 2000s.

**Cierre con advertencia**:

- "Pero el problema más grave no es el precio. El problema es que **MOSIX está inactivo desde octubre de 2017**. Esto significa: sin actualizaciones de seguridad, sin soporte, sin evolución."
- "Un sistema operativo sin parches de seguridad desde 2017 tiene cientos de vulnerabilidades conocidas. **No se recomienda para producción en ningún escenario**."

---

## 📌 Puntos Clave

| Aspecto                | MOSIX                                                                          |
| ---------------------- | ------------------------------------------------------------------------------ |
| **Modelo de licencia** | Propietaria restrictiva (prohíbe modificación, reverse engineering, derivados) |
| **Costo histórico**    | ~$61.141 USD inicial + ~$16.835 USD/año mantenimiento                          |
| **Mantenimiento**      | Solo por Hebrew University de Jerusalem                                        |
| **Estado actual**      | ❌ INACTIVO desde octubre 2017                                                 |

### Comparación rápida con Zephyr

| Aspecto            | Zephyr OS                            | MOSIX                   |
| ------------------ | ------------------------------------ | ----------------------- |
| **Licencia**       | Apache 2.0 (permisiva, sin regalías) | Propietaria restrictiva |
| **Costo**          | $0 (gratis)                          | $61.141 + $16.835/año   |
| **Modificaciones** | Permitidas y esperadas               | Prohibidas              |
| **Comunidad**      | 3.000+ contribuyentes activos        | Proyecto abandonado     |
| **Producción**     | ✅ Recomendado                       | ❌ NO RECOMENDADO       |

---

## 🔗 Relación con FSO

### §1.4 — Arquitecturas de SO

La diferencia de licensing refleja dos filosofías de desarrollo de software:

- **Software propietario** (§1.4, modelo tradicional): El código es propiedad de la empresa, nadie außer el vendor puede modificarlo o corregirlo. Cuando el vendor abandona el proyecto, el software muere.

- **Open source** (§1.4, modelo moderno): Código libre. Zephyr usa Apache 2.0 que permite modificación sin obligación de devolver cambios. Esta permisividad atrajo contribuyentes que mantienen el proyecto vivo.

El contraste ilustra por qué la licencia importa en un SO: determina si el proyecto sobrevive a sus creadores originales.

### §1.1 — Objetivos de un SO

Recordá que un SO debe ser tanto "máquina extendida" como "gestor de recursos". MOSIX cumplía ambos roles en clusters HPC, pero su modelo de negocio hizo que muriera cuando dejó de ser rentable. Zephyr, con comunidad abierta, sobrevive porque hay múltiples empresas incentivadas a mantenerlo.

---

## ⚠️ Cosas a Tener en Cuenta

### ⚠️ ALERTA PRINCIPAL

```
PROYECTO INACTIVO DESDE OCTUBRE 2017
NO RECOMENDADO PARA PRODUCCIÓN
```

### Implicaciones concretas

1. **Seguridad**: Vulnerabilidades descubiertas desde 2017 nunca fueron parcheadas. Un sistema en producción sería un objetivo fácil.

2. **Compatibilidad**: No hay soporte para hardware nuevo (CPUs, redes, sistemas de almacenamiento). Los clusters HPC modernos usan InfiniBand, y el soporte de MOSIX está冻结ado en 2017.

3. **Comunidad**: No hay forum activo, no hay documentación actualizada, no hay nadie respondiendo dudas.

4. **Alternativas superiores**: SLURM, Kubernetes, y MPI moderno ofrecen mejor funcionalidad con soporte activo.

### Contexto histórico

MOSIX fue innovador en su momento — migración de procesos transparente en 1990 era tecnología de punta. Pero el paradigma de modificar el kernel Linux directamente fue superado por contenedores y orquestadores que operan a nivel de aplicación, no de kernel.

---

## ⏱️ Tiempo Estimado

**Duración sugerida**: 30-45 segundos

### Desglose

| Parte                                 | Tiempo             |
| ------------------------------------- | ------------------ |
| Introducción al modelo de licencia    | 10 segundos        |
| Precio histórico (61k + 17k/año)      | 5 segundos         |
| Advertencia de inactividad desde 2017 | 10 segundos        |
| Cierre con recomendación clara        | 5-10 segundos      |
| **Total**                             | **30-45 segundos** |

### Tips para la presentación

- **No dediques mucho tiempo** a MOSIX — es un proyecto muerto.
- **Enfatizá la advertencia** con tono firme pero académico.
- **Compará brevemente con Zephyr** para reforzar el contraste.
- Si alguien pregunta sobre alternativas HPC, mencioná SLURM y Kubernetes como referencia.

---

## 📚 Glosario Rápido

| Término                              | Definición                                                                                |
| ------------------------------------ | ----------------------------------------------------------------------------------------- |
| **Licencia propietaria restrictiva** | Software cuyo código no puede ser modificado, analizado ni derivado sin permiso del owner |
| **Reverse engineering**              | Análisis del funcionamiento interno del software para entenderlo o replicarlo             |
| **HPC**                              | High Performance Computing — computación de alto rendimiento en clusters                  |
| **Migración de procesos**            | Movimiento de un proceso en ejecución de un nodo a otro                                   |

---

## ❓ Preguntas Probables

**P: ¿Por qué alguien elegiría pagar 61k por MOSIX en vez de algo gratis como Zephyr?**

R: No compiten en el mismo mercado. MOSIX era para clusters HPC de alto rendimiento donde 61k es irrelevante comparado con el costo del hardware (millones de dólares). Zephyr es para microcontroladores IoT donde el costo del software debe ser mínimo.

**P: ¿Hay algún caso de uso donde MOSIX sea aún viable?**

R: No para producción. Solo para investigación académica sobre migración de procesos a nivel kernel. Even then, alternativas como LinuxPMI (también discontinuado) ofrecen más código estudiable.
