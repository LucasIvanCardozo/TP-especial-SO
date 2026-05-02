# slide-13-explicacion.md — Seguridad en Zephyr OS

## Introducción y Contexto

La slide 13 aborda la **arquitectura de seguridad de Zephyr OS**, un RTOS diseñado específicamente para sistemas embebidos IoT de recursos restringidos. A diferencia de sistemas operativos de propósito general, Zephyr debe proporcionar mecanismos de seguridad robustos sin el overhead de una MMU completa, trabajando frecuentemente en microcontroladores con solo una MPU (Memory Protection Unit). La seguridad en Zephyr es multicapa, cubriendo desde el boot hasta la ejecución de aplicaciones, e incluye tanto mecanismos hardware como software.

---

## 1. MPU + Modo Dual de Operación (§1.5, §1.6)

### 1.1 Memory Protection Unit (MPU)

La **MPU (Memory Protection Unit)** es una unidad de hardware presente en microcontroladores que permite definir **regiones de memoria** con atributos específicos de protección. A diferencia de una MMU (Memory Management Unit) completa, la MPU no implementa paginación ni memoria virtual — su función es exclusivamente la protección de regiones de memoria ya mapeadas.

**Funcionamiento interno de la MPU:**

La MPU divide la memoria en un número limitado de regiones (típicamente 8-16 en arquitecturas ARM Cortex-M, 8 en x86 embebido, variable en ARC). Cada región tiene:
- **Dirección base**: punto de inicio de la región en memoria física
- **Tamaño**: dimensión de la región (potencias de 2)
- **Atributos**: permisos de acceso (read, write, execute) y características (shareable, cacheable)

**Regiones MPU en Zephyr:**

| Tipo de Región | Atributos Típicos | Propósito |
|---------------|-------------------|-----------|
| Código/Flash | Read + Execute, No Write | Memoria de programa |
| Datos/RAM | Read + Write, No Execute | Variables y heap |
| peripherals | Read + Write, No Execute, Strongly Ordered | Registros de hardware |
| Stack (user) | Read + Write, No Execute, Privileged | Pila de thread no privilegiado |
| Stack (kernel) | Read + Write, No Execute, Privileged | Pila de thread privilegiado |

**Configuración de regiones MPU:**

La MPU se configura mediante instrucciones privilegiadas (§1.6). En arquitecturas ARM, las instrucciones `MRC` (Move from Coprocessor) y `MCR` (Move to Coprocessor) acceden a los registros de la MPU. En x86 embebido, se usan registros específicos del modelo como `MSR` (Model Specific Register). Estas instrucciones solo pueden ejecutarse en kernel mode (modo privilegiado), lo que significa que código de usuario no puede modificar la configuración de protección.

### 1.2 Modo Dual de Operación (§1.5)

Zephyr implementa el modelo de **modo dual de operación** donde el código puede ejecutarse en dos niveles de privilegio:

```
┌──────────────────────────────────────────────┐
│           MODO PRIVILEGIADO (Kernel)         │
│  - Acceso completo a hardware                 │
│  - Puede configurar MPU                       │
│  - Instrucciones privilegiadas permitidas     │
│  - Acceso a todas las regiones de memoria     │
├──────────────────────────────────────────────┤
│         MODO NO PRIVILEGIADO (User)           │
│  - Restricciones MPU activas                 │
│  - Solo puede acceder a regiones designadas  │
│  - Instrucciones privilegiadas generan trap  │
│  - No puede configurar MPU                    │
└──────────────────────────────────────────────┘
```

**Implementación en Zephyr:**

La opción `CONFIG_USERSPACE` habilita la ejecución en modo usuario. Cuando un thread se crea con `K_THREAD_ACCESS_FLAGS`, se le pueden asignar:
- **Execution level**: Determines si corre en modo privilegiado o no privilegiado
- **Memory domains**: Conjuntos de regiones de memoria a las que puede acceder
- **Stack size**: Tamaño de su stack, que se protege con la MPU

**Cambio entre modos:**

En el modelo tradicional de sistemas operativos (como Linux), la transición de user mode a kernel mode ocurre mediante:
1. Una **system call** (`syscall` instruction en x86-64, `svc` en ARM)
2. Una **interrupción** (timer, hardware)
3. Una **excepción** (page fault, división por cero)

En Zephyr, como se detalla más adelante, las system calls se implementan como function calls directos debido al diseño de single address space. Sin embargo, el cambio de privilege level sí ocurre en las transiciones mencionadas.

