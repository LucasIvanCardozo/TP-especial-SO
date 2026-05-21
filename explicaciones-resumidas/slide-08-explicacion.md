# slide-08-explicacion — Resumen: Sistema de Archivos MOSIX

## Overview

MOSIX no tiene su propio sistema de archivos distribuido. En cambio, usa **DFSA** (Direct File System Access) para interceptar operaciones de archivos y redirigirlas al nodo donde el archivo reside físicamente.

---

## 1. DFSA — El mecanismo central

### Qué es
DFSA es una capa de interposición que intercepta syscalls de archivos (open, read, write, close, etc.) y las redirige al nodo correspondiente del cluster. Permite que un proceso migrado acceda a archivos como si fueran locales, sin importar dónde estén almacenados.

### Cómo funciona (5 pasos)

1. **Generación de syscall**: El proceso invoca una llamada al sistema (ej: `read()`)
2. **Interceptación por DFSA**: DFSA captura la syscall antes de que llegue al FS local
3. **Determinación de ubicación**: DFSA consulta en qué nodo está el archivo
4. **Redirección de E/S**: Si el archivo está en otro nodo, la operación se envía por red
5. **Retorno transparente**: El proceso recibe el resultado como si fuera una operación local

### Transparencia de ubicación
- Las aplicaciones no necesitan saber dónde está almacenado un archivo
- Un `open("/home/user/data.txt")` funciona igual si el archivo está en el nodo actual o en otro
- La migración de procesos es transparente respecto a archivos
- Los archivos se referencian por ruta normal, sin prefijos especiales de nodo

---

## 2. Sistemas de Archivos Locales por Nodo

### Filosofía de diseño
MOSIX delega la gestión de archivos a los sistemas locales de cada nodo. No crea su propia estructura de datos en disco.

### FS soportados

| FS | Tipo | Notas |
|----|------|-------|
| ext3 | Journaling | ext2 con journaling, recuperación ante fallos |
| ext4 | Journaling | Evolución de ext3, hasta 1 EB, mejor rendimiento |
| XFS | Journaling alto rendimiento | Diseñado para grandes volúmenes y alta E/S |
| NFS | Network FS | Permite acceder archivos exportados remotamente |
| ext2 | Legacy | Sin journaling, usado en USBs |

Todos usan **i-nodos** (no FAT ni asignación contigua).

---

## 3. Limitaciones

### No es un Parallel Filesystem
- Cada archivo reside en un solo nodo (sin striping)
- Un archivo no se divide entre múltiples nodos
- Solo el nodo que posee el archivo puede accederlo
- Rendimiento limitado a la capacidad de ese nodo + latencia de red

### Latencia de red como cuello de botella
- Lectura local: microsegundos (caché del FS)
- Lectura remota: ~0.1-1 ms mínimo (red + procesamiento)

MOSIX advierte: *"The access to files can become a bottleneck when there is a lot of I/O"*

### Sin paralelismo de E/S
- Si un archivo está en Nodo A, todas las operaciones pasan por Nodo A
- No hay múltiples streams simultáneos como en Lustre o GPFS
- Constraste: un Parallel FS puede striping un archivo de 100 GB en 10 nodos → 10 streams paralelos

### Sin memoria compartida distribuida
- No hay DSM (Distributed Shared Memory)
- No se pueden crear segmentos de memoria que abarquen múltiples nodos
- Aplicaciones que dependen de memoria compartida necesitan soluciones externas (OpenMP, etc.)

### Enlaces limitados al ámbito local
- No se pueden crear hard links entre nodos (un hard link en Nodo A apuntando a archivo en Nodo B)
- Los enlaces simbólicos tampoco cruzan nodos
- Cada nodo gestiona su propia jerarquía de directorios

---

## 4. Resumen técnico

| Aspecto | Detalle |
|---------|---------|
| ¿FS propio? | No — usa DFSA como capa de interposición |
| Mecanismo | DFSA intercepta syscalls y redirige al nodo correspondiente |
| FS subyacentes | ext3, ext4, XFS, NFS, ext2 (todos con i-nodos) |
| ¿Parallel FS? | No — sin striping, sin paralelismo de E/S |
| ¿Shared memory via FS? | No |
| Cuellos de botella | Latencia de red para archivos remotos |
| Transparencia | Sí — apps ven operaciones locales aunque archivo esté en otro nodo |

---

## 5. Conexión con temario FSO

- **§3.1**: DFSA es un "sistema de archivos en sentido amplio" (software + servicios + red), no solo estructura de datos en disco
- **§3.6**: Los FS subyacentes usan método de i-nodos (punteros directos/indirectos), no FAT ni asignación contigua
- **§3.8**: Las limitaciones de enlaces refuerzan que no hay espacio de nombres unificado entre nodos

---

## Glosario rápido

- **DFSA**: Capa de interposición que redirige syscalls de archivos al nodo donde reside el archivo
- **Syscall Interception**: Técnica que captura llamadas al sistema antes de que lleguen al handler nativo
- **Parallel FS**: Sistema de archivos que distribuye datos (striping) entre múltiples nodos para acceso paralelo (ej: Lustre, GPFS)
- **Transparency de ubicación**: El usuario no necesita saber dónde está almacenado un archivo