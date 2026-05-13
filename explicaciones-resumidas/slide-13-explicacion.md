# Resumen: Seguridad en Zephyr OS (Slide 13)

## 1. MPU y Modo Dual de Operación

### MPU (Memory Protection Unit)
- Hardware presente en microcontroladores que protege **regiones de memoria** definidas
- A diferencia de una MMU, NO implementa memoria virtual ni paginación
- Solo permite/excluye acceso a regiones ya mapeadas

**Regiones típicas en Zephyr:**

| Tipo | Permisos | Propósito |
|------|----------|-----------|
| Código/Flash | Read + Execute, No Write | Memoria de programa |
| Datos/RAM | Read + Write, No Execute | Variables y heap |
| Peripherals | Read + Write, No Execute | Registros de hardware |

**Configuración:** La MPU se configura solo en modo privilegiado (kernel). En ARM se usan instrucciones `MRC/MCR`; en x86 se usan `MSR` registers. Código de usuario no puede modificarla.

### Modo Dual de Operación
Zephyr implementa dos niveles de privilegio:

- **Kernel (Privilegiado):** Acceso completo a hardware, puede configurar MPU, ejecuta instrucciones privilegiadas
- **User (No privilegiado):** Restricciones MPU activas, acceso solo a regiones designadas, instrucciones privilegiadas generan trap

**Memory Domains:** Zephyr permite crear grupos de threads que comparten acceso a regiones específicas de memoria. En cada context switch, la MPU se reconfigura automáticamente según el domain del thread entrante.

---

## 2. Single Address Space y System Calls

### Arquitectura de Binario Estático
Zephyr compila kernel Y aplicaciones en **un único binario estático**. Esto elimina:
- `dlopen()` / `dlsym()` → Sin carga dinámica de libraries
- PLT/GOT → Sin hijacking de tablas de enlace
- ELF dynamic loading → Sin parsing de binarios dinámicos
- Runtime relocations → Sin ataques a relocations

### System Calls como Function Calls Directos
En sistemas tradicionales:
```
User → syscall instruction → Kernel (mode switch) → Service → User (mode switch)
```

En Zephyr (optimizado):
```
User → function call → Kernel (SIN mode switch, mismo privilege level)
```

**Nota:** Esta optimización solo es posible porque kernel y aplicaciones son trusted (compilados juntos). Si Zephyr soportara código no confiado en runtime, esto sería inseguro.

---

## 3. Secure Boot + MCUboot + A/B Partitioning

### Cadena de Confianza (Chain of Trust)
Cada componente verifica al siguiente antes de ejecutarse:

```
HARDWARE (RoT - immutable)
    ↓
ROM BOOTLOADER (first-stage, immutable)
    ↓
MCUboot (bootloader portable)
    ↓
ZEPHYR KERNEL + APLICACIONES
```

### Firmas Asimétricas
MCUboot usa criptografía de clave pública para verificar firmware:

| Algoritmo | Uso |
|-----------|-----|
| RSA-2048 | Firmas primarias |
| RSA-3072 | Mayor seguridad |
| ECDSA P-256 | Mejor para MCUs restringidos |

**Proceso:**
1. Build time: Binario se firma con clave privada del desarrollador
2. Clave pública embebida en MCUboot
3. Boot time: MCUboot recalcula hash del firmware y lo compara con la firma descifrada

### A/B Partitioning (Dual-bank)
Permite actualizaciones atómicas del firmware:

```
┌─────────────────────────────────────────────┐
│              FLASH MEMORY                   │
├────────────────────┬────────────────────────┤
│     SLOT 0 (A)     │      SLOT 1 (B)        │
│  Firmware actual   │  Nuevo firmware         │
│  Read-only         │  Writable hasta confirmar│
└────────────────────┴────────────────────────┘
```

**Flujo de update:**
1. Nuevo firmware se descarga a slot 1 (inactivo)
2. MCUboot verifica la firma
3. Swap/Move: Se intercambian o copian slots
4. Si el nuevo firmware falla → rollback al anterior

### Rollback Protection
- MCUboot mantiene un **contador de imágenes** en flash
- Solo permite instalar versiones con contador mayor o igual al actual
- Previene instalar versiones antiguas con vulnerabilidades conocidas

---

## 4. PSA Crypto API + mbedTLS

### PSA (Platform Security Architecture)
Interfaz de criptografía estandarizada diseñada por **Arm** para dispositivos IoT restringidos:

| Principio | Descripción |
|-----------|-------------|
| Portabilidad | Misma API en cualquier plataforma |
| Opacity de claves | Las claves nunca se exponen directamente |
| Cryptographic agility | Soporte para nuevos algoritmos sin cambiar API |

**Casos de uso en Zephyr:**
- Network Security (TLS/DTLS)
- Secure Storage (almacenamiento cifrado)
- Device Pairing (emparejamiento seguro)
- Secure Boot (verificación de firmware)
- Attestation (prueba de identidad del dispositivo)

