# Administración de Memoria en MOSIX

## 1. Modelo de Memoria Distribuida "Shared-Nothing"

MOSIX implementa un modelo de memoria **"shared-nothing"** (nada compartido), también llamado **memoria distribuida**. En este modelo:

- **Cada nodo posee su propia memoria física local** y la administra de forma independiente
- **No existe memoria compartida entre nodos** del cluster
- Los nodos se comunican mediante mensajes explícitos a través de la red (típicamente Ethernet o Myrinet)
- Cada nodo tiene su propio espacio de direcciones virtual, completamente aislado de los demás

Este enfoque contrasta con los sistemas **NUMA (Non-Uniform Memory Access)** donde existe una única imagen de memoria pero con tiempos de acceso variables según la ubicación física del dato, o con sistemas de **memoria compartida distribuida (DSM)** que simulan un espacio de direcciones compartido sobre nodos físicamente separados.

**Fuente:** [The MOSIX Algorithms for Managing Cluster, Multi-Clusters, GPU](https://os.inf.tu-dresden.de/Studium/DOS/SS2011/05-MOSIX.pdf), [Wikipedia: Shared-nothing architecture](https://en.wikipedia.org/wiki/Shared-nothing_architecture)

---

## 2. Memory Ushering: Migración Proactiva de Memoria

### 2.1 ¿Qué es?

**Memory Ushering** es un algoritmo de MOSIX que permite que un nodo que ha **agotado su memoria principal** pueda utilizar la memoria libre disponible en otros nodos del cluster, **migrando procesos en lugar de usar paging o swapping al disco local**.

El término "ushering" (acompañarguiado) hace referencia a que el sistema guidinga/migre proactivamente los procesos hacia nodos con memoria disponible antes de que ocurra una situación de "out of memory".

### 2.2 ¿Cómo funciona?

El algoritmo opera de la siguiente manera:

1. **Detección de memoria baja:** El sistema monitorea continuamente la cantidad de memoria libre en cada nodo
2. **Identificación proactiva:** Cuando un nodo detecta que su memoria libre está por debajo de un umbral crítico, busca nodos con memoria disponible
3. **Selección de proceso a migrar:** Se selecciona un proceso del nodo con memoria escasa para ser migrado
4. **Transferencia del proceso:** El proceso (incluyendo su contexto de memoria) se transfiere al nodo destino
5. **Continuación de ejecución:** El proceso continúa ejecutándose en el nodo destino de forma transparente

### 2.3 Características clave

- **Migración proactiva (no reactiva):** A diferencia del paging tradicional que reacciona cuando ya hay contención de memoria, Memory Ushering previene la situación antes de que ocurra
- **Transparente para la aplicación:** El proceso migrado no necesita ser modificado ni recompilado
- **Integrado con balanceo de carga:** Funciona junto con el algoritmo de balanceo de carga de CPU de MOSIX
- **Útil para:** Casos donde la memoria no se usa de manera uniforme, nodos con diferentes cantidades de memoria, o cuando se crea un proceso tan grande que no cabe en la memoria libre de un solo nodo

**Fuente:** [Memory ushering in a scalable computing cluster - ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S0141933198000775) (1998, Amnon Barak y Avner Braver), [High Performance Computing with Mosix - ICTP](https://indico.ictp.it/event/a01127/session/33/contribution/22/material/0/1.pdf)

---

## 3. Cada Nodo Mantiene su Propia Memoria Local

En MOSIX, cada nodo del cluster:

- **Gestiona su propia memoria física** mediante el gestor de memoria nativo de Linux
- **Mantiene tablas de páginas propias** para mapear direcciones virtuales a físicas
- **Tiene control total** sobre qué procesos se ejecutan y cuánta memoria consumen localmente
- **No comparte estructuras de memoria** con otros nodos

Esta arquitectura significa que no existe coherencia de caché entre nodos (no hay problema de coherencia de caché), ni一致性 de memoria entre nodos. Cada nodo es un sistema completo e independiente.

---

## 4. NO Hay Memoria Compartida entre Nodos: Implicaciones

### 4.1 Ausencia de Shared Memory

MOSIX **no soporta memoria compartida entre procesos (shared-memory)** de forma nativa. Esto implica:

- **Sin POSIX shared memory** (`shm_open`, etc.)
- **Sin memoria compartida System V** (`shmget`, `shmat`, etc.)
- **Sin DSM (Distributed Shared Memory)** integrada

### 4.2 Implicaciones para las aplicaciones

| Aspecto | Impacto |
|---------|---------|
| **Comunicación entre procesos** | Debe usar mecanismos basados en mensajes (MPI, PVM, sockets) |
| **Aplicaciones paralelas** | Deben usar modelos de paso de mensajes en lugar de memoria compartida |
| **Rendimiento** | Comunicación entre nodos tiene latencia de red vs. acceso a memoria local |
| **Programación** | Mayor complejidad al no poder compartir datos directamente |

### 4.3 Comparación con modelos alternativos

| Modelo | Memoria compartida entre nodos | Latencia de comunicación |
|--------|-------------------------------|------------------------|
| **MOSIX (shared-nothing)** | No | Alta (red) |
| **NUMA** | Sí (pero no uniforme) | Media |
| **DSM (ej. OpenMP distribuido)** | Sí (simulada) | Variable |
| **SMP** | Sí (uniforme) | Baja |

**Fuente:** [The MOSIX Algorithms for Managing Cluster](https://os.inf.tu-dresden.de/Studium/DOS/SS2011/05-MOSIX.pdf), [Wikipedia: MOSIX](https://en.wikipedia.org/wiki/MOSIX)

---

## 5. Migración de Memoria con Procesos

### 5.1 ¿Cómo se transfiere la memoria?

Cuando MOSIX migra un proceso, incluye su **contexto de memoria completo**:

1. **Espacio de direcciones del proceso:** Se copia toda la imagen de memoria del proceso (heap, stack, código, datos)
2. **Tablas de páginas:** Se transfieren las estructuras que mapean direcciones virtuales a físicas
3. **Estado de los descriptores de archivos:** Los archivos abiertos se manejan mediante DFSA (Direct File System Access)
4. **Contexto de ejecución:** Registros del CPU, contador de programa, estado de threads

### 5.2 Mecanismo de migración

- **Preemptive process migration:** El proceso puede ser migrado en cualquier momento, incluso mientras está ejecutando
- **Transparente:** Ni el usuario ni la aplicación necesitan indicar cuándo o dónde migrar
- **Via red:** Los datos se transfieren por la red del cluster (Ethernet, Myrinet, etc.)
- **Checkpoint/Restart:** MOSIX también soporta checkpointing para recuperación ante fallos

### 5.3 Costos de la migración

La migración de procesos con grandes espacios de memoria puede generar:

- **Overhead de red significativo** durante la transferencia del espacio de direcciones
- **Tiempo de inactividad** durante el handover del proceso
- **Dependencia de ancho de banda** de la red del cluster

**Fuente:** [The NOW MOSIX and its Preemptive Process Migration Scheme](http://yuval.yarom.org/pdfs/mosix.pdf), [Scalable Cluster Computing with MOSIX for LINUX](https://courses.cs.vt.edu/~cs5204/fall05-kafura/Papers/Migration/mosix.pdf)

---

## 6. Limitaciones Conocidas

### 6.1 Sin memoria compartida

- **No es compatible con aplicaciones que requieren shared-memory** (muchas aplicaciones HPC paralelas)
- **No soporta DSM (Distributed Shared Memory)** de forma nativa
- Los programas que dependen de `shmget()`/`shmat()` o `shm_open()` no funcionarán como se espera en un ambiente distribuido

### 6.2 Overhead en procesos grandes

- **Procesos con grandes espacios de memoria** generan tráfico de red considerable durante la migración
- **Tiempo de migración proporcional al tamaño** del espacio de direcciones del proceso
- **Puede causar latencia** si se migran procesos frecuentemente

### 6.3 Limitaciones de threads

- **No soporta aplicaciones con threads** de la forma tradicional (pregunta 42 del FAQ de MOSIX)
- Las aplicaciones multithreaded no se migran de la misma manera que procesos single-threaded

### 6.4 Sistema de archivos

- **El acceso a archivos puede convertirse en un cuello de botella** cuando hay mucha E/S
- **DFSA** (Direct File System Access) ayuda pero no es un sistema de archivos distribuido completo como PVFS o Lustre

**Fuente:** [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html), [The MOSIX Algorithms for Managing Cluster](https://os.inf.tu-dresden.de/Studium/DOS/SS2011/05-MOSIX.pdf)

---

## 7. Comparación con Sistemas NUMA

### 7.1 Similitudes y diferencias

| Característica | MOSIX | NUMA |
|----------------|-------|------|
| **Memoria física** | Distribuida (cada nodo su propia RAM) | Distribuida (cada CPU/socket su propia RAM) |
| **Acceso a memoria remota** | Posible (vía migración de procesos) | Posible (más lento que local) |
| **Espacio de direcciones** | Múltiples espacios independientes | Único espacio de direcciones compartido |
| **Coherencia de caché** | No necesaria (no hay memoria compartida) | Necesaria (CC-NUMA) |
| **Modelo** | Shared-nothing | Shared-everything (vista) |
| **Latencia de acceso remoto** | Alta (red) | Media-baja (interconnect de CPU) |

### 7.2 Ventajas de NUMA sobre MOSIX

- **Memoria teóricamente compartida:** Las aplicaciones pueden ver un único espacio de direcciones
- **Coherencia de caché** (en sistemas CC-NUMA)
- **Acceso directo** a memoria remota sin necesidad de migrar procesos
- **Mejor para:** Aplicaciones que necesitan compartir datos frecuentemente

### 7.3 Ventajas de MOSIX sobre NUMA

- **Escalabilidad horizontal:** Puede agregar nodos simplemente con más PCs/servidores
- **Costo:** Hardware NUMA es significativamente más caro
- **Tolerancia a fallos:** La migración de procesos permite recuperación ante fallos de nodos
- **Heterogeneidad:** Puede combinar nodos de diferentes capacidades

### 7.4 Cuándo usar cada uno

| Contexto | Recomendación |
|----------|---------------|
| **HPC con memoria compartida verdadera** | NUMA o DSM |
| **Clusters de workstations heterogéneas** | MOSIX o similar |
| **Presupuesto limitado, escala media** | MOSIX o SLURM |
| **Aplicaciones con alto intercambio de datos** | NUMA o memoria compartida distribuida |

---

## 8. Resumen

MOSIX implementa un modelo de memoria **shared-nothing** donde:

- ✅ Cada nodo tiene memoria física independiente
- ✅ **Memory Ushering** permite usar memoria de otros nodos migrando proactivamente procesos
- ✅ La migración de memoria va incluida en la migración de procesos
- ❌ **No hay memoria compartida** entre nodos
- ❌ La migración de procesos grandes genera overhead de red
- ❌ Limitaciones con aplicaciones que requieren shared-memory o threads

Este modelo es adecuado para clusters de PCs/servidores donde se busca aprovechar recursos de memoria dispersos, pero no es la mejor opción para aplicaciones que requieren acceso compartido a grandes estructuras de datos.

---

## Fuentes

- [Memory ushering in a scalable computing cluster - ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S0141933198000775) (Barak & Braver, 1998)
- [The MOSIX Algorithms for Managing Cluster, Multi-Clusters, GPU - TU Dresden](https://os.inf.tu-dresden.de/Studium/DOS/SS2011/05-MOSIX.pdf)
- [The NOW MOSIX and its Preemptive Process Migration Scheme](http://yuval.yarom.org/pdfs/mosix.pdf)
- [Scalable Cluster Computing with MOSIX for LINUX - VT University](https://courses.cs.vt.edu/~cs5204/fall05-kafura/Papers/Migration/mosix.pdf)
- [High Performance Computing with Mosix - ICTP](https://indico.ictp.it/event/a01127/session/33/contribution/22/material/0/1.pdf)
- [Wikipedia: MOSIX](https://en.wikipedia.org/wiki/MOSIX)
- [Wikipedia: Shared-nothing architecture](https://en.wikipedia.org/wiki/Shared-nothing_architecture)
- [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)

---

*Documento elaborado para Fundamentos de Sistemas Operativos — Mayo 2026*

---
## Nota Académica — Fundamentos de SO

**Conceptos de la materia relacionados:**

- **§4.1 y §5.1 Administración de memoria - múltiples procesos compiten por memoria limitada**: MOSIX resuelve la competencia por memoria a nivel de cluster — cuando un nodo agota su RAM, migra procesos completos a otros nodos con memoria disponible, en lugar de usar swapping local. Esto es una extensión del concepto de "múltiples procesos compiten por memoria limitada" pero a escala de cluster.

- **§5.1 Memoria virtual**: MOSIX no implementa memoria virtual tradicional (paging a disco). Su "memoria virtual de cluster" surge del hecho de que cada nodo tiene su propio gestor de memoria Linux local y la migración de procesos enteros simula una forma de swapping distribuido — la "ilusión de más memoria" se logra vía migración en lugar de paging.

- **§5.3 Algoritmos de reemplazo - alternativa a FIFO/LRU**: Memory Ushering es un algoritmo de reemplazo de páginas a nivel de procesos: en lugar de elegir qué página evictar (como haría FIFO/LRU), elige qué proceso migrar a otro nodo. Es conceptualmente un "process eviction" en vez de "page eviction".

- **§4.2 MFT vs §4.3 MVT**: Cada nodo MOSIX funciona como un sistema independiente con memoria local — el modelo de particiones (fija/variable) lo maneja el Linux local de cada nodo. A nivel de cluster, MOSIX es más parecido a "particiones variables" porque la memoria disponible varía dinámicamente según qué nodos tengan libres.

- **§4.6 Fragmentación externa**: Al no haber memoria compartida entre nodos, no existe fragmentación externa de memoria compartida (no hay bloques de memoria asignados a múltiples nodos). Cada nodo maneja su propia fragmentación local.

- **§4.7 Compactación**: MOSIX no necesita compactación porque no hay memoria compartida que se fragmente. La migración de procesos no compacta memoria — simplemente relocaliza procesos completos a otros nodos, evitando el problema de compactación en tiempo real que menciona §4.7.

- **§5.6 Thrashing e hiperpaginación**: Memory Ushering es precisamente la respuesta al thrashing — detecta proactivamente nodos con memoria baja y migra procesos ANTES de que ocurra contención severa. A diferencia de working set que mide páginas, MOSIX mide "disponibilidad de memoria del nodo completo".

- **Modelo shared-nothing vs NUMA (§4.1, §7 comparación)**: MOSIX implementa "shared-nothing" donde cada nodo tiene memoria físicamente independiente. Esto contrasta con NUMA (§7) donde existe un único espacio de direcciones compartido con latencia variable. En MOSIX no hay coherencia de caché porque no hay memoria compartida; en NUMA sí la hay (CC-NUMA).