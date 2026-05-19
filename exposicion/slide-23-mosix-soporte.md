# Slide 23 — Notas de Exposición: MOSIX — Soporte a Usuarios

## 1. 🎤 Qué Decir (Speaking Notes)

**Versión corta (30 segundos):**

> "MOSIX fue un proyecto de investigación de la Hebrew University de Jerusalén, desarrollado bajo el liderazgo del profesor Amnon Barak. Sin embargo, el proyecto quedó **completamente inactivo desde octubre de 2017**, hace más de 8 años. Esto significa tres cosas concretas: no hay actualizaciones de seguridad, no hay comunidad activa que responda dudas, y no hay soporte comercial disponible. Para cualquier entorno de producción, esto lo convierte en una opción **no viable**."

**Versión completa (45 segundos) — para expandir si el tribunal pregunta:**

> "En términos de soporte, MOSIX representa el polo opuesto a Zephyr. Este fue un proyecto académico de la Hebrew University of Jerusalem, liderado por el profesor Amnon Barak. El último release fue la versión 4.4.4 el 24 de octubre de 2017. Desde entonces, **no ha habido ninguna actualización, parche ni actividad**. El sitio web mosix.org sigue funcionando pero con información completamente desactualizada. No existe lista de correo activa, no hay foros de soporte, no hay contribución de código. Para sistemas que van a producción, especialmente en HPC donde la seguridad y estabilidad son críticas, un proyecto sin soporte activo durante 8 años es un riesgo inaceptable."

---

## 2. 📌 Puntos Clave

### Sobre la Inactividad

| Aspecto                        | Detalle                             |
| ------------------------------ | ----------------------------------- |
| **Último release**             | MOSIX 4.4.4 (24 de octubre de 2017) |
| **Tiempo sin desarrollo**      | Más de 8 años                       |
| **Mantenimiento de seguridad** | ❌ Ninguno                          |
| **Comunidad activa**           | ❌ No existe                        |
| **Soporte comercial**          | ❌ No disponible                    |
| **Documentación**              | ⚠️ Desactualizada                   |

### ¿Por qué importa?

1. **Vulnerabilidades sin parchear**: Cualquier vulnerabilidad de seguridad descubierta desde 2017 permanece sin corregir
2. **Incompatibilidad con kernels modernos**: Linux ha evolucionado significativamente; MOSIX puede no funcionar con kernels actuales
3. **No hay quién responder dudas**: Si tienen un problema técnico, no hay a quién preguntar
4. **Riesgo para producción**: Clusters HPC necesitan soporte profesional para entornos críticos

### El Contexto del Proyecto

- **Origen**: Investigación académica, no producto comercial
- **Modelo**: Propietario restrictivo (prohíbe modificación y reverse engineering)
- **Cese**: El grupo de investigación decidió discontinuar el proyecto
- **Fork histórico**: OpenMosix (2002-2008) también fue discontinuado

---

## 3. 🔗 Relación con FSO

### §1.1 — ¿Qué es un Sistema Operativo? (Rol de Gestor de Recursos)

Un SO en producción necesita no solo gestionar recursos, sino también **mantenerse**. La inactividad de MOSIX viola el principio de que un SO debe ser un gestor de recursos **confiable y mantenible** en el tiempo. Un cluster HPC que dependa de MOSIX tiene un punto único de fallo: si aparece un bug crítico, no hay equipo resolviéndolo.

### §2.1 — Scheduling y Confiabilidad

El scheduling en un cluster HPC debe ser **confiable y predecible**. Con un proyecto inactivo:

- No hay quién mejore los algoritmos de scheduling
- No hay quién corrija bugs en la migración de procesos
- No hay soporte para nuevos tipos de hardware

### §5.6 — Thrashing y Mantenimiento

El concepto de **hiperpaginación** (§5.6) menciona que sin control, los sistemas degradan. En el caso de MOSIX, la "hiperpaginación" es literal: el proyecto está en un estado de degradación total donde ningún parámetro se optimiza, ningún bug se corrige, y ningún feature se agrega.

### La Pregunta del Tribunal Posible

> "¿Por qué comparar un proyecto activo contra uno inactivo?"

**Respuesta preparada**: "La comparación es precisamente valiosa por eso. En el mercado real, ustedes necesitan saber: ¿cuál de estas soluciones pueden usar hoy? ¿Cuál tendrá soporte mañana? ¿Cuál invertirían en un producto de largo lifecycle? La respuesta no es 'la que era mejor técnicamente en 2017', sino 'la que tiene respaldo activo, comunidad, y futuro'. Eso nos lleva directamente a la conclusión de que son productos para segmentos completamente distintos."

---

## 4. ⚠️ Cosas a Tener en Cuenta

### Para la Exposición

1. **Ser claros pero no despectivos**: MOSIX fue un proyecto de investigación significativo. El profesor Barak hizo contribuciones importantes al campo de sistemas distribuidos. No digan "es basura", digan "es un proyecto de investigación históricamente valioso pero inactivo".

2. **No exagerar**: No digan "no funciona" si no lo probaron. Digan "no tiene soporte ni mantenimiento activo desde 2017".

3. **Conectar con el contexto académico**: En FSO vimos que la administración del procesador, memoria y archivos son pilares de un SO. Estos pilares requieren mantenimiento continuo.

4. **Prepararse para la pregunta**: "¿Cuándo usaría MOSIX entonces?" → Respuesta: "En 2017, para clusters de investigación específicos. Hoy, para producción, no lo recomendaría."

### Para las Diapositivas Posteriores

- La slide 25 (MOSIX Casos de Uso) refuerza este mensaje con la advertencia "⚠️ PROYECTO INACTIVO — NO RECOMENDADO PARA PRODUCCIÓN"
- La slide 27 (MOSIX Costos) también mantiene la advertencia
- La slide 28 (Comparativa) deja en evidencia el contraste

---

## 5. ⏱️ Tiempo Estimado

| Versión      | Tiempo      | Cuándo usarla                                                         |
| ------------ | ----------- | --------------------------------------------------------------------- |
| **Corta**    | 30 segundos | Si el tribunal está acelerado o si hay muchas preguntas               |
| **Completa** | 45 segundos | Si hay tiempo y el tribunal parece interesado en el aspecto académico |

### Transición Sugerida

**Desde slide 22 (Zephyr Soporte)**:

> "Zephyr tiene un ecosistema de soporte robusto. En contraste, MOSIX..."

**Hacia slide 24 (Zephyr Casos de Uso)**:

> "Esta diferencia de soporte se refleja en la adopción real. Veamos cómo Zephyr se utiliza en productos comerciales..."

---

## 6. 🎯 Frase de Cierre para esta Slide

> "Un sistema operativo sin soporte activo es como un edificio sin mantenimiento: puede seguir en pie, pero nadie se hace responsable si algo sale mal."

---

_Notas preparadas para el Trabajo Práctico Especial — Zephyr OS vs MOSIX_
_Fundamentos de Sistemas Operativos — UNMDP_
_Mayo 2026_