### 1.3 Aislamiento de Threads y Memory Domains

Los **memory domains** son un concepto de Zephyr que permite crear grupos de threads que comparten acceso a regiones específicas de memoria. Esto es particularmente útil para implementar separación entre componentes.

**Funcionamiento:**

1. Se crea un memory domain con `k_mem_domain_create()`
2. Se le asignan particiones (regiones de memoria) con `k_mem_domain_add_partition()`
3. Threads se agregan al domain con `k_mem_domain_add_thread()`
4. En cada context switch, la MPU se reconfigura según el domain del thread entrante

**Verificación en context switch:**

Cada vez que ocurre un context switch (§2.2 del temario), el scheduler de Zephyr:
1. Salva el contexto del thread saliente
2. Configura la MPU con las regiones del memory domain del thread entrante
3. Restaura el contexto del thread entrante

Esta verificación en cada cambio de contexto garantiza que un thread malicioso o defectuoso no pueda escapar su jaula de memoria.

---

## 2. Single Address Space + System Calls (§1.7, §1.8)

### 2.1 Arquitectura de Binario Estático

Una decisión arquitectónica fundamental de Zephyr es el **diseño monolítico seguro**: kernel y todas las aplicaciones se compilan en **un único binario estático**. Esta eliminación del dynamic loader tiene implicaciones profundas para la seguridad.

**Ventajas de seguridad del diseño estático:**

| Aspecto Eliminado | Riesgo Asociado |
|------------------|-----------------|
| `dlopen()` / `dlsym()` | Carga de libraries compartidas maliciosas |
| PLT/GOT | Hijacking deProcedure Linkage Table |
| ELF dynamic loading | Parsing de binarios dynamicamente |
| Relocation security | Ataques a relocations runtime |

**Comparación con otros RTOS:**

En RTOS más tradicionales, las aplicaciones se cargan separadamente y se linking dinámicamente. Esto permite flexibilidad pero introduce superficies de ataque significativas:
- Un atacante que comprometa el loader puede inyectar código
- Las GOT entries pueden ser sobrescritas (GOT hijacking)
- Libraries compartidas con vulnerabilidades afectan a todas las apps

Zephyr evita estos problemas compilando todo en un único binario donde cada dirección de función es resolved en tiempo de compilación.

### 2.2 System Calls como Function Calls

En sistemas operativos convencionales (§1.8), una llamada al sistema implica:
1. Usuario ejecuta `open()` (library wrapper)
2. Library ejecuta instrucción `syscall` / `int 0x80`
3. CPU cambia de user mode a kernel mode (mode switch)
4. Kernel ejecuta handler de syscalls
5. Kernel regresa a user mode (otro mode switch)

Este modelo tiene overhead significativo por los dos cambios de modo (user→kernel→user).

**Zephyr innova aquí:** dado que kernel y aplicaciones comparten el mismo espacio de direcciones y el kernel confía en las aplicaciones (están en el mismo binario), Zephyr implementa **system calls como function calls directos**.

**Funcionamiento:**

```
// En user mode (thread no privilegiado)
fd = z_syscall_open("/dev/tty0", O_RDONLY);

// Se compila como llamada a función directa
// Zephyr羽 tiene magia de link-time para resolver esto

// El "syscall" realmente hace:
// 1. Verifica que el thread tiene permisos (k_obj_permission_check())
// 2. Ejecuta la función del kernel correspondiente
// 3. Regresa directamente sin mode switch
```

**Nota crítica:** Esta optimización es posible porque el código de aplicación es trusted — está compilado en el mismo binario que el kernel. Si Zephyr soportara carga dinámica de código, esta optimización no sería segura.

### 2.3 Eliminación de Dynamic Loaders

Sin dynamic loaders, Zephyr elimina:
- **dlfcn.h** functions: `dlopen`, `dlsym`, `dlclose`, `dlerror`
- **Runtime linker**: El mecanismo que resuelve símbolos en libraries compartidas
- **ELF dynamic section**: La sección del binario que guía al loader dinámico
- **Lazy binding**: El mecanismo de resolución de símbolos on-demand

Esto reduce significativamente:
- **Footprint**: Menos código de runtime
- **Boot time**: No hay resolución de símbolos al iniciar
- **Superficie de ataque**: Menos vectores de ataque

---

## 3. Secure Boot + MCUboot + A/B Partitioning

