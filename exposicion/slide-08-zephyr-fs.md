# Slide 08 — Sistema de Archivos de Zephyr OS

> **Nota**: Esta slide corresponde a Zephyr OS (sistema embebido IoT). La explicación a fondo se encuentra en `slide-07-explicacion.md`. Este archivo contiene las notas de exposición para la presentación oral.

---

## 🎤 Qué Decir (Speaking Notes)

### Introducción al Sistema de Archivos

"Zephyr no es un servidor de archivos ni un sistema de escritorio. Cuando hablamos de filesystem en un microcontrolador con 256 KB de flash, el juego cambia completamente. Zephyr implementa un enfoque pragmático con tres sistemas de archivos nativos, coordinados por una capa VFS."

### VFS como Abstracción Central

"La clave del diseño es el **Virtual File System Switch**, el VFS. Funciona exactamente igual que el VFS en Linux: provee una API uniforme para que las aplicaciones no necesiten conocer qué filesystem hay abajo. La aplicación llama a `fs_open()`, `fs_read()`, `fs_write()` sin saber si los datos van a LittleFS, FAT o NVS."

"Puntos de montaje: `/lfs` para LittleFS, `/fatfs` para FAT, `/nvs` para el storage de configuración. Esto es transparente para el programador."

### Los Tres Filesystems

**LittleFS — El corazón de Zephyr para flash embebida.**

"LittleFS es el filesystem principal de Zephyr. Está diseñado específicamente para memorias flash, que tienen restricciones muy distintas a los discos magnéticos. La diferencia fundamental es que flash solo puede pasar de 1 a 0 con programación, pero para volver a 1 necesita un borrado en bloque, que es lento."

"LittleFS usa un enfoque **log-structured**: en lugar de sobrescribir datos donde están, toda escritura va al final del log. Esto sounds counterintuitive, pero tiene dos beneficios enormes. Primero: las escrituras se distribuyen uniformemente por toda la flash — esto se llama **wear leveling** — entonces ningún bloque se desgasta prematuramente. Segundo: si hay un corte de luz durante una escritura, el sistema puede recuperarse a un estado consistente porque usa transacciones atómicas."

"Specs: consume solo 2 KB de RAM fija, no crece con el tamaño del filesystem. Ideal para microcontroladores."

**FAT FS — Solo para tarjetas SD y USB.**

"FAT es la implementación de Elm-Chan, la más usada en sistemas embebidos worldwide. La ventaja: compatibilidad universal. Cualquier PC, cualquier SO lee FAT. Por eso lo usamos para tarjetas SD que intercambiamos con una computadora."

"ADVERTENCIA: FAT en flash interna destruye la memoria. FAT no tiene wear leveling, no tiene tolerancia a power loss. Si lo usás en la flash del microcontrolador, los bloques frecuentemente modificados se mueren rápido."

**NVS — No es un filesystem, es clave-valor.**

"NVS es diferente. No tiene archivos, no tiene directorios. Guarda datos identificados por un número ID. Diseñado para configuración: SSID del WiFi, credenciales, offsets de calibración. Guardás `nvs_write(&fs, 10, &offset, sizeof(offset))` y listo. Al arrancar, `nvs_read()` te trae el valor."

---

## 📌 Puntos Clave

| Filesystem   | Uso                                | RAM        | Wear Leveling | Power Loss Safe                |
| ------------ | ---------------------------------- | ---------- | ------------- | ------------------------------ |
| **LittleFS** | Flash interna, datos de aplicación | ~2 KB fija | ✅ Sí         | ✅ Sí (transacciones atómicas) |
| **FAT FS**   | Tarjetas SD, USB nomás             | Variable   | ❌ No         | ❌ No                          |
| **NVS**      | Configuración (IDs, clave-valor)   | Mínima     | ✅ Sí         | ✅ Sí                          |

**Regla práctica**: LittleFS para flash interna SIEMPRE. FAT solo para intercambio con PC. NVS para settings que cambian frecuentemente (contador de boots, credenciales WiFi).

---

## 🔗 Relación con FSO (§3)

Esta slide conecta con el capítulo de Sistemas de Archivos del temario:

### §3.1 — Sentido Amplio vs Estricto

El **VFS** es el filesystem en **sentido amplio**: toda la capa de software que gestiona archivos (API + despachador + servicios). Cada implementación concreta (LittleFS, FAT, NVS) es el filesystem en **sentido estricto**: la estructura de datos en el almacenamiento físico.

### §3.5 — Métodos de Acceso

