# Slide 05 — MOSIX: La Empresa

> **Nota**: Esta slide en el PPTX es "MOSIX — La Empresa", pero el archivo de explicación `slide-05-explicacion.md` corresponde a Zephyr (coincide con la slide 6 del PPTX). El contenido de esta nota se basa en la investigación general del proyecto MOSIX disponible en el contexto del TP.

---

## 1. 🎤 Qué decir (Speaking Notes)

**Duración estimada: 45-60 segundos**

---

**[Comenzar señalando el contraste visual]**

"Mientras Zephyr es un proyecto corporativo con soporte de la Linux Foundation, **MOSIX tiene un origen completamente académico**. A diferencia de lo que vimos con Zephyr, MOSIX no nació en una empresa ni fue impulsado por una fundación. Nació en un laboratorio universitario."

**[Señalar la línea de tiempo del PPTX]**

"MOSIX fue desarrollado por el **Grupo de Investigación en Sistemas Distribuidos** de la **Hebrew University of Jerusalem**, en Israel. El líder de este proyecto fue el **Profesor Amnon Barak**, quien memimpin el desarrollo desde los años 70 hasta la última versión oficial en 2017."

**[Destacar la naturaleza de investigación]**

"Es importante entender que MOSIX fue siempre un **proyecto de investigación académica**. No fue diseñado para ser vendido como producto comercial, sino para estudiar y demostrar conceptos de sistemas operativos distribuidos, especialmente la **migración preemptiva de procesos** — mover procesos entre computadoras de un cluster sin que el usuario lo note."

---

## 2. 📌 Puntos Clave

### Origen académico (no comercial)

- **Universidad**: Hebrew University of Jerusalem, Israel
- **Grupo**: Distributed Systems Research Group
- **Líder académico**: Prof. Amnon Barak
- **Motivación**: Investigación en sistemas operativos distribuidos, migración de procesos
- **Financiamiento**: Financiamiento universitario y de investigación (no capital de riesgo ni corporativo)

### Línea de tiempo resumida

| Período         | Evento                                                               |
| --------------- | -------------------------------------------------------------------- |
| 1977-1979       | MOS (Version 0) — primeros experimentos en PDP-11                    |
| 1981-1983       | MOS (Version 1) — primer sistema multicomputadora funcional          |
| 1988-1989       | **MOSIX** — primer sistema con el nombre actual, cluster de 16 nodos |
| 1998-1999       | MOSIX v7 — primera versión sobre Linux, cluster de 64 nodos          |
| 2001            | **Se cierra el código** — MOSIX se vuelve propietario                |
| 2002            | Moshe Bar crea **openMosix** como fork open source                   |
| 2014            | MOSIX-4 — ya no requiere parche de kernel (funciona como módulo)     |
| **24 Oct 2017** | **MOSIX-4.4.4** — último release oficial                             |
| Post-2017       | Proyecto **inactivo** — sin actualizaciones                          |

### openMosix como contexto

- Cuando MOSIX se volvió propietario en 2001, **Moshe Bar** decidió crear **openMosix** como fork open source bajo GPL
- openMosix fue discontinued en 2008
- LinuxPMI continuó el desarrollo post-2008, también discontinuado
- Esto muestra que MOSIX tenía tracción comunitaria que se perdió

---

## 3. 🔗 Relación con FSO

### §1.4 — Arquitecturas de SO

MOSIX opera como una **extensión de kernel Linux** (overlay), no como un SO independiente:

- Funciona como un **módulo de kernel** que extiende Linux (desde 2014)
- Antes requería parches al kernel de Linux
- Esto lo posiciona como una arquitectura **híbrida**: extiende el kernel existente en lugar de reemplazarlo

**Pregunta que puede surgir en la defensa**: ¿MOSIX es un sistema operativo nuevo o es Linux?

- **Respuesta**: Es Linux con una capa adicional que implementa migración de procesos a nivel kernel
- No es un kernel nuevo, no tiene sus propios drivers ni filesystem
- Se parece más a una "capa de virtualización" sobre Linux

### §2.1 y §2.3 — Scheduling y Procesos Distribuidos

