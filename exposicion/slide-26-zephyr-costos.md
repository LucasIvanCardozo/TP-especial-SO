# Slide 26 — Zephyr OS: Costos y Modelo de Licenciamiento

> **Notas de exposición** | Fundamentos de Sistemas Operativos — TP Especial Zephyr OS vs MOSIX

---

## 1. 🎤 Qué Decir (Speaking Notes)

**Tiempo estimado: 50-60 segundos**

---

**Apertura:**

"Zephyr OS tiene un modelo de licenciamiento que lo diferencia radicalmente de RTOS propietarios como VxWorks o QNX. No solo es gratuito, sino que su licencia está diseñada específicamente para facilitar la adopción comercial sin riesgos legales."

**Desarrollo principal:**

"Zephyr utiliza la **Apache License 2.0**, una licencia permisa — lo que significa cinco cosas concretas:

Primero, **uso comercial permitido**: cualquier empresa puede tomar Zephyr, modificarlo, y vender un producto basado en él sin pagar un centavo.

Segundo, **sin copyleft**: a diferencia de GPL, no están obligados a publicar sus modificaciones. Pueden cerrar el código si quieren.

Tercero, **código cerrado permitido**: el firmware propietario puede incluir componentes de Zephyr sin exposición legal.

Cuarto, **sin regalías**: no pagan por unidad producida. Esto es clave para productos IoT de alto volumen — si fabrican un millón de dispositivos, el costo de licenciamiento sigue siendo cero.

Y quinto, **atribución requerida**: solo deben mantener los créditos de los contribuidores originales en un archivo NOTICE. Es un requisito administrativo mínimo."

**Cierre:**

"El soporte viene en camadas: pueden empezar con el **soporte comunitario gratuito** — Discord, mailing lists, GitHub Discussions — y si su producto necesita SLAs contractuales, hay empresas como Wind River, Nordic Semiconductor e Intel que ofrecen soporte comercial."

---

## 2. 📌 Puntos Clave para la Exposición

| Aspecto                    | Detalle               | Para enfatizar                                                                    |
| -------------------------- | --------------------- | --------------------------------------------------------------------------------- |
| **Licencia**               | Apache License 2.0    | "La más permisa posible — casi como dominio público con créditos"                 |
| **Costo de licencia**      | $0 (permanente)       | "No es un tier freemium, no hay downgrade a versión paga"                         |
| **Regalías por unidad**    | $0                    | "Clave para IoT de alto volumen — millones de dispositivos sin costo incremental" |
| **Código cerrado**         | Permitido             | "Pueden proteger su propiedad intelectual diferenciadora"                         |
| **Toolchain (Zephyr SDK)** | Gratuito              | "No necesitan gastar $1,000-$5,000 en toolchains comerciales"                     |
| **Soporte comercial**      | Disponible (opcional) | "Wind River, Nordic, Intel — SLAs si los necesitan"                               |

---

## 3. 🔗 Relación con FSO y el Temario

### §1.1 — Software Libre vs Propietario

La slide conecta directamente con el tema **"Qué es un Sistema Operativo"** del temario. En FSO aprendimos que un SO tiene dos objetivos: **máquina extendida** y **gestor de recursos**.

El modelo de licenciamiento afecta directamente cómo esos objetivos llegan a los usuarios:

| Modelo                                 | Cómo alcanza los objetivos                                                       |
| -------------------------------------- | -------------------------------------------------------------------------------- |
| **Propietario** (VxWorks, QNX)         | Venta de licencias financia desarrollo. Usuario paga por acceso.                 |
| **Software libre permissivo** (Zephyr) | Comunidad + membresías corporativas financian desarrollo. Usuario accede gratis. |

### El Continuum de Licencias

```
Propietario → Copyleft débil (LGPL) → Copyleft fuerte (GPL) → Permisivo
  QNX, VxWorks      OpenSSL               Linux kernel       Apache 2.0
                                                    ↑
                                              Zephyr está aquí
```

