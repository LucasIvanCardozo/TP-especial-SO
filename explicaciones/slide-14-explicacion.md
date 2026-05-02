# Slide 14 — Explicación: Seguridad en MOSIX

## Contextualización

La slide 14 aborda los mecanismos de seguridad que MOSIX implementa para permitir la migración transparente de procesos entre nodos de un cluster. A diferencia de tecnologías de virtualización modernas (VMs, contenedores con políticas estrictas), MOSIX adopta un modelo fundamentalmente diferente: **confianza mutua entre nodos + aislamiento lógico a nivel del kernel**. Esta combinación refleja una filosofía de diseño de los años 90-2000s, cuando los clusters eran típicamente propiedad de una única institución y administrados por un equipo de confianza.

Los cuatro conceptos centrales de la slide son:
1. **Kernel module corriendo en modo privilegiado** (§1.5, §1.6 del temario)
2. **SSI Unified UID + permisos Linux locales heredados**
3. **Sandbox isolation para procesos guest**
4. **Transferencia de contexto de seguridad en migración (Checkpoint/Restart)**

---

## 1. Kernel Module en Modo Privilegiado

### §1.5 Modo Dual de Operación — Repaso

El temario FSO explica que los CPUs modernos operan en al menos dos modos:

- **Modo Kernel (privileged / modo supervisor)**: El sistema operativo ejecuta sus servicios. Tiene acceso completo al hardware, puede ejecutar instrucciones privilegiadas (HALT, I/O, modificar registros de control como CR0-CR3), y accede a toda la memoria del sistema.
- **Modo Usuario (unprivileged)**: Las aplicaciones de usuario se ejecutan con restricciones. No pueden ejecutar instrucciones privilegiadas, tienen acceso limitado a la memoria (solo a su espacio de direcciones), y para interactuar con hardware o servicios del kernel deben pasar por **llamadas al sistema (syscalls)**.

La transición de modo usuario a modo kernel ocurre mediante:
- **Llamadas al sistema (syscall)**: El proceso usuario invoca explícitamente un servicio del kernel.
- **Interrupciones de hardware**: Un dispositivo necesita atención (teclado, disco, red).
- **Excepciones**: Error de ejecución (división por cero, page fault).

### El módulo de kernel de MOSIX

MOSIX se implementa como un **módulo de kernel cargable** ( Loadable Kernel Module, LKM) en Linux. Un LKM es código que se carga en el kernel de Linux en tiempo de ejecución, sin necesidad de recompilar el kernel completo. Una vez cargado, el módulo **se ejecuta en modo kernel**, es decir, con todos los privilegios del SO.

Esto significa que el módulo de MOSIX:
- Puede ejecutar **cualquier instrucción** de la CPU, incluyendo instrucciones privilegiadas.
- Tiene acceso a **toda la memoria física y virtual** del sistema.
- PuedeInterceptar syscalls antes de que el kernel las procese (via hooks en la tabla de syscalls).
- Puede modificar la tabla de páginas, manipuladores de interrupciones, y cualquier estructura del kernel.

### Interceptación y filtrado de syscalls

Cuando un proceso **guest** (un proceso que fue migrado desde otro nodo) intenta realizar una llamada al sistema, el módulo de MOSIX puede interceptarla. El flujo es:

```
Proceso guest (en modo usuario) → syscall → Módulo MOSIX (en modo kernel) →
  ¿Syscall peligrosa? → SÍ → Devuelve EPERM o redirige
  ¿Syscall peligrosa? → NO → Pasa al handler normal del kernel de Linux
```

Esta interceptación es posible porque el módulo corre en el mismo espacio de kernel que el SO host. Puede instalar sus propios handlers o envoltorios (wrappers) alrededor de los handlers de syscalls nativos de Linux.

