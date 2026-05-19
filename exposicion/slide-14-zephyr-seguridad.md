# Slide 14: Zephyr OS — Seguridad

> **Nota**: Esta slide es sobre Zephyr OS, no sobre MOSIX.

---

## 🎤 Qué decir (Speaking Notes)

**Apertura (~15 segundos)**

"Zephyr implementa una arquitectura de seguridad adaptada a las restricciones de los microcontroladores. A diferencia de sistemas con MMU completa, Zephyr usa **MPU — Memory Protection Unit**— un hardware más simple pero suficiente para proteger procesos entre sí."

**Desarrollo (~45 segundos)**

"En sistemas embebidos IoT, la seguridad es crítica: un dispositivo comprometido puede filtrar datos sensibles o ser usado en ataques. Zephyr implementa el **modo dual** que vimos en la teoría (§1.5): hay un modo privilegiado donde corre el kernel y un modo usuario donde corren las aplicaciones.

La diferencia clave con sistemas de escritorio es el mecanismo de protección:

- **Zephyr usa MPU**, no MMU. La MPU divide la memoria en regiones con permisos (lectura, escritura, ejecución) y protege cada región por hardware. Es más simple que una MMU completa — no tiene paginación ni memoria virtual — pero es suficiente para microcontroladores de 32 bits.

- El modo dual funciona igual que en la teoría: cuando una aplicación intenta acceder a memoria fuera de sus regiones, la MPU genera una excepción, el kernel captura el fault, y puede terminar el proceso o tomar acción.

"Además, Zephyr soporta **user mode**: las aplicaciones pueden correr con privilegios restringidos, y el kernel decide qué syscalls están permitidas. Esto limita el daño si una aplicación está comprometida."

**Cierre (~15 segundos)**

"En resumen: Zephyr logra protección robusta con hardware limitado, usando MPU + modo dual, igual que los conceptos que estudiamos."

---

## 📌 Puntos Clave

1. **MPU (Memory Protection Unit)**
   - Divide memoria en regiones con permisos
   - Protección por hardware, no software
   - Más simple que MMU (sin paginación)
   - Ideal para microcontroladores (32 bits, RAM limitada)

2. **Modo Dual (§1.5)**
   - Modo privilegiado (kernel): acceso total
   - Modo usuario (aplicaciones): regiones restringidas

3. **User Mode en Zephyr**
   - Aplicaciones pueden correr sin privilegios
   - Syscalls controladas por kernel
   - Aislamiento entre threads/procesos

4. **Privilegios escalonados**
   - Kernel > Supervisor > User
   - Cada nivel tiene acceso a recursos específicos

5. **Seguridad para IoT**
   - Dispositivos conectados = superficie de ataque
   - MPU previene que malware acceda a firmware
   - Aislamiento protege stack de red, credenciales

---

## 🔗 Relación con FSO

### §1.5 — Modo Dual de Operación

| Concepto teórico        | Implementación en Zephyr                                     |
| ----------------------- | ------------------------------------------------------------ |
| Modo Kernel             | Código del kernel corre en privilege level más alto          |
| Modo Usuario            | Aplicaciones corren con restrictions impuestas por MPU       |
| Transición por syscall  | `syscall` instruction o `svc` para pedir servicios al kernel |
| Protección por hardware | MPU enforce regions; si una app cruza su límite → fault      |

**Diferencia importante**: En sistemas de escritorio, el kernel usa MMU + tablas de páginas para protección. En Zephyr, la MPU hace algo similar pero más simple: define hasta 8-16 regiones de memoria con permisos, y cualquier acceso fuera de región genera excepción.

### §1.6 — Instrucciones Privilegiadas

En el temario, las instrucciones privilegiadas son las que solo el kernel puede ejecutar:

```
Privilegiadas: HALT, I/O, STI/CLI, MOV to CR0-CR3, HLT
No privilegiadas: ADD, SUB, MOV (entre registros), PUSH, POP, CALL, RET
```

En Zephyr con MPU:

- Las aplicaciones en user mode **no pueden** ejecutar instrucciones privilegiadas
- Si intentan hacerlo → excepción de violación de privilegio (privilege violation)
- El kernel maneja la excepción y puede terminar el proceso

### §1.7 — Interrupciones y Excepciones

Cuando la MPU detecta un acceso inválido:

