# Slide 07 — Explicación: Sistema de Archivos de Zephyr OS

## Contexto y Propósito

Esta slide introduce el subsistema de almacenamiento de Zephyr OS, un RTOS de tiempo real diseñado para sistemas embebidos con recursos extremadamente restringidos (microcontroladores de 32 bits con desde 256 KB hasta varios MB de flash). El sistema de archivos en Zephyr no es una reminiscencia de los sistemas de archivos de escritorio o servidor — es una solución pragmática para dispositivos IoT donde la eficiencia energética, la duración de la memoria flash y la determinismo temporal son más importantes que la capacidad de almacenar millones de archivos o permisos granulares.

La slide presenta una arquitectura de tres niveles: la capa VFS como abstracción superior, tres implementaciones de almacenamiento (LittleFS, FAT FS, NVS) en el medio, y los dispositivos de almacenamiento físico (flash interna, flash SPI externa, tarjetas SD) en la base. Esta jerarquía permite que aplicaciones usen una API uniforme independientemente del hardware subyacente.

---

## 1. Virtual File System Switch (VFS)

### 1.1 Concepto y Propósito

El **Virtual File System Switch (VFS)** es una capa de abstracción que actúa como intermediario entre las aplicaciones de usuario y las implementaciones concretas de sistemas de archivos. Su diseño responde a un problema práctico: en un sistema embebido IoT, el mismo dispositivo puede tener múltiples dispositivos de almacenamiento con características radicalmente diferentes — flash NAND interna, flash SPI externa, tarjeta SD — y cada uno requiere un sistema de archivos optimizado para sus características físicas.

El VFS resuelve esto proporcionando una **interfaz uniforme** (API POSIX-like) que oculta los detalles de implementación de cada FS concreto. La aplicación llama a `fs_open()`, `fs_read()`, `fs_write()` sin saber si los datos irán a LittleFS en flash interna o a FAT FS en una tarjeta SD. Esta separación entre interfaz y implementación es un patrón de diseño clásico en sistemas operativos, y el VFS de Zephyr sigue el mismo concepto que el VFS en Linux.

### 1.2 Arquitectura y Funcionamiento

```
┌─────────────────────────────────────────────────────┐
│              Aplicaciones de Usuario                │
│   (usan fs_open(), fs_read(), fs_write(), etc.)     │
└─────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────┐
│       Virtual File System Switch (VFS)              │
│   · Despacha llamadas a FS concretos               │
│   · Maneja puntos de montaje (/lfs, /fatfs, /nvs)   │
│   · Provee API genérica independente del FS         │
└─────────────────────────────────────────────────────┘
           │                │                │
           ▼                ▼                ▼
    ┌───────────┐    ┌───────────┐    ┌───────────┐
    │  LittleFS │    │   FAT FS  │    │    NVS    │
    │           │    │           │    │           │
    └───────────┘    └───────────┘    └───────────┘
           │                │                │
           ▼                ▼                ▼
    ┌─────────────────────────────────────────────┐
    │     Dispositivos de Almacenamiento          │
    │  Flash interna │ SD card │ Flash SPI       │
    └─────────────────────────────────────────────┘
```

El VFS mantiene internamente una tabla de sistemas de archivos registrados. Cuando una aplicación abre `/lfs/config.txt`, el VFS identifica que el prefijo `/lfs` corresponde a un punto de montaje LittleFS, y delega la operación al handler correspondiente. Cuando abre `/fatfs/datos.bin`, reconoce el punto de montaje FAT y usa la implementación FatFs.

### 1.3 API POSIX-like

Zephyr provee funciones que miman la firma de llamadas al sistema POSIX, pero el documentación oficial aclara que **no es POSIX compliant** — es "POSIX-like". Las funciones principales son:

| Función Zephyr | Función POSIX equivalente | Descripción |
|---------------|---------------------------|-------------|
| `fs_open()` | `open()` | Abre o crea archivo |
| `fs_close()` | `close()` | Cierra archivo |
| `fs_read()` | `read()` | Lee bytes |
| `fs_write()` | `write()` | Escribe bytes |
| `fs_unlink()` | `unlink()` | Elimina archivo |
| `fs_mkdir()` | `mkdir()` | Crea directorio |
| `fs_opendir()` / `fs_readdir()` | `opendir()` / `readdir()` | Lee entradas de directorio |

