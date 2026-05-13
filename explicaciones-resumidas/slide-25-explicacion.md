# Slide 25 — Resumen: Zephyr OS — Costos y Licenciamiento

## Modelo de Licenciamiento: Apache License 2.0

Zephyr usa **Apache License 2.0**, una licencia **permisiva** (no copyleft) que facilita la adopción comercial.

### 5 características clave:

1. **Uso comercial permitido**: Se puede usar Zephyr como base de productos comerciales sin pagar regalías ni pedir permisos.

2. **Sin copyleft**: Si una empresa modifica el kernel de Zephyr para su hardware propietario, **no está obligada a publicar esas modificaciones**. Esto protege secretos industriales.

3. **Código cerrado permitido**: Software propietario puede incluir componentes basados en Zephyr sin disclosear código.

4. **Sin regalías**: No se paga por unidad fabricada. En productos IoT de alto volumen (millones), esto representa un ahorro enorme vs. RTOS que cobran por unidad.

5. **Atribución requerida**: La única obligación es mantener el aviso de copyright en las distribuciones (archivo NOTICE). Es un requisito administrativo mínimo, sin costo.

### Licencia de patentes

Apache 2.0 incluye una **grant de patentes**: si un contribuidor tenía patentes sobre tecnología en Zephyr, automáticamente otorga licencia de esas patentes a cualquier usuario. Elimina el riesgo de reclamos de patentes sobre código ya incorporado.

---

## Estructura de Costos: $0

El precio es **$0 real y permanente** (no es una versión de prueba).

### Qué incluye ese $0:

| Componente | Detalle |
|------------|---------|
| Código fuente | Completo en GitHub, sin "feature gates" |
| Regalías por unidad | $0 sin importar el volumen de producción |
| Zephyr SDK | Toolchain, compilador, debugger, CMake, Ninja — todo gratis |
| Hardware de desarrollo | Boards disponibles entre $20-$200 |
| Soporte comunitario | Discord, mailing lists, GitHub Discussions — gratis |

### Impacto según perfil:

- **Startups/PyMEs**: Sin capital para licencias, la curva de adopción empieza en $0.
- **Alto volumen**: Regalías cero = mejor margen por dispositivo.
- **Ciclo largo**: No hay riesgo de renegociación de licencias ni incrementos de precio.

---

## Soporte Opcional (Linux Foundation)

### Gobernanza

**Linux Foundation** es la entidad custodia de Zephyr. Es una **organización sin fines de lucro** (no una empresa de soporte) que alberga +100 proyectos open source. Su rol neutral evita que una sola empresa controle el proyecto — previene **vendor lock-in**.

### Miembros Platinum destacados:

- **Wind River**: Histórico en embebidos (VxWorks). Ofrece soporte comercial, consultoría, y "Wind River Rocket" (distribución derivada).
- **Nordic Semiconductor**: Líder en Bluetooth LE. Mayor contribuidor individual de código en 2025.
- **Intel, NXP, Renesas**: Fabricantes de semiconductores con soporte específico para sus plataformas.

### Soporte pago disponible

Para productos de producción donde las caídas tienen costo financiero:
- **SLA** con tiempos de respuesta garantizados
- **Acceso prioritario** a engineers especializados
- **Responsabilidad contractual**

Es opt-in: no obligatorio para usar Zephyr.

---

## TCO (Total Cost of Ownership) — Muy Bajo

### Qué incluye TCO:

- **Directos**: licencia, hardware, implementación
- **Indirectos**: tiempo de desarrollo, training
- **Recurrentes**: mantenimiento, actualizaciones
- **Ocultos**: riesgo de vendor lock-in, costos de migración

### Por qué es bajo para IoT:

- Licencia: $0
- Herramientas: SDK gratuito (vs. $1,000-$5,000 por seat en herramientas comerciales)
- Soporte: comunitario cubre desarrollo; pago solo si se necesita SLA
- Obsolescencia: Proyecto de Linux Foundation con múltiples sponsors = bajo riesgo de discontinuación

### Sin barreras de entrada:

- No hay costo de evaluación
- No hay toolchain costoso inicial
- No hay regalías desde la primera unidad
- Sin ambigüedad legal sobre uso comercial

---

## Contexto Académico (§1.1 — Software Libre vs Propietario)

### Software Libre vs Propietario

| Aspecto | Propietario | Libre |
|---------|-------------|-------|
| Código fuente | No disponible | Disponible |
| Uso | Pago por licencia | Libre |
| Modificación | No permitido | Permitido |
| Ejemplos | VxWorks, QNX, Windows | Zephyr, Linux, FreeRTOS |

### Tipos de licencias libres:

- **Copyleft débil (LGPL)**: Permite linking con software propietario
- **Copyleft fuerte (GPL)**: Obliga a liberar obras derivadas (Linux kernel = GPLv2)
- **Permisiva (Apache 2.0, MIT, BSD)**: Sin obligaciones de copyleft

```
Propietario → Copyleft débil → Copyleft fuerte → Permisiva
  (QNX)        (LGPL)           (GPL)           (Apache 2.0)
```

Zephyr (Apache 2.0) está en el **extremo más permisivo**.

---

## Glosario Rápido

| Término | Definición |
|---------|------------|
| **TCO** | Costo total de propiedad: todos los costos a lo largo del ciclo de vida de un producto |
| **Vendor lock-in** | Dependencia excesiva de un vendor que hace costoso migrar a otra solución |
| **Copyleft** | Obligación legal de distribuir obras derivadas bajo la misma licencia |
| **Permisiva** | Licencia con pocas restricciones sobre uso, modificación y distribución |
| **SLA** | Service Level Agreement: contrato con tiempos de respuesta garantizados |
| **Toolchain** | Conjunto de herramientas (compilador, debugger, linker) para desarrollar |
| **Grant de patentes** | Cesión automática de derechos de patente a usuarios del software |

---

## Síntesis

**Zephyr = $0 de entrada + licencia permísima + gobernanza neutral + soporte opt-in**

Para elegir un RTOS para IoT, Zephyr **elimina la variable costo**, permitiendo enfocarse en:
- Suitability para el hardware target
- Opciones de conectividad
- Features de seguridad
- Longevity del proyecto
