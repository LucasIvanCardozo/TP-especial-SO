# Sistema de Archivos de MOSIX

MOSIX no proporciona su propio sistema de archivos distribuido. En cambio, implementa un mecanismo llamado **Direct File System Access (DFSA)** que permite a los procesos migrados acceder a archivos de manera transparente a través del cluster.

---

## ¿Por qué MOSIX no tiene un FS propio distribuido?

MOSIX adopta un enfoque pragmático: en lugar de crear un sistema de archivos distribuido desde cero, aprovecha los sistemas de archivos Linux existentes y añade una capa de inteligencia para redirigir las operaciones de E/S hacia el nodo donde residen los datos.

**¿Por qué es importante esta decisión?**

1. **Compatibilidad con estándares**: Usa sistemas de archivos maduros y probados (ext3, ext4, XFS, etc.)
2. **Simplicidad de implementación**: No requiere mantener un FS paralelo completo
3. **Enfoque en migración de procesos**: La energía de desarrollo se concentra en el balanceo de carga y migración, no en almacenamiento
4. **Escalabilidad limitada por diseño**: Al no tener un FS propio, evita los problemas de consistencia distribuidos

> **Nota:** Esta decisión implica que MOSIX no puede resolver cuellos de botella de E/S de la misma manera que un Parallel FS dedicado. La documentación oficial indica que el acceso a archivos puede convertirse en un cuello de botella cuando hay mucha carga de E/S [The MOSIX Direct File System Access Method for Supporting Scalable Cluster File Systems](https://www.researchgate.net/publication/220406183_The_MOSIX_Direct_File_System_Access_Method_for_Supporting_Scalable_Cluster_File_Systems).

---

## DFSA (Direct File System Access)

### ¿Qué es?

DFSA es el mecanismo mediante el cual MOSIX permite que un proceso migrado realice operaciones sobre archivos **directamente en el nodo actual de ejecución**, sin necesidad de retornar al nodo donde se inició el proceso para cada operación de E/S.

### ¿Cómo funciona?

```
┌─────────────────────────────────────────────────────────────────┐
│                    CLUSTER MOSIX                                 │
│                                                                 │
│  Nodo 1 (Origen)          Nodo 2 (Ejecución)                    │
│  ┌─────────┐              ┌─────────┐                           │
│  │ Proceso │────migra────▶│ Proceso │                           │
│  │iniciado │              │ migrado │                           │
│  └─────────┘              └────┬────┘                           │
│                                │                                │
│                      ┌─────────▼─────────┐                     │
│                      │  Interceptación   │                     │
│                      │   de operaciones   │                     │
│                      │   de archivo (DFSA)│                     │
│                      └─────────┬─────────┘                     │
│                                │                                │
│                      ┌─────────▼─────────┐                     │
│                      │  ¿Dónde está el   │                     │
│                      │     archivo?      │                     │
│                      └─────────┬─────────┘                     │
│                                │                                │
│              ┌─────────────────┼─────────────────┐             │
│              ▼                                   ▼             │
│    ┌─────────────────┐                 ┌─────────────────┐     │
│    │  Archivo está   │                 │  Archivo está  │     │
│    │  en el nodo     │                 │  en OTRO nodo  │     │
│    │  actual (Nodo 2)│                 │  (Nodo 3 por   │     │
│    │                 │                 │   ejemplo)     │     │
│    └────────┬────────┘                 └────────┬────────┘     │
│             │                                   │               │
│             │        ┌─────────────────┐        │               │
│             └───────▶│  Redirección    │◀───────┘               │
│                      │  de E/S al nodo │                        │
│                      │  correspondiente│                        │
│                      └─────────────────┘                        │
└─────────────────────────────────────────────────────────────────┘
```

**Pasos:**
1. Un proceso se inicia en el Nodo 1
2. MOSIX migra el proceso al Nodo 2 (por balanceo de carga)
3. El proceso intenta abrir un archivo (`open()`)
4. DFSA intercepta la llamada y determina si el archivo está en el nodo actual o en otro nodo
5. Si el archivo está en otro nodo (ej. Nodo 3), DFSA redirige la operación de E/S hacia ese nodo
6. El resultado se retorna al proceso como si la operación hubiera sido local

### Características clave

| Aspecto | Descripción |
|---------|-------------|
| **Transparencia** | Las aplicaciones no necesitan saber dónde están almacenados sus archivos |
| **Interceptación** | DFSA intercepta lassyscalls de archivo a nivel de kernel |
| **Redirección** | Las operaciones se redirigen al nodo donde reside el dato |
| **Compatibilidad** | Funciona con sistemas de archivos estándar de Linux |
| **Limitación** | No es un Parallel FS completo — la E/S puede ser cuello de botella |

> **Fuente:** [The MOSIX Direct File System Access Method for Supporting Scalable Cluster File Systems](https://www.researchgate.net/publication/220406183_The_MOSIX_Direct_File_System_Access_Method_for_Supporting_Scalable_Cluster_File_Systems), [MOSIX Scalable Cluster File Systems for LINUX](https://www.academia.edu/8128495/The_MOSIX_Scalable_Cluster_File_Systems_for_LINUX)

---

## Sistemas de Archivos Compatibles

MOSIX es compatible con la mayoría de los sistemas de archivos Linux estándar porque DFSA opera a nivel desyscalls de archivo genéricas:

### Soportados oficialmente

| Sistema de Archivos | Tipo | Compatibilidad |
|---------------------|------|----------------|
| **ext3** | Journaling | ✅ Soportado |
| **ext4** | Journaling (extensión de ext3) | ✅ Soportado |
| **XFS** | Journaling de alto rendimiento | ✅ Soportado |
| **NFS** (Network File System) | Archivo en red | ✅ Soportado |
| **ext2** | Legacy | ✅ Soportado |

### Detalles importantes

- **Sistemas de archivos locales**: ext3, ext4, XFS funcionan sin modificaciones
- **NFS**: Permite que MOSIX acceda a archivos exportados por otros nodos
- **DFSA integrado**: Cuando el sistema de archivos lo soporta nativamente, DFSA puede integrarse de forma más eficiente

> **Nota:** La compatibilidad depende de que el kernel Linux donde se ejecuta MOSIX tenga soporte para estos sistemas de archivos. MOSIX no añade restricciones adicionales sobre qué FS se puede usar.

---

## Limitaciones

### 1. No es un Parallel File System

MOSIX **no** es un sistema de archivos paralelo como PVFS, Lustre o GFS. Esto significa:

| Característica | Parallel FS (PVFS/Lustre/GFS) | MOSIX (DFSA) |
|----------------|-------------------------------|--------------|
| **Almacenamiento** | Datos distribuidos en múltiples nodos | Cada nodo tiene su almacenamiento local |
| **Striping** | Archivos divididos entre múltiples nodos | No hay striping de archivos |
| **Paralelismo de E/S** | Múltiples nodos pueden escribir/leer simultáneamente | Acceso secuencial por nodo |
| **Rendimiento** | Alto para E/S paralela | Limitado por un solo nodo |

### 2. Cuellos de botella en E/S

La documentación oficial de MOSIX advierte explícitamente:

> *"The access to files can become a bottleneck when there is a lot of I/O"* [The MOSIX Direct File System Access Method for Supporting Scalable Cluster File Systems](https://www.researchgate.net/publication/220406183_The_MOSIX_Direct_File_System_Access_Method_for_Supporting_Scalable_Cluster_File_Systems)

**¿Por qué ocurre?**
- Cuando un proceso migrado necesita acceder a archivos, las operaciones de E/S pueden requerir comunicación de red adicional
- Si el archivo está en un nodo diferente al de ejecución, hay latencia de red
- No hay paralelismo de E/S como en sistemas de archivos paralelos

### 3. Sin soporte para memoria compartida entre procesos

MOSIX no soporta memoria compartida (shared memory) entre procesos. Esto afecta a aplicaciones que usarían un FS distribuido para shared memory:

- No hay capacidad de usar un FS paralelo para comunicación entre procesos
- Las aplicaciones que requieren DSM (Distributed Shared Memory) no son compatibles de forma nativa

### 4. Dependencia de NFS para escenarios multi-nodo

En clusters donde los archivos necesitan compartirse entre múltiples nodos, MOSIX depende de **NFS** (o protocolos similares) para el acceso compartido. Esto introduce:

- Latencia adicional de red
- Un único punto de failure si el servidor NFS falla
- Limitaciones de NFS en términos de escalabilidad

---

## Comparación con Sistemas de Archivos Distribuidos/Paralelos

### Tabla Comparativa

| Característica | MOSIX (DFSA) | PVFS | Lustre | GFS (GPFS) |
|----------------|--------------|------|--------|------------|
| **Tipo** | Acceso directo a archivos | Parallel FS | Parallel FS | Parallel FS |
| **Almacenamiento** | Local por nodo | Distribuido | Distribuido | Distribuido |
| **Striping** | ❌ No | ✅ Sí | ✅ Sí | ✅ Sí |
| **Paralelismo de E/S** | ❌ Limitado | ✅ Alto | ✅ Alto | ✅ Alto |
| **Licencia** | Propietaria | GPL | GPL (kernel) | Propietaria (IBM) |
| **Última versión** | 2017 | 2011 (inactivo) | Activo | Activo |
| **Uso en Top500** | ❌ No | ❌ No | ✅ Sí | ✅ Sí |
| **Integración con MOSIX** | Nativa | ❌ No compatible | ❌ No compatible | ❌ No compatible |

### Descripción de cada alternativa

#### PVFS (Parallel Virtual File System)

**PVFS** fue un sistema de archivos paralelo desarrollado inicialmente por el University of Chicago y Argonne National Laboratory. Diseñado para clusters de alto rendimiento.

**Características:**
- Striping de datos entre múltiples nodos de almacenamiento
- Acceso paralelo a archivos para máximo rendimiento
- Estado: Proyecto **discontinuado** (~2011)

**Fuente:** [PVFS Project](https://www.paratera.com/pvfs/), [Wikipedia: PVFS](https://en.wikipedia.org/wiki/Parallel_Virtual_File_System)

#### Lustre

**Lustre** es un sistema de archivos paralelo open source, actualmente mantenido por **Intel** (y anteriormente por **Whamcloud**, luego **DDN**). Es el FS paralelo más utilizado en supercomputadoras Top500.

**Características:**
- Escala a miles de nodos
- Alto rendimiento para E/S paralela
- Usado en >60% de Top500
- Soporte comercial disponible

**Fuente:** [Lustre Wiki](https://wiki.lustre.org/), [VAST Data - Parallel vs Distributed File Systems](https://www.vastdata.com/blog/parallel-vs-distributed-file-systems-for-hpc)

#### GFS / GPFS (General Parallel File System)

**GPFS** (ahora **IBM Spectrum Scale**) es un sistema de archivos paralelo propietario de IBM, utilizado en supercomputadoras como Summit y Sierra.

**Características:**
- Alta disponibilidad y redundancia
- Soporte para múltiples protocolos (NFS, SMB, POSIX)
- Escalabilidad a petabytes
- Soporte comercial de IBM

**Fuente:** [IBM Spectrum Scale](https://www.ibm.com/products/spectrum-scale), [Bacula Systems - Lustre vs GPFS](https://www.baculasystems.com/blog/lustre-vs-gpfs/)

### Comparación de Rendimiento

Según estudios comparativos:

> *"Parallel and Distributed File systems are the next generation file systems on cluster. For this test condition, the performance of Lustre and PVFS is slower than..."* — [Performance Comparison of Parallel and Distributed File Systems (Nectec)](https://www.nectec.or.th/nac2005/documents/20050328_BioInformatics-01_Presentation.pdf)

> *"PVFS, Lustre and GPFS focused on I/O performance, scalability, redundancy..."* — [Comparative Experimental Study of Parallel File Systems (USENIX)](https://www.usenix.org/legacy/event/lasco08/tech/full_papers/sebepou/sebepou.pdf)

### ¿Por qué no integrar un Parallel FS con MOSIX?

MOSIX fue diseñado en una época donde los Parallel FS no estaban tan maduros y la complejidad de integrar ambos sistemas habría sido excesiva. Además:

1. **Enfoque diferente**: MOSIX prioriza la migración de procesos, no el almacenamiento
2. **Complejidad**: Un Parallel FS requiere coordinación de metadatos y datos distribuidos
3. **Solución alternativa**: NFS proporciona acceso compartido básico sin la complejidad de un Parallel FS

---

## Resumen

| Aspecto | MOSIX |
|---------|-------|
| **¿Tiene FS propio?** | ❌ No |
| **Mecanismo** | DFSA (Direct File System Access) |
| **FS estándar compatibles** | ext3, ext4, XFS, NFS |
| **¿Parallel FS?** | ❌ No |
| **Cuellos de botella** | ⚠️ Posibles con alta E/S |
| **Shared memory via FS** | ❌ No soportado |

> **Conclusión:** MOSIX no intenta competir con Parallel FS como Lustre o GPFS. Su enfoque de "no crear un FS nuevo" es una decisión de diseño pragmática que simplifica la arquitectura pero limita las capacidades de E/S en comparación con soluciones dedicadas.

---

## Fuentes

- [The MOSIX Direct File System Access Method for Supporting Scalable Cluster File Systems](https://www.researchgate.net/publication/220406183_The_MOSIX_Direct_File_System_Access_Method_for_Supporting_Scalable_Cluster_File_Systems)
- [MOSIX Scalable Cluster File Systems for LINUX](https://www.academia.edu/8128495/The_MOSIX_Scalable_Cluster_File_Systems_for_LINUX)
- [Wikipedia: Comparison of distributed file systems](https://en.wikipedia.org/wiki/Comparison_of_distributed_file_systems)
- [VAST Data: Parallel vs Distributed File Systems for HPC Storage](https://www.vastdata.com/blog/parallel-vs-distributed-file-systems-for-hpc)
- [USENIX: Comparative Experimental Study of Parallel File Systems](https://www.usenix.org/legacy/event/lasco08/tech/full_papers/sebepou/sebepou.pdf)
- [Performance Comparison of Parallel and Distributed File Systems (Nectec)](https://www.nectec.or.th/nac2005/documents/20050328_BioInformatics-01_Presentation.pdf)
- [Bacula Systems: Lustre vs GPFS](https://www.baculasystems.com/blog/lustre-vs-gpfs/)
- [Wikipedia: PVFS](https://en.wikipedia.org/wiki/Parallel_Virtual_File_System)
- [Lustre Wiki](https://wiki.lustre.org/)
- [IBM Spectrum Scale](https://www.ibm.com/products/spectrum-scale)

---

*Documento elaborado para Fundamentos de Sistemas Operativos — Mayo 2026*

---
## Nota Académica — Fundamentos de SO
**Conceptos de la materia relacionados:**

- **§3.1 — Sistema de archivos en sentido amplio vs estricto**: MOSIX no tiene un FS distribuido propio; en cambio, DFSA actúa como una capa inteligente que redirige operaciones de archivos hacia el nodo donde residen los datos. El sistema de archivos "en sentido amplio" en MOSIX es este mecanismo de interposición sobre FS estándar de Linux.

- **§3.3 — Atributos de archivo e i-nodos**: MOSIX delega completamente la gestión de atributos e i-nodos a los FS subyacentes (ext3, ext4, XFS). Estos FS Linux usan i-nodos para almacenar metadatos (permisos, timestamps, ubicación de bloques). La tabla de comparación del documento muestra que los FS estándar compatibles son todos del tipo journaling con i-nodos.

- **§3.4 — Operaciones sobre archivos**: DFSA intercepta syscalls de archivo (open, read, write, close, etc.) y las redirige si el archivo está en otro nodo. El proceso ve el resultado como si la operación fuera local. Las operaciones create/delete/open/close/read/write/seek son todas afectadas por esta interposición.

- **§3.6 — Métodos de asignación de espacio**: Los FS subyacentes compatibilizados (ext3/ext4, XFS) usan el método de i-nodos, no FAT ni asignación contigua. Cada nodo del cluster tiene su almacenamiento local gestionado por su propio FS con i-nodos. No hay striping de datos entre nodos — cada archivo reside en un solo nodo.

- **§3.8 — Enlaces en contexto distribuido**: La limitación de no soportar shared memory via FS afecta directamente a los enlaces: no hay posibilidad de crear enlaces (hard ni symbolic) que apunten a archivos en otros nodos. Cada nodo gestiona sus propios archivos independientemente.

- **§3.9 — UNIX vs DOS**: MOSIX corre sobre Linux (sistemas tipo UNIX), por lo tanto usa i-nodos, permisos UNIX (rwx por owner/group/other), y nombres de archivo sensibles a mayúsculas/minúsculas. Sin embargo, la capa DFSA añade complejidad: un proceso migrado puede estar accediendo archivos de otro nodo a través de la red, behave de manera no completamente transparente respecto al modelo UNIX estándar.
