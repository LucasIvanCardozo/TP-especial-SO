# Resumen: Seguridad en MOSIX

MOSIX es un sistema de cluster que permite migrar procesos entre nodos de forma transparente. Su modelo de seguridad se basa en **confianza mutua entre nodos** (filosofía de años 90-2000s, cuando los clusters eran de una sola institución).

---

## Los 4 pilares de seguridad

### 1. Módulo de kernel en modo privilegiado

MOSIX se implementa como un **Loadable Kernel Module (LKM)** que corre dentro del kernel de Linux, en **modo privilegiado** (modo kernel). Esto le da:
- Acceso completo a hardware y memoria
- Capacidad de interceptar **syscalls** (llamadas al sistema) antes de que el kernel las procese
- Control sobre tablas del sistema

**¿Cómo funciona?** Cuando un proceso guest (migrado desde otro nodo) hace una syscall:
```
Proceso guest → Módulo MOSIX (intercepta) → ¿Es peligrosa? → SÍ: la bloquea/redirige
                                                    → NO: la pasa al kernel normal
```

**Aislamiento del sandbox**: No usa virtualización por hardware (VT-x/AMD-V) ni contenedores (namespaces/cgroups). El aislamiento es **lógico/programático**, implementado por el filtro de syscalls. El proceso guest corre en modo usuario normal, pero el módulo MOSIX restringe sus operaciones.

> **Relación con la materia**: Esto se conecta con el modo dual de operación (§1.5) — el módulo corre en modo kernel mientras el proceso guest queda en modo usuario.

---

### 2. SSI Unified UID + Permisos locales

**SSI (Single System Image)**: El cluster se presenta como **una sola máquina**. Todos los nodos comparten el mismo espacio de UIDs/GIDs.

- El UID "1000" en el nodo A es el mismo UID "1000" en el nodo B
- No hay mapeo de UIDs entre nodos
- Un usuario tiene el mismo identificador en cualquier nodo

**Matiz importante**: Los permisos efectivos se calculan **localmente** en cada nodo según las reglas de Linux. Esto permite que diferentes nodos tengan configuraciones distintas, manteniendo la ilusión de un solo sistema.

> **Diferencia clave**: No es un sistema de autenticación centralizado (como LDAP). Cada nodo tiene sus propios `/etc/passwd`, pero el UID numérico es globalmente consistente.

---

### 3. Sandbox para procesos guest

El **sandbox** es el entorno aislado que impide que un proceso guest dañe o acceda indebidamente al nodo host.

| Lo que el proceso guest | PUEDE hacer | NO puede hacer |
|------------------------|-------------|----------------|
| Ejecutar su código normalmente | ✅ | ❌ |
| Usar CPU/memoria asignada | ✅ | ❌ |
| Acceder archivos del nodo origen (via **DFSA**) | ✅ | ❌ |
| Acceder archivos locales del nodo host | ❌ | ❌ |
| Modificar configuración del SO host | ❌ | ❌ |
| Instalar software o cargar módulos | ❌ | ❌ |
| Ver procesos del nodo host | ❌ | ❌ |
| Ejecutar syscalls peligrosas (mount, chroot, ptrace, syslog) | ❌ | ❌ |

**DFSA (Direct File System Access)**: Permite acceso directo y transparente a archivos del nodo de origen mientras el proceso corre en otro nodo.

**Comparación con otros mecanismos**:

| Mecanismo | Aislamiento | ¿Nodos no-confiables? |
|-----------|-------------|------------------------|
| MOSIX Sandbox | Lógico (kernel) | ❌ No |
| Contenedores (Docker) | Namespace + cgroups | ⚠️ Limitado |
| VMs | Hipervisor (hardware) | ✅ Sí |
| gVisor | Kernel usuario | ⚠️ Mayormente |

---

### 4. Checkpoint/Restart — Transferencia de contexto de seguridad

