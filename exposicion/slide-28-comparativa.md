# Slide 28 — Comparativa Técnica: Zephyr OS vs MOSIX

> **Nota:** Esta es una de las slides más importantes de la presentación. Es el cierre técnico donde se resumen todos los hallazgos. Dedicate más tiempo que a las demás.

---

## 1. 🎤 Qué Decir (Speaking Notes)

### Apertura (30 segundos)

"Esta slide es el corazón de toda la comparativa. Acá resumimos las diferencias fundamentales entre ambos sistemas. Y la conclusión más importante es simple: **no compiten entre sí**. Zephyr corre en un microcontrolador de 4KB; MOSIX administraba un cluster de cientos de nodos. Son soluciones para problemas radicalmente diferentes."

### Arquitectura (30 segundos)

"En arquitectura, tenemos dos filosofías opuestas:

- **Zephyr** usa un **kernel monolítico unificado** optimizado para footprint mínimo. Desde la versión 1.6 de 2016, el nanokernel y microkernel se fusionaron en uno solo, lo que simplificó el código sin perder modularidad. Esto conecta directamente con lo que vimos en §1.4 sobre arquitecturas de SO — no hay arquitectura 'mejor', hay arquitectura correcta para el problema.

- **MOSIX** implementaba **SSI — Single System Image**, que es un concepto donde un cluster entero se presenta como una única máquina. Cada nodo tiene su propio kernel Linux, y MOSIX opera como una capa overlay que coordina migración de procesos."

### Memoria (40 segundos — ir lento, es técnico)

"Aquí está una de las diferencias más striking:

**Zephyr** usa **MPU — Memory Protection Unit** — no MMU completa como en PCs. Esto es porque la mayoría de los microcontroladores no tienen MMU, tienen MPU que es más simple. La MPU define regiones de memoria con permisos (read/write/execute) en tiempo de compilación. Esto es similar a lo que en §4.5 vemos como 'segmentación con bounds registers', pero más limitado y estático.

**MOSIX** implementaba **Memory Ushering** — un algoritmo proactivo donde si un nodo se acerca a quedarse sin memoria, el sistema migra procesos completos a otros nodos ANTES de que ocurra OOM. Esto es conceptualmente diferente al page replacement de §5.3: en lugar de reemplazar páginas individuales dentro de la memoria de un nodo, se reemplaza el nodo completo donde corre el proceso.

Esto conecta con §4.1: administración de memoria. En Zephyr, el problema es 'cómo proteger múltiples procesos en un MCU sin MMU'. En MOSIX, el problema era 'cómo balancear memoria entre decenas de nodos'."

### Scheduling (30 segundos)

"En administración del procesador, ambos implementan scheduling distribuido pero de formas opuestas:

- **Zephyr** soporta **scheduling cooperativo, preemptive e híbrido** — configurable estáticamente en tiempo de compilación. No hay quantum clásico como en Round Robin (§2.5); en su lugar, las threads tienen prioridades fijas. El scheduler siempre elige la thread de mayor prioridad que esté lista.

- **MOSIX** usaba la **migración de procesos como forma de scheduling distribuido**. El PCB completo — contador de programa, registros, contexto de memoria, archivos abiertos — se transfería de un nodo a otro. Esto es un scheduler de largo plazo y corto plazo combinados a nivel cluster.

Según §2.1, el scheduler debe maximizar utilización de CPU y throughput. MOSIX lo hacía migrando procesos a nodos menos cargados; Zephyr lo hace asegurando que threads de alta prioridad nunca esperen."

### Filesystem (25 segundos)

"En sistemas de archivos:

- **Zephyr** tiene **VFS con tres implementaciones**: LittleFS (log-structured, wear leveling, tolerancia a power loss), FAT FS (universal, para SD cards), y NVS (key-value simple para configuración). Esto conecta con §3.6 sobre métodos de asignación: LittleFS usa log-structured que no es ninguno de los métodos clásicos pero combina ventajas; FAT usa el método FAT; NVS no tiene método de asignación tradicional.

- **MOSIX** no tenía filesystem propio — usaba **DFSA (Direct File System Access)** que interceptaba operaciones de archivos y las redirigía al nodo que posee el archivo. Conceptualmente, esto es similar al VFS de Linux (§3.1), pero operando a través de la red."

### Seguridad (25 segundos)

"En seguridad:

- **Zephyr** implementa **MPU + modo dual** con todas las protecciones que vimos en §1.5 y §1.6: modo kernel vs modo usuario, instrucciones privilegiadas, interrupciones. Además incluye PSA Crypto API, Secure Boot, y Security Subcommittee activo.

