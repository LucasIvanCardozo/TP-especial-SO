# Slide 24 — Notas de Exposición: Zephyr OS — Casos de Uso

## 1. 🎤 Qué decir (Speaking Notes)

**Apertura (~15 segundos):**
"Ahora que ya conocen las características técnicas de Zephyr, se preguntarán: ¿se usa realmente en productos comerciales? La respuesta es sí, y les voy a mostrar ejemplos concretos de tres sectores donde Zephyr está presente."

**Desarrollo (~45 segundos):**

"Empecemos por **wearables**. El Oticon More es un audífono recargable de alta gama que usa Zephyr para gestionar la conectividad Bluetooth y el procesamiento de audio en tiempo real. Esto es crítico: un audífono tiene que procesar sonido, conectarse al celular, y durar todo el día con una batería pequeña. Zephyr les permite hacer todo eso con apenas unos KB de memoria."

"En **industrial**, Zephyr está en las controladoras de GARDENA, una empresa alemana de sistemas de riego. Imaginen una controladora de riego que tiene que comunicarse por wireless, ejecutar programación horaria, y funcionar al aire libre durante años sin mantenimiento. Zephyr les da esa confiabilidad con bajo consumo."

"El tercer sector es **médico**. HealthyPi es un monitor de ECG portable que usa Zephyr. Acá la seguridad no es negociable — si el software falla, alguien puede no recibir una alerta de emergencia. Zephyr provee las garantías de tiempo real que estos dispositivos necesitan."

**Cierre (~15 segundos):**
"Y estos son solo tres ejemplos documentados. El ecosistema Zephyr tiene más de mil placas soportadas y es utilizado por empresas como Vestas en turbinas eólicas, y en notebooks Framework. Es un RTOS que pasó de proyecto de investigación a producción real."

---

## 2. 📌 Puntos Clave

| Sector         | Producto                 | Qué hace Zephyr ahí                            |
| -------------- | ------------------------ | ---------------------------------------------- |
| **Wearables**  | Oticon More (audífono)   | Procesamiento de audio + Bluetooth LE          |
| **Industrial** | GARDENA smart Irrigation | Control de válvulas + comunicación wireless    |
| **Médico**     | HealthyPi (ECG monitor)  | Adquisición de señales + alerta en tiempo real |

### Por qué estos casos importan

1. **No son demos**: Son productos que la gente compra y usa hoy
2. **Requisitos estrictos**: Cada sector tiene constraints diferentes pero Zephyr los satisface
3. **Comercialmente viables**: Empresas chose Zephyr por razones técnicas y de costos

---

## 3. 🔗 Relación con FSO

### §1.1 — Máquina Extendida

Zephyr como máquina extendida: oculta la complejidad del hardware heterogéneo de microcontroladores. El programador de un audífono no necesita entender cómo funciona el BLE radio ni los timers del MCU — Zephyr se lo abstrae.

### §2.1 — Scheduling en Tiempo Real

En sistemas embebidos críticos, el scheduling no es solo "qué proceso corre", sino "con qué latencia máxima". Un monitor cardíaco debe detectar arritmias dentro de milisegundos — Zephyr garantiza eso con sus políticas de prioridad.

### §4.1 — Administración de Memoria Restringida

Estos dispositivos tienen memoria limitada (típicamente 256 KB a 1 MB de RAM). Zephyr maneja esta restricción con:

- Memory Protection Unit (MPU) en lugar de MMU completa
- Gestores de memoria eficientes (heap, memory slabs)
- Sin swap — todo está en RAM

### §5.1 — Memoria Virtual

Zephyr soporta memoria virtual incluso en MCUs sin MMU, usando demand paging. Esto permite que aplicaciones complejas corran en hardware limitado.

---

## 4. ⚠️ Cosas a Tener en Cuenta

### Para la exposición oral:

- **Sean concretos**: No digan "dispositivos IoT" — digan "un audífono que cuesta 3000 dólares"
- **Conecten con lo conocido**: "Es como tener Linux embebido, pero para microcontroladores"
- **Muestren la diversidad**: Un RTOS que sirve para un audífono Y para una turbina eólica demuestra versatilidad
- **Eviten jerga innecesaria**: No mencionen "MPU-based protection" a menos que alguien pregunte

### Para preguntas técnicas:

| Pregunta probable                                 | Respuesta preparada                                             |
| ------------------------------------------------- | --------------------------------------------------------------- |
| ¿Cómo se programa en Zephyr?                      | API POSIX-like en C, build system West                          |
| ¿Qué pasa si el dispositivo se queda sin memoria? | Zephyr tiene mecanismos de memory domains y protección          |
| ¿Zephyr es seguro?                                | Tiene PSA Crypto API, Secure Boot (MCUboot), OpenSSF Gold Badge |

### Para evitar:

- No exageren la adopción: "Zephyr está en todas partes" es falso. Compiten con FreeRTOS, ThreadX, NuttX
- No comparen con smartphones: Un microcontrolador no corre Android
- No prometan que Zephyr resuelve todo: Tiene limitaciones de memoria y no soporta aplicaciones complejas

---

## 5. ⏱️ Tiempo Estimado

**60-90 segundos** (~1 minuto)

| Parte                | Tiempo |
| -------------------- | ------ |
| Apertura             | 15 seg |
| Wearables (Oticon)   | 15 seg |
| Industrial (GARDENA) | 15 seg |
| Médico (HealthyPi)   | 15 seg |
| Cierre               | 15 seg |

**Tip**: Si el tiempo es corto, saltar Industrial y enfocar Wearables + Médico (son más cotidianos para el público).

---

## 6. 📚 Información de Soporte

### Productos mencionados

**Oticon More** (audífono)

- Marca danesa Oticon (GN Hearing)
- Procesamiento de sonido basado en deep learning
- Conectividad Bluetooth LE Audio
- Batería: ~24 horas
- Precio: ~$3000 USD/pair

**GARDENA smart Irrigation Control** (riego)

- Controladora para jardines residenciales
- Comunicación wireless (433 MHz o Bluetooth)
- Controla válvulas de 24V
- Programación vía app móvil

**HealthyPi** (monitor ECG)

- Dispositivo open source para salud
- ECG + Spo2 + temperatura
- Diseño portable (ESP32 + Zephyr)
- Usado en investigación y prototipado

### Fuentes para verificar

- Zephyr Project: https://zephyrproject.org/applications/
- Linux Foundation Research: "Zephyr at 10" (marzo 2026)
- Documentación oficial de cada producto

---

_Notas generadas para slide 24 del TP Especial — Zephyr OS vs MOSIX_
_Fundamentos de Sistemas Operativos — UNMDP_
_Mayo 2026_
