# Sistema de Archivos de Zephyr OS

> Este documento describe el sistema de archivos de Zephyr OS, un RTOS de tiempo real diseñado para sistemas embebidos con recursos restringidos. Está orientado a lectores sin conocimiento previo sobre el tema.

---

## 1. Virtual File System Switch (VFS)

### 1.1 ¿Qué es?

El **Virtual File System Switch (VFS)** es una capa de abstracción en Zephyr OS que permite que las aplicaciones accedan a diferentes sistemas de archivos a través de una **interfaz uniforme**, sin necesidad de conocer los detalles internos de cada implementación.

El concepto es análogo al VFS en Linux:提供一个 capa abstracta sobre los sistemas de archivos concretos, permitiendo que múltiples file systems coexistan en el mismo sistema operativo.

### 1.2 ¿Para qué sirve?

- **Montaje de múltiples file systems**: Permite montar diferentes sistemas de archivos en diferentes puntos de montaje (ej: `/fatfs` para FAT FS, `/lfs` para LittleFS, `/nvs` para NVS).
- **Portabilidad de aplicaciones**: Las aplicaciones pueden usar la API genérica del VFS sin preocuparse por qué sistema de archivos físico se está usando.
- **Flexibilidad de hardware**: El mismo código puede funcionar con diferentes dispositivos de almacenamiento (flash interna, flash externa, tarjetas SD) sin cambios.

### 1.3 Arquitectura

```
┌─────────────────────────────────────┐
│         Aplicaciones                │
│    (usan API genérica del VFS)     │
└─────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│    Virtual File System Switch      │
│  (capa de abstracción uniforme)    │
└─────────────────────────────────────┘
              │
    ┌─────────┼──────────┐
    ▼         ▼          ▼
┌────────┐ ┌────────┐ ┌────────┐
│LittleFS│ │  FAT   │ │   NVS  │
│        │ │   FS   │ │        │
└────────┘ └────────┘ └────────┘
    │         │          │
    ▼         ▼          ▼
┌─────────────────────────────────────┐
│      Dispositivos de Almacenamiento │
│  (flash interna, flash externa, SD) │
└─────────────────────────────────────┘
```

### 1.4 Limitaciones del VFS

- El número máximo de tipos de file systems registados se controla con `CONFIG_FILE_SYSTEM_MAX_TYPES` (Kconfig).
- No todos los flags de POSIX están soportados completamente.
- No es POSIX compliant (solo similar a POSIX).

