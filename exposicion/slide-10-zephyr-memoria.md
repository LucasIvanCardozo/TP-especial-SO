# Slide 10 — Zephyr OS: Administración de Memoria

> **Notas para la exposición oral del Trabajo Práctico Especial: Zephyr OS vs MOSIX**

---

## 1. 🎤 Qué Decir (Speaking Notes)

### Introducción (15 segundos)

"Zephyr usa **MPU-based protection** en lugar de MMU para la mayoría de sus configuraciones. Esto significa que prioriza la **protección** por sobre la **virtualización** de memoria. Mientras que un sistema con MMU puede implementar memoria virtual completa con paginación y swapping, la MPU solo define regiones de memoria con permisos específicos, sin capacidad de traducir direcciones virtuales a físicas."

### MPU vs MMU (25 segundos)

"¿Por qué Zephyr elige MPU sobre MMU? La respuesta está en el hardware objetivo: los microcontroladores.

La **MPU** es una unidad de hardware presente en procesadores ARM Cortex-M y RISC-V embebido. Permite configurar entre 8 y 16 regiones con permisos de lectura, escritura y ejecución. Cada acceso a memoria pasa por la MPU que verifica si está dentro de una región permitida. No hay traducción de direcciones: la dirección que usa la CPU es directamente la dirección física.

La **MMU** en cambio, presente en procesadores de aplicación como Cortex-A o x86, usa tablas de páginas para traducir direcciones virtuales a físicas, permitiendo paginación, swapping y aislamiento total entre procesos.

Para un microcontrolador con 64 KB de RAM, una MMU sería overkill: consume más energía, ocupa más silicio, y añade complejidad de software que no aporta valor."

### Las Tres Regiones de Memoria (30 segundos)

"El diagrama muestra las tres regiones fundamentales del mapa de memoria de Zephyr:

La **región KERNEL** contiene el código del kernel y se ejecuta en modo privilegiado. Tiene permisos completos de lectura, escritura y ejecución cuando el sistema está en kernel mode. Cuando una aplicación de usuario intenta escribir en esta región, la MPU lo bloquea.

La **región APPLICATION** contiene las aplicaciones de usuario ejecutándose con privilegios restringidos. Zephyr implementa user mode donde las apps no pueden acceder directamente al hardware ni a la memoria del kernel. Solo pueden interactuar mediante system calls.

La **región DRAM y PERIFÉRICOS** incluye tanto la memoria principal para datos y heap, como los dispositivos de hardware mapeados a memoria — timers, UARTs, GPIO. Los periféricos requieren atributos de memoria especiales porque no pueden ser cacheados."

---

## 2. 📌 Puntos Clave

| Concepto                 | Qué decir                                                                                                   |
| ------------------------ | ----------------------------------------------------------------------------------------------------------- |
| **MPU**                  | Memory Protection Unit — protege regiones de memoria sin traducir direcciones. 8-16 regiones configurables. |
| **Sin MMU**              | La mayoría de MCUs no tienen MMU — no hay paginación ni memoria virtual tradicional.                        |
| **Single Address Space** | Kernel y aplicaciones comparten el mismo espacio de direcciones. Aislamiento via MPU regions.               |
| **Single Address Space** | Comunicación eficiente entre threads — un puntero pasado es válido directamente.                            |
| **Determinismo**         | Sin paging dinámico, los tiempos de acceso son predecibles — crítico para tiempo real.                      |
| **No hay Thrashing**     | Los recursos están limitados por hardware, no hay competencia dinámica. Diseñado para que quepa todo.       |

---

## 3. 🔗 Relación con FSO

### §4.1 — Administración de Memoria

> Múltiples procesos compiten por memoria limitada.

En Zephyr, múltiples threads compiten por SRAM limitada (típicamente 8-512 KB). Los mecanismos de heap, slabs y memory domains son las herramientas para gestionar esa competencia.

### §4.2 y §4.3 — MFT y MVT

> Particiones fijas vs variables.

La MPU trabaja con regiones configuradas estáticamente — conceptualmente más cercano a particiones fijas. Sin embargo, los memory slabs eliminan la fragmentación interna porque usan bloques de tamaño exacto.

### §4.4 — Paginación

> Memoria lógica dividida en páginas, física en frames.