Los flags de apertura son un subconjunto de POSIX:
- `FS_O_READ` — abrir para lectura
- `FS_O_WRITE` — abrir para escritura
- `FS_O_CREATE` — crear si no existe
- `FS_O_APPEND` — posicionar al final en cada escritura

### 1.4 Limitaciones del VFS en Zephyr

- **No es POSIX compliant**: Aunque la interfaz se inspira en POSIX, hay diferencias significativas. No todas las flags de `open()` están disponibles, y funciones como `fcntl()`, `flock()`, `mmap()` no existen.
- **Límite configurable**: El número máximo de tipos de FS registrados se controla vía `CONFIG_FILE_SYSTEM_MAX_TYPES` en Kconfig.
- **Sin memoria virtual**: La mayoría de los microcontroladores ejecutando Zephyr no tienen MMU, así que no hay aislamiento de memoria entre procesos ni protección de archivos.

---

## 2. LittleFS — Sistema de Archivos Log-Structured

### 2.1 Origen y Diseño

LittleFS fue creado por ARM Mbed específicamente para memorias flash en sistemas embebidos con recursos extremadamente limitados. La versión integrada en Zephyr es la branch del Zephyr Project (versión 2.x), adaptada para el API de Zephyr y mantenida como parte del proyecto.

A diferencia de sistemas de archivos tradicionales diseñados para discos magnéticos (donde la ubicación física de los datos es casi irrelevante), LittleFS está diseñado desde el primer día para las **características físico-eléctricas de las memorias flash**:

- **Borrado en bloques**: Las celdas de flash solo pueden pasar de 1 a 0 mediante programación, pero para volver a 1 deben borrarse en grupo (típicamente sectores de 4 KB a 128 KB). Escribir es rápido; borrar es lento.
- **Ciclos de escritura limitados**: Cada celda de flash tiene un número finito de ciclos de borrado/escritura (típicamente 10,000 a 100,000 para NAND, hasta 1,000,000 para NOR). Después de ese límite, la celda se degrada.
- **Power loss**: Un corte de energía durante una escritura puede dejar datos en estado inconsistente.

### 2.2 Almacenamiento Log-Structured

La diferencia más fundamental entre LittleFS y FAT FS es su **estructura log-structured** (también llamada "log-structured file system" o LFS).

En un sistema de archivos tradicional (como ext4 o FAT), cuando se modifica un archivo, se sobrescriben los bloques viejos en su ubicación original. Esto causa dos problemas en flash:

1. **Fragmentación**: El archivo queda esparcido por toda la memoria, aumentando el número de operaciones de lectura/escritura.
2. **Wear uneven**: Los bloques frecuentemente modificados se desgastan mucho más rápido que otros (hot spots vs cold spots).

LittleFS resuelve esto con un enfoque de **log append-only**: en lugar de sobrescribir datos en su ubicación original, toda escritura nueva se añade al **final del log**. Las modificaciones anteriores no se borran inmediatamente — quedan como entradas inválidas. El proceso de **compactación** (garbage collection) se encarga periódicamente de recorrerr el storage, copiar los datos válidos al inicio del log, y reclamar el espacio de las entradas obsoletas.

```
Estado del storage en el tiempo:

T1: [Bloque A] [Bloque B] [Bloque C] [Espacio libre]
    archivo_v1   archivo_v2  archivo_v3

T2 (modificamos archivo_v2): 
    [Bloque A] [Bloque B'] [Bloque C] [Espacio libre]
    archivo_v1   archivo_v2' (nueva versión), archivo_v3
    Bloque B queda como "obsoleto" pero no se borra todavía
```

Este enfoque tiene consecuencias importantes:

- **Escrituras distribuidas**: Como siempre se escribe al final del log, las escrituras se distribuyen uniformemente por toda la flash — esto es el **wear leveling** natural.
- **Tolerancia a power loss**: Si hay un corte de energía durante una escritura, la estructura del log permite recovery. Las transacciones se graban de forma atómica (usando un mecanismo de "commit blocks"), asegurando consistencia.
- **No hay sobrescrituras**: Los bloques nunca se sobrescriben hasta que el garbage collector los reclama, lo que maximiza la vida útil de la flash.

### 2.3 Wear Leveling

El **wear leveling** es un conjunto de técnicas cuyo objetivo es distribuir las escrituras uniformemente por todos los bloques de la memoria flash, evitando que un bloque particular se degrade prematuramente mientras otros siguen casi vacíos.

