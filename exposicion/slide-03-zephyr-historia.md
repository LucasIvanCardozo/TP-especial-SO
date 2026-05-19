# Slide 03 — Notas de Exposición: Zephyr OS — La Empresa

> **Título de la slide:** Zephyr OS — La Empresa
> **Subtítulo:** Historia, gobernanza y miembros

---

## 1. 🎤 Qué Decir (Notas para Explicar)

### Apertura y Contexto

"Vamos a hablar de la empresa detrás de Zephyr, es decir, cómo nació este proyecto y qué lo sostiene hoy en día."

### La Genealogía del Código

"Zephyr no apareció de la nada en 2016. El código base tiene sus raíces en los **años 90**, cuando la empresa belga **Eonic Systems** desarrolló **Virtuoso RTOS**, un sistema operativo de tiempo real para procesadores de señal digital, los famous DSPs."

"¿Por qué es importante esto? Porque cuando Wind River adquirió Eonic Systems en 2001, Virtuoso pasó a formar parte del ecosistema Wind River, que es la empresa creadora de **VxWorks**, uno de los RTOS más famosos del mundo."

### El Salto al Open Source

"En **noviembre de 2015**, Wind River tomó una decisión estratégica: liberar el código de Virtuoso, renombrándolo como **Rocket RTOS**, y ofrecerlo **libre de regalías**. El tamaño del kernel era impresionante: apenas **4 KB**, comparado con los 200 KB de VxWorks."

"Esta decisión respondía al auge del mercado de **IoT**, donde los microcontroladores tienen recursos extremadamente limitados."

### Nacimiento de Zephyr

"En **febrero de 2016**, Wind River donó el kernel de Rocket a la **Linux Foundation**, naciendo oficialmente el proyecto **Zephyr Project**."

Mencionar los founding members: "Las empresas que iniciaron todo esto fueron Intel, Wind River, Synopsys y NXP Semiconductors."

### Gobernanza Bajo Linux Foundation

"¿Por qué Linux Foundation y no Amazon, Google o Microsoft? La respuesta es **neutralidad**. Zephyr no pertenece a ninguna empresa grande de tecnología. Esto es atractivo para las empresas que fabrican productos de ciclo de vida largo — imaginen un dispositivo médico que debe funcionar 20 años — no quieren depender de que Amazon no cambie de opinión."

"La gobernanza tiene tres niveles: el **Governing Board**define políticas, el **TSC** (Technical Steering Committee) toma las decisiones técnicas, y hay un **Security Committee** que maneja vulnerabilidades."

### Crecimiento Actual

"Desde 2016 hasta hoy, Zephyr creció a más de **3.000 contribuyentes**, soporta más de **1.000 placas** diferentes, y en 2026 el 70% de las organizaciones en Norteamérica lo usan en productos comerciales."

---

## 2. 📌 Puntos Clave para Enfatizar

| Fecha | Evento | Por qué importa |
|-------|--------|-----------------|
| **Finales '90** | Eonic Systems crea Virtuoso RTOS | Origen real del código, 15+ años de desarrollo comercial previo |
| **2001** | Wind River adquiere Eonic Systems | Conexión con VxWorks, gigante del mercado RTOS |
| **2009** | Intel compra Wind River por $884M | Consolidación de la industria embedded |
| **Nov 2015** | Código abierto como Rocket RTOS (~4 KB) | Nacimiento del código libre |
| **Feb 2016** | Donación a Linux Foundation → Zephyr | Fundación oficial del proyecto |
| **2016-2026** | Crecimiento continuo | Madurez comercial comprobada |

**Members corporativos clave (2025):** Qualcomm, CARIAD (Volkswagen), Renesas, ZEISS, Analog Devices, Silicon Labs, Antmicro

**Modelo de gobernanza:**
- Governing Board → políticas y estrategia
- TSC → decisiones técnicas (Chair: Anas Nashif, Intel)
- Security Committee → vulnerabilidades y disclosures

---

## 3. 🔗 Relación con FSO (§1.2 y §1.4)

### §1.2 — Generaciones de Sistemas Operativos

Esta slide conecta directamente con las generaciones del temario:

| Generación | Características | Zephyr como ejemplo |
|------------|-----------------|---------------------|
| **3ª (1965-1980)** | Multiprogramación, time-sharing | Virtuoso ya era RTOS con scheduling preemptive |
| **4ª (1980-1990)** | Microprocesadores, UNIX, Linux | Zephyr hereda filosofía UNIX/Linux, hospedado en Linux Foundation |
| **5ª (1990-presente)** | IoT, móvil, nube | Zephyr es específicamente un RTOS para IoT |

**Punto pedagógico:** "Zephyr demuestra que las generaciones no son cajas rígidas. Un RTOS de IoT en 2026 combina características de la 4ª generación — el modelo open source inspirado en UNIX/Linux — con constraints de la 3ª generación — sistemas de tiempo real con multiprogramación."

### §1.4 — Arquitecturas de SO

Zephyr implementa **arquitectura microkernel**:

> *Del temario: "Kernel mínimo, servicios en usuario" → MINIX, QNX, macOS*