- **MOSIX** funcionaba como **módulo de kernel en modo privilegiado** — tenía acceso completo al hardware de cada nodo. Pero no tenía mecanismos de seguridad modernos: no había secure boot, no había cryptographic APIs, no había proceso de security advisories."

### Cierre (20 segundos)

"En resumen: Zephyr es un RTOS activo con 10 años de desarrollo, gobernanza neutral, y seguridad integrada. MOSIX fue un proyecto académico históricamente significativo pero abandonware desde 2017. La tabla lo muestra claro: son soluciones para problemas completamente diferentes."

---

## 2. 📌 Puntos Clave

### Zephyr OS

| Aspecto          | Punto clave                                                                 |
| ---------------- | --------------------------------------------------------------------------- |
| **Arquitectura** | Kernel monolítico unificado, footprint desde ~4KB                           |
| **Memoria**      | MPU-based protection (no MMU), sin memoria virtual en la mayoría de configs |
| **Scheduling**   | Priority-based, cooperativo/preemptive/híbrido configurable                 |
| **Filesystem**   | VFS con LittleFS + FAT + NVS — tres soluciones para tres casos              |
| **Seguridad**    | PSA Crypto, Secure Boot, MPU + modo dual, Security Committee activo         |
| **Estado**       | ✅ Producción activa (2026)                                                 |
| **Licencia**     | Apache 2.0 — open source permisivo                                          |

### MOSIX

| Aspecto          | Punto clave                                                   |
| ---------------- | ------------------------------------------------------------- |
| **Arquitectura** | SSI overlay sobre Linux — cluster como una máquina            |
| **Memoria**      | Memory Ushering — migración proactiva de procesos entre nodos |
| **Scheduling**   | Migración de PCB como scheduling distribuido                  |
| **Filesystem**   | DFSA — acceso transparente a archivos remotos                 |
| **Seguridad**    | Módulo de kernel privilegiado, sin features modernos          |
| **Estado**       | ❌ Abandonware desde octubre 2017                             |
| **Licencia**     | Propietaria restrictiva — prohíbe reverse engineering         |

---

## 3. 🔗 Relación con FSO

### §1.4 — Arquitecturas de SO

Esta comparativa es un caso de estudio vivo de §1.4:

> _"No existe la mejor arquitectura — existe la arquitectura correcta para el problema."_

| Arquitectura              | Zephyr                                    | MOSIX                 |
| ------------------------- | ----------------------------------------- | --------------------- |
| Monolítica                | ✅ Kernel unificado para footprint mínimo | ❌                    |
| SSI (Single System Image) | ❌                                        | ✅ — concepto central |
| Por capas                 | ❌                                        | ❌                    |
| Microkernel               | ⚠️ Diseño minimalista similar             | ❌                    |

MOSIX implementa un modelo SSI que no aparece explícitamente en §1.4 pero es conceptualmente cercano a "máquinas virtuales" — donde múltiples sistemas se presentan como uno. En SSI es lo inverso: múltiples físicos presentan una interfaz unificada.

### §2.1 y §2.5 — Scheduling

| Objetivo del scheduler        | Zephyr                          | MOSIX                         |
| ----------------------------- | ------------------------------- | ----------------------------- |
| Maximizar utilización CPU     | Prioridad de threads I/O-bound  | Balanceo de carga entre nodos |
| Minimizar tiempo de respuesta | Preemption por prioridad        | Migración proactiva           |
| Equidad                       | Colas multinivel (configurable) | Distribución automática       |

**Diferencia clave:** Zephyr controla scheduling estáticamente en tiempo de compilación (determinismo); MOSIX lo hacía dinámicamente basándose en carga real de cada nodo.

### §3.6 — Métodos de Asignación

| Método             | Zephyr                  | MOSIX                             |
| ------------------ | ----------------------- | --------------------------------- |
| Contiguo           | ❌                      | ❌                                |
| Enlazado           | ❌                      | ❌                                |
| FAT                | ✅ FAT FS (tarjetas SD) | ❌                                |
| I-nodos            | ❌                      | ❌                                |
| Log-structured     | ✅ LittleFS             | ❌                                |
| Sin FS tradicional | ✅ NVS                  | ✅ DFSA (no es FS, es redirector) |

MOSIX no tiene filesystem propio; DFSA es un redirector de operaciones de E/S a través de la red — esto es conceptualmente un "VFS distribuido" pero operando entre nodos, no entre FS locales.

### §4.4 y §5.3 — Memoria

**Zephyr — MPU vs MMU:**