LittleFS implementa wear leveling a nivel de:

1. **Bloques de datos**: El garbage collector monitorea el número de borrados de cada bloque. Cuando detecta que algunos bloques tienen más ciclos que otros, reubica datos para nivelar la distribución.
2. **Superbloque redundante**: LittleFS mantiene múltiples superbloques distribuidos por toda la flash. Si uno se corrompe, puede reconstruirse la metadata desde otro. Los superbloques también rotan su ubicación para distribuir el desgaste.

El resultado práctico es que la vida útil de la flash se extiende drásticamente. Una memoria flash que sin wear leveling podría fallar después de 50,000 escrituras en los mismos 100 bloques, con wear leveling efectivo puede durar 50,000 × (capacidad total en bloques / bloques activos) ciclos.

### 2.4 Especificaciones y Recursos

LittleFS está diseñado para operar con recursos mínimos:

| Recurso | Valor típico |
|---------|-------------|
| RAM mínima | ~2 KB |
| ROM mínima | ~4 KB |
| Bloque de almacenamiento | 4 KB a 128 KB (configurable) |
| Tamaño máximo de filesystem | Limitado solo por el dispositivo |

La RAM fija es una característica crítica: no crece con el tamaño del filesystem ni con la cantidad de archivos. Esto lo hace predecible y مناسب para sistemas de tiempo real.

### 2.5 Tolerancia a Fallas (Power-Loss Tolerance)

LittleFS está diseñado para sobrevivir cortes de energía inesperados sin corromperse. Los mecanismos incluyen:

- **Transacciones atómicas**: Antes de marcar un bloque como válido, LittleFS escribe marcadores de transacción en el superbloque. Si hay un corte, el sistema puede determinar el último estado consistente.
- **Copy-on-write**: Las modificaciones nunca sobrescriben datos directamente; siempre se escribe una nueva copia y luego se actualiza el puntero atómicamente.
- **CRC en todas las estructuras**: Cada estructura de metadata tiene Checksums CRC que permiten detectar corrupción.

En la práctica, si un corte de energía ocurre durante una escritura, LittleFS recupera un estado consistente al reinicio, sin pérdida de datos ya committed.

### 2.6 Casos de Uso Recomendados para LittleFS

- **Datos de configuración que deben sobrevivir reinicios**: Parametrización de sensores, credenciales WiFi, datos de calibración.
- **Logs de sensores**: Archivos que se escriben frecuentemente y deben ser tolerantes a crashes.
- **Archivos de aplicación en flash interna**: Datos de la aplicación que necesitan estructura de archivos y directorios.
- **Flash SPI externa**: Donde se necesita un filesystem completo con resistencia al desgaste.

---

## 3. FAT FS — File Allocation Table

### 3.1 Implementación

FAT FS en Zephyr es una implementación basada en la biblioteca **FatFs** de **ChaN (Elm-chan)**. ChaN es un desarrollador japonés que mantiene FatFs como proyecto open source desde hace décadas; es la implementación de FAT más usada en sistemas embebidos por su portabilidad, tamaño reducido y licencia permisiva (BSD-3-Clause).

Zephyr usa la implementación "ELM" (CONFIG_FAT_FILESYSTEM_ELM), que es la versión completa de FatFs con soporte para FAT12, FAT16, FAT32 y exFAT.

### 3.2 Método de Asignación FAT

FAT (File Allocation Table) es el método de asignación que da nombre al filesystem. La estructura básica:

- **Tabla FAT**: Una array en memoria (y duplicada en flash para redundancia) donde cada entrada corresponde a un cluster del disco. La entrada indica cuál es el siguiente cluster del archivo, o marca el final (EOF), o marca un cluster defectuoso.
- **Directorio raíz**: Una entrada especial al inicio del filesystem que lista los archivos en el directorio raíz, con atributos, timestamps, y puntero al primer cluster.
- **Clusters de datos**: Los bloques físicos donde se almacenan los datos de los archivos.

```
Ejemplo simplificado deFAT para archivo "datos.bin" que ocupa clusters 5, 6, 9:

FAT[5] = 6    (continúa en cluster 6)
FAT[6] = 9    (continúa en cluster 9)
FAT[9] = EOF  (fin de archivo)
FAT[10] = 0   (cluster libre)
...
```