**Analogía con seccomp**: En Linux moderno, `seccomp` es un mecanismo que permite a un proceso restrictirse a sí mismo las syscalls que puede usar. MOSIX hace algo similar, pero **desde el kernel y para procesos guest**: filtra qué syscalls pueden ejecutarse en un nodo remoto, independientemente de lo que el proceso originalmente solicitó.

### Sandbox a nivel del kernel de Linux

El sandbox de MOSIX no usa virtualización hardware (como VT-x/AMD-V para VMs), ni usa mecanismos de aislamiento de contenedores (namespaces, cgroups). En cambio, implementa aislamiento **puramente lógico/programático** dentro del kernel de Linux:

1. **Filter de syscalls**: ciertas operaciones son bloqueadas o redirigidas.
2. **Redirección de acceso a archivos**: el proceso guest ve un "archivo" que en realidad es una referencia al sistema de archivos del nodo origen vía DFSA (Direct File System Access).
3. **Restricción de red**: la comunicación de red del guest puede ser filtrada o limitada.

**Relación con §1.6 (Instrucciones Privilegiadas)**: En el modelo de MOSIX, el proceso guest **no necesita** ejecutarse en modo kernel real. El guest corre en modo usuario normal (no privilegiado), pero el módulo de MOSIX en modo kernel фильтрует sus operaciones. Esto es distinto a cómo una VM tiene su propio kernel ejecutándose en modo kernel virtualizado. Aquí, el guest comparte el kernel del host (Linux), pero con restricciones impuestas por el módulo de kernel de MOSIX.

**Limitación importante**: Este modelo de aislamiento depende de que el kernel de Linux subyacente funcione correctamente y de que el módulo de MOSIX no tenga bugs. No hay "defensa en profundidad" por hardware.

---

## 2. SSI Unified UID + Permisos Locales

### SSI: Single System Image

SSI (Single System Image) es un concepto fundamentales en MOSIX. Significa que, desde la perspectiva del usuario y de las aplicaciones, el cluster de múltiples nodos se comporta como **una sola máquina** con un solo espacio de IDs de usuario (UIDs) y grupos (GIDs).

Cuando un usuario inicia sesión en cualquier nodo del cluster MOSIX, tiene el mismo UID y grupos. Un proceso creado por ese usuario tiene el mismo UID en todos los nodos. No hay mapeo de UIDs entre nodos: el UID "1000" en el nodo A es el mismo UID "1000" en el nodo B.

### Permisos locales heredados

Aquí hay un matiz importante que la slide destaca: **cada nodo retiene sus permisos Linux locales**. Esto significa que, si bien el UID es unificado, los permisos efectivos del proceso migrado se calculan localmente en el nodo destino según las reglas de Linux (basadas en UID + grupos complementarios + filesystem ACLs locales).

En la práctica:
- El UID unificado permite que MOSIX identifique rápidamente al usuario en cualquier nodo.
- Pero los permisos efectivos (effective UID/GID, capabilities) se recalculan en el nodo destino según la configuración local de ese nodo.
- Esto permite que diferentes nodos tengan configuraciones de permisos ligeramente diferentes (por ejemplo, un nodo dedicado a computación podría tener permisos distintos que un nodo de almacenamiento), manteniendo la ilusión de un solo sistema.

**Implicación**: Esto es diferente a un sistema de autenticación centralizado (como LDAP + NFS). Aquí no hay un servidor de autenticación: cada nodo tiene sus propios archivos `/etc/passwd` y `/etc/group`, pero el UID numérico es globalmente consistente.

---

## 3. Sandbox Isolation para Procesos Guest

### Concepto de sandbox en MOSIX

El sandbox (entorno aislado) de MOSIX es el mecanismo que impide que un proceso guest que migra a un nodo remoto cause daño o acceda indebidamente a los recursos de ese nodo.

Definición según documentación oficial de MOSIX:
> *"MOSIX provides a secure run time environment (sandbox) for guest processes"*
> — MOSIX Administrator's Guide

### Aspectos del aislamiento