Cuando un proceso migra, se transfiere su **contexto de ejecución completo**:

- UID efectivo/real, GIDs suplementarios, capabilities
- Directorio de trabajo, descriptores de archivos abiertos, umask
- Límites de recursos (ulimits), señales pendientes
- Estado de memoria (pila, heap, código)

**Flujo Checkpoint/Restart**:
```
Checkpoint: Ejecutando → Serializar estado → Escribir a disco → Proceso puede terminar/migrar
Restart:    Leer archivo → Reconstruir estado → Continuar desde punto exacto
```

**Beneficios**:
- Tolerancia a fallas (nodo cae → restaurar en otro)
- Aislamiento temporal (congelar para examen)
- Recuperación ante incidentes (restaurar a estado conocido)
- Auditoría (reconstruir qué hacía el proceso)

**⚠️ Limitación crítica**: Los archivos de checkpoint **no están cifrados por defecto**. Contienen toda la memoria del proceso (contraseñas en texto claro, claves, datos). Diseñado para HPC donde los nodos son de confianza.

---

## Requisito fundamental: Confianza mutua

**TODOS los nodos deben ser mutuamente confiables.** No es opcional.

Según la documentación oficial de MOSIX:
> *"All remote nodes must be trustworthy... guest applications will not be modified during execution, and no hostile equipment will be connected to the LAN."*

**El modelo no tiene**:
- Firma digital que garantice integridad del código migrado
- Attestation (como TPM en VMs)
- Verificación criptográfica de nodos

**Entornos apropiados vs. no apropiados**:

| Entorno | ¿Apropiado? |
|---------|-------------|
| Cluster de universidad (misma institución) | ✅ Sí |
| Grid de investigación colaborativo (todos confían) | ⚠️ Posiblemente |
| Cloud público (AWS, GCP, Azure) | ❌ No |
| Multi-tenant environment | ❌ No |
| Nodos externos de terceros | ❌ No |

**IPSec no resuelve**: IPSec protege la comunicación en tránsito, pero si un nodo destino es malicioso, puede hacer lo que quiera con los datos una vez recibidos.

---

## Conexión con el temario de FSO

- **§1.5 (Modo Dual)**: El sandbox implementa aislamiento lógico a nivel de kernel, no físico como VMs. El guest corre en modo usuario pero con syscalls filtradas.
- **§1.6 (Instrucciones Privilegiadas)**: MOSIX se basa en confianza mutua, no en restricciones de hardware como la MPU de Zephyr.
- **§1.7 (Interrupciones)**: La interceptación de syscalls es análoga al manejo de flujo entre modo usuario y kernel.
- **§1.8 (Llamadas al Sistema)**: Similar a `seccomp` en Linux moderno, que filtra syscalls para restringir capacidades.

---

## Glosario rápido

| Término | Significado |
|---------|-------------|
| **LKM** | Loadable Kernel Module — código que se carga en el kernel sin recompilar |
| **SSI** | Single System Image — el cluster parece una sola máquina |
| **DFSA** | Direct File System Access — acceso transparente a archivos del nodo origen |
| **Guest process** | Proceso migrado desde otro nodo |
| **Sandbox** | Entorno aislado que restringe lo que un proceso puede hacer |
| **Checkpoint/Restart** | Guardar estado completo de un proceso a disco para restaurarlo después |
| **Syscall** | Llamada al sistema — solicitud de servicio al kernel |

---

## En síntesis

El modelo de seguridad de MOSIX tiene 4 componentes:
1. **Kernel module privilegiado** que intercepta syscalls
2. **UID unificado** en todo el cluster con permisos locales
3. **Sandbox lógico** que aísla procesos guest
4. **Checkpoint/Restart** que transfiere contexto completo

**Limitación fundamental**: Todo depende de que los nodos sean confiables. No hay defensa contra nodos internos maliciosos. No es apta para clouds públicos ni entornos multi-tenant.