### mbedTLS como Backend
Biblioteca criptográfica mantenida por **Trusted Firmware**. Zephyr ofrece configuraciones predefinidas:
- `config-ccm-psk-tls1_2.h` → TLS 1.2 con AES-CCM
- `config-mini-tls1_2.h` → TLS 1.2 mínimo
- `config-coap.h` → Para protocolos CoAP/DTLS

**TLS 1.2 mínimo:** Zephyr rechaza conexiones con versiones anteriores (SSL 3.0, TLS 1.0, TLS 1.1) por vulnerabilidades conocidas.

---

## 5. Stack Protection + Stack Guards

### El Problema del Stack Overflow
Cuando un programa escribe más datos de los que el buffer puede contener, puede sobrescribir:
- Variables locales
- Saved registers
- Return address
- Saved frame pointer

Esto permite redirigir ejecución o escalar privilegios.

### Stack Guards en Zephyr
Protección mediante **canary** (valor especial entre buffers y return address):

```
┌─────────────────────────────────┐
│  Return Address                 │
├─────────────────────────────────┤
│  Saved Frame Pointer            │
├─────────────────────────────────┤
│  Local Variables                │
├─────────────────────────────────┤
│  CANARY (0xDEADBEEF, 0xFF...)  │  ← Si se modifica → overflow detectado
├─────────────────────────────────┤
│  Buffer que puede overflowear   │
└─────────────────────────────────┘
```

**Verificación:** Antes de cada return de función o context switch, el runtime verifica que el canary no haya sido modificado. Si está corrupto, se asume stack overflow.

### MPU-based Stack Isolation
Zephyr marca regiones de stack como **no-ejecutables** (MPU_XN):
```c
MPU_REGION(stack_region, stack_base, stack_size, MPU_RW | MPU_XN);
```
Aunque un atacante escriba código shell en el stack, la CPU generará una excepción al intentar ejecutarlo.

---

## 6. OpenSSF Gold Badge

### OpenSSF Best Practices Badge
Certificación de mejores prácticas de seguridad:

| Nivel | Requisitos |
|-------|------------|
| **Passing** | Todos los criterios MUST básicos |
| **Silver** | 50% criterios SHOULD adicionales con justificación |
| **Gold** | 21 criterios MUST + 2 SHOULD + auditoría externa |

### Zephyr Gold Badge (2018-03-10)
Zephyr fue uno de los primeros en obtener Gold, cumpliendo:

- **90% statement coverage** → 90% del código se ejecuta en tests
- **80% branch coverage** → 80% de decisiones lógicas verificadas
- **Auditoría NCC Group 2020** → Evaluación externa de seguridad
- **TLS 1.2 mínimo** obligatorio
- **Two-person code review** documentado

### Security Subcommittee
Comité dedicado a mantener la seguridad del proyecto:
- Define procesos de desarrollo seguro
- Supervisa code reviews
- Gestiona vulnerabilidades reportadas (CVSS)
- Divulgación coordinada con plazos definidos

---

## 7. Conexión con Fundamentos de Sistemas Operativos

| Tema FSO | Aplicación en Zephyr |
|----------|---------------------|
| **§1.5 Modo Dual** | Kernel en modo privilegiado, threads con CONFIG_USERSPACE en modo no privilegiado |
| **§1.6 Instrucciones Privilegiadas** | Configuración MPU solo en kernel mode; user mode genera exception |
| **§1.7 Interrupciones** | Interrupciones hardware siguen modelo estándar; excepciones trigger cambio a kernel mode |
| **§1.8 Llamadas al Sistema** | Zephyr optimiza: syscalls como function calls directos (sin mode switch) dado que kernel y apps son trusted |

---

## Glosario Rápido

| Término | Definición |
|---------|------------|
| **MPU** | Memory Protection Unit — hardware que protege regiones de memoria por atributos |
| **MMU** | Memory Management Unit — hardware que implementa memoria virtual (más complejo que MPU) |
| **RoT** | Root of Trust — componente fundamental en el que se confía ciegamente |
| **A/B Partitioning** | Técnica de update con dos slots de memoria para actualizaciones atómicas |
| **Rollback Protection** | Previene instalar versiones antiguas de firmware con vulnerabilidades |
| **Canary** | Valor especial entre buffers y return address que detecta overflow |
| **mbedTLS** | Biblioteca criptográfica open source (Trusted Firmware) |
| **PSA Crypto API** | Interfaz estándarizada de criptografía (Arm) |
| **Cryptographic Agility** | Capacidad de cambiar algoritmos sin modificar la API |

---

## Fuentes
- [Zephyr Security Overview](https://docs.zephyrproject.org/latest/security/security-overview.html)
- [PSA Crypto - Zephyr Documentation](https://docs.zephyrproject.org/latest/services/crypto/psa_crypto.html)
- [Over-the-Air Update - Zephyr](https://docs.zephyrproject.org/latest/services/device_mgmt/ota.html)
- [OpenSSF Best Practices - Zephyr Gold](https://www.bestpractices.dev/projects/74/gold)