| Aspecto | Qué significa en la práctica |
|---------|------------------------------|
| **Aislamiento de recursos** | El proceso guest no puede abrir, leer, escribir o eliminar archivos del sistema host. Su acceso a archivos es redirigido al nodo origen via DFSA. |
| **Comunicación controlada** | La red del proceso guest está filtrada. No puede abrir sockets hacia servicios locales del nodo host (como sshd, web servers) a menos que sean explícitamente permitidos. |
| **Visibilidad del sistema** | El proceso guest ve un entorno virtualizado parcial. No ve la totalidad de procesos corriendo en el nodo, no ve la estructura real del filesystem más allá de lo que MOSIX expone. |
| **Syscalls peligrosas restringidas** | Syscalls como `mount`, `chroot`, `ptrace`, `syslog`, `/dev/kmem`, etc., que podrían permitir escape del sandbox, son interceptadas y denegadas. |

### Qué PUEDE hacer un proceso guest

- Ejecutar su código de aplicación normalmente.
- Usar la CPU y memoria asignadas por MOSIX.
- Realizar operaciones de E/S sobre archivos del nodo origen (via DFSA, que permite acceso directo transparente al filesystem del nodo de origen mientras el proceso corre en otro nodo).
- Comunicarse por red (dentro de las restricciones impuestas).

### Qué NO PUEDE hacer un proceso guest

- Acceder directamente a archivos locales del nodo host.
- Modificar la configuración del sistema operativo host.
- Instalar software o cargar módulos del kernel.
- Acceder directamente a dispositivos hardware locales (aunque los devices simulados/Compartidos están disponibles si MOSIX lo permite).
- Ver la lista completa de procesos del nodo host.

### Comparación con otros mecanismos

| Mecanismo | Tipo de Aislamiento | ¿Puede ejecutar en nodos no-confiables? |
|-----------|---------------------|------------------------------------------|
| MOSIX Sandbox | Lógico (kernel-level) | ❌ No — requiere nodos mutuamente confiables |
| Contenedores (Docker) | Namespace + cgroups | ⚠️ Limitado — host debe ser relativamente confiable |
| Virtual Machines | Hipervisor (hardware virtualizado) | ✅ Sí — aislamiento completo por hardware |
| gVisor | Kernel de espacio de usuario | ⚠️ Mayormente — aislamiento híbrido |

El sandbox de MOSIX ofrece **menos aislamiento que VMs** pero **más que nada** comparado con procesos Linux normales. No es comparable a ejecutar en un cloud público con nodos de terceros.

### Relación con §1.7 (Interrupciones) y §1.8 (Llamadas al Sistema)

El mecanismo de filtrado de syscalls en MOSIX es conceptualmente similar a cómo el kernel de Linux maneja syscalls desde procesos de usuario: el kernel decide si concede o deniega cada operación. En MOSIX, el módulo de kernel actúa como ese intermediario, pero filtrando no solo por permisos del proceso, sino por políticas de seguridad del cluster.

---

## 4. Contexto de Seguridad en Migración — Checkpoint/Restart

### Qué es el contexto de seguridad

Cuando un proceso migra de un nodo origen a un nodo destino, no solo migra su código y datos: migra todo su **contexto de ejecución**, que incluye:
- UID efectivo y real
- GIDs suplementarios
- Capabilities (en sistemas Linux modernos)
- Directorio de trabajo actual
- Descriptores de archivos abiertos (y sus flags)
- Máscara de creación de archivos (umask)
- Límites de recursos (ulimits)
- Configuración de señales pendientes
- Estado de memoria (pila, heap, código)

Este contexto se serializa en el nodo origen, se transfiere al nodo destino, y se deserializa para que el proceso continúe exactamente donde quedó.

### Checkpoint/Restart en MOSIX

MOSIX incluye soporte nativo para **checkpoint/restart**: la capacidad de detener un proceso en ejecución, guardar su estado completo a almacenamiento persistente, y luego restaurarlo (en el mismo nodo o en uno diferente) más tarde.