MOSIX es el ejemplo clásico de **scheduling distribuido**:

- El scheduler de cada nodo puede **migrar un proceso** a otro nodo
- Cada nodo tiene su propio **PCB (Process Control Block)**
- Cuando un proceso migra, su PCB se transfiere al nodo destino
- Concepto de "Single System Image (SSI)": el cluster entero aparece como una única máquina

### §1.3 — Multiprocesamiento vs Sistemas Distribuidos

MOSIX no es multiprocesamiento (múltiples CPUs compartida) sino **sistemas distribuidos**:

- Cada nodo tiene su propia CPU, memoria y disco
- Comunicación via red (Ethernet, InfiniBand)
- Memoria **NO compartida** entre nodos (modelo shared-nothing)
- Esto contrasta con SMP donde múltiples CPUs comparten memoria

---

## 4. ⚠️ Cosas a Tener en Cuenta

### Contraste con Zephyr (importante para la comparativa)

| Aspecto             | Zephyr                                     | MOSIX                                |
| ------------------- | ------------------------------------------ | ------------------------------------ |
| **Tipo de entidad** | Proyecto open source bajo Linux Foundation | Proyecto de investigación académica  |
| **Comercial**       | Sí — usado en productos comerciales        | No — nunca fue un producto comercial |
| **Financiamiento**  | Miembros corporativos (Qualcomm, VW, etc.) | Financiamiento universitario/grants  |
| **Estado actual**   | **Activo** — desarrollo continuo           | **Inactivo** desde 2017              |
| **Comunidad**       | >3,000 contribuyentes, comunidad activa    | Sin comunidad desde 2017             |

### Para la defensa: Por qué importa este contraste

- Zephyr demuestra cómo un proyecto open source puede construirse sobre una fundación neutral
- MOSIX demuestra que investigación académica brillante no garantiza viabilidad comercial
- La diferencia de soporte explica por qué Zephyr tiene 1,000+ boards y MOSIX tiene 0% de adopción en Top500

### Datos curiosos que pueden impresionar al docente

- El proyecto tiene **más de 40 años** de historia (1977-2017)
- La primera versión corría en **PDP-11**, una computadora de los años 70 con 8 KB de RAM
- El sitio web `mosix.org` **sigue funcionando** aunque no hay actualizaciones desde 2017
- En su momento fue considerado para supercomputadoras reales (Top500)

---

## 5. ⏱️ Tiempo Estimado

| Sección                                   | Tiempo           |
| ----------------------------------------- | ---------------- |
| Introducción al origen académico          | 15 segundos      |
| Línea de tiempo y contexto histórico      | 20 segundos      |
| Relación con FSO y tipos de arquitecturas | 15 segundos      |
| **Total**                                 | **~50 segundos** |

---

## 6. 📝 Notas para Práctica

### Frase de apertura sugerida

> "A diferencia de Zephyr, que tiene respaldo corporativo de la Linux Foundation, MOSIX nació y creció en un ámbito puramente académico: el laboratorio del Profesor Amnon Barak en la Hebrew University of Jerusalem."

### Cierre sugerido para esta slide

> "Durante casi 40 años, MOSIX fue un referente de investigación en sistemas distribuidos. Sin embargo, como veremos más adelante, su naturaleza académica y posterior inactividad lo convierten en un caso de estudio más que en una recomendación práctica."

### Pregunta preparada para la defensa

> "¿Por qué un proyecto de investigación tan importante quedó inactivo? La respuesta tiene que ver con la competencia de tecnologías como Kubernetes y contenedores, que ofrecen capacidades similares con mayor flexibilidad y soporte comercial moderno."

---

## 7. 📚 Fuentes y Referencias

- [MOSIX Official Site](http://www.mosix.org/)
- [MOSIX History — Hebrew University](https://mosix.cs.huji.ac.il/txt_history.html)
- [Prof. Amnon Barak — HUJI](https://www.cs.huji.ac.il/~amnon)
- [Wikipedia — MOSIX](https://en.wikipedia.org/wiki/MOSIX)

---

_Nota de presentación preparada para el TP Especial de Fundamentos de Sistemas Operativos — Universidad Nacional de Mar del Plata_
