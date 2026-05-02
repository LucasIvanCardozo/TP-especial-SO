# Seguridad en Zephyr OS

Zephyr OS implementa una arquitectura de seguridad elaborada diseñada específicamente para sistemas embebidos IoT de recursos restringidos. El proyecto sigue un proceso de seguridad definido que incluye desarrollo seguro, diseño seguro y certificación de seguridad, con un enfoque en reducir la superficie de ataque mientras provee funcionalidades criptográficas robustas [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html).

---

## 1. Diseño Monolítico Seguro (Binario Estático)

Una de las decisiones arquitectónicas fundamentales de Zephyr es su **diseño monolítico seguro**, donde el kernel y todas las aplicaciones se compilan en **un único binario estático**. Esta característica elimina por completo la necesidad de _dynamic loaders_ (cargadores dinámicos), reduciendo significativamente la superficie de ataque del sistema [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html).

### Ventajas del Diseño Monolítico

| Aspecto | Descripción |
|---------|-------------|
| **Sin carga dinámica de código** | Se elimina la posibilidad de cargar código malicioso vía libraries compartidas o PLT/GOT hijacking |
| **System calls como function calls** | Las llamadas al sistema se implementan como invocaciones de función directas sin cambios de contexto, eliminando overhead de seguridad asociado a mode switches |
| **Eliminación de superficies de ataque** | Sin dlopen/dlsym, sin解析 de ELF dinámico, sin relocation security issues |
| **Menor footprint** | El código estático permite optimización agresiva y eliminación de código muerto |

### Modelo de Ejecución

En Zephyr, el kernel y las aplicaciones comparten un único espacio de direcciones (_Single Address Space_), donde las system calls son simples function calls. Cuando una aplicación necesita servicios del kernel, no ocurre un cambio de contexto tradicional sino una llamada directa a funciones del kernel. Esto reduce la complejidad y elimina vectores de ataque asociados a transiciones de privilege levels [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html).

> **Nota:** La arquitectura de seguridad requiere que los desarrolladores habiliten explícitamente características de seguridad opcionales (como stack protection o user mode) a través de Kconfig, permitiendo optimizar el tradeoff seguridad vs. recursos según la aplicación.

---

## 2. PSA Crypto API + mbedTLS