El flujo básico:
```
Checkpoint:
  1. Proceso en ejecución
  2. Se serializa estado completo (memoria, registros, fd, estado CPU)
  3. Se escribe a disco (archivo de checkpoint)
  4. El proceso puede terminar o continuar en otro nodo

Restart:
  1. Se lee archivo de checkpoint
  2. Se reconstruye el estado del proceso
  3. Se continúan execution desde el punto exacto
```

### Utilidad para seguridad

| Beneficio | Descripción |
|-----------|-------------|
| **Tolerancia a fallas** | Si un nodo falla, los procesos pueden restaurarse en otro sin pérdida de estado |
| **Aislamiento temporal** | Un proceso puede ser "congelado" para examen forense sin que continúe ejecutándose |
| **Recuperación ante incidentes** | Si se detecta compromiso, los procesos pueden restaurarse a un estado anterior conocido |
| **Auditoría** | El estado checkpointado permite reconstruir qué hacía un proceso en un momento dado |

### Limitaciones importantes

- Los archivos de checkpoint **no están cifrados por defecto** en MOSIX. Contiene toda la memoria del proceso, incluyendo datos sensibles (contraseñas en texto claro, claves, datos personales).
- El acceso no autorizado a un archivo de checkpoint compromete la confidencialidad del proceso.
- No hay información públicamente disponible sobre si MOSIX soporta checkpoint cifrado.
- En la práctica, checkpoint/restart en MOSIX fue concebido para HPC (High Performance Computing) donde los nodos son de confianza, no para escenarios donde se necesita cifrado.

### Contexto académico — Relación con temas de FSO

El mecanismo de checkpoint/restart se relaciona con:
- **Contexto de un proceso (PCB)**: El temario menciona que un proceso tiene un "contexto de CPU completo" (registros, PC, estado de scheduling). El checkpoint serializa exactamente eso.
- **Cambios de contexto**: En scheduling, cuando un proceso pierde la CPU, se salva su contexto para poder restaurarlo. El checkpoint/restart es una forma extrema: se salva a disco, no solo a RAM.
- **Admin de memoria**: Un checkpoint incluye el estado completo de la memoria del proceso (pila, heap, datos).

---

## 5. Requisito de Confianza Mutua — Limitación Crítica

### Qué significa "mutuamente confiables"

La slide advierte que **todos los nodos deben ser mutuamente confiables**. Esto no es una recomendación, es un **requisito obligatorio** del modelo de seguridad de MOSIX.

Según el FAQ oficial de MOSIX:
> *"All remote nodes must be trustworthy. That means that the remote nodes guarantee that: (a) guest applications will not be modified during execution, and (b) no hostile equipment will be connected to the LAN."*
> — MOSIX FAQ, pregunta 10

### Por qué es necesario

El modelo de seguridad de MOSIX se basa en **confianza**, no en verificación criptográfica:
1. **No hay firma digital** que garantice que el código del proceso no fue alterado durante la migración.
2. **No hay attestation** (como en VMs con TPM) que verifique la integridad del nodo destino.
3. **El proceso guest tiene acceso parcial** al nodo host (dentro del sandbox), pero depende de que el nodo no sea malicioso.
4. **La red entre nodos** debe estar protegida de equipos hostiles.

### Implicaciones prácticas

| Entorno | ¿Apropiado para MOSIX? | Por qué |
|---------|------------------------|---------|
| Cluster de universidad | ✅ Sí | Todos los nodos son administrados por la misma institución |
| Grid de investigación colaborativo | ⚠️ Posiblemente | Solo si todos los participantes confían entre ellos |
| Cloud público (AWS, GCP, Azure) | ❌ No | Nodos compartidos con terceros no confiables |
| Multi-tenant environment | ❌ No | Un tenant malicioso podría afectar procesos de otro |
| Cluster con nodos externos de terceros | ❌ No | No hay garantía de que los nodos no sean maliciosos |