La MPU (Memory Protection Unit) es una forma simplificada de protección de memoria que NO es paginación. A diferencia de §4.4 donde la tabla de páginas mapea páginas virtuales a frames físicos con granularidad de 4KB, la MPU:

- Define 8-16 regiones de memoria (depende del MCU)
- Cada región tiene dirección base + tamaño + permisos
- Sin traducción de direcciones (no hay memoria virtual)
- Protección estática en tiempo de compilación

**MOSIX — Memory Ushering vs Page Replacement:**

En §5.3, el algoritmo de reemplazo de páginas decide cuál página evictar cuando la memoria se llena. En MOSIX, cuando un nodo se acerca a OOM, se migra el proceso ENTERO a otro nodo con memoria disponible. Esto es conceptualmente "reemplazo de páginas" pero a nivel de proceso, no de página.

### §1.5 y §1.6 — Modo Dual e Instrucciones Privilegiadas

| Concepto                    | Zephyr                     | MOSIX                                            |
| --------------------------- | -------------------------- | ------------------------------------------------ |
| Modo kernel                 | ✅ Supervisor mode         | ✅ Kernel module                                 |
| Modo usuario                | ✅ User mode con MPU       | ⚠️ Sin separación usuario/kernel a nivel cluster |
| Instrucciones privilegiadas | ✅ Enforzadas por hardware | ✅ Solo en nodos individuales                    |

---

## 4. ⚠️ Cosas a Tener en Cuenta

### Para la Exposición

1. **Esta slide condensa TODO el TP.** Cada tema que presentamos (memoria, scheduling, filesystem, seguridad) está comparado aquí. Si el tribunal pregunta sobre cualquier aspecto técnico, referenciá esta slide.

2. **No intentes declarar un "ganador".** La conclusión es que son para mercados diferentes. Si te preguntan "¿cuál es mejor?", la respuesta es: "¿Mejor para qué?".

3. **La tabla es el resumen visual.** Los puntos que expandimos oralmente están en la tabla. La slide funciona como cheat sheet visual para el tribunal.

4. **Diferencia MPU vs MMU es importante.** Muchos estudiantes confunden ambos conceptos. MPU = protección sin traducción; MMU = protección + traducción (memoria virtual). Zephyr usa MPU porque los MCU típicamente no tienen MMU.

5. **Memory Ushering es conceptualmente diferente a page replacement.** No es "reemplazar páginas" — es "reemplazar el nodo donde corre el proceso entero". Esto es lo que lo hace diferente.

### Para Preguntas del Tribunal

| Pregunta probable                        | Respuesta corta                                                                                                                                                                  |
| ---------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "¿Por qué Zephyr no usa MMU?"            | "Los MCU target de Zephyr típicamente no tienen MMU por costo y consumo. MPU provee protección suficiente con menos overhead."                                                   |
| "¿MOSIX podría competir con Kubernetes?" | "No. MOSIX migraba procesos; Kubernetes migra containers. Los containers son más portables, eficientes, y el ecosystem es activo. MOSIX murió porque su paradigma fue superado." |
| "¿Cuál es la ventaja de VFS?"            | "Permite que la misma aplicación use LittleFS, FAT, o NVS sin cambiar código. Cambia solo el punto de montaje."                                                                  |
| "¿Por qué LittleFS usa log-structured?"  | "Wear leveling natural: todas las escrituras van al final del log, distribuyendo el desgaste uniformemente por toda la flash."                                                   |

---

## 5. ⏱️ Tiempo Estimado

| Sección             | Tiempo         |
| ------------------- | -------------- |
| Apertura y contexto | 30 segundos    |
| Arquitectura        | 30 segundos    |
| Memoria (detallado) | 40 segundos    |
| Scheduling          | 30 segundos    |
| Filesystem          | 25 segundos    |
| Seguridad           | 25 segundos    |
| Cierre y transición | 20 segundos    |
| **Total**           | **~3 minutos** |

> ⚠️ **Esta es una slide CRÍTICA.** Es la número 28 de 30, lo que significa que ya casi terminás. Si el tribunal quiere profundizar en algún tema técnico, esta es la slide a la que vuelven. No la apures.

---

## 6. 📝 Frases Clave para Usar

- _"Single System Image — el cluster se presenta como una única máquina"_
- _"MPU: protección sin traducción de direcciones"_
- _"Memory Ushering: migra el proceso antes de que se quede sin memoria"_
- _"DFSA: redirector de operaciones de archivos a través de la red"_
- _"VFS: misma API para tres implementaciones diferentes"_
- _"Diseño depende del dominio — no existe la arquitectura 'mejor'"_