**Diferencia clave**: La MPU **no implementa paginación**. Trabaja con regiones de direcciones físicas contiguas. Esto es conceptualmente más cercano a las particiones fijas que a la paginación.

### §5.1 — Memoria Virtual

> Ilusión de más memoria de la físicamente disponible.

Zephyr **no ofrece esta ilusión** en la mayoría de configuraciones. La dirección virtual es la dirección física. Memoria virtual solo existe cuando hay MMU + demand paging habilitado.

### §5.6 — Thrashing

> Page faults excesivos causando degradación severa.

**No ocurre en Zephyr** porque: los recursos son fijos y conocidos en tiempo de compilación, no hay swapping a disco, y el developer configura explícitamente qué tasks existen.

### §1.5 — Modo Dual

> Kernel mode vs User mode.

Zephyr implementa exactamente esto vía MPU y el bit de privilegio ARM. El kernel corre en modo privilegiado con acceso total; las aplicaciones corren en modo usuario con acceso restringido por la MPU.

---

## 4. ⚠️ Cosas a Tener en Cuenta

### Por qué no hay MMU en la mayoría de MCUs

- **Costo**: La MMU ocupa más silicio (~1-5 mm² vs ~0.1 mm² de MPU)
- **Consumo de energía**: MMU requiere más transistores activos
- **Complejidad**: Page tables, TLB management, context switches más pesados
- **Beneficio limitado**: Un MCU con 64 KB de RAM ejecutando 3 tareas no necesita virtualización

### Trade-offs del Single Address Space

| Ventaja                                     | Desventaja                                                                   |
| ------------------------------------------- | ---------------------------------------------------------------------------- |
| Comunicación eficiente entre threads        | Un bug puede corromper memoria compartida si la MPU no está bien configurada |
| Syscalls son function calls (bajo overhead) | Menos aislamiento que address spaces separados                               |
| Conmutación más rápida entre threads        | No hay protección entre procesos si el developer lo permite                  |

### Demand Paging (solo cuando hay MMU)

Si el sistema tiene MMU y paging habilitado:

- Páginas se cargan bajo demanda desde backing store
- Zephyr soporta algoritmos NRU y LRU para eviction
- **Pero**: generalmente no hay almacenamiento secundario rápido conectado
- El paging es más útil para datos que para código (código ejecuta desde flash in-place)

### Allocators de Memoria en Zephyr

- **k_heap**: Heap sincronizado, seguro para multi-thread, con timeout
- **sys_heap**: Heap de bajo nivel sin sincronización, combina bloques adyacentes libres
- **Memory slabs**: Bloques de tamaño fijo, asignación O(1) determinística — ideal para pools de objetos

---

## 5. ⏱️ Tiempo Estimado

**Total recomendado: 90 segundos (1:30)**

| Sección                           | Tiempo      |
| --------------------------------- | ----------- |
| Introducción MPU-based protection | 15 segundos |
| MPU vs MMU explicación            | 25 segundos |
| Las tres regiones de memoria      | 30 segundos |
| Conexión con conceptos FSO        | 15 segundos |
| Transición a siguiente slide      | 5 segundos  |

---

## 6. 💡 Tips para la Exposición

1. **Mencioná el contexto**: "Zephyr está diseñado para microcontroladores con 8 KB a 512 KB de RAM. No estamos hablando de una PC con 16 GB."

2. **Compará visualmente**: "Imaginate una PC donde cada programa tiene su propia memoria aislada. En Zephyr, todos comparten pero la MPU vigila que nadie se cuele."

3. **Resaltá el determinismo**: "Sin paging dinámico, cuando un thread pide memoria, siempre sabe cuánto va a tardar. Esto es crítico para sistemas de tiempo real."

4. **Conectá con la próxima slide**: "Esta protección por hardware es la base de la arquitectura de seguridad de Zephyr que vemos en la próxima diapositiva."

---

## Referencias para Profundizar

- **Tema FSO**: §4.1-4.7 (Administración de Memoria), §5.1-5.6 (Memoria Virtual)
- **Documentación Zephyr**: https://docs.zephyrproject.org/latest/kernel/memory_management/index.html
- **Explicación detallada**: `../explicaciones/slide-09-explicacion.md`

---

_Material preparado para el TP Especial de Fundamentos de Sistemas Operativos — UNMDP_