### Limitaciones conocidas

| Limitación | Descripción |
|------------|-------------|
| **No apta para entornos hostiles** | Un nodo comprometido o malicioso puede modificar procesos guest |
| **Sin verificación criptográfica** | No hay mecanismos técnicos para verificar integridad del código migrado |
| **Dependencia de la red** | La red debe estar protegida; equipos hostiles no pueden conectarse |
| **Sin defensa contra nodos internos maliciosos** | Si un administrador de un nodo es hostil, puede alterar procesos |

### Comparación con amenazas modernas

| Amenaza | ¿MOSIX puede defenderse? |
|---------|---------------------------|
| Nodo malicioso en el cluster | ❌ No — el modelo asume nodos confiables |
| Ataque desde la red interna | ⚠️ Parcialmente — requiere que la red sea segura |
| Compromiso de un nodo | ❌ No — el atacante tiene control total sobre procesos guest |
| Escalación de privilegios | ⚠️ Parcialmente — el sandbox limita pero no garantiza protección |
| Ataques cross-tenant (cloud) | ❌ No diseñado para este escenario |

### IPSec no es suficiente

Aunque MOSIX puede funcionar sobre túneles IPSec ( TCP y UDP sobre IP), IPSec **no resuelve** el problema fundamental de confianza en los nodos. IPSec protege la comunicación en tránsito (confidencialidad, integridad), pero una vez que el paquete llega al nodo destino, si ese nodo es malicioso, puede hacer lo que quiera con los datos.

---

## 6. Glosario de Términos

| Término | Definición |
|---------|-----------|
| **Kernel Module (LKM)** | Loadable Kernel Module. Código que se carga dinámicamente en el kernel de Linux para extender su funcionalidad sin necesidad de reiniciar o recompilar. Corre en modo privilegiado. |
| **Modo Privilegiado (Kernel Mode)** | Modo de ejecución de CPU donde el SO tiene acceso completo al hardware, puede ejecutar instrucciones privilegiadas, y accede a toda la memoria del sistema. |
| **SSI (Single System Image)** | Single System Image. Concepto donde un cluster de múltiples nodos se presenta como una sola máquina lógica, con un solo espacio de UIDs/GIDs, un solo filesystem видимый para las aplicaciones. |
| **UID Unificado** | El mismo identificador de usuario (número UID) se usa en todos los nodos del cluster, permitiendo que MOSIX identifique rápidamente a un usuario sin mapeo. |
| **Sandbox** | Entorno de ejecución aislado que限制了 lo que un proceso puede hacer. En MOSIX, es un entorno a nivel del kernel que impide que procesos guest accedan a recursos del nodo host. |
| **Proceso Guest** | Un proceso que fue migrado desde otro nodo del cluster y está ejecutando en un nodo que no es su nodo de origen. |
| **DFSA (Direct File System Access)** | Mecanismo de MOSIX que permite que un proceso guest acceda archivos del nodo origen de manera directa y transparente, como si estuviera ejecutando localmente. |
| **Syscall (Llamada al Sistema)** | Mecanismo por el cual un proceso en modo usuario solicita un servicio del kernel (ej: read, write, open, fork, exec). |
| **Checkpoint/Restart** | Mecanismo para salvar el estado completo de un proceso en ejecución (memoria, registros, descriptores, etc.) a almacenamiento persistente, para luego restaurarlo y continuar la ejecución. |
| **Security Context (Contexto de Seguridad)** | Información que define las propiedades de seguridad de un proceso: UID, GIDs, capabilities, máscara de archivos, límites de recursos. Se transfiere durante la migración. |
| **Confianza Mutua** | Requisito de que todos los nodos en un cluster MOSIX sean administrados por partes de confianza, donde se asume que ningún nodo will behave maliciously. |
| **Seccomp** | Mecanismo de seguridad en Linux moderno que permite a un proceso restringirse a un subconjunto de syscalls. Análogo conceptual al filtrado de syscalls en MOSIX. |

