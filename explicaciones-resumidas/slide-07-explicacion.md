# Slide 07 — Sistema de Archivos de Zephyr OS (Resumen)

## Contexto

Zephyr OS es un RTOS (sistema operativo de tiempo real) para sistemas embebidos con recursos muy limitados. Su sistema de archivos tiene tres niveles:

```
Aplicaciones (fs_open, fs_read, fs_write)
        │
        ▼
   VFS (capa de abstracción)
        │
  ┌─────┼─────┐
  ▼     ▼     ▼
LittleFS  FAT FS  NVS
  │       │       │
  ▼       ▼       ▼
Flash   SD card  Flash
interna  USB    interna
```

---

## 1. VFS — Virtual File System Switch

**Propósito**: Proveer una API única para que las aplicaciones no necesiten saber en qué hardware se almacena la información.

- Oculta las diferencias entre LittleFS, FAT y NVS
- Mantiene puntos de montaje (`/lfs`, `/fatfs`, `/nvs`)
- API estilo POSIX: `fs_open()`, `fs_read()`, `fs_write()`, `fs_mkdir()`, etc.
- **No es POSIX compliant**: faltan funciones como `fcntl()`, `flock()`, `mmap()`
- Sin memoria virtual ni aislamiento entre procesos (la mayoría de los MCUs no tienen MMU)

---

## 2. LittleFS — Para flash interna

### ¿Qué es?

Sistema de archivos **log-structured** (escribe al final del log, nunca sobrescribe datos viejo directamente). Diseñado para memorias flash en sistemas embebidos.

### Características principales

| Característica | Detalle |
|----------------|---------|
| RAM mínima | ~2 KB (fija, no crece con el FS) |
| ROM mínima | ~4 KB |
| Bloque | 4 KB a 128 KB |
| Wear leveling | Automático, distribuido por todo el storage |
| Tolerancia a power loss | Sí, mediante transacciones atómicas y CRC |
| Tamaño máximo | Solo limitado por el dispositivo |

### ¿Cómo funciona?

1. Toda escritura se añade al **final del log**
2. Los datos old no se borran inmediatamente — quedan como "obsoletos"
3. El **garbage collection** compacta periódicamente: copia datos válidos al inicio y reclama espacio

### Wear Leveling

- El garbage collector monitorea cuántos ciclos de borrado tiene cada bloque
- Si detecta desequilibrio, reubica datos para nivelar el desgaste
- Mantiene múltiples superbloques redundantes distribuidos por la flash
- **Resultado**: la vida útil de la flash se extiende drásticamente

### Tolerancia a fallas

- **Copy-on-write**: nunca sobrescribe datos directamente; escribe una nueva copia y actualiza el puntero atómicamente
- **CRC en todas las estructuras**: detecta datos corruptos
- **Transacciones atómicas**: marcadores en el superbloque permiten recovery al reinicio

### Casos de uso
- Datos de configuración que deben sobrevivir reinicios
- Logs de sensores (frecuentemente escritos)
- Archivos en flash interna
- Flash SPI externa

---

## 3. FAT FS — Para tarjetas SD y USB

### ¿Qué es?

Implementación de **FatFs** de ChaN (Elm-chan). Soporta FAT12, FAT16, FAT32 y exFAT.

### Estructura

- **Tabla FAT**: array donde cada entrada indica el siguiente cluster del archivo (o EOF)
- **Directorio raíz**: lista de archivos con atributos, timestamps y puntero al primer cluster
- **Clusters de datos**: bloques físicos de datos

### Ejemplo simplificado

Para un archivo que ocupa clusters 5 → 6 → 9:
```
FAT[5] = 6    (continúa en cluster 6)
FAT[6] = 9    (continúa en cluster 9)
FAT[9] = EOF  (fin de archivo)
```

### Limitaciones en flash

- **Sin wear leveling**: bloques frecuentemente modificados se degradan rápido
- **No es power-loss tolerant**: un corte de energía puede corromper el filesystem
- **Fragmentación**: con el uso, los archivos quedan esparcidos

### ⚠️ Importante

> **FAT FS solo para tarjetas SD y USB**. Nunca para flash interna — carece de wear leveling y la destruiría prematuramente.

