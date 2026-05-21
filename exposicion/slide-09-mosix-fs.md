# Slide 09 — MOSIX: Sistema de Archivos

> **Notas para la exposición oral — Tiempo estimado: 60-90 segundos**

---

## 🎤 Qué decir (Speaking Notes)

### Apertura

"Ahora veamos cómo MOSIX maneja los archivos. A diferencia de Zephyr que tiene sus propios file systems optimizados para flash embebida, MOSIX opera en un cluster donde los datos están distribuidos en múltiples máquinas. ¿Cómo hace entonces para que un proceso pueda acceder archivos sin saber dónde están físicamente?"

### El problema que resuelve DFSA

"Cuando un proceso migra de un nodo a otro por balanceo de carga, necesita seguir usando sus archivos abiertos. Imaginen que el proceso se inició en el Nodo A donde tiene sus datos, pero luego MOSIX lo migra al Nodo B para balancear la carga. Si el proceso quiere leer `/home/datos/experimento.dat`, ese archivo está en el disco del Nodo A, no del B."

### Cómo funciona la interceptación

"DFSA — Direct File System Access — intercepta cada syscall de archivo antes de que llegue al sistema de archivos local. Si el archivo está en otro nodo, DFSA redirige la operación por red. Todo esto es transparente para la aplicación: el proceso cree que está leyendo de manera local, pero en realidad los datos cruzan la red."

### Los FS subyacentes

"Importante destacar: MOSIX no inventa un filesystem nuevo. Cada nodo usa ext4, XFS, o lo que tenga configurado. DFSA simplemente se interpone encima. Esto es pragmático porque aprovecha décadas de desarrollo en filesystems Linux maduros, pero tiene una limitación clave: no es un parallel filesystem. Los archivos no se distribuyen entre nodos — cada archivo vive completo en un solo nodo."

### Cierre de la idea

"Veamos el diagrama: el proceso hace una syscall, DFSA intercepta, pregunta '¿está el archivo en este nodo?', y si no está, lo redirige. Transparente y simple, pero con el costo de latencia de red."

---

## 📌 Puntos Clave

1. **DFSA intercepta syscalls, no crea un FS propio**
   - Cada nodo usa ext3/ext4/XFS local
   - DFSA actúa como puente/redirrección, no como filesystem

2. **Transparencia de ubicación completa**
   - Las aplicaciones usan rutas normales (`/home/user/archivo.txt`)
   - No necesitan conocer la topología del cluster
   - La migración de procesos no rompe el acceso a archivos

3. **Limitación: no es parallel filesystem**
   - Cada archivo reside en un solo nodo
   - Sin striping de datos entre nodos
   - Sin paralelismo de E/S

4. **Latencia de red es el cuello de botella**
   - Acceso local: microsegundos
   - Acceso remoto: mínimo 0.1-1 ms por la red
   - La documentación oficial advierte sobre esto

5. **Sin enlaces entre nodos**
   - Hard links y symbolic links no cruzan nodos
   - Cada nodo tiene su propia jerarquía de directorios

---

## 🔗 Relación con FSO

### §3.1 — Sistema de Archivos en sentido amplio vs estricto

DFSA es un **filesystem en sentido amplio**: no consiste solo en estructuras de datos en disco (i-nodos, bloques), sino que incluye software de gestión de red, lógica de transparencia, y servicios de ubicación. Trabaja **sobre** los filesystems estrictos de cada nodo.

### §1.7 — Llamadas al Sistema

El mecanismo de interceptación opera en el punto donde las aplicaciones hacen `open()`, `read()`, `write()`, `close()` — las mismas syscalls que vimos en la teórica. DFSA se interpone entre la syscall y el handler local del kernel.

### §3.5 — Métodos de Acceso

DFSA soporta tanto acceso **secuencial** como **directo** (seek). El tipo de acceso depende del patrón de la aplicación, no de DFSA; DFSA solo redirige.

### §3.6 — Métodos de Asignación

Los filesystems subyacentes (ext4, XFS) usan **i-nodos** con punteros directos e indirectos. DFSA no cambia cómo se asignan los bloques — solo hace transparente su ubicación.

### Contraste con sistemas distribuidos modernos

MOSIX DFSA es un enfoque de 1990s. Los sistemas modernos (Lustre en Top500, GPFS, WekaIO) usan **parallel filesystems** con striping de datos, lo que da rendimiento de E/S paralelo real. La evolución conceptual va de "transparencia" (MOSIX) a "distribución explícita" (Kubernetes persistent volumes).

---

## ⚠️ Cosas a Tener en Cuenta

### En la presentación

- **Mencionar que NO es parallel filesystem** — es la confusión más común. La gente asume que "sistema de archivos distribuido" significa striping y paralelismo, pero MOSIX no hace eso.
- **El diagrama es clave** — muestra claramente el flujo: Proceso → DFSA intercepta → ¿Archivo en este nodo? → Local o Red.
- **MOSIX está inactivo desde 2017** — hay que decirlo. Este enfoque de interceptación de syscalls fue pionero pero fue superado.

### Para el contraste con Zephyr

| Aspecto            | Zephyr                             | MOSIX                      |
| ------------------ | ---------------------------------- | -------------------------- |
| **Scope**          | Local (un microcontrolador)        | Distribuido (cluster)      |
| **FS propio**      | Sí — LittleFS, FAT, NVS            | No — usa ext4/XFS locales  |
| **Almacenamiento** | Flash integrada, ~KB a MB          | Discos duros, ~TB por nodo |
| **Acceso**         | Todo local, sin red                | Red para archivos remotos  |
| **Optimización**   | Wear leveling, power-loss tolerant | Throughput de cluster      |
| **Complejidad**    | Determinado, embedded              | Variable, HPC              |

### Preguntas que pueden hacer

- **"¿Por qué no usar NFS directamente?"** — NFS requiere mounting explícito y configuración. DFSA hace todo transparente sin que la aplicación lo sepa.
- **"¿Qué pasa si la red se cae?"** — La operación de E/S falla. DFSA no tiene mecanismos de caché o resiliencia propios más allá de lo que provea la red.
- **"¿Cómo sabe DFSA dónde está cada archivo?"** — Mantiene metadata de ubicación, probablemente en una tabla distribuida actualizada cuando se crean/modifican archivos.

---

## ⏱️ Tiempo Estimado

| Sección                       | Tiempo             |
| ----------------------------- | ------------------ |
| Apertura + problema           | 15-20 seg          |
| Cómo funciona DFSA            | 25-30 seg          |
| FS subyacentes + limitaciones | 15-20 seg          |
| Cierre + transición           | 10 seg             |
| **Total**                     | **65-80 segundos** |

---

## 📝 Frases Clave para Usar

- _"Intercepta syscalls de archivo"_
- _"Transparencia de ubicación"_
- _"Cada archivo vive en un solo nodo"_
- _"No es parallel filesystem — es una capa de redirección"_
- _"Pragmático: usa los FS Linux existentes"_

---

## 🔗 Navegación

- **Anterior**: Slide 08 — Zephyr OS: Sistema de Archivos (VFS, LittleFS, FAT, NVS)
- **Siguiente**: Slide 10 — Zephyr OS: Administración de Memoria (MPU, heap, slabs)

---

_Material preparado para la presentación del TP Especial de Evaluación — Zephyr OS vs MOSIX_
_Fundamentos de Sistemas Operativos — UNMDP_
_Mayo 2026_