**Punto a mencionar si preguntan:** "Zephyr está en el extremo más permiso del software libre. Esto lo hace atractivo para empresas que quieren los beneficios del código abierto sin las obligaciones de GPL."

### Modelo de Negocio de Zephyr

Zephyr demuestra que un SO moderno puede mantenerse sin vender licencias:

1. **Linux Foundation** como custodio neutral (no es una empresa que vende soporte)
2. **Membresías corporativas** financian el proyecto (Wind River, Nordic, Intel, NXP, Renesas)
3. **Servicios comerciales** son optativos (no la única fuente de revenue)

Este modelo es una evolución del modelo tradicional donde cada fabricante de hardware incluía su propio SO propietario.

---

## 4. ⚠️ Cosas a Tener en Cuenta para la Presentación

### ✅ Qué DESTACAR

- **Costo cero real**: No hay "gotchas" — no hay tier oculto, no hay límite de uso, no hay downgrade
- **Protección del código propio**: A diferencia de GPL, pueden cerrar su firmware sin consecuencias legales
- **Sin riesgo de vendor lock-in**: Linux Foundation es neutral — ninguna empresa individual controla el proyecto
- **TCO (Total Cost of Ownership) mínimo**: Eliminación de licencias, toolchains, y regalías reduce la barrera de entrada

### ⚠️ Qué ACLARAR si Preguntan

| Pregunta probable                                             | Respuesta sugerida                                                                                                                                                       |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| "¿Y el soporte es bueno siendo gratuito?"                     | "La comunidad es activa — 3,000+ contribuidores. Si necesitás SLA contractuales, hay empresas comerciales disponibles."                                                  |
| "¿No hay peligro de que Linux Foundation discontinúe Zephyr?" | "Es improbable — tiene 6+ miembros Platinum con interés económico en mantenerlo. Además, el código está disponible: si se discontinuara, la comunidad podría continuar." |
| "¿Puedo usar Zephyr en un producto médico?"                   | "Sí, es usado en dispositivos médicos. La licencia no lo prohíbe. Medical-grade requiere validación adicional independientemente del RTOS."                              |

### 🎯 Momento para Contrastar con MOSIX (si hay tiempo)

"Ojo, no todos los proyectos open source son iguales. Comparen con MOSIX: Zephyr usa Apache 2.0 (permissiva), mientras que MOSIX tenía licencia propietaria restrictiva. Eso explica en parte por qué Zephyr prospera y MOSIX está inactivo desde 2017."

---

## 5. ⏱️ Tiempo Estimado por Sección

| Sección                        | Tiempo    | Notas                                                                             |
| ------------------------------ | --------- | --------------------------------------------------------------------------------- |
| Apertura + concepto Apache 2.0 | 20-25 seg | No entrar en detalles legales, enfocarse en implicaciones prácticas               |
| Los 5 puntos de la licencia    | 20-25 seg | Ser conciso, ejemplos concretos (ej: "un millón de dispositivos = cero regalías") |
| Soporte en capas               | 10-15 seg | Mencionar comunitaria vs comercial                                                |
| Cierre + contraste opcional    | 5-10 seg  | Conectar con TCO bajo                                                             |

**Total: ~50-60 segundos**

---

## 6. 📝 Frase Guía para Recordar

> _"Zephyr: cero de entrada, cero de producción, código cerrado permitido, soporte opcional."_

Esta frase cubre los cuatro pilares del modelo.

---

## 7. 🔗 Fuentes y Referencias

- [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)
- [Zephyr Licensing Documentation](https://docs.zephyrproject.org/latest/LICENSING.html)
- [Zephyr Project — Member Ecosystem](https://www.zephyrproject.org/ecosystem-vendor-offerings/)
- Temario FSO §1.1 — "¿Qué es un Sistema Operativo?"

---

_Notas generadas para slide 26 — Zephyr OS vs MOSIX — Fundamentos de Sistemas Operativos — UNMDP_