---

## 7. Nota Académica — Conexión con Temario FSO

### §1.5 (Modo Dual) y MOSIX

El sandbox de MOSIX implementa un aislamiento **lógico** a nivel de kernel, no físico como máquinas virtuales. El proceso guest no tiene modo kernel real — opera dentro de un entorno restringido creado por el módulo de MOSIX. Esto difiere del modo dual de CPU visto en la materia: el guest corre en modo usuario normal pero con syscalls filtradas o restringidas por software.

### §1.6 (Instrucciones Privilegiadas) y MOSIX

A diferencia de Zephyr (que usa MPU para imponer restricciones a nivel de hardware sobre qué memoria puede acceder un proceso), MOSIX se basa en **confianza mutua entre nodos**. No hay verificación criptográfica de integridad ni aislamiento físico: el modelo confía en que los administradores de los nodos no son maliciosos. Esto ilustra la diferencia entre mecanismos de protección impuestos por hardware (§1.6) versus políticas de seguridad basadas en confianza (§1.5).

### §1.7 (Interrupciones y Excepciones) y MOSIX

MOSIX intercepta y filtra ciertas llamadas al sistema (syscalls) para impedir que el proceso guest acceda a recursos del nodo host. Esta restricción de syscalls es análoga a cómo un sistema operativo maneja el flujo de control entre modo usuario y modo kernel.

### §1.8 (Llamadas al Sistema) y MOSIX

El modelo de seguridad de MOSIX depende de la restricción de syscalls. Cuando un proceso guest intenta realizar una syscall privilegiada o potencialmente peligrosa, el módulo de kernel de MOSIX la intercepta. Este mecanismo es conceptualmente similar a `seccomp` en Linux moderno, que filtra syscalls para restringir capacidades de procesos.

---

## 8. Resumen de la Slide

La slide 14 presenta el modelo de seguridad de MOSIX en cuatro pilares complementarios:

1. **Kernel module privilegiado**: Corre en modo kernel para interceptar y filtrar syscalls de procesos guest, implementando el sandbox desde el nivel más privilegiado del sistema.

2. **SSI + permisos locales**: Un UID unificado en todo el cluster proporciona transparencia, mientras los permisos efectivos se calculan localmente en cada nodo.

3. **Sandbox isolation**: El aislamiento a nivel de kernel impide que procesos guest accedan a recursos del host, comuniquen por red de manera no controlada, o ejecuten syscalls peligrosas.

4. **Checkpoint/Restart**: La transferencia de contexto de seguridad completo durante la migración permite que el proceso continúe exactamente donde estaba, pero requiere que los archivos de checkpoint estén protegidos.

**Limitación fundamental**: Todo el modelo se basa en que los nodos son mutuamente confiables. No hay defensa contra nodos maliciosos internos, y no es apta para clouds públicos o entornos multi-tenant.

---

## Fuentes

- MOSIX Administrator's Guide (https://mosix.cs.huji.ac.il/pub/Guide.pdf)
- MOSIX FAQ (https://mosix.cs.huji.ac.il/faq/output/faq_toc.html)
- MOSIX FAQ - Flat listing (https://mosix.cs.huji.ac.il/faq/output/faq_flat.html)
- White Paper: Security and openMosix (http://midnightcode.org/papers/White%20Paper%20-%20Security%20and%20openMosix.pdf)
- DMTCP - NERSC Documentation (https://docs.nersc.gov/development/checkpoint-restart/dmtcp/)
- Requirements for Linux Checkpoint/Restart - OSTI (https://www.osti.gov/servlets/purl/793773)
- Containerization vs. Virtualization: Key Differences Explained - Wiz (https://www.wiz.io/academy/containerization-vs-virtualization)