- **LittleFS y FAT**: acceso **secuencial** (byte por byte) Y acceso **directo** (`fs_seek()` para posicionar puntero).
- **NVS**: SOLO acceso **directo** por clave ID. No hay seek, no hay sequential.

### §3.6 — Métodos de Asignación

- **FAT FS**: usa método **FAT** (File Allocation Table) — tabla centralizada que encadena clusters. Esto lo estudiaron en la teoría.
- **LittleFS**: usa enfoque **log-structured** con copy-on-write. No es contiguo, no es enlazado, no es i-nodos. Es un híbrido optimizado para flash.
- **NVS**: sin método de asignación clásico — espacio plano por sectores con garbage collection.

### §3.8 — Enlaces

Zephyr **NO soporta** symbolic links ni hard links. En un microcontrolador IoT, los enlaces no tienen sentido práctico. Esto diverge del modelo UNIX.

### §3.9 — UNIX vs DOS

Zephyr se parece más a **DOS** que a UNIX en varios aspectos: no hay i-nodos separados, no hay permisos rwx, los nombres en FAT siguen formato 8.3. NVS ni siquiera tiene nombres de archivo.

---

## ⚠️ Cosas a Tener en Cuenta

### Profundidad Técnica — Cuándo Expandir

**Si el docente/pregunta sobre wear leveling**:
"Imaginate la flash como un block de post-its. Cada celda tiene un número limitado de veces que la podés borrar — típicamente 10.000 a 100.000 ciclos. Si siempre escribís en el mismo lugar, ese bloque muere. LittleFS evita esto: como siempre escribe al final del log, distribuye las escrituras por toda la memoria. El garbage collector periódicamente compacta el storage copiando los datos válidos al inicio y reclamando espacio obsoleto."

**Si pregunta sobre transacciones atómicas**:
"LittleFS usa un mecanismo de 'commit blocks'. Antes de marcar un bloque como válido, escribe marcadores de transacción en el superbloque. Si cortan la luz a mitad de escritura, al reiniciar el sistema lee los marcadores, detecta el estado incompleto, y rollbacka a la última transacción consistente. No hay corrupción."

**Si pregunta sobre por qué no FAT en flash interna**:
"FAT fue diseñado para discos magnéticos donde las escrituras son prácticamente ilimitadas. En flash, la FAT misma — que se actualiza constantemente — se convierte en un hot spot. Se muere prematuramente. En una SDcard está ok porque es intercambiable, pero en la flash interna del MCU, no."

### Errores Comunes a Evitar

1. **"LittleFS usa i-nodos"** → NO. No tiene i-nodos. Es log-structured.
2. **"NVS guarda archivos"** → NO. Guarda datos clave-valor identificados por ID numérico.
3. **"FAT tiene wear leveling"** → NO. FAT no lo tiene. Por eso no va en flash interna.
4. **"VFS es POSIX compliant"** → El docs dice explicitamente que es **POSIX-like**, no compliant. Hay diferencias.

---

## ⏱️ Tiempo Estimado

| Sección                           | Tiempo          | Notas                                |
| --------------------------------- | --------------- | ------------------------------------ |
| Introducción al contexto embebido | 15-20 seg       | "256 KB de flash, el juego cambia"   |
| VFS como abstracción              | 20-25 seg       | Diagrama, puntos de montaje          |
| LittleFS (detallado)              | 30-40 seg       | Log-structured, wear leveling, specs |
| FAT FS y NVS                      | 20-25 seg       | Casos de uso, regla práctica         |
| Conexión con FSO (§3)             | 15 seg          | Si hay tiempo, sino skip             |
| **Total**                         | **~90-120 seg** | (~1.5 a 2 minutos)                   |

---

## 🧠 Preguntas Probables y Respuestas

**P: "¿LittleFS usa paginación?"**
R: "No directamente. LittleFS usa bloques de tamaño configurable (4 KB a 128 KB). Dentro de cada bloque, organiza los datos de forma estructurada. No tiene tablas de páginas porque Zephyr típicamente corre en sistemas sin MMU."

**P: "¿Se puede usar Zephyr sin filesystem?"**
R: "Sí, absolutamente. Para aplicaciones muy simples, solo usás NVS para configuración y listo. No necesitás archivos. El filesystem es optional."

**P: "¿NVS es como un EEPROM?"**
R: "Conceptualmente sí, es clave-valor persistido. Pero NVS corre sobre flash con wear leveling, a diferencia de EEPROM que tiene sus propias características de desgaste."

---

_Nota de exposición preparada para la presentación del TP Especial — Zephyr OS vs MOSIX. Fundamentos de Sistemas Operativos — UNMDP. Mayo 2026._
