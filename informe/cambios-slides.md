# Registro de Cambios — Slides del TP Especial FSO

> Este documento registra todos los cambios realizados durante el Judgment Day a los archivos `explicaciones-resumidas/*.md` y `informacion/**/*.md` del proyecto Zephyr OS vs MOSIX.
>
> Usá este registro para actualizar manualmente los slides correspondientes del PowerPoint.

---

## 1. RAM Mínima — Zephyr OS (~4KB → ~16KB actual)

### Cambio general
- Zephyr OS actual requiere **~16 KB RAM mínimo** (no ~4 KB)
- El nanokernel histórico pre-v1.6 sí tenía configs de ~4 KB
- Solo usar "~4 KB" cuando se refiera específicamente al nanokernel histórico

### Archivos corregidos

| Archivo | Cambio |
|---------|--------|
| `explicaciones-resumidas/slide-05-explicacion.md` | Aclarado que ~16 KB es el OS completo; ~4 KB es el nanokernel histórico |
| `explicaciones-resumidas/slide-09-explicacion.md` | Consistencia interna |
| `archivos-finales/informe/03-caracteristicas-fs.md` | `~2 KB` → `~16 KB RAM (nanokernel histórico ~4 KB)` |
| `archivos-finales/informe/02-la-empresa.md` | `~4 KB de RAM mínimo` → `~16 KB RAM mínimo; nanokernel histórico ~4 KB` |

---

## 2. OpenSSF Gold Badge — Fecha corregida

### Cambio general
- **Fecha correcta**: 2018-03-10 (no "2019")
- Badge mantenido y actualizado hasta 2024-06-05
- Usar "OpenSSF Gold Badge (2018-2024)" o "OpenSSF Gold Badge (desde 2018-03-10)"

### Archivos corregidos

| Archivo | Cambio |
|---------|--------|
| `explicaciones-resumidas/slide-13-explicacion.md` | `Zephyr Gold Badge (2019)` → `Zephyr Gold Badge (2018-03-10)` |
| `explicaciones-resumidas/slide-17-explicacion.md` | `desde 2019` → `desde 2018-03-10, mantenido hasta 2024-06-05` |
| `explicaciones-resumidas/slide-27-explicacion.md` | `desde 2019` → `desde 2018-03-10 (mantenido hasta 2024-06-05)` |
| `explicaciones-resumidas/slide-01-explicacion.md` | `desde 2019` → `desde 2018-03-10` |
| `archivos-finales/informe/05-seguridad-devtools.md` | `en 2019` → `en 2018-03-10 (Gold Badge mantenido y actualizado hasta 2024-06-05)` |
| `archivos-finales/informe/07-comparativa-conclusiones.md` | `en 2019` → `en 2018-03-10 (mantenido hasta 2024-06-05)` |

---

## 3. Precio Histórico MOSIX — Fuente agregada

### Cambio general
- Precio histórico: **$61,141 USD** (año 2000, fuente: USENIX)
- Ya no existe link verificable (URL original rota)
- Hoy en día: proyecto inactivo, sin precio público disponible

### Archivos corregidos

| Archivo | Cambio |
|---------|--------|
| `explicaciones-resumidas/slide-26-explicacion.md` | Agregada fuente USENIX con nota: precio histórico documentado en USENIX 2000 proceedings |
| `archivos-finales/informe/06-puertas-afuera.md` | Aclarado como "histórico" y "actualmente sin precio público" |

---

## 4. Bibliografía del Informe — Links mejorados

### Cambio general
- Agregado link directo a GitHub de Zephyr
- Link directo al reporte "Zephyr at 10" de Linux Foundation (marzo 2026)
- Nota de acceso: "mayo 2026"
- Link USENIX marcado como referencia histórica sin URL disponible

### Archivos corregidos

| Archivo | Cambio |
|---------|--------|
| `archivos-finales/informe/informe-final.md` | Bibliografía con links específicos, fechas de acceso, fuentes verificables |

---

## Resumen de Slides que Necesitan Actualización Manual

| Slide # | Contenido a actualizar | Cambio específico |
|---------|----------------------|-------------------|
| **slide-01** | OpenSSF Gold Badge | "desde 2019" → "desde 2018-03-10" |
| **slide-05** | RAM mínima Zephyr | "~4 KB" → "~16 KB" + aclarar nanokernel histórico |
| **slide-09** | RAM mínima | Consistencia interna con ~16 KB |
| **slide-13** | OpenSSF Gold Badge | "2019" → "2018-03-10" |
| **slide-17** | OpenSSF Gold Badge | "desde 2019" → "desde 2018-03-10, mantenido 2024-06-05" |
| **slide-26** | Precio MOSIX | Agregar "$61,141 USD (año 2000, fuente: USENIX)" |
| **slide-27** | OpenSSF Gold Badge | "desde 2019" → "desde 2018-03-10" |

---

## Notas para el PowerPoint

1. **OpenSSF Gold Badge**: La fecha correcta es **2018-03-10**, cuando Zephyr logró el badge por primera vez. Se mantuvo actualizado hasta 2024-06-05.

2. **RAM mínima Zephyr**:
   - Nanokernel histórico (pre-v1.6, antes de 2016): ~4 KB
   - Zephyr OS actual (v1.6+): ~16 KB mínimo recomendado
   - No confundir los dos valores

3. **Precio MOSIX**: $61,141 USD era el precio histórico documentado en USENIX 2000. El proyecto está inactivo desde 2017, no hay precio actual.

---

*Documento generado automáticamente tras el Judgment Day del informe TP Especial FSO — Mayo 2026*