### 3.1 Chain of Trust (Cadena de Confianza)

El **secure boot** en Zephyr implementa una cadena de confianza donde cada componente verifica al siguiente antes de ejecutarlo. Esta cadena comienza en hardware y termina en la aplicación.

```
┌─────────────────────────────────────────────────────────────┐
│                    HARDWARE (SoC)                           │
│              Root of Trust (RoT) — immutable                │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              ROM BOOTLOADER (on-chip)                      │
│    First-stage immutable bootloader específico del SoC       │
│    - Verifica integridad del próximo eslabón                │
│    - Configura clocks y memoria                             │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                    MCUboot (Primary Boot)                   │
│    Bootloader portable que:                                  │
│    - Verifica firma asimétrica del firmware Zephyr          │
│    - Usa clave pública embebida en build                    │
│    - Supporta A/B partitioning para updates                  │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              ZEPHYR KERNEL + APPLICATIONS                    │
│    Binario estático firmado cryptográficamente               │
│    - Kernel en modo privilegiado                            │
│    - Aplicaciones pueden correr en user mode                │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Firmas Asimétricas (RSA/ECDSA)

MCUboot utiliza **criptografía de clave pública** para verificar la autenticidad del firmware:

**Algoritmos soportados:**

| Algoritmo | Tipo | Uso en MCUboot |
|-----------|------|----------------|
| **RSA-2048** | Asimétrico | Firmas primarias |
| **RSA-3072** | Asimétrico | Mayor seguridad |
| **ECDSA P-256** | Asimétrico | Mejor para MCUs restringidos |
| **ECDSA P-384** | Asimétrico | Mayor tamaño clave |

**Proceso de firma:**

1. **Build time**: El binario de Zephyr se firma con la clave privada del desarrollador
2. **La clave pública se embebe** en el bootloader MCUboot durante el build
3. **Boot time**: MCUboot recalcula el hash del firmware y lo compara con la firma decriptada con la clave pública

```
Firma = RSA_Sign(private_key, SHA256(firmware))
Verificación = RSA_Verify(public_key, Firma, SHA256(firmware))
```

### 3.3 A/B Partitioning para Updates Atómicos

El **A/B partitioning** (también llamado dual-bank o dual-slot) es una técnica que permite actualizaciones atómicas del firmware.

**Concepto:**

```
┌────────────────────────────────────────────────────────────┐
│                    FLASH MEMORY                            │
├─────────────────────────────┬──────────────────────────────┤
│       SLOT 0 (A)            │       SLOT 1 (B)             │
│  Firmware actual en uso     │  Nuevo firmware (recibido)   │
│  Read-only durante operación │ Writable hasta confirmación  │
└─────────────────────────────┴──────────────────────────────┘
```

**Flujo de actualización:**

1. **Download**: Nuevo firmware se descarga a slot 1 (inactivo)
2. **Verification**: MCUboot verifica la firma del nuevo firmware
3. **Swap/Move**: Según el modo configurado:
   - **Swap**: Se intercambian los slots atómicamente
   - **Direct**: Se escribe directamente sobre slot 0
   - **Overwrite**: Se copia slot 1 sobre slot 0
4. **Rollback protection**: Si el nuevo firmware falla en boot, se vuelve al anterior

**Modes de swap en MCUboot:**

| Modo | Descripción | Uso |
|------|-------------|-----|
| **test** | Ejecuta nuevo firmware en RAM sin tocar slots | Testing |
| **preload** | Carga nuevo firmware pero no lo activa | Validación previa |
| **swap-scratch** | Intercambia slots usando scratch area | MCUs con RAM limitada |
| **swap** | Intercambio directo de slots | Flash grande |

### 3.4 Rollback Protection

La **protección contra rollback** evita que un atacante instale una versión anterior del firmware que contenga vulnerabilidades conocidas.

**Implementación:**

- MCUboot mantiene un **contador de imágenes** en flash
- Cada versión de firmware incrementa este contador
- Solo se permite instalar versiones con contador mayor o igual al actual
- El contador persiste en una región de flash inmutable

---

## 4. PSA Crypto API + mbedTLS

### 4.1 Platform Security Architecture (PSA)

La **PSA Crypto API** es una interfaz de programación diseñada por **Arm** como parte de su framework Platform Security Architecture. Su objetivo es proporcionar cryptography estandarizada para dispositivos IoT de recursos restringidos.

**Principios de diseño:**

| Principio | Descripción |
|-----------|-------------|
| **Portabilidad** | Misma API en cualquier plataforma (ARM, RISC-V, x86) |
| **Flexibilidad algorítmica** | Fácil switching entre algoritmos |
| **Opaque key handles** | Las claves nunca se exponen directamente |
| **Cryptographic agility** | Soporte para nuevos algoritmos sin cambiar API |
| **Separación de concerns** | La API no depende de la implementación subyacente |

### 4.2 Casos de Uso en Zephyr

La PSA Crypto API en Zephyr soporta múltiples casos de uso críticos para IoT:

| Caso de Uso | Descripción | Primitivas PSA Crypto |
|-------------|-------------|----------------------|
| **Network Security (TLS/DTLS)** | Conexiones seguras sobre IP | AEAD (AES-CCM, ChaCha20-Poly1305), HKDF, signature |
| **Secure Storage** | Almacenamiento cifrado de datos | Symmetric ciphers, key derivation |
| **Network Credentials** | Gestión de X.509, PSKs | Certificate parsing, PSK derivation |
| **Device Pairing** | Emparejamiento seguro de dispositivos | ECDH, ECDHE key agreement |
| **Secure Boot** | Verificación de firmware | Hash, signature verification |
| **Attestation** | Prueba de identidad del dispositivo | HMAC, signature |
| **Factory Provisioning** | Instalación de claves de identidad | Key generation, import |

### 4.3 mbedTLS como Backend

**mbedTLS** es una biblioteca criptográfica de código abierto mantenida por **Trusted Firmware** (bajo governance de Linaro). Zephyr utiliza mbedTLS como implementación subyacente de la PSA Crypto API.

**Configuraciones predefinidas en Zephyr:**

```
Configuraciones mbedTLS disponibles:
├── config-ccm-psk-tls1_2.h    → TLS 1.2 con AES-CCM y Pre-Shared Keys
├── config-coap.h               → Para protocolos CoAP/DTLS
├── config-mini-dtls1_2.h       → DTLS 1.2 mínimo (para dispositivos muy restringidos)
└── config-mini-tls1_2.h        → TLS 1.2 mínimo
```

**TLS 1.2 mínimo por defecto:** Zephyr requiere TLS 1.2 como mínimo, rechazando conexiones con versiones anteriores (SSL 3.0, TLS 1.0, TLS 1.1) que tienen vulnerabilidades conocidas.

### 4.4 PSA Crypto API en la Práctica

**Manejo de errores:**

Todas las funciones PSA Crypto retornan `psa_status_t`:
- `PSA_SUCCESS` si la operación fue exitosa
- Códigos de error específicos (`PSA_ERROR_INVALID_ARGUMENT`, `PSA_ERROR_HARDWARE_FAILURE`, etc.)

**Concurrencia:**

- La API permite **un writer** o **múltiples lectores** simultáneos sobre el mismo objeto
- Accesos concurrentes de escritura al mismo objeto tienen **comportamiento indefinido**
- La aplicación debe serializar escritura si es necesario

**Limpieza de datos sensibles:**

Zephyr recomienda (y la PSA Crypto API facilita):
- Limpiar buffers temporales en stack o heap después de uso
- Abortar operaciones incompletas si ocurre un error
- Destruir claves (`psa_destroy_key()`) cuando ya no se necesitan

---

## 5. Stack Protection + Stack Guards

### 5.1 El Problema del Stack Overflow

El **stack buffer overflow** es una de las vulnerabilidades más antiguas y comunes en sistemas de software. Ocurre cuando un programa escribe más datos de los que el buffer en el stack puede contener, sobrescribiendo:

1. **Variables locales** adyacentes en el stack frame
2. **Saved registers** del llamador
3. **Return address** (dirección de retorno)
4. **Saved frame pointer**

Un overflow exitoso puede:
- Corromper la lógica del programa
- Sobrescribir la return address para redirigir ejecución
- Escalate privileges si se corrompe memoria del kernel

### 5.2 Stack Guards en Zephyr

Zephyr implementa **stack guards** como mecanismo de protección disponible desde la versión 1.9.0.

**Mecanismo de canary:**

```
┌─────────────────────────────────────────────────────────────┐
│                    STACK FRAME                              │
├─────────────────────────────────────────────────────────────┤
│  Return Address          ←── Sobrescrito por overflow       │
├─────────────────────────────────────────────────────────────┤
│  Saved Frame Pointer                                    │
├─────────────────────────────────────────────────────────────┤
│  Local Variables                                         │
├─────────────────────────────────────────────────────────────┤
│  ...                                                      │
├─────────────────────────────────────────────────────────────┤
│  CANARY VALUE    ←── Guard bytes (0xFF, 0xDEADBEEF, etc.) │
├─────────────────────────────────────────────────────────────┤
│  Buffer que puede overflowear                              │
└─────────────────────────────────────────────────────────────┘
```

**Ubicación del canary:** El canary se coloca entre los buffers automáticos y la dirección de retorno. Si un overflow ocurre, debe sobrescribir el canary antes de llegar a la return address.

**Detección:** Antes de cada `return` de función o antes de un context switch, el runtime verifica que el canary no haya sido modificado.

### 5.3 Verificación en Context Switch

Como se mencionó anteriormente, Zephyr verifica la integridad del stack en cada context switch:

1. **Antes de des schedule un thread**: Se verifica que el canary de su stack no haya sido modificado
2. **Si el canary está corrupto**: Se asume stack overflow y se toma acción (típicamente matar el thread o el sistema)

Esta verificación es computacionalmente barata comparada con verificar cada función, y garantiza detección oportuna.

### 5.4 MPU-based Stack Isolation

Además de los stack guards, Zephyr utiliza la MPU para marcar las regiones de stack como **no-executables**:

```c
// Configuración típica de región de stack en MPU
MPU_REGION(stack_region, stack_base, stack_size,
    MPU_RW |           // Read-write
    MPU_XN             // No execute
);
```

Esto significa que aunque un atacante logra escribir código shell en el stack, la CPU generará una excepción al intentar ejecutarlo.

### 5.5 Configuración en Kconfig

Las opciones relevantes en Kconfig:

| Opción | Descripción |
|--------|-------------|
| `CONFIG_STACK_USAGE` | Habilita análisis de uso de stack en tiempo de compilación |
| `CONFIG_HW_STACK_PROTECTION` | Usa features del compilador + MPU para protección |
| `CONFIG_STACK_GUARD` | Agrega guard bytes a cada stack frame (si la arquitectura lo soporta) |

**Nota:** La protección de stack tiene overhead de rendimiento y consumo de memoria adicional, por lo que está deshabilitada por defecto en builds de producción.

---

## 6. OpenSSF Gold Badge

### 6.1 OpenSSF Best Practices Badge

El **OpenSSF Best Practices Badge** es un programa de la **Open Source Security Foundation** que certifica que proyectos de código abierto siguen mejores prácticas de seguridad reconocidas por la industria.

**Niveles de certificación:**

| Nivel | Requisitos |
|-------|------------|
| **Passing** | Todos los criterios MUST básicos cumplidos |
| **Silver** | 50% adicional de criterios SHOULD con justificación documentada |
| **Gold** | 21 criterios MUST adicionales + 2 SHOULD + auditoría externa |

### 6.2 Zephyr Gold Badge (2019)

Zephyr fue uno de los primeros proyectos en obtener el **Gold Badge**, cumpliendo criterios rigurosos:

**Categorías principales:**

| Categoría | Criterios Cumplidos | Detalles |
|-----------|---------------------|----------|
| **Basics (5/5)** | Descripción, bus factor ≥12, contributors ≥2, copyright, license | Proyecto maduro con comunidad |
| **Change Control (4/4)** | Git distribuido, small tasks, 2FA obligatorio | Proceso de desarrollo seguro |
| **Quality (7/7)** | Code review documentado, two-person review, reproducible builds, CI/CD, **90% statement coverage**, **80% branch coverage** | Testing riguroso |
| **Security (5/5)** | TLS 1.2 mínimo, crypto en red, hardening headers, auditoría NCC 2020, stack protectors | Seguridad robusta |
| **Analysis (2/2)** | Dynamic analysis (GCov, ASAN), assertions en tests | Validación continua |

**Criterios destacados:**
- **90% statement coverage**: El 90% de las líneas de código se ejecutan durante los tests
- **80% branch coverage**: El 80% de las decisiones lógicas (if/else) se verifican
- **Auditoría NCC Group 2020**: Evaluación de seguridad por firma externa

### 6.3 Security Subcommittee

El **Zephyr Security Subcommittee** es el comité dedicado a mantener y mejorar la postura de seguridad del proyecto.

**Responsabilidades:**

| Responsabilidad | Descripción |
|-----------------|-------------|
| **Proceso de seguridad** | Definir y documentar procesos de desarrollo seguro |
| **Enforcement** | Asegurar adherencia a guidelines de codificación segura |
| **Code review** | Supervisar que reviews consideren seguridad |
| **Vulnerability management** | Evaluar, clasificar y mitigar vulnerabilidades reportadas |
| **Mejora continua** | Actualizar guidelines ante nuevas amenazas |

**Proceso de vulnerabilidad:**

1. Reporte privado vía GitHub Security Advisories
2. Revisión por subcommittee (mínimo 3 asistentes)
3. Clasificación con CVSS (Common Vulnerability Scoring System)
4. Desarrollo de fix y workarounds
5. Divulgación coordinada con plazos definidos

---

## 7. Conexión con Temario FSO

### 7.1 §1.5 — Modo Dual de Operación

El temario define:

> **Modo Kernel**: Ejecuta el SO, acceso completo al hardware, instrucciones privilegiadas
> **Modo Usuario**: Ejecuta aplicaciones, acceso limitado a memoria/instrucciones

**Aplicación en Zephyr:**

Zephyr implementa exactamente este modelo:
- El kernel de Zephyr corre en modo privilegiado (kernel mode)
- Threads con `CONFIG_USERSPACE` habilitado pueden correr en modo no privilegiado (user mode)
- La MPU hardware enforce las restricciones de memoria en user mode
- El cambio entre modos ocurre en interrupciones, excepciones, y (en el diseño de Zephyr) syscalls

### 7.2 §1.6 — Instrucciones Privilegiadas

El temario lista ejemplos de instrucciones privilegiadas:

| Privilegiadas | No Privilegiadas |
|---------------|-------------------|
| Halt, I/O | ADD, SUB, MOV |
| STI/CLI | PUSH, POP |
| LGDT/SGDT | CALL, RET |
| MOV to CR0-CR3 | JMP, JE, JNE |

**Aplicación en Zephyr:**

La configuración de la MPU se realiza mediante instrucciones privilegiadas:
- En **ARM**: Instrucciones `MCR p15, 0, <Rt>, c6, c3, 0` para escribir regiones MPU
- En **x86**: Escritura a MSRs (Model Specific Registers) específicos de MPU
- En **ARC**: Registros de control de MPU accesibles solo en modo privilegiado

Un thread corriendo en user mode que intenta ejecutar estas instrucciones recibirá una excepción (General Protection Fault en x86, UsageFault en ARM).

### 7.3 §1.7 — Interrupciones

El temario categoriza interrupciones:

| Tipo | Origen |
|------|--------|
| Hardware | Dispositivos físicos |
| Software | Instrucción `syscall` |
| Excepción | Error de ejecución |

**Aplicación en Zephyr:**

- Las interrupciones de hardware siguen el modelo estándar
- En Zephyr, las system calls son function calls directos, pero las interrupciones y excepciones sí triggers cambios de privilegio
- Cuando una excepción ocurre en user mode, la CPU transiciona a kernel mode para handle

### 7.4 §1.8 — Llamadas al Sistema

El temario define syscalls como "interfaz entre programas de usuario y servicios del kernel".

**Innovación de Zephyr:**

El modelo tradicional (§1.8) usa syscall instruction con mode switch:
```
User → syscall instruction → Kernel (mode switch) → service → User (mode switch)
```

Zephyr optimiza esto dado su trust model de binario único:
```
User → function call → Kernel (sin mode switch, mismo privilege level para trusted code)
```

Esta optimización solo es posible porque:
1. Kernel y aplicaciones están en el mismo binario (confianza built-in)
2. No hay soporte para cargar código no confiado en runtime
3. Las restricciones de MPU se aplican a nivel de thread, no de proceso

---

## 8. Glosario de Términos

### A

**A/B Partitioning (Dual-bank)**
Técnica de update de firmware donde existen dos particiones de memoria de igual tamaño (slot A y slot B). El dispositivo ejecuta desde una mientras la otra puede recibir updates. Permite actualizaciones atómicas y rollback.

**AES-CCM**
Advanced Encryption Standard with Counter with CBC-MAC. Modo de operación AES que provee confidencialidad y autenticación. Común en IoT por su eficiencia en hardware limitado.

**Attestation**
Capacidad de un dispositivo de probar su identidad e integridad a un tercero, típicamente usando claves хранящиеся en secure hardware.

### C

**Canary (Stack Canary)**
Valor especial colocado entre buffers de stack y la dirección de retorno. Si es sobrescrito, indica buffer overflow.

**Cryptographic Agility**
Propiedad de un sistema que permite cambiar algoritmos criptográficos sin modificar la API o infraestructura.

**CVSS (Common Vulnerability Scoring System)**
Sistema de puntuación estándar para vulnerabilities de seguridad. Rango 0-10, donde 10 es la severidad máxima.

### G

**Gold Badge (OpenSSF)**
Certificación de nivel más alto del OpenSSF Best Practices Badge. Requiere auditoría externa, 90%+ statement coverage, 80%+ branch coverage, y múltiples criterios MUST adicionales.

**GOT (Global Offset Table)**
Tabla en binarios ELF que contiene direcciones de símbolos que deben ser resolved en runtime. Objetivo de ataques de GOT hijacking.

### H

**HKDF (HMAC-based Key Derivation Function)**
Función de derivación de claves basada en HMAC. Usada para derivar claves de sesión de material maestro.

**HMAC (Hash-based Message Authentication Code)**
Código de autenticación de mensaje que usa una función hash criptográfica y una clave secreta.

### M

**mbedTLS**
Biblioteca criptográfica de código abierto mantenida por Trusted Firmware. Backend común para PSA Crypto API en Zephyr.

**MCUboot**
Bootloader de código abierto diseñado para microcontroladores. Implementa secure boot con firmas asimétricas y A/B partitioning.

**MMU (Memory Management Unit)**
Unidad de hardware que implementa memoria virtual: paginación, segmentación, protección de memoria. Más compleja y costosa que MPU.

**MPU (Memory Protection Unit)**
Unidad de hardware que implementa protección de memoria por regiones. No soporta memoria virtual, solo protección estática.

**MPRC (Memory Protection Region Configuration)**
Configuración de una región individual en la MPU: dirección base, tamaño, atributos.

### O

**OTA (Over-the-Air)**
Actualización de firmware remotely a través de conexión de red. Incluye mecanismos de seguridad como firmas digitales y A/B partitioning.

### P

**PCB (Process Control Block)**
Estructura de datos del kernel que contiene toda la información de un proceso/thread. En Zephyr, el equivalente es el `k_thread` struct.

**PLT (Procedure Linkage Table)**
Tabla en binarios ELF que contiene stubs de funciones que deben ser resolved en runtime via dynamic linker.

**PSA Crypto API**
Platform Security Architecture Crypto API. Interfaz estándarizada para operaciones criptográficas diseñada por Arm.

### R

**Rollback Protection**
Mecanismo que previene instalación de versiones anteriores de firmware. Usa contadores de imágenes persistentes.

**Root of Trust (RoT)**
El componente fundamental en el que se confía ciegamente en una cadena de confianza. Típicamente immutable hardware o ROM.

**RSA**
Algoritmo de criptografía asimétrica basado en factorización de números primos grandes. Comúnmente usado para firmas digitales.

### S

**Secure Boot**
Proceso de boot donde cada stage verifica cryptográficamente al siguiente antes de ejecutarlo. Forma una cadena de confianza.

**Single Address Space**
Arquitectura donde kernel y todas las aplicaciones comparten el mismo espacio de direcciones virtuales. Elimina need para MMU y reduce overhead.

**Stack Guard**
Mecanismo de protección que detecta overflows de stack mediante canaries placed entre buffers y addresses de retorno.

**Swap Mode (MCUboot)**
Estrategia para actualizar firmware: el contenido de slot 0 y slot 1 se intercambian (swap) atómicamente.

### T

**TLS/DTLS**
Transport Layer Security y Datagram TLS. Protocolos de seguridad para comunicaciones sobre redes IP.

---

## 9. Fuentes y Referencias

- [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html)
- [PSA Crypto - Zephyr Documentation](https://docs.zephyrproject.org/latest/services/crypto/psa_crypto.html)
- [Over-the-Air Update - Zephyr Documentation](https://docs.zephyrproject.org/latest/services/device_mgmt/ota.html)
- [Zephyr Memory Management](https://docs.zephyrproject.org/latest/kernel/memory_management/index.html)
- [Security Vulnerability Reporting](https://docs.zephyrproject.org/latest/security/reporting.html)
- [OpenSSF Best Practices - Zephyr](https://www.bestpractices.dev/projects/74/gold)