> **Fuente:** [Zephyr Documentation — File Systems](https://docs.zephyrproject.org/latest/services/storage/index.html)

---

## 2. LittleFS

### 2.1 ¿Qué es?

**LittleFS** es un sistema de archivos diseñado específicamente para **sistemas embebidos con memoria flash**. Fue creado por ARM Mbed y luego integrado en Zephyr como el file system recomendado para dispositivos IoT.

### 2.2 Características Principales

| Característica | Descripción |
|---|---|
| **Diseño para flash** | Optimizado para memorias flash NAND y NOR, trabajando directamente con las características de estas memorias (borrado en bloques, escritura limitada). |
| **Tolerante a fallas** | Diseñado para funcionar correctamente incluso ante cortes de energía inesperados (*power-loss tolerant*). Los datos se mantienen consistentes. |
| **Bajo overhead** | Diseñado para funcionar con recursos muy limitados. El consumo de RAM está estrictamente acotado y no crece con el tamaño del file system. |
| **Bounded RAM/ROM** | El uso de memoria RAM es fijo y predeterminado, sin importar el tamaño total del file system. |
| **Wear leveling** | Implementa algoritmos de distribución de escrituras (*wear leveling*) para maximizar la vida útil de la flash. |
| **Directorio recursivo** | Soporta estructuras de directorios anidados. |

### 2.3 Especificaciones Técnicas

- **RAM mínima**: Configurable, típicamente ~2 KB
- **ROM mínima**: ~4 KB
- **Versión en Zephyr**: Generalmente la versión 2.x
- **Licencia**: BSD-3-Clause (original), integraciones pueden tener variantes

### 2.4 ¿Para qué se usa?

LittleFS es ideal para:
- **Datos de configuración** que deben persistir entre reinicios
- **Logs de sensores** que se escriben frecuentemente
- **Archivos de aplicaciones** en dispositivos IoT
- **Almacenamiento en flash externa** (SPI NOR Flash)

### 2.5 Ejemplo de Uso en Zephyr

```c
#include <zephyr/fs/fs.h>

// Montar LittleFS
struct fs_mount_t mp = {
    .type = "littlefs",
    .mnt_point = "/lfs",
    .storage_dev = "SPI_FLASH_0",
};

fs_mount(&mp);

// Ahora se puede usar la API genérica
fs_open("/lfs/config.txt", FS_O_CREATE | FS_O_RDWR);
```

> **Fuente:** [LittleFS GitHub — Zephyr](https://github.com/zephyrproject-rtos/littlefs), [Zephyr LittleFS Sample](https://docs.zephyrproject.org/latest/samples/subsys/fs/littlefs/README.html)

---

## 3. FAT FS

### 3.1 ¿Qué es?

**FAT FS** en Zephyr es una implementación del sistema de archivos **FAT (File Allocation Table)** basada en la biblioteca **FatFs** de **ChaN (Elm-chan)**. FAT es el sistema de archivos clásico usado en tarjetas SD, memorias USB y discos antiguos.

### 3.2 Características Principales

| Característica | Descripción |
|---|---|
| **Implementación** | Basada en FatFs de ChaN (elm-chan.org), una biblioteca portable y ligera escrita en ANSI C. |
| **Variantes soportadas** | FAT12, FAT16, FAT32, exFAT |
| **Portable** | Separada completamente de la capa de I/O de disco, lo que facilita el porting a diferentes plataformas. |
| **ANSI C** | Implementada en C89, compatible con casi cualquier compilador. |
| **Licencia** | FatFs usa licencia BSD-3-Clause (ChaN permite uso comercial gratuito). |

### 3.3 ¿Para qué se usa?

- **Tarjetas SD**: Es el file system nativo de tarjetas SD formateadas en FAT.
- **Dispositivos USB**: Memorias USB típicamente usan FAT.
- **Interoperabilidad**: FAT es leído por几乎 todos los sistemas operativos (Windows, macOS, Linux), facilitando el intercambio de datos.

### 3.4 Configuración en Zephyr

En Kconfig se habilita con:
- `CONFIG_FAT_FILESYSTEM_ELM`: Usa la implementación "ELM" de ChaN

### 3.5 Consideraciones Importantes

- **No es tolerant a fallas**: Si hay un corte de energía durante una escritura, se pueden perder datos o corrupta el file system.
- **No tiene wear leveling**: FAT no está diseñado para memorias flash con limited write cycles.
- **Overhead mayor**: En comparación con LittleFS, FAT tiene mayor overhead en RAM y ROM.

> **Fuente:** [FatFs — Elm-chan.org](https://elm-chan.org/fsw/ff/00index_e.html), [Zephyr Documentation — File Systems](https://docs.zephyrproject.org/latest/services/storage/file_system/index.html)

---

## 4. NVS (Non-Volatile Storage)

### 4.1 ¿Qué es?

**NVS** es un sistema de almacenamiento **no volátil** de Zephyr diseñado específicamente para guardar **datos de configuración** en memoria flash. No es un sistema de archivos tradicional (no tiene estructura de directorios), sino un sistema de **almacenamiento clave-valor simplificado**.

### 4.2 Características Principales

| Característica | Descripción |
|---|---|
| **Almacenamiento clave-valor** | Permite almacenar datos identificados por un ID (clave), no por nombre de archivo. |
| **Para flash** | Optimizado para memorias flash, minimizando el número de escrituras para prolongar la vida útil. |
| **Wear leveling integrado** | NVS tiene su propio algoritmo para distribuir las escrituras y evitar el desgaste prematuro de sectores. |
| **Sin estructura de directorios** | Es un sistema plano: todos los datos se almacenan en un espacio común. |
| **Orientado a configuración** | Diseñado para guardar parámetros de configuración, no archivos general purpose. |

### 4.3 ¿Para qué se usa?

- **Parámetros de configuración**: Guardar valores como SSID de WiFi, credenciales, calibraciones de sensores.
- **Contadores**: Como un contador de reboots que se incrementa en cada encendido.
- **Datos de estado**: Guardar el último estado conocido de un dispositivo.

### 4.4 ¿Cómo funciona?

La flash se divide en **sectores**. Los elementos se van agregando a un sector hasta que se agota el espacio, y luego se usa un nuevo sector. NVS incluye **garbage collection** para recuperar espacio de datos eliminados.

### 4.5 Ejemplo de Uso

```c
#include <zephyr/drivers/nvs.h>

struct nvs_fs fs;
fs.offset = FLASH_AREA_OFFSET(storage);  // Partición configurada en Devicetree

nvs_init(&fs, "FLASH_0");

// Escribir un dato
uint8_t reboot_counter;
nvs_write(&fs, 1, &reboot_counter, sizeof(reboot_counter));

// Leer un dato
nvs_read(&fs, 1, &reboot_counter, sizeof(reboot_counter));
```

### 4.6 Limitaciones

- **No es un file system general**: No soporta archivos ni directorios.
- **IDs limitados**: Los datos se identifican por IDs (enteros), lo que puede ser menos intuitivo que nombres de archivos.
- **Garbage collection**: Puede haber un pequeño overhead durante la recuperación de espacio.

> **Fuente:** [Zephyr Documentation — Non-Volatile Storage (NVS)](https://docs.zephyrproject.org/latest/services/storage/nvs/nvs.html), [Understanding BLE Stack uses NVS on Zephyr — Baremetallics](https://baremetallics.com/blog/understanding-ble-with-nvs-on-zephyr)

---

## 5. API POSIX-like

### 5.1 ¿Qué es?

Zephyr provee una **API de sistema de archivos similar a POSIX** (pero **no compliant**), diseñada para que desarrolladores familiarizados con sistemas Unix/Linux puedan portar aplicaciones fácilmente.

### 5.2 Funciones Principales

| Función Zephyr | Descripción | Equivalente POSIX |
|---|---|---|
| `fs_open()` | Abre o crea un archivo | `open()` |
| `fs_close()` | Cierra un archivo | `close()` |
| `fs_read()` | Lee datos de un archivo | `read()` |
| `fs_write()` | Escribe datos en un archivo | `write()` |
| `fs_unlink()` | Elimina un archivo | `unlink()` |
| `fs_rename()` | Renombra un archivo | `rename()` |
| `fs_mkdir()` | Crea un directorio | `mkdir()` |
| `fs_opendir()` | Abre un directorio | `opendir()` |
| `fs_readdir()` | Lee entradas de un directorio | `readdir()` |
| `fs_mount()` | Monta un sistema de archivos | `mount()` |
| `fs_unmount()` | Desmonta un sistema de archivos | `umount()` |

### 5.3 Flags de Apertura

```c
#define FS_O_READ   0x01    // Lectura
#define FS_O_WRITE  0x02    // Escritura
#define FS_O_CREATE 0x04    // Crear si no existe
#define FS_O_APPEND 0x08    // Append
```

### 5.4 Limitaciones de la API

- **No es POSIX compliant**: Aunque las funciones son similares, hay diferencias y funciones POSIX no implementadas.
- **No todos los flags soportados**: Algunos flags de `open()` de POSIX no están disponibles.
- **Nomenclatura diferente**: Las funciones tienen prefijo `fs_` en lugar de no tener prefijo.

### 5.5 Ejemplo

```c
#include <zephyr/fs/fs.h>

struct fs_file_t fp;

fs_open(&fp, "/lfs/data.txt", FS_O_CREATE | FS_O_RDWR);
fs_write(&fp, buffer, sizeof(buffer), &bytes_written);
fs_close(&fp);
```

> **Fuente:** [Zephyr File System API Documentation](https://docs.zephyrproject.org/latest/doxygen/html/group__file__system__api.html), [GitHub Issue — POSIX-like API design](https://github.com/zephyrproject-rtos/zephyr/issues/1792)

---

## 6. Limitaciones y Consideraciones Importantes

### 6.1 Consideraciones Generales

| Aspecto | Consideración |
|---|---|
| **No hay memoria virtual** | En la mayoría de las plataformas embebidas no hay MMU, así que no hay protección de memoria a nivel de procesos. |
| **Recursos limitados** | El tamaño del file system y la cantidad de archivos están limitados por la memoria disponible del dispositivo. |
| **Sin soporte de symbolic links** | No hay soporte para enlaces simbólicos en la implementación actual. |
| **No hay permissions Unix** | No hay sistema de permisos tipo Unix (rwx). |
| **Sin soporte de archivos dispersos** | No hay soporte para archivos dispersos (*sparse files*). |

### 6.2 LittleFS vs FAT FS vs NVS

| Criterio | **LittleFS** | **FAT FS** | **NVS** |
|---|---|---|---|
| **Uso recomendado** | Archivos generales en flash | Tarjetas SD, USB | Configuración simple |
| **Tolerancia a fallas** | ✅ Alta | ❌ Baja | ✅ Alta |
| **Wear leveling** | ✅ Sí | ❌ No | ✅ Sí |
| **Estructura de directorios** | ✅ Sí | ✅ Sí | ❌ No |
| **RAM/ROM overhead** | Bajo | Medio | Muy bajo |
| **Interoperabilidad** | Baja | ✅ Alta (todos los SO) | Baja |

### 6.3 Recomendaciones de Uso

1. **Para datos de configuración**: Usar **NVS** — es más simple y eficiente para datos pequeños.
2. **Para archivos generales en flash**: Usar **LittleFS** — tolerante a fallas y eficiente.
3. **Para tarjetas SD o intercambio con PC**: Usar **FAT FS** — compatibilidad universal.
4. **Nunca usar FAT para flash interna**: FAT no tiene wear leveling y puede destruir la memoria flash rápidamente.

### 6.4 Seguridad

- **No hay encryption automático**: Los datos se almacenan en texto plano. Para datos sensibles, usar **Secure Storage** (basado en PSA) que implementa cifrado.
- **Sin protección de archivos**: No hay mecanismo de protección de archivos individuales contra acceso no autorizado.

> **Fuente:** [Zephyr Documentation — File Systems](https://docs.zephyrproject.org/latest/services/storage/index.html)

---

## Fuentes

1. **Zephyr Documentation — File Systems**
   [docs.zephyrproject.org/latest/services/storage/index.html](https://docs.zephyrproject.org/latest/services/storage/index.html)

2. **Zephyr Documentation — Non-Volatile Storage (NVS)**
   [docs.zephyrproject.org/latest/services/storage/nvs/nvs.html](https://docs.zephyrproject.org/latest/services/storage/nvs/nvs.html)

3. **LittleFS GitHub — Zephyr Project**
   [github.com/zephyrproject-rtos/littlefs](https://github.com/zephyrproject-rtos/littlefs)

4. **FatFs — Elm-chan.org**
   [elm-chan.org/fsw/ff/00index_e.html](https://elm-chan.org/fsw/ff/00index_e.html)

5. **Nordic Semiconductor — File Systems Documentation**
   [docs.nordicsemi.com/bundle/ncs-3.1.0/page/zephyr/services/file_system/index.html](https://docs.nordicsemi.com/bundle/ncs-3.1.0/page/zephyr/services/file_system/index.html)

6. **Zephyr File System API Reference**
   [docs.zephyrproject.org/latest/doxygen/html/group__file__system__api.html](https://docs.zephyrproject.org/latest/doxygen/html/group__file__system__api.html)

7. **Understanding BLE Stack uses NVS on Zephyr — Baremetallics**
   [baremetallics.com/blog/understanding-ble-with-nvs-on-zephyr](https://baremetallics.com/blog/understanding-ble-with-nvs-on-zephyr)

8. **Antmicro — Improved Zephyr Virtual Filesystem**
   [antmicro.com/blog/2026/02/improved-zephyr-virtual-filesystem/](https://antmicro.com/blog/2026/02/improved-zephyr-virtual-filesystem/)

---

*Documento preparado para el Trabajo Práctico Especial de Fundamentos de Sistemas Operativos. Última actualización: mayo 2026.*

---
## Nota Académica — Fundamentos de SO
**Conceptos de la materia relacionados:**

- **§3.1 — Sistema de archivos en sentido amplio vs estricto**: El VFS de Zephyr implementa el concepto de sistema de archivos en sentido amplio: no es un FS concreto sino una capa de abstracción que unifica el acceso a LittleFS, FAT FS y NVS bajo una interfaz común. Cada implementación subyacente es un FS en sentido estricto.

- **§3.3 — Atributos de archivo**: Zephyr diverge del modelo UNIX tradicional. NVS carece de nombre de archivo e i-nodo (usa IDs numéricos como claves). FAT FS no usa i-nodos sino una File Allocation Table centralizada. LittleFS implementa metadatos propios en superbloques, no i-nodos UNIX. No hay permisos Unix (rwx) — no hay protección de archivos entre aplicaciones.

- **§3.4 — Operaciones sobre archivos**: La API POSIX-like implementa exactamente las operaciones básicas del temario: `fs_open()` y `fs_close()` (open/close), `fs_read()` y `fs_write()` (read/write), `fs_unlink()` (delete), `fs_mkdir()` (create), `fs_rename()` — todas presentes. NVS añade `nvs_write()`/`nvs_read()` con semántica de clave-valor que no corresponde al modelo tradicional de archivos.

- **§3.5 — Métodos de acceso**: LittleFS y FAT FS soportan acceso secuencial y directo (seek). NVS es exclusivamente acceso directo por clave — no hay concepto de.seek ni acceso secuencial.

- **§3.6 — Métodos de asignación de espacio**: El temario cubre contiguo, enlazado, FAT e i-nodos. Zephyr materializa esta diversidad: **FAT FS** usa el método FAT (File Allocation Table) donde una tabla centralizada indica qué bloques pertenecen a cada archivo. **LittleFS** usa un enfoque log-structured con wear leveling dinámico, diferente de los tres métodos clásicos. **NVS** usa espacio plano por sectores sin estructura de archivos.

- **§3.7 — Estructura de directorios**: LittleFS soporta directorios jerárquicos recursivos (anidados). FAT FS también soporta estructura jerárquica de directorios. NVS es flat/single-level — todos los datos en un espacio común sin organización jerárquica de carpetas.

- **§3.8 — Enlaces (hard links, symbolic links)**: El documento indica explícitamente que **no hay soporte para symbolic links** en Zephyr. No se mencionan hard links. Esto representa una diferencia notable respecto al modelo UNIX donde ambos tipos de enlaces existen.

- **§3.9 — UNIX vs DOS**: Zephyr no es POSIX compliant (solo "similar a POSIX"), carece de i-nodos y no tiene modelo de permisos UNIX. En esto se parece más a DOS/Windows que a UNIX: los archivos no tienen owner, group ni permisos rwx. NVS ni siquiera tiene nombres de archivo — solo IDs numéricos, alejándose completamente del modelo UNIX de nombres de archivo.
