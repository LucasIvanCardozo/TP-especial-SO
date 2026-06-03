# Slide 08 — Sistema de Archivos de Zephyr

## 🎤 Guía de Exposición (Qué decir)

### Apertura (10 seg)

"Zephyr no es una PC. Estamos hablando de un microcontrolador con apenas 256 KB de flash. Ahí no corre Windows ni Linux — el filesystem es completamente diferente."

---

### VFS: La capa que unifica (15 seg)

"Zephyr tiene una capa llamada **VFS** — Virtual File System Switch. Es como un recepcionista que recibe todos los pedidos de archivos y los deriva al filesystem correcto."

```
Aplicación llama: fs_open("/datos/sensor.bin")
                          ↓
                    VFS pregunta:
                    "¿A cuál filesystem voy?"
                          ↓
              ┌──────────┼──────────┐
              ↓          ↓          ↓
          LittleFS    FAT       NVS
          /lfs/     /fatfs/   (IDs)
```

"El programador no necesita saber qué hay abajo. Solo usa la API standard."

---

### LittleFS: El principal (25 seg)

"LittleFS es el filesystem principal de Zephyr. Está diseñado específicamente para **flash** — la memoria del microcontrolador."

**¿Qué es flash?**

"Flash es la memoria que guarda datos incluso sin energía. Dentro del MCU tenés RAM (se borra al apagar) y flash (guarda para siempre)."

**¿Por qué flash es especial?**

"La diferencia fundamental con un disco común:

- Disco: podés escribir donde quieras, siempre
- Flash: solo podés pasar de **1 a 0** (escribir). Para volver de 0 a 1, tenés que **borrar todo el bloque** — y eso es lento."

**¿Cómo funciona LittleFS?**

"Usa un sistema llamado **log-structured**:
- Nunca sobrescribe donde ya hay datos
- Siempre escribe al **final** de la memoria
- Usa un 'súperbloque' que apunta a dónde está cada archivo

```
Memoria flash:

  [Bloque 1][Bloque 2][Bloque 3][Bloque 4][Bloque 5]
     A          AB        ABC
                                      ↑
                              Siguiente espacio libre
```

**Beneficios:**

1. **Wear leveling**: distribuye las escrituras por toda la memoria, así ninguna celda se desgasta antes
2. **Safe ante cortes de luz**: si se corta la luz, siempre hay una versión completa (la anterior o la nueva), nunca corrupto"

---

### FAT: Solo para intercambio (10 seg)

"FAT es el filesystem de las tarjetas SD y USB. Lo conoces de Windows: FAT32."

"Solo lo usamos cuando necesitamos **intercambiar datos con una PC**."

"⚠️ **Importante**: FAT NO va en la flash interna del MCU. FAT no tiene wear leveling — si lo usás en la flash del microcontrolador, la memoria se muere rápido."

---

### NVS: Configuración simple (15 seg)

"NVS no es un filesystem. Es un almacen de **clave-valor**."

"Guardás datos identificados por un número ID, no por archivos."

```
Ejemplo:

  ID 10 → "MiRedWiFi"
  ID 11 → "Password123"
  ID 12 → 42

  nvs_write(&fs, 10, ssid, strlen(ssid));
  nvs_read(&fs, 10, &buffer);
```

**¿Cuándo usar NVS?**

- SSID y passwords de WiFi
- Contador de veces que arrancó
- Offsets de calibración
- Cualquier dato simple que cambia seguido

---

### Resumen y regla práctica (10 seg)

```
┌─────────────────────────────────────────────┐
│              ¿CUÁNDO USAR CADA UNO?          │
├─────────────────────────────────────────────┤
│                                              │
│  LittleFS → Flash interna del MCU           │
│              Archivos de aplicación          │
│                                              │
│  FAT       → Tarjetas SD, USB              │
│              Solo para intercambiar con PC   │
│                                              │
│  NVS       → Configuración                  │
│              Datos simples (IDs → valores)   │
│                                              │
└─────────────────────────────────────────────┘
```

---

### Transición (5 seg)

"Ahora veamos cómo MOSIX maneja los archivos... pero en un cluster de cientos de servidores, no en un chip de 256 KB."

---

## 📝 Glosario Rápido

| Término | Significado |
|---------|-------------|
| **Flash** | Memoria que guarda datos sin energía. Dentro del MCU: donde se guarda el programa. |
| **RAM** | Memoria volátil. Se borra al apagar. Zephyr corre acá. |
| **VFS** | Capa que unifica el acceso a filesystems. Es como un "recepcionista". |
| **Log** | Sistema donde nunca se sobrescribe — siempre se escribe al final |
| **Súperbloque** | Metadata que dice dónde está cada archivo |
| **Wear leveling** | Distribuir escrituras por toda la memoria para que ninguna celda se gaste |
| **Transacción atómica** | Operación que se completa toda o no se hace nada — ante cortes de luz no hay corrupción |
| **Clave-valor** | Guardar datos como ID → valor (ej: ID 10 → "MiPassword") |

---

## 📌 Puntos Clave

1. **VFS** = capa unificadora, el programador no necesita saber qué FS hay abajo
2. **LittleFS** = principal, para flash interna, wear leveling, safe ante cortes
3. **FAT** = solo para SD/USB, nunca en flash interna
4. **NVS** = clave-valor, para configuración
5. **Flash** ≠ Disco magnético. Flash: 1→0 fácil, 0→1 necesita borrar todo el bloque

---

## ⚠️ Errores a Evitar

| ❌ NO decir | ✅ Decir |
|-------------|----------|
| "LittleFS usa i-nodos" | "LittleFS usa log-structured, no i-nodos" |
| "NVS guarda archivos" | "NVS guarda datos por ID, no archivos" |
| "FAT tiene wear leveling" | "FAT NO tiene wear leveling — destruye la flash interna" |
| "VFS es POSIX compliant" | "VFS es POSIX-like, hay diferencias" |

---

## 🔗 Relación con FSO

| Concepto | Cómo se manifiesta |
|----------|-------------------|
| **§3.1 — Sentido amplio** | VFS es el filesystem en sentido amplio (capa de software) |
| **§3.1 — Sentido estricto** | LittleFS, FAT, NVS son el filesystem en sentido estricto (estructura en disco) |
| **§3.6 — Métodos de asignación** | FAT usa FAT (tabla), LittleFS usa log-structured |
| **§3.8 — Enlaces** | Zephyr NO soporta symbolic ni hard links |

---

## ⏱️ Tiempo Total: 60-90 segundos

- 10 seg: apertura
- 15 seg: VFS
- 25 seg: LittleFS
- 10 seg: FAT
- 15 seg: NVS
- 10 seg: resumen
- 5 seg: transición