Zephyr provee funcionalidades criptográficas a través de la **PSA Crypto API** (_Platform Security Architecture Crypto API_), con **mbedTLS** como implementación subyacente [PSA Crypto - Zephyr Documentation](https://docs.zephyrproject.org/latest/services/crypto/psa_crypto.html).

### ¿Qué es la PSA Crypto API?

La PSA Crypto API es una interfaz de programación portable para operaciones criptográficas y almacenamiento de claves, diseñada por **Arm** como parte de su framework Platform Security Architecture. Está diseñada para ser usable en una amplia variedad de dispositivos, desde procesadores criptográficos especializados hasta microcontroladores restringidos [PSA Crypto - Zephyr Documentation](https://docs.zephyrproject.org/latest/services/crypto/psa_crypto.html).

### Objetivos de Diseño

| Objetivo | Descripción |
|----------|-------------|
| **Flexibilidad algorítmica** | Soporta una amplia gama de algoritmos criptográficos permitiendo switching entre métodos según necesidades |
| **Gestión robusta de claves** | Usa identificadores opacos de claves (_opaque key identifiers_) que permiten reemplazo fácil sin exponer material de claves |
| **Independencia de implementación** | Abstrae la biblioteca criptográfica subyacente, permitiendo cambiar implementaciones sin afectar código de aplicación |
| **Future-proofing** | Adhiere al principio de _cryptographic agility_, permitiendo adaptación rápida a nuevos estándares |

### Casos de Uso de PSA Crypto en Zephyr

| Caso de Uso | Descripción |
|-------------|-------------|
| **Network Security (TLS)** | Provee todas las primitivas criptográficas necesarias para establecer conexiones TLS/DTLS |
| **Secure Storage** | Cifrado de almacenamiento block-based o file-based con claves maestras almacenadas en keystore |
| **Network Credentials** | Gestión de credenciales de red (X.509, pre-shared keys) dentro de un keystore |
| **Device Pairing** | Soporte para protocolos de acuerdo de claves (_key agreement protocols_) usados en emparejamiento seguro |
| **Secure Boot** | Primitivas para validación de integridad y autenticidad de firmware durante boot seguro |
| **Attestation** | Capacidad del dispositivo de firmar datos con clave privada y probar que fue generada dentro de un keystore seguro |
| **Factory Provisioning** | APIs para poblar dispositivos con claves que representan su identidad única |

### mbedTLS como Backend

**mbedTLS** es una biblioteca criptográfica de código abierto mantenida por Trusted Firmware que provee las funciones criptográficas subyacentes. Zephyr usa configuraciones predefinidas de mbedTLS optimizadas para diferentes casos de uso (TLS 1.2 mínimo por defecto, soporte para AES-CCM, TLS con PSK, etc.) [PSA Crypto - Zephyr Documentation](https://docs.zephyrproject.org/latest/services/crypto/psa_crypto.html).

```
// Configuraciones mbedTLS disponibles en Zephyr:
// - config-ccm-psk-tls1_2.h: TLS 1.2 con AES-CCM y Pre-Shared Keys
// - config-coap.h: Para protocolos CoAP/DTLS
// - config-mini-dtls1_2.h: DTLS 1.2 mínimo
// - config-mini-tls1_2.h: TLS 1.2 mínimo
```

### Consideraciones de Uso

**Verificación de errores:** La mayoría de las funciones PSA Crypto pueden retornar errores. Todas las funciones que pueden fallar tienen tipo de retorno `psa_status_t` [PSA Crypto - Zephyr Documentation](https://docs.zephyrproject.org/latest/services/crypto/psa_crypto.html).

**Concurrencia:** La API PSA Crypto permite un writer o múltiples lectores simultáneos sobre cualquier objeto. Accesos concurrentes de escritura al mismo objeto tienen comportamiento indefinido.

**Limpieza de datos sensibles:** Se recomienda que las aplicaciones limpien datos sensibles de memoria (_wiping_) cuando ya no se necesitan: buffers temporales en stack o heap, abortar operaciones incompletas, destruir claves que ya no se usan.

---

## 3. Secure Boot — Chains de Secure Boot

Zephyr soporta **secure boot** (arranque seguro) mediante la verificación criptográfica de firmware antes de su ejecución. El sistema usa **MCUboot** como bootloader primitivo de seguridad [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html).

### ¿Qué es MCUboot?

**MCUboot** es un bootloader diseñado específicamente para sistemas embebidos restringidos que implementa firmas digitales asimétricas para verificación de firmware. Cuando Zephyr se configura con soporte secure boot, MCUboot actúa como el primer código que se ejecuta al encender el dispositivo [Secure and Encrypted Boot in Zephyr RTOS](https://www.youtube.com/watch?v=FwWhPn5glwQ).

### Funcionamiento del Chain de Secure Boot

```
+------------------+
|    Hardware      |  ← Root of Trust (RoT)
|   (SoC-specific) |
+--------+---------+
         |
         v
+------------------+
|  ROM Bootloader   |  ← First-stage immutable bootloader
| (HW-specific)     |
+--------+---------+
         |
         v
+------------------+
|    MCUboot       |  ← Verifies signature of Zephyr image
| (Primary Boot)   |    using public key embedded at build
+--------+---------+
         |
         v
+------------------+
|  Zephyr Kernel   |  ← Application and kernel binary
| + Applications   |    (signed and verified)
+------------------+
```

### Características de MCUboot en Zephyr

| Característica | Descripción |
|---------------|-------------|
| **Firmas asimétricas** | Utiliza criptografía de clave pública (RSA o ECDSA) para verificar la autenticidad del firmware |
| **A/B partitioning** | Dos slots de firmware (_slot0_ y _slot1_) permiten actualizaciones atómicas con rollback |
| **Swap modes** | various swap strategies: test, preload, swap-scratch, compare |
| **Rollback protection** | Previene instalación de versiones anteriores de firmware已知 vulnerables |
| **Encrypted updates** | Soporte opcional para firmware cifrado (requiere configuración adicional) |

### Flujo de Actualización OTA con MCUboot

1. El nuevo firmware se descarga a una partición no ocupada (_slot1_partition_)
2. MCUboot verifica la firma digital del nuevo firmware usando la clave pública embebida
3. Si la verificación es exitosa, MCUboot puede copiar/flash el nuevo firmware al slot activo
4. En caso de falla, el dispositivo puede hacer rollback a la versión anterior [Over-the-Air Update - Zephyr Documentation](https://docs.zephyrproject.org/latest/services/device_mgmt/ota.html)

---

## 4. Memory Separation + Thread Separation

Zephyr implementa mecanismos de protección de memoria y aislamiento de threads para prevenir que código malicioso o errores en un thread comprometan el sistema completo [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html).

### Memory Separation (Separación de Memoria)

La **separación de memoria** particiona la memoria en regiones con atributos específicos basados en el propietario de cada región. Los threads solo tienen acceso a las regiones de memoria que controlan. Esto se implementa usando:

| Mecanismo | Descripción |
|-----------|-------------|
| **MPU (Memory Protection Unit)** | En plataformas sin MMU completo, la MPU define regiones de memoria con atributos (solo lectura, ejecución prohibida, etc.) |
| **Memory domains** | Grupos de threads que comparten acceso a regiones de memoria específicas |
| **Atributos de memoria** | Configuraciones de memoria que controlan permisos de acceso (read-only, no-execute, etc.) |

### Thread Separation (Separación de Threads)

El aislamiento de threads asegura que **cada thread solo acceda a sus propios recursos**. Cuando un thread es scheduleado, solo los recursos de memoria принадлежащие a ese thread son accesibles. Las constraints de thread execution level y memory protection se imponen en el momento del _context switch_ [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html).

### Stack Protection

Zephyr incluye protección contra **stack overflow/overrun** disponible desde la versión 1.9.0. Los mecanismos incluyen:

- **Stack guards**: Mecanismos para detectar y_trap stack overruns
- **Acceso limitado al stack**: Cada thread solo puede acceder a su propio stack
- **Detección en context switch**: Las verificaciones de stack ocurren durante cambios de contexto

### User Mode (Privileged/Unprivileged Execution)

Zephyr soporta ejecución en dos niveles de privilegio:

| Modo | Descripción |
|------|-------------|
| **Privilegiado (kernel mode)** | El kernel corre con acceso completo a hardware y memoria |
| **No privilegiado (user mode)** | Threads de aplicación corren con restricciones a nivel de hardware |

La capacidad de ejecutar hilos en modo no privilegiado permite imponer restricciones a nivel de hardware, protegiendo el sistema de código de aplicación defectuoso o malicioso. Esta característica está disponible en arquitecturas que lo soporten (x86 desde v1.10, ARM y ARC desde v1.11) [Zephyr Memory Management](https://docs.zephyrproject.org/latest/kernel/memory_management/index.html).

---

## 5. User Mode (Privileged/Unprivileged)

El modelo de **User Mode** en Zephyr implementa un concepto fundamental de seguridad donde existe una clara separación entre el código del kernel (privilegiado) y el código de aplicación (no privilegiado) [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html).

### Concepto de Privileged/Unprivileged

| Aspecto | Privilegiado (Kernel) | No Privilegiado (User) |
|---------|---------------------|------------------------|
| **Acceso a hardware** | Completo | Restringido por MPU/MPU |
| **Acceso a memoria** | Todas las regiones | Solo regiones asignadas |
| **System calls** | Directas | Via API de kernel |
| **Modificación de PCB** | Sí | No |

### Beneficios del User Mode

1. **Containment**: Si una aplicación falla o es comprometida, no puede acceder a memoria crítica del kernel
2. **Hardware enforcement**: Las restricciones se aplican a nivel de hardware (MPU), no solo por software
3. **Defense in depth**: Complementa otras medidas de seguridad
4. **Simplifica debugging**: Memoria corrupta de una aplicación no corrompe el kernel

### Configuración

El user mode se habilita a través de Kconfig con la opción `CONFIG_USERSPACE`. Una vez habilitado, los desarrolladores pueden especificar qué memoria y recursos son accesibles para cada thread [Zephyr Memory Management](https://docs.zephyrproject.org/latest/kernel/memory_management/index.html).

---

## 6. Stack Protection

La **protección de stack** en Zephyr es un mecanismo de seguridad que detecta y previene _stack buffer overflows_, una de las vulnerabilidades más comunes en sistemas embebidos [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html).

### Mecanismos de Protección

| Mecanismo | Descripción |
|-----------|-------------|
| **Stack guards** | Valores canary placed entre variables locales y dirección de retorno |
| **Verificación en context switch** | 检测 stack overflow antes de scheduling de próximo thread |
| **MPU-based stack isolation** | Regiones de stack marcadas como no-executable |

### Habilitación

La protección de stack en Zephyr se puede habilitar mediante la opción `CONFIG_STACK_USAGE` y `CONFIG_HW_STACK_PROTECTION`. Estas opciones usan features del compilador (como `-fstack-protector`) y configuraciones de MPU para proteger contra overruns.

> **Nota:** La protección de stack puede tener overhead de rendimiento, por lo que está deshabilitada por defecto y debe ser habilitada explícitamente en Kconfig.

---

## 7. Over-the-Air (OTA) Updates

Las actualizaciones **Over-the-Air (OTA)** permiten actualizar el firmware de dispositivos Zephyr de forma remota a través de una conexión de red. Aunque el nombre implica actualización wireless, las actualizaciones por wired connections también se denominan OTA [Over-the-Air Update - Zephyr Documentation](https://docs.zephyrproject.org/latest/services/device_mgmt/ota.html).

### Seguridad en OTA

La seguridad es una preocupación crítica en actualizaciones OTA. Zephyr implementa las siguientes medidas:

1. **Firmware criptográficamente firmado**: Los binaries de firmware sonfirmaos digitalmente antes de distribución
2. **Verificación antes de upgrade**: MCUboot verifica la firma antes de aplicar cualquier actualización
3. **A/B partitioning**: Dos slots permiten actualizaciones atómicas con rollback automático en caso de falla
4. **TLS/DTLS**: Las transmisiones entre servidor y dispositivo usan canales seguros

### Plataformas OTA Soportadas en Zephyr

| Plataforma | Descripción |
|------------|-------------|
| **Golioth** | IoT management platform con OTA, conexión TLS/DTLS [Golioth OTA](https://docs.golioth.io/device-management/ota) |
| **Eclipse hawkBit** | Update server framework con polling REST API [Eclipse hawkBit](https://www.eclipse.org/hawkbit/) |
| **UpdateHub** | Plataforma para actualización remota de dispositivos embebidos [UpdateHub](https://updatehub.io/) |
| **SMP Server** | Server para actualización via Bluetooth LE o UDP usando MCUmgr |
| **LwM2M** | Protocolo con soporte nativo para firmware update via DTLS |
| **mender-mcu** | Update Module para actualización atómica con rollback automático [mender-mcu](https://github.com/mendersoftware/mender-mcu) |
| **Memfault** | IoT observability platform con OTA management |

### Flujo Típico de OTA

```
1. Servidor notifica nueva versión disponible
2. Dispositivo descarga firmware (sobre TLS/DTLS)
3. Firmware se almacena en slot1_partition (inactivo)
4. MCUboot verifica firma digital
5. Si es válida: instalación atómica
6. Si falla: rollback automático a versión anterior
```

[Over-the-Air Update - Zephyr Documentation](https://docs.zephyrproject.org/latest/services/device_mgmt/ota.html)

---

## 8. Security Subcommittee

El **Zephyr Security Subcommittee** es un comité dedicado exclusivamente a la seguridad dentro del proyecto Zephyr. Su creación responde a la necesidad de establecer un proceso de seguridad estructurado que ayude a developers a construir software más seguro [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html).

### Responsabilidades del Security Subcommittee

| Responsabilidad | Descripción |
|-----------------|-------------|
| **Desarrollo de proceso de seguridad** | Definir y documentar procesos de seguridad para el proyecto |
| **Enforcement de guidelines** | Asegurar adherencia a guidelines de codificación segura |
| **Monitoreo de reviews** | Supervisar que code reviews consideren aspectos de seguridad |
| **Mejora continua** | Mejorar y actualizar guidelines de seguridad |
| **Vulnerability management** | Evaluar, clasificar y mitigar vulnerabilities reportadas |

### Proceso de Reporte de Vulnerabilidades

El proceso de manejo de vulnerabilidades incluye:

1. **Reporte privado** vía GitHub Security Advisories o email al Product Security Committee
2. **Revisión por el subcommittee** durante reuniones con más de tres asistentes
3. **Clasificación** usando CVSS (_Common Vulnerability Scoring System_)
4. **Mitigación** con fix patches y workarounds
5. **Divulgación** Coordinada con plazos definidos [Security Vulnerability Reporting - Zephyr Documentation](https://docs.zephyrproject.org/latest/security/reporting.html)

### Logros Reconocidos

- En mayo 2020, el proyecto recibió un reporte de NCC Group detallando varias decenas de vulnerabilidades, las cuales fueron evaluadas y mitigadas por el subcommittee [Security and the Zephyr Project](https://www.zephyrproject.org/security-and-the-zephyr-project/)
- Auditoría de seguridad externa realizada en 2017 por David Brown y nuevamente en 2020 por NCC Group [OpenSSF Best Practices - Zephyr](https://www.bestpractices.dev/projects/74/gold)

---

## 9. OpenSSF Gold Badge

Zephyr fue uno de los primeros proyectos en obtener el **[OpenSSF Best Practices Gold Badge](https://www.bestpractices.dev/projects/74/gold)**, una certificación que verifica que un proyecto de código abierto sigue mejores prácticas de seguridad reconocidas por la industria [OpenSSF Best Practices](https://www.bestpractices.dev/projects/74/gold).

### ¿Qué es el OpenSSF Best Practices Badge?

El **OpenSSF Best Practices Badge** es un programa de la Open Source Security Foundation que permite a proyectos de código abierto auto-certificarse voluntariamente. Existen tres niveles:

| Nivel | Requisitos |
|-------|------------|
| **Passing** | Criterios MUST básicos cumplidos |
| **Silver** | +50% de criterios SHOULD cumplidos con justificación |
| **Gold** | +21 criterios MUST adicionales y 2 SHOULD adicionales |

### Criterios Gold Cumplidos por Zephyr

| Categoría | Criterios Principales |
|-----------|----------------------|
| **Basics (5/5)** | Descripción del proyecto, bus factor ≥2, contributors no asociados ≥2, copyright en cada archivo, license en cada archivo |
| **Change Control (4/4)** | Git repo distribuido, small tasks identificadas, 2FA requerido, 2FA seguro (TOTP) |
| **Quality (7/7)** | Code review standards documentados, two-person review, reproducible builds, test suite invocable, CI/CD, 90% statement coverage, 80% branch coverage |
| **Security (5/5)** | TLS 1.2 mínimo, crypto usado en network, hardening headers, security review (auditoría NCC Group 2020), hardening mechanisms (stack protector flags) |
| **Analysis (2/2)** | Dynamic analysis tools (GCov, ASAN), assertions en tests |

### Truck Factor

El proyecto Zephyr tiene un **truck factor de 12**, lo que significa que se necesitan al menos 12 miembros del proyecto para que este se detenga por falta de personal capacitado. Esto supera el requisito mínimo de 2 del badge, indicando un proyecto con alta resiliencia de personal [OpenSSF Best Practices - Zephyr](https://www.bestpractices.dev/projects/74/gold).

### Implicaciones del Gold Badge

1. **Confianza para adopters**: El badge indica que el proyecto sigue prácticas de seguridad reconocidas
2. **Requisito para certificaciones**: Muchos procesos de certificación de productos embebidos requieren que el RTOS tenga certificaciones de terceros
3. **Diferenciación competitiva**: Zephyr es uno de los pocos RTOS con Gold Badge de OpenSSF

---

## 10. Code Reviews + Static Analysis

Zephyr implementa un proceso riguroso de **Quality Assurance** que incluye code reviews obligatorios y análisis estático de código como parte integral del proceso de desarrollo [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html).

### Code Reviews

El proceso de code review en Zephyr es **obligatorio** antes de merge. Características principales:

| Aspecto | Detalle |
|---------|---------|
| **Votación requerida** | Al menos un voto a favor de reviewer independiente |
| **Subsystem maintainers** | Reviews realizados por maintainers de cada subsistema |
| **Seguridad prioritaria** | Para código security-critical, guidelines especiales |
| **No self-merge** | Pull requests no permiten que el autor haga merge de sus propios cambios |

### Goals of Code Review

1. **Verificación de funcionalidad**: Asegurar que la implementación funciona correctamente
2. **Legibilidad y mantenibilidad**: Código debe ser claro y mantenible
3. **Uso correcto de funciones**: Especialmente string y memory functions
4. **Validación de input de usuario**: Prevenir injection attacks
5. **Revisión de código security-critical**: Identificar potenciales issues de seguridad [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html)

### Static Code Analysis

El análisis estático de código se ejecuta **regularmente** en el codebase de Zephyr. Los findings deben ser resueltos o _waived_ con documentación antes de cada release [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html).

**Proceso de waivers:**
- Herramienta y versión usada
- Fecha del análisis
- Rama y revisión padre
- Razón del waiver
- Autor del código
- Aprobador(es) del waiver

### Continuous Integration

Zephyr implementa **CI/CD** con GitHub Actions. Cada pull request ejecuta:
- `twister` para testing en hardware
- `checkpatch` para style guidelines
- Análisis estático automático
- Coverage analysis (90% statement, 80% branch)

La cobertura de código se mide con `codecov.io/gh/zephyrproject-rtos/zephyr` [OpenSSF Best Practices - Zephyr](https://www.bestpractices.dev/projects/74/gold).

---

## Resumen de Características de Seguridad en Zephyr OS

| Categoría | Feature | Versión Desde |
|-----------|---------|---------------|
| **Arquitectura** | Diseño monolítico, binario estático, sin dynamic loaders | v1.0 |
| **Criptografía** | PSA Crypto API + mbedTLS | v1.0 |
| **Secure Storage** | PSA Secure Storage | v1.0 |
| **Secure Boot** | MCUboot chain | v1.0 |
| **Protección de memoria** | MPU-based memory protection | v1.10 (x86), v1.11 (ARM/ARC) |
| **Thread separation** | Aislamiento de threads | v1.10 (x86), v1.11 (ARM/ARC) |
| **Stack protection** | Stack guards | v1.9 |
| **User mode** | Privileged/unprivileged execution | v1.10 (x86), v1.11 (ARM/ARC) |
| **OTA updates** | Device Firmware Upgrade con MCUboot | v1.0 |
| **Security processes** | Security Subcommittee, vulnerability management | v1.0 |
| **Certificaciones** | OpenSSF Gold Badge | 2019 |

---

## Fuentes

- [Zephyr Security Overview - Documentación oficial](https://docs.zephyrproject.org/latest/security/security-overview.html)
- [PSA Crypto - Zephyr Documentation](https://docs.zephyrproject.org/latest/services/crypto/psa_crypto.html)
- [Over-the-Air Update - Zephyr Documentation](https://docs.zephyrproject.org/latest/services/device_mgmt/ota.html)
- [Zephyr Memory Management](https://docs.zephyrproject.org/latest/kernel/memory_management/index.html)
- [Security Vulnerability Reporting](https://docs.zephyrproject.org/latest/security/reporting.html)
- [Zephyr Project - OpenSSF Best Practices Gold Badge](https://www.bestpractices.dev/projects/74/gold)
---
## Nota Académica — Fundamentos de SO

**Conceptos de la materia relacionados:**

- **§1.5 — Modo dual de operación (kernel/user mode)**: Zephyr implementa ejecución privilegiada y no privilegiada (`CONFIG_USERSPACE`). El código del kernel corre en modo privilegiado con acceso completo a hardware, mientras que los threads de aplicación pueden correr en modo usuario con restricciones impuestas por la MPU a nivel de hardware. Esto refleja directamente el modelo de modo dual visto en la materia.

- **§1.6 — Instrucciones privilegiadas**: La Memory Protection Unit (MPU) se configura mediante instrucciones privilegiadas del CPU. En arquitecturas x86, ARM y ARC, solo el código corriendo en kernel mode puede configurar las regiones de memoria protegido. Zephyr usa la MPU para imponer restricciones de acceso a memoria que son forzadas por hardware.

- **§1.7 & §1.8 — Interrupciones y Llamadas al sistema**: Zephyr implementa las system calls como invocaciones de función directas dentro del mismo espacio de direcciones (single address space). Cuando una aplicación en modo usuario necesita servicios del kernel, no ocurre un `syscall` tradicional con cambio de contexto completo, sino una llamada directa a funciones del kernel. Este diseño es una optimización que elimina el overhead del `mode switch`, aunque requiere que todo el código (kernel + aplicaciones) esté compilado en un único binario estático de confianza.

- **Aislamiento de threads (§1.5)**: En el context switch, Zephyr aplica restricciones de thread execution level y memory protection, cambiando los atributos de la MPU según el thread que entra en ejecución. Esto es similar al mecanismo de protección de procesos en sistemas multiusuario, donde cada proceso tiene su propio espacio de direcciones.