**En Zephyr:**
- **Nanokernel**: scheduling, interrupciones, sincronización (mínimo)
- **Microkernel unificado** (desde v1.6, dic 2016): drivers, filesystem, networking
- **Servicios en modo usuario**: shell, logs, debugging

**Tradeoffs del microkernel (§1.4):**

| Ventaja | Desventaja |
|---------|------------|
| Modularidad: servicios arrancan/detienen independientemente | Mayor overhead de IPC (comunicación entre procesos) |
| Seguridad: fallo en driver no corrompe kernel | Latencia potencialmente mayor para syscalls |
| Portabilidad: portar microkernel requiere reescribir poco código | |

**Comparación rápida:**
- Zephyr ≠ Linux (que es monolithítico)
- Zephyr ≈ MINIX, QNX (microkernel para sistemas embebidos/ tiempo real)

### Conexión con gobernanza

"La gobernanza de Zephyr es funcionalmente una arquitectura **cliente-servidor** (§1.4): los miembros proponen cambios, el TSC orquesta la implementación. Análogo a cómo systemd o DBus en Linux moderno operan como servicios que se comunican por mensajes."

---

## 4. ⚠️ Cosas a Tener en Cuenta

### Para el Momento de la Presentación

1. **No leer la línea de tiempo completa.** La slide ya la muestra visualmente. Mencioná los hitos clave y dejá que la audiencia lea el resto.

2. **Evitar perderse en detalles de fusiones/adquisiciones.** El punto no es Wind River → Intel → TPG Capital. El punto es: "este código tiene más de 25 años de desarrollo comercial."

3. **El número 4 KB es impactante.** Si mostrás la slide, enfatizá: "4 kilobytes. Para que se den una idea, una foto de celular típica ocupa 4 megabytes. Zephyr cabe mil veces en eso."

4. **Linux Foundation no es Linux kernel.** Aclarar que Linux Foundation hospeda proyectos pero Zephyr no es parte del kernel Linux. Zephyr es un proyecto separado que usa la fundación como entidad neutral.

5. ** founding members ≠ miembros actuales.** En 2016 había 4 empresas. En 2026 hay docenas. Esto muestra madurez, no contradicción.

### Para Preguntas del Audiencia

- **"¿Zephyr usa código del kernel Linux?"** → No directamente. Zephyr es un proyecto separado. Comparte filosofía de desarrollo (git, code review, mailing lists) pero no comparte código con el kernel Linux.

- **"¿Por qué no usar Linux directamente?"** → Linux requiere típicamente 1-2 MB de RAM mínimo. Zephyr corre en 4 KB. Para un microcontrolador Cortex-M0+ con 16 KB de RAM total, Linux es inviable.

- **"¿Qué pasa si Intel deja de participar?"** → El modelo Linux Foundation está diseñado para que ninguna empresa sea indispensable. El código pertenece al proyecto, no a Intel.

---

## 5. ⏱️ Tiempo Estimado

| Sección | Tiempo | Contenido |
|---------|--------|-----------|
| Apertura | 10-15 seg | Contextualizar la slide |
| Genealogía | 25-30 seg | Virtuoso → Wind River → Rocket |
| Nacimiento de Zephyr | 20-25 seg | Donación a Linux Foundation, founding members |
| Gobernanza | 15-20 seg | Por qué Linux Foundation, estructura de gobierno |
| Crecimiento actual | 10-15 seg | Números 2026 |
| **Total** | **60-90 seg** | ~1 a 1.5 minutos |

**Tip:** Esta slide tiene mucha información pero es fundamentalmente narrativa. Si el tiempo apremia, recortá los números de membresía y la sección de gobernanza — la historia es lo más memorable.

---

## 6. Recursos Visuales de Apoyo

Si querés preparar material complementario:

1. **Diagrama de línea de tiempo** (podés proyectar la imagen de la slide): Mostrá visualmente Virtuoso → Rocket → Zephyr con fechas.

2. **Comparativa de tamaño**: Una imagen mostrando 4 KB vs 200 KB vs 1-2 MB para impresionar con la miniaturización.

3. **Logos de miembros**: Mostrar los Platinum members (Qualcomm, Volkswagen/CARIAD, Renesas, ZEISS) da credibilidad comercial.

---

## 7. Glosario Rápido para Referencia

| Término | Definición |
|---------|------------|
| **RTOS** | Real-Time Operating System — debe completar tareas dentro de deadlines garantizados |
| **Microkernel** | Diseño de kernel mínimo con servicios en espacio de usuario |
| **Linux Foundation** | Organización sin fines de lucro que hospeda proyectos open source (no es Linux kernel) |
| **Founding Members** | Empresas que iniciaron el proyecto en 2016 |
| **Vendor lock-in** | Dependencia de un proveedor específico — Zephyr lo evita al ser neutral |
| **Footprint** | Cantidad de memoria RAM/ROM que consume el SO (~4 KB en Zephyr) |

---

*Notas generadas para el Trabajo Práctico Especial de Fundamentos de Sistemas Operativos — UNMDP*
*Comparativa: Zephyr OS vs MOSIX*