---

## 4. NVS — Non-Volatile Storage (Almacenamiento clave-valor)

### ¿Qué es?

**No es un sistema de archivos tradicional**. Es un almacenamiento **clave-valor** simplificado para datos de configuración.

### Modelo

- Datos identificados por **ID numérico** (no por nombre de archivo)
- Análogo a un diccionario o hash map persistido en flash
- Sin estructura de directorios, sin nombres de archivo

### Funcionamiento interno

1. Flash dividida en sectores (típicamente 4 KB)
2. Datos escritos de forma append-only al final del sector activo
3. Cuando un sector se llena, se crea uno nuevo
4. Garbage collection periódica reclaim espacio de datos borrados

### Ejemplo de uso

```c
// Escribir configuración WiFi
char ssid[] = "MiRed";
nvs_write(&fs, 1, ssid, strlen(ssid));  // ID = 1

// Leer calibración
float offset;
nvs_read(&fs, 10, &offset, sizeof(offset));  // ID = 10
```

### Wear leveling en NVS

- Propio algoritmo distribuye escrituras por todos los sectores
- Crítico para datos que se modifican frecuentemente (ej: contador de reinicios)

### Limitaciones

- Sin estructura de archivos ni directorios
- IDs limitados: 8-bit (0-255) o 16-bit (0-65535)
- Solo acceso directo por clave, sin acceso secuencial
- Garbage collection puede causar latency spikes

---

## 5. Comparación rápida

| Característica | LittleFS | FAT FS | NVS |
|----------------|----------|--------|-----|
| Estructura | Log-structured | Tabla FAT | Clave-valor flat |
| Directorios | Sí | Sí | No |
| Wear leveling | Sí | No | Sí |
| Tolerancia a power loss | Alta | Baja | Media |
| Uso de RAM | Fijo (~2 KB) | Variable | Bajo |
| Casos de uso | Flash interna, logs | Tarjetas SD, USB | Configuración |
| Compatible con PC | No | Sí | No |

---

## 6. Recomendaciones de uso

| Escenario | Recomendación |
|-----------|---------------|
| Datos de configuración (SSID, credenciales) | **NVS** |
| Archivos en flash interna | **LittleFS** |
| Tarjeta SD o intercambio con PC | **FAT FS** |
| Flash interna del microcontrolador | **NUNCA FAT FS** |
| Logs que deben sobrevivir crashes | **LittleFS** |

---

## 7. Relación con el temario de FSO

| Concepto del temario | Cómo se aplica en Zephyr |
|---------------------|--------------------------|
| §3.1 — FS en sentido amplio vs estricto | VFS = sentido amplio; cada FS concreto = sentido estricto |
| §3.5 — Métodos de acceso | LittleFS y FAT: secuencial + directo. NVS: solo directo por clave |
| §3.6 — Métodos de asignación | FAT = tabla FAT centralizada. LittleFS = log-structured (copy-on-write). NVS = sin método clásico |
| §3.8 — Enlaces | No hay soporte para symbolic ni hard links en Zephyr |
| §3.9 — UNIX vs DOS | Zephyr se parece más a DOS: sin i-nodos, sin permisos, formato 8.3 en FAT |

---

## 8. Glosario

- **VFS**: Capa de abstracción que uniformiza el acceso a múltiples FS
- **LittleFS**: FS log-structured para flash embebida, con wear leveling y tolerancia a power loss
- **Log-Structured**: Patrón donde toda escritura va al final del log; nunca se sobrescribe
- **Wear Leveling**: Distribuir escrituras uniformemente para maximizar vida de la flash
- **FAT FS**: FS con tabla centralizada que encadena clusters; universal pero sin wear leveling
- **NVS**: Almacenamiento clave-valor para configuración; IDs numéricos en lugar de archivos
- **Garbage Collection**: Proceso que reclama espacio de datos obsoletos
- **Power-Loss Tolerance**: Capacidad de mantener consistencia ante cortes de energía
- **API POSIX-like**: Interfaz inspirada en POSIX pero con limitaciones

---

*Resumen basado en documentación oficial de Zephyr Project y temario de Fundamentos de Sistemas Operativos.*