Este método corresponde directamente a lo que el temario de FSO llama "FAT" como método de asignación (§3.6): una tabla en memoria centralizada con cadena de bloques. A diferencia del método de i-nodos (UNIX), no hay una estructura de metadata separada por archivo; toda la información de ubicación está en la FAT central.

### 3.3 Compatibilidad y Limitaciones

La ventaja fundamental de FAT es su **universalidad**: prácticamente todos los sistemas operativos del mundo pueden leer/escribir FAT (Windows, macOS, Linux, BSD). Una tarjeta SD formateada en FAT puede intercambiarse entre una PC y un microcontrolador sin problemas.

Sin embargo, FAT tiene problemas significativos para flash:

- **Sin wear leveling**: FAT fue diseñado para discos magnéticos donde las escrituras son prácticamente ilimitadas. En flash, los bloques que se modifican frecuentemente (como entradas de directorio o la FAT misma) se desgastan rápidamente.
- **No es power-loss tolerant**: Si un corte de energía ocurre durante una escritura, es fácil corrupta el filesystem. No hay mecanismo de transacciones atómicas.
- **La FAT debe mantenerse en memoria**: En operaciones frecuentes, esto consume RAM.
- **Fragmentación**: Con el uso, los archivos quedan esparcidos por clusters no contiguos, aumentando los accesos de lectura.

Por estas razones, FAT FS en Zephyr está recomendado **solo para tarjetas SD y dispositivos USB** — nunca para la flash interna del microcontrolador.

### 3.4 Estructura de Directorios

FAT usa una estructura de árbol jerárquico con entradas de directorio que contienen:

- Nombre del archivo (formato 8.3, o LFNB para long file names en VFAT)
- Atributos (readonly, hidden, system, archive, directory)
- Timestamp de creación/modificación
- Puntero al primer cluster
- Tamaño del archivo

Esta estructura es diferente del modelo UNIX: en FAT, el nombre del archivo y sus metadatos viven en la entrada de directorio, no hay i-nodos separados. Cada entrada de directorio es de tamaño fijo (32 bytes). Este modelo corresponde más al sentido estricto de §3.1 donde el FS es principalmente una estructura de datos en disco.

---

## 4. NVS — Non-Volatile Storage

### 4.1 Diseño y Propósito

NVS es un sistema de almacenamiento **no volátil simplificado** diseñado específicamente para guardar datos de **configuración** en memoria flash. A diferencia de LittleFS y FAT FS, NVS **no es un sistema de archivos tradicional** — no tiene estructura de directorios, no tiene nombres de archivo, no tiene archivos en el sentido convencional.

NVS implementa un modelo de **almacenamiento clave-valor**: los datos se identifican por una **clave** (un ID numérico entero), no por un nombre de archivo. Esto es análogo a un diccionario o hash map persistido en flash.

### 4.2 Funcionamiento Interno

Internamente, NVS divide la flash en **sectores** (del tamaño de un erase block, típicamente 4 KB). Los datos se almacenan de forma append-only dentro de cada sector:

1. Cuando se escribe un dato, NVS lo añade al final del sector activo.
2. Cuando el sector se llena, se crea un nuevo sector.
3. El proceso de **garbage collection** periódicamente recorre sectores antiguos, eliminando datos marcados como borrados, y preparando sectores para reutilización.

Los datos tienen:
- **ID (clave)**: Entero de 8 o 16 bits que identifica el dato
- **DATA**: Contenido binario
- **CRC**: Para detección de corrupción

### 4.3 ¿Por qué NVS para IoT?

NVS es la solución ideal para el problema común en dispositivos IoT de guardar parámetros de configuración:

**Ejemplo**: Un sensor de temperatura que debe recordar:
- SSID y password del WiFi (strings de ~32-64 bytes)
- Intervalo de muestreo (entero de 4 bytes)
- Offset de calibración (float de 4 bytes)
- Contador de reinicios (entero de 4 bytes)
- Última medición (float de 4 bytes)

Con un filesystem tradicional (LittleFS), esto requeriría crear archivos como `wifi.cfg`, `calibration.dat`, y usar `fopen()`/`fread()`/`fwrite()`. Con NVS, simplemente:

```c
// Escribir WiFi config
char ssid[] = "MiRed";
char password[] = "MiPassword123";
nvs_write(&fs, 1, ssid, strlen(ssid));
nvs_write(&fs, 2, password, strlen(password));

// Escribir calibración
float offset = 0.5;
nvs_write(&fs, 10, &offset, sizeof(offset));

// Leer al arrancar
nvs_read(&fs, 10, &offset, sizeof(offset));
```

No hay que preocuparse por paths, apertura/cierre de archivos, ni gestión de estructuras de directorio. La simplicidad es el diseño.

### 4.4 Wear Leveling en NVS

NVS implementa su propio algoritmo de wear leveling para distribuir las escrituras uniformemente por todos los sectores. Esto es crítico porque los datos de configuración como un contador de reinicios se incrementan en cada boot — si el mismo sector fuera sobrescrito, fallaría prematuramente.

El garbage collection de NVS también ayuda: al mover datos a sectores nuevos, distribuye el desgaste.

### 4.5 Limitaciones de NVS

- **Sin estructura de archivos**: No hay directorios, no hay nombres de archivo. Solo IDs numéricos.
- **IDs limitados**: Dependiendo de la configuración, los IDs son 8-bit (0-255) o 16-bit (0-65535).
- **No hay acceso secuencial**: Solo acceso directo por clave. No hay concepto de "leer los próximos 100 bytes".
- **Garbage collection overhead**: El proceso de reclaim de espacio puede causar latency spikes no deseados en aplicaciones de tiempo real.

---

## 5. Comparación con Sistemas de Archivos Tradicionales (UNIX/DOS)

### 5.1 Diferencias Estructurales

La slide incluye una comparacion crítica que conecta con los conceptos de FSO:

| Característica | Sistemas UNIX (ext4, XFS) | Zephyr (sin NVS) | NVS |
|---------------|--------------------------|------------------|-----|
| **I-nodos** | Sí, estructura separada con metadata | No (FAT usa tabla centralizada) | No |
| **Permisos rwx** | Propietario, grupo, otros | No | No |
| **Enlaces simbólicos** | Sí | No | No |
| **Estructura de directorios** | Jerárquica, recursiva | Jerárquica (LittleFS, FAT) | Flat |
| **Modelo de nombres** | Path absoluto, nombres flexibles | Path, nombres limitados | IDs numéricos |
| **Control de acceso** | ACLs, propietarios | Ninguno | Ninguno |

### 5.2 Relación con el Temario de FSO

La nota académica de la slide conecta explícitamente con el temario:

**§3.1 — Sistema de archivos en sentido amplio vs estricto**:
El VFS implementa el concepto de FS en sentido amplio: es la capa de software completa que gestiona archivos (API + estructuras de datos + servicios). Cada FS concreto (LittleFS, FAT) es un FS en sentido estricto, la estructura de datos en el almacenamiento.

**§3.5 — Métodos de acceso**:
- LittleFS y FAT FS: Soportan acceso **secuencial** (leer byte por byte) y acceso **directo** (fs_seek() para posicionar el puntero).
- NVS: Solo acceso **directo** por clave. No hay seek, no hay acceso secuencial.

**§3.6 — Métodos de asignación**:
- **FAT FS**: Usa el método FAT (File Allocation Table) — una tabla centralizada que encadena clusters.
- **LittleFS**: Usa un enfoque **log-structured** que no corresponde exactamente a ninguno de los tres métodos clásicos (contiguo, enlazado, i-nodos). Es una variante de log-structured con copy-on-write.
- **NVS**: Sin método de asignación tradicional — espacio plano por sectores con garbage collection.

**§3.8 — Enlaces**:
No hay soporte para symbolic links ni hard links en Zephyr. Esto diverge del modelo UNIX donde los enlaces son una característica fundamental.

**§3.9 — UNIX vs DOS**:
Zephyr se parece más a DOS que a UNIX en muchos aspectos: no hay i-nodos, no hay permisos, los nombres de archivo en FAT siguen el formato 8.3. NVS ni siquiera tiene nombres de archivo — es más cercano a una EEPROM simplificada.

---

## 6. Glosario de Términos

### VFS (Virtual File System Switch)
Capa de abstracción que provee una interfaz uniforme para acceder a múltiples sistemas de archivos concretos. Permite que aplicaciones usen la misma API independientemente del FS subyacente (LittleFS, FAT, NVS).

