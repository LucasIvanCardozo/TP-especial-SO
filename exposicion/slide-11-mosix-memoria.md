# Slide 11 — MOSIX: Administración de Memoria

## 🎤 Qué Decir

**"En un cluster, la memoria no es un recurso local — es un recurso distribuido."**

MOSIX enfrenta un problema completamente diferente al de un sistema operativo tradicional: tiene múltiples nodos, cada uno con su propia RAM local, y necesita que los procesos vean esta memoria distribuida como un recurso unificado.

### El concepto de Memory Ushering

La solución de MOSIX se llama **Memory Ushering** — "ushear" significa guiar o escoltar. En lugar de esperar a que un nodo se quede sin memoria (OOM = Out Of Memory) y tenga que hacer page replacement local, MOSIX **migra páginas de forma proactiva** antes de que ocurra la crisis.

**¿Cómo funciona?**

1. El nodo A detecta que su memoria está "casi llena" —digamos, al 85% de uso
2. El algoritmo de Ushering identifica qué páginas pueden migrarse (por ejemplo, páginas de un proceso que no se están usando activamente)
3. Se selecciona la página X
4. Se copia la página al nodo B, que tiene más memoria disponible
5. El proceso continúa ejecutando, pero ahora tiene páginas tanto en A como en B

**La diferencia clave con page replacement tradicional:**

En un SO normal, cuando la memoria se llena, el algoritmo de reemplazo (FIFO, LRU) elige una víctima local y la intercambia a disco. En MOSIX, en lugar de escribir a disco lento, se transmite la página por red a otro nodo que tiene RAM disponible. La red es mucho más rápida que el disco para este caso de uso.

---

## 📌 Puntos Clave

### 1. Shared-Nothing Architecture

MOSIX usa un modelo de memoria **"shared-nothing"** — cada nodo tiene su RAM local privada. **No hay memoria compartida entre nodos.** Esto contrasta con sistemas NUMA donde hay acceso a memoria remota pero sigue siendo visible como un único espacio de direcciones.

### 2. Migración a nivel de página, no de proceso completo

A diferencia de la migración de procesos (slide 13), aquí se migran **páginas individuales** mientras el proceso sigue ejecutando. Es migración parcial, granular, y transparente.

### 3. Memory Ushering ≠ Page Replacement

| Aspecto                | Page Replacement clásico (§5.3) | Memory Ushering                  |
| ---------------------- | ------------------------------- | -------------------------------- |
| Unidad                 | Página                          | Página                           |
| Destino víctimas       | Disco (swap)                    | Otro nodo (RAM)                  |
| Timing                 | Reactivo (cuando memoria llena) | Proactivo (antes de llenar)      |
| Algoritmo de selección | FIFO, LRU, OPT                  | Basado en predictibilidad de uso |
| Costo                  | Disco lento                     | Red relativamente rápida         |

### 4. Beneficio: Aprovechar RAM distribuida

En un cluster con 10 nodos de 64 GB, hay 640 GB de RAM total. Memory Ushering permite que procesos individuales usen más memoria de la que tiene un solo nodo, distribuyendo la carga.

---

## 🔗 Relación con FSO

### §5.1 — Concepto de Memoria Virtual

MOSIX extiende el concepto de memoria virtual a un cluster: la memoria total disponible no es la RAM de un solo nodo, sino la suma de todas las RAMs del cluster. El proceso ve un espacio de direcciones "virtualmente" más grande.

### §5.3 — Algoritmos de Reemplazo de Páginas

Memory Ushering es conceptualmente un algoritmo de reemplazo de páginas, pero con dos diferencias fundamentales:

- **El victim pool** es la RAM de otros nodos, no el disco
- **La política de selección** debe considerar no solo uso reciente (§5.3 LRU) sino también la velocidad de la red y la carga del nodo destino

### §5.6 — Thrashing e Hiperpaginación

Aquí hay un paralelo interesante: si MOSIX migra demasiado agresivamente, puede causar "network thrashing" — la red se satura con tráfico de migración de páginas. El algoritmo de Ushering debe balancear entre:

- Mantener procesos en el nodo local (menor latencia)
- Migrar páginas antes de OOM (prevención)
- No saturar la red (balanceo)

### §5.7 — Working Set

El working set de un proceso en MOSIX puede estar distribuido en múltiples nodos. La pregunta es: ¿cuánta de esa página set debería estar en RAM local vs migrada? Es el equivalente distribuido del working set model.

### §4.1 — Administración de Memoria Distribuida

MOSIX no usa MFT ni MVT clásicos — usa un modelo donde cada nodo administra su memoria local y cooperativamente comparte con el cluster mediante Ushering.

---

## ⚠️ Cosas a Tener en Cuenta

### Contraste con Zephyr (slide 10)

| Aspecto               | Zephyr                                             | MOSIX                              |
| --------------------- | -------------------------------------------------- | ---------------------------------- |
| **Modelo de memoria** | Local, unificada (single address space)            | Distribuida, shared-nothing        |
| **Protección**        | MPU (simplificada)                                 | Privilegios de kernel Linux        |
| **Memoria virtual**   | Limitada o nula (la mayoría de MCUs no tienen MMU) | Sí, paginación completa de Linux   |
| **Page replacement**  | No aplica (sin swapping)                           | Memory Ushering + swap tradicional |
| **Overhead de red**   | No aplica (no hay red en sentido cluster)          | Crítico (latencia, ancho de banda) |

### Limitaciones de Memory Ushering

- **Latencia de red**: Migrar una página por red toma microsegundos vs nanosegundos de acceso a RAM local
- **Consistencia de caché**: Cuando una página migra, las copias en caché de otros nodos deben invalidarse
- **No soporta memoria compartida entre procesos distribuidos**: Si dos procesos en diferentes nodos necesitan compartir memoria, MOSIX no lo permite directamente
- **No es caché coherente**: No implementa coherencia de caché tipo MESI entre nodos

### Crítica académica

Memory Ushering es un algoritmo interesante de investigación, pero en la práctica:

- Las redes HPC modernas usan InfiniBand con latencia ultra-baja, lo que hace viable la migración
- Sin embargo, los clusters HPC actuales prefieren explícits data locality via MPI
- El overhead de mantener páginas migradas coherentes generalmente supera el beneficio

---

## ⏱️ Tiempo Estimado

**60-90 segundos** (~1 minuto)

### Desglose sugerido:

| Parte                | Tiempo | Contenido                                                     |
| -------------------- | ------ | ------------------------------------------------------------- |
| Introducción         | 15s    | "MOSIX administra memoria distribuida, no local"              |
| Memory Ushering      | 30s    | Explicar proactividad vs reactive, ventaja sobre swap a disco |
| Relación con FSO     | 20s    | Conectar con §5.3, §5.6, §5.7                                 |
| Contraste con Zephyr | 15s    | Local vs distribuida, MPU vs MMU completa                     |
| Cierre               | 10s    | Resumen: "Memory Ushering = page replacement + red"           |

---

## 🎯 Frase de Cierre Sugerida

> _"Memory Ushering es la respuesta de MOSIX al problema de memoria limitada en clusters: en lugar de swapear a disco, migra a otro nodo por la red. Elegante en teoría, pero hoy los clusters HPC modernos prefieren que el programador controle explícitamente la locality de sus datos con MPI."_

---

## 📚 Términos Clave para Recordar

| Término                  | Definición rápida                                   |
| ------------------------ | --------------------------------------------------- |
| **Memory Ushering**      | Migración proactiva de páginas antes de OOM         |
| **Shared-nothing**       | Cada nodo tiene RAM privada, sin memoria compartida |
| **Page migration**       | Mover páginas individuales entre nodos              |
| **OOM (Out Of Memory)**  | Condición cuando un nodo no puede asignar más RAM   |
| **Network thrashing**    | Degradación por exceso de tráfico de migración      |
| **Remote Memory Access** | Acceso a RAM de otro nodo por la red                |

---

_Material preparado para exposición del TP Especial — Zephyr OS vs MOSIX_
_Fundamentos de Sistemas Operativos — UNMDP_
