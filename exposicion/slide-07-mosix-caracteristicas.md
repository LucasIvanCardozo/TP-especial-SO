# Slide 7: MOSIX — Características Generales

## 🎤 Qué decir (Speaking Notes)

### Apertura y Concepto Central

"Esta slide presenta las características generales de MOSIX, un sistema operativo distribuido desarrollado en la Hebrew University of Jerusalem. A diferencia de Zephyr que es un RTOS para microcontroladores, MOSIX es un **sistema operativo de cluster** diseñado para supercomputadoras."

### Single System Image (SSI)

"El concepto clave de MOSIX es el **Single System Image** o imagen de sistema único. Esto significa que aunque MOSIX gestione dozens o hundreds de computadoras conectadas en red, para el usuario y para las aplicaciones **todo parece una única máquina**. No necesitás saber en qué nodo específico corre tu proceso, no tenés que hacer ssh manualmente a cada máquina. El cluster completo se ve como una supercomputadora gigante con una sola entrada."

**Analogía útil:** "Es como un restaurant donde tenés muchos cocineros en distintas estaciones, pero vos hacés un solo pedido y alguien se encarga de distribuírlo y traer tu comida sin que sepas qué cocina la preparó."

### Capa de Software sobre Linux

"MOSIX no es un sistema operativo completo desde cero. Es una **capa de software que corre sobre Linux**. Funciona como una extensión del kernel de Linux que agrega capacidades de clustering y migración de procesos. Esto tiene sus ventajas: se beneficia de todo el desarrollo de Linux, drivers, herramientas. Pero también tiene una limitación importante: está atado a la arquitectura de Linux."

### Distribución vs Centralización

"A diferencia de un servidor tradicional donde tenés un único sistema operativo controlando todo, MOSIX distribuye la carga de trabajo entre múltiples nodos. Cada nodo tiene su propio Linux, pero MOSIX coordina que trabajen como un equipo."

---

## 📌 Puntos Clave para Mencionar

| Punto                             | Descripción                                                                                                 |
| --------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| **Single System Image (SSI)**     | El cluster se presenta como una única máquina. Procesos, memoria y archivos parecen estar en un solo lugar. |
| **Sistema Operativo Distribuido** | Múltiples nodos cooperan, pero ocultan la complejidad al usuario.                                           |
| **Capa sobre Linux**              | No reinventa la rueda; extiende el kernel Linux existente con capacidades de cluster.                       |
| **Proyecto de Investigación**     | Desarrollado por el grupo del Prof. Amnon Barak en Hebrew University desde 1977.                            |
| **Origen Académico**              | Nació como proyecto de investigación, no como producto comercial.                                           |

---

## 🔗 Relación con FSO (Conexiones con la Materia)

### §1.1 — ¿Qué es un Sistema Operativo?

MOSIX cumple los dos objetivos fundamentales de un SO:

1. **Máquina extendida:** En lugar de ocultar complejidad de hardware heterogéneo (como Zephyr), MOSIX oculta la complejidad de múltiples computadoras. Para el programador, programar en un cluster MOSIX es similar a programar en una sola máquina.

2. **Gestor de recursos:** MOSIX administra recursos distribuidos: CPU, memoria y red de múltiples nodos. Decide dinámicamente dónde ejecutar cada proceso basándose en disponibilidad y carga.

### §1.4 — Arquitecturas de SO

MOSIX representa una arquitectura **híbrida o de extensión de kernel**:

- **No es monolítico puro:** No es un kernel que corre solo en una máquina.
- **No es microkernel:** No tiene servicios en espacio de usuario distribuidos como un microkernel clásico.
- **Es una extensión de kernel Linux:** Opera como un módulo o overlay sobre el kernel de cada nodo.

Esta categoría no aparece explícitamente en el temario, pero MOSIX la ejemplifica.

### §2.1 — Scheduling y Multiprogramación

MOSIX implementa un **scheduling distribuido** donde:

- La decisión de dónde correr un proceso se toma a nivel de cluster
- El scheduler considera CPU disponible, memoria libre y velocidad de red
- Los procesos pueden **migrar** entre nodos durante ejecución

Esto extiende el concepto de scheduling de §2 a múltiples máquinas.

### §4.1 — Administración de Memoria

MOSIX tiene un modelo de **memoria distribuida shared-nothing**:

- Cada nodo tiene su propia RAM local
- **No hay memoria compartida entre nodos** (a diferencia de sistemas NUMA)
- La migración de procesos implica transferir el estado de memoria entre nodos
- Incluye "Memory Ushering" para mover proactivamente procesos antes de OOM

### §1.5 — Modo Dual de Operación

MOSIX opera en modo kernel de Linux para manipular el estado de procesos durante la migración. Las decisiones de scheduling y migración requieren acceso privilegiado a estructuras del kernel.

---

## ⚠️ Cosas a Tener en Cuenta

### Contraste Explícito con Zephyr

| Aspecto      | Zephyr OS                | MOSIX                       |
| ------------ | ------------------------ | --------------------------- |
| **Target**   | Microcontroladores (MCU) | Clusters HPC                |
| **Escala**   | 4KB - 256KB RAM          | Clusters de 64+ nodos       |
| **Modelo**   | RTOS embebido            | Sistema distribuido         |
| **Memoria**  | Local, protegida por MPU | Distribuida, shared-nothing |
| **Licencia** | Apache 2.0 (open source) | Propietaria restrictiva     |
| **Estado**   | Activo (2026)            | Inactivo desde 2017         |

**No compiten entre sí.** Son soluciones para problemas completamente diferentes.

### Explicar SSI Claramente

SSI puede sonar abstracto. Algunos puntos para hacerlo concreto:

- SSI significa que `ps` muestra procesos de todos los nodos
- SSI significa que no necesitás saber qué nodo tiene qué archivo
- SSI significa que si un nodo se cae, MOSIX puede migrar tus procesos automáticamente

### Precisión Histórica

- MOSIX comenzó en **1977** en PDP-11
- La versión Linux llegó en **1998**
- Se volvió propietario en **2001**
- Último release: **MOSIX-4.4.4** (24 de octubre de **2017**)

### Advertencia sobre Estado

Esta slide es de **2017 en adelante** — el proyecto está inactivo. Si preguntan sobre uso actual, hay que aclarar que **no se recomienda para producción moderna** porque no hay soporte ni actualizaciones de seguridad.

---

## ⏱️ Tiempo Estimado

**60-90 segundos** (~1 minuto)

| Segmento                                 | Tiempo |
| ---------------------------------------- | ------ |
| Introducción a MOSIX                     | 15 seg |
| Explicación de SSI (Single System Image) | 25 seg |
| Capa sobre Linux                         | 15 seg |
| Contraste con Zephyr                     | 15 seg |
| Transición a siguiente slide             | 10 seg |

---

## 🎯 Frase de Cierre Sugerida

"Si Zephyr es un gigante que corre en un microcontrolador, MOSIX es un enjambre de hormigas que trabajan juntas pero parecen una sola. Ambos son sistemas operativos, pero operan en escalas y解决的问题 completamente opuestas."

---

## 📚 Fuentes para Profundizar (Si Preguntan)

- MOSIX Official: http://www.mosix.org/
- Hebrew University MOSIX History: https://mosix.cs.huji.ac.il/txt_history.html
- Prof. Amnon Barak: https://www.cs.huji.ac.il/~amnon

---

_Notas de presentación para Slide 7 — MOSIX Características Generales_
_TP Especial: Zephyr OS vs MOSIX_
_Fundamentos de Sistemas Operativos — UNMDP_