### LittleFS
Sistema de archivos log-structured diseñado para flash embebida. Implementa wear leveling automático, tolerancia a power loss, y usa RAM fija bounded que no crece con el tamaño del filesystem. Ideal para flash NAND/NOR interna.

### Log-Structured Storage
Patrón de diseño donde todas las escrituras se añaden al final de un log en lugar de sobrescribir datos en su ubicación original. Maximiza la vida útil de la flash al distribuir escrituras uniformemente y permite recover de power loss.

### Wear Leveling
Conjunto de técnicas para distribuir均匀emente las operaciones de escritura por todos los bloques de una memoria flash, evitando que bloques frecuentemente escritos se degraden prematuramente. Implementado tanto en LittleFS (a nivel de bloques de datos y superbloques) como en NVS (a nivel de sectores con garbage collection).

### FAT FS (File Allocation Table)
Sistema de archivos basado en la tabla FAT (File Allocation Table), una estructura centralizada que encadena clusters para formar archivos. Implementación de ChaN (FatFs) integrada en Zephyr. Soporta FAT12/FAT16/FAT32/exFAT. Universalmente compatible con todos los sistemas operativos, pero no tiene wear leveling ni tolerancia a power loss.

### NVS (Non-Volatile Storage)
Sistema de almacenamiento clave-valor simplificado para datos de configuración en flash. Usa IDs numéricos en lugar de nombres de archivo. Diseñado para minimizar overhead y maximizar vida útil de la flash mediante wear leveling integrado.

### Flash NAND/NOR
Tipos de memoria no volátil. NAND ofrece mayor densidad y velocidad de escritura, pero menor durabilidad (ciclos de borrado). NOR ofrece mejor耐久abilidad y lectura aleatoria rápida, pero menor densidad. LittleFS está optimizado para ambos tipos.

### Garbage Collection
Proceso en sistemas log-structured y NVS que reclamation el espacio ocupado por datos obsoletos. En LittleFS, compacta el log copiando datos válidos al inicio. En NVS, recorre sectores para eliminar entradas marcadas como borradas.

### Power-Loss Tolerance
Capacidad de un sistema de archivos para mantener consistencia incluso si hay un corte de energía inesperado durante una operación de escritura. LittleFS implementa transacciones atómicas y CRC checksums para garantizar recovery a un estado consistente.

### API POSIX-like
Interfaz de programación inspirada en POSIX pero que no cumple completamente con el estándar. Zephyr implementa funciones como fs_open(), fs_read(), fs_write() con firmas similares a open(), read(), write(), pero con limitaciones y diferencias respecto al estándar POSIX.

---

## 7. Recomendaciones de Uso según el Caso

| Escenario | Sistema de archivos recomendado |
|-----------|--------------------------------|
| Datos de configuración (SSID, credenciales, calibración) | **NVS** — más eficiente y simple para datos pequeños |
| Archivos generales en flash interna | **LittleFS** — tolerante a fallas, wear leveling |
| Tarjeta SD o intercambio con PC | **FAT FS** — compatibilidad universal |
| Flash interna del microcontrolador | **NUNCA FAT FS** — destruiría la memoria por falta de wear leveling |
| Logs que deben sobrevivir crashes | **LittleFS** — power-loss tolerant |
| Datos que se escriben una vez y nunca más | **LittleFS** o **FAT FS** |

---

## 8. Fuentes y Referencias

La información de esta slide proviene exclusivamente de:

1. **Zephyr Documentation — File Systems**
   https://docs.zephyrproject.org/latest/services/storage/index.html

2. **Zephyr Documentation — NVS (Non-Volatile Storage)**
   https://docs.zephyrproject.org/latest/services/storage/nvs/nvs.html

3. **LittleFS — Zephyr Project**
   https://github.com/zephyrproject-rtos/littlefs

4. **FatFs — Elm-chan.org** (ChaN)
   https://elm-chan.org/fsw/ff/00index_e.html

5. **Zephyr File System API Reference**
   https://docs.zephyrproject.org/latest/doxygen/html/group__file__system__api.html

6. **Understanding BLE Stack uses NVS on Zephyr — Baremetallics**
   https://baremetallics.com/blog/understanding-ble-with-nvs-on-zephyr

---

*Explicación generada para el TP Especial de Fundamentos de Sistemas Operativos — Zephyr MOSIX. Basada en documentación oficial de Zephyr Project y temario de la materia.*