1. Genera una **excepción de fault** (análoga a page fault en sistemas con MMU)
2. El hardware transfiere control al handler de excepciones del kernel
3. El kernel decide qué hacer (terminar proceso, matar thread, etc.)

### §4.4 y §5 — Memoria

| Concepto        | En sistemas con MMU            | En Zephyr con MPU                |
| --------------- | ------------------------------ | -------------------------------- |
| Protección      | Tablas de páginas + bits r/w/x | Regiones MPU                     |
| Aislamiento     | Por página (4KB)               | Por región (tamaño configurable) |
| Memoria virtual | Sí, con page tables            | No, memoria física directamente  |
| Swap a disco    | Posible                        | No (sin MMU)                     |

---

## ⚠️ Cosas a tener en cuenta

### MPU vs MMU: No es lo mismo

| Característica  | MPU                          | MMU                        |
| --------------- | ---------------------------- | -------------------------- |
| Regiones        | Limitadas (8-16 típicamente) | Miles de páginas           |
| Paginación      | No                           | Sí                         |
| Memoria virtual | No                           | Sí                         |
| Swap a disco    | No soportado                 | Soportado                  |
| Overhead        | Muy bajo                     | Bajo a medio               |
| Uso de RAM      | Mínimo                       | Tablas de páginas en RAM   |
| CPU requerida   | Microcontroladores           | Aplicaciones más complejas |

**Importante**: Zephyr puede funcionar **sin MPU** en configs mínimas (para MCUs de 8 bits), pero entonces no hay protección entre threads.

### User Mode es opcional

En Zephyr, el user mode no está habilitado por defecto. Muchas configs pequeñas corren todo en kernel mode. User mode agrega overhead de verificación pero mejora la seguridad.

### Sin MMU = Sin memoria virtual completa

Esto significa:

- **No hay swap**: si la RAM se llena, no hay dónde paging out
- **No hay protección de direcciones virtuales**: las direcciones son físicas
- **Más predecible**: sin page faults impredecibles, ideal para RTOS

### Para la exposición

- **No digan "MMU"** cuando quieran decir "MPU". Son mecanismos distintos.
- **Pueden explicar** la diferencia con una analogía: MPU es como un edificio con 8 puertas controladas por un portero; MMU es como un sistema de 4000 casilleros con llave electrónica.
- **Mencionen** que esto es lo que permite a Zephyr correr en 4KB: sin las tablas de páginas de una MMU, el overhead de memoria es mínimo.

---

## ⏱️ Tiempo estimado

**60-90 segundos** (aproximadamente 1 slide de 15 min de presentación)

| Parte                     | Tiempo |
| ------------------------- | ------ |
| Apertura + definición MPU | 20 seg |
| Comparación MPU vs MMU    | 25 seg |
| Modo dual en Zephyr       | 20 seg |
| Cierre                    | 10 seg |

---

## 📚 Glosario rápido

| Término             | Definición                                                                                    |
| ------------------- | --------------------------------------------------------------------------------------------- |
| **MPU**             | Memory Protection Unit — hardware que define regiones de memoria con permisos                 |
| **User Mode**       | Modo de ejecución sin privilegios, donde aplicaciones no pueden acceder hardware directamente |
| **Kernel Mode**     | Modo privilegiado donde corre el SO con acceso total al hardware                              |
| **Syscall**         | Llamada al sistema — mecanismo para que aplicaciones pidan servicios al kernel                |
| **Fault/Excepción** | Evento cuando una operación viola las reglas de protección                                    |

---

## 🎯 Preguntas posibles del docente

1. **"¿Por qué Zephyr usa MPU en lugar de MMU?"**

   > "Porque la MPU es más simple, consume menos energía y espacio en silicio. Los microcontroladores Ziel tienen MPU integrada pero no MMU completa. Además, sin paginación hay menos overhead y más predictibilidad — crítico para RTOS."

2. **"¿Qué pasa si una app intenta acceder a memoria de otra?"**

   > "La MPU detecta que la dirección está fuera de la región permitida y genera una excepción. El kernel recibe el fault, puede terminar el proceso infractor, y los otros procesos siguen funcionando."

3. **"¿Zephyr tiene aislamiento entre threads?"**
   > "Sí, con memory domains. Threads del mismo proceso pueden compartir o no memoria según configuración. Además, cada thread tiene su propio stack en regiones separadas."
