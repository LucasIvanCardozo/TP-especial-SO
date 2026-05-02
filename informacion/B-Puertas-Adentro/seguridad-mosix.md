# Seguridad en MOSIX

MOSIX implementa diversos mecanismos de seguridad para permitir la migración de procesos entre nodos de un cluster o grid. Estos mecanismos están diseñados para proteger tanto los procesos guest (migrados) como los sistemas hosts que los ejecutan. Es importante entender que el modelo de seguridad de MOSIX se basa en la **confianza mutua entre nodos**, lo cual es un aspecto fundamental de su diseño.

---

## 1. Sandbox para Procesos Guest

### ¿Qué es?

Cuando un proceso migra a un nodo remoto en MOSIX, se ejecuta dentro de un **sandbox** (entorno aislado). El sandbox es un entorno de ejecución seguro que impide que el proceso guest acceda a los recursos locales del nodo hosting.

Según la documentación oficial:

> *"MOSIX provides a secure run time environment (sandbox) for guest processes"*
> — [MOSIX Administrator's Guide](https://mosix.cs.huji.ac.il/pub/Guide.pdf)

### ¿Cómo aísla?

El sandbox de MOSIX opera a nivel del kernel de Linux y proporciona las siguientes garantías de aislamiento:

| Aspecto | Descripción |
|---------|-------------|
| **Aislamiento de recursos** | Los procesos guest no pueden acceder a archivos locales, dispositivos o recursos del nodo host |
| **Comunicación controlada** | El acceso a la red del nodo host está limitado o filtrado |
| **Visibilidad del sistema** | El proceso guest ve un entorno "virtual" que no refleja la configuración real del host |
| **Restricciones de syscalls** | Determinadas llamadas al sistema que podrían comprometer la seguridad están restringidas |

### Analogía

El sandbox de MOSIX es conceptualmente similar a una **cápsula sellada**: el proceso guest corre dentro de ella, pero no puede escapar ni interactuar con el "mundo exterior" (el sistema host) a menos que sea explícitamente permitido.

**Nota:** Información específica sobre la implementación técnica exacta del sandbox (qué syscalls se filtran, cómo se implementa el aislamiento a nivel de kernel) **no está públicamente disponible** en la documentación oficial.

---

## 2. Requisito de Nodos Mutuamente Confiables

### El Principio Fundamental

MOSIX **requiere que todos los nodos en el cluster sean mutuamente confiables**. Este es uno de los aspectos más críticos del modelo de seguridad de MOSIX, y es un requisito explícito, no opcional.

Según el FAQ oficial de MOSIX (pregunta 10):

> *"All remote nodes must be trustworthy. That means that the remote nodes guarantee that: (a) guest applications will not be modified during execution, and (b) no hostile equipment will be connected to the LAN."*
> — [MOSIX FAQ](https://mosix.cs.huji.ac.il/faq/output/faq_toc.html)

### ¿Por qué es necesario?

Este requisito existe porque:

1. **El modelo de seguridad se basa en confianza**, no en tecnología de virtualización pesada
2. **El proceso guest tiene acceso al nodo host** (dentro del sandbox), pero el sistema depende de que el nodo host no sea malicioso
3. **No hay verificación criptográfica** de que el código del proceso no ha sido alterado durante la migración

### Implicaciones

| Implicación | Descripción |
|-------------|-------------|
| **Grid institucionales** | MOSIX está diseñado para entornos donde todos los administradores son de confianza mutua |
| **No apta para clouds públicos** | No es adecuado para ejecutar en nodos de terceros no confiables |
| **Confianza entre administradores** | Los administradores de cada nodo deben confiar entre ellos |
| **Red privada** | La red que conecta los nodos debe estar protegida de equipos hostiles |

---

## 3. Aislamiento de Procesos Guest respecto del Sistema Host

### Nivel de Aislamiento

El aislamiento entre procesos guest y el sistema host en MOSIX es **lógico/programático**, no físico. Esto significa:

- **NO utiliza virtualización completa** (como VMs)
- **NO utiliza contenedores pesados** (como Docker)
- **Utiliza mecanismos a nivel de kernel** para restringir el acceso

### Lo que el proceso guest PUEDE hacer:
- Ejecutar código normalmente
- Usar CPU y memoria asignadas
- Realizar operaciones de E/S a través de DFSA (Direct File System Access)
- Comunicarse por red (con restricciones)

### Lo que el proceso guest NO PUEDE hacer:
- Acceder directamente a archivos del sistema host
- Modificar la configuración del nodo host
- Instalar software o drivers
- Acceder a dispositivos hardware locales

### Comparación con otros mecanismos de aislamiento

| Mecanismo | Tipo de Aislamiento | Nivel de Seguridad |
|-----------|---------------------|---------------------|
| **MOSIX Sandbox** | Lógico (kernel-level) | Medio |
| **Contenedores (Docker)** | Lógico (namespace + cgroups) | Medio-Alto |
| **Virtual Machines** | Físico (hipervisor) | Alto |
| **gVisor / Kata Containers** | Híbrido (kernel + usuario) | Alto |

---

## 4. Garantías de No-Modificación durante Ejecución Remota

### El Problema

Cuando un proceso migra de un nodo origen a un nodo destino, existe el riesgo de que:
- El código del proceso sea modificado en tránsito
- El nodo destino altere el proceso antes de ejecutarlo
- Software malicioso en el nodo destino intercepte o modifique el proceso

### Lo que MOSIX garantiza

MOSIX **no proporciona garantías criptográficas** de no-modificación. En cambio, depende de:

1. **Confianza en la red:** La red entre nodos debe ser de confianza
2. **Confianza en los nodos:** Los nodos destino deben ser confiables
3. **Confianza mutua entre administradores:** Todo el cluster opera bajo política de confianza compartida

### Limitación conocida

> *"The remote nodes guarantee that guest applications will not be modified during execution"*
> — MOSIX FAQ

Esta garantía es una **promesa del nodo remoto**, no una verificación técnica. Si un nodo remoto está comprometido o es malicioso, esta garantía no se cumple.

**Conclusión:** MOSIX **no es adecuado** para ejecutar procesos en nodos no confiables o en entornos where the threat model includes hostile nodes.

---

## 5. Checkpoint/Restart

### ¿Qué es Checkpoint/Restart?

Checkpoint/Restart es un mecanismo que permite **salvar el estado completo de un proceso en ejecución** (su memoria, registros de CPU, descriptores de archivos, estado de conexiones, etc.) a disco o a otro medio de almacenamiento, para luego **restaurarlo** ya sea en el mismo nodo o en uno diferente.

### ¿Cómo funciona en MOSIX?

MOSIX incluye soporte nativo para checkpoint/restart:

```
Checkpoint → El estado del proceso se guarda
     ↓
El proceso puede continuar en otro nodo o ser reiniciado más tarde
     ↓
Restart → El proceso se restaura desde el checkpoint
```

### Utilidad para Seguridad

El mecanismo de checkpoint/restart aporta las siguientes beneficios de seguridad:

| Beneficio | Descripción |
|-----------|-------------|
| **Tolerancia a fallas** | Si un nodo falla, los procesos pueden restaurarse en otro nodo sin pérdida de datos |
| **Auditoría** | El estado checkpointado permite auditar qué estaba haciendo un proceso en un momento dado |
| **Aislamiento temporal** | Un proceso puede ser "congelado" y examinado sin que pueda continuar ejecutándose |
| **Recuperación ante incidentes** | En caso de detección de compromiso, los procesos pueden restaurarse en un estado seguro conocido |

### Limitaciones

- El checkpoint contiene toda la memoria del proceso, incluyendo datos sensibles **sin cifrar por defecto**
- El acceso no autorizado al archivo de checkpoint compromete la seguridad del proceso
- **No hay información públicamente disponible** sobre si MOSIX soporta checkpoint cifrado

### Contexto académico

El checkpoint/restart en MOSIX es un concepto precursor de tecnologías modernas como:
- **DMTCP** (Distributed MultiThreaded Checkpointing) — herramienta moderna de checkpoint/restart para HPC
- **CRIU** (Checkpoint/Restore in Userspace) — implementación en Linux moderno
- **Container checkpoint** en Kubernetes

**Fuentes:**
- [DMTCP - NERSC Documentation](https://docs.nersc.gov/development/checkpoint-restart/dmtcp/)
- [Requirements for Linux Checkpoint/Restart - OSTI](https://www.osti.gov/servlets/purl/793773)

---

## 6. Consideraciones sobre Comunicación Segura entre Nodos

### Comunicación en MOSIX

Los nodos MOSIX se comunican para coordinar:
- Migración de procesos
- Balanceo de carga
- Estado del cluster
- Transferencia de memoria durante migración

### Protocolos utilizados

Según la documentación:

> *"MOSIX works on top of TCP and UDP"*
> — [MOSIX FAQ](https://mosix.cs.huji.ac.il/faq/output/faq_flat.html)

### IPSec y MOSIX

**Pregunta frecuente:** ¿Puede el tráfico entre nodos MOSIX pasar a través de túneles IPSec?

**Respuesta:** Sí, MOSIX funciona sobre TCP/UDP, por lo que **puede** atravesar túneles IPSec. Sin embargo, hay considerations importantes:

| Aspecto | Consideration |
|---------|----------------|
| **Rendimiento** | IPSec añade overhead de cifrado/descifrado que puede afectar el rendimiento de la migración |
| **Compatibilidad** | El tráfico MOSIX es compatible con IPSec a nivel de red |
| **Configuración** | Los túneles IPSec deben estar correctamente configurados en ambos extremos |

### Limitaciones de seguridad en la comunicación

**Información no disponible públicamente** sobre:
- Cifrado de datos en tránsito entre nodos
- Autenticación mutua entre nodos
- Protocolos de handshake para migración

---

## 7. Limitaciones de Seguridad

### Limitaciones conocidas del modelo de seguridad de MOSIX

#### 7.1 Confianza mutua como requisito obligatorio

| Limitación | Descripción |
|------------|-------------|
| **No apta para entornos hostiles** | Si un nodo es malicioso o está comprometido, puede modificar procesos guest |
| **No hay verificación criptográfica** | No hay mecanismos para verificar integridad del código migrado |
| **Dependencia de la red** | La red debe estar protegida; equipos hostiles no pueden conectarse |

#### 7.2 Comparación con amenazas modernas

| Amenaza | MOSIX puede defenderse? |
|---------|------------------------|
| **Nodo malicioso en el cluster** | ❌ No — el modelo assume nodos confiables |
| **Ataque desde la red interna** | ⚠️ Parcialmente — requiere que la red sea segura |
| **Compromiso de un nodo** | ❌ No — el atacante tiene control total sobre procesos guest |
| **Escalación de privilegios** | ⚠️ Parcialmente — el sandbox limita pero no garantiza protección |
| **Ataques cross-tenant (cloud)** | ❌ No diseñado para este escenario |

#### 7.3 IPSec no es suficiente

> *"IPSec can cause problems which are not..."*
> — [Security in Live Virtual Machine Migration - SOAR Wichita](https://soar.wichita.edu/bitstreams/55130e1b-4465-4f73-8e6a-75a4d7cad363/download)

Aunque IPSec puede cifrar el tráfico, **no resuelve** el problema fundamental de confianza en los nodos.

---

## 8. Comparación con Modelos de Seguridad Modernos

### Tabla Comparativa

| Característica | MOSIX | Contenedores (Docker) | Virtual Machines | gVisor / Kata |
|----------------|-------|----------------------|------------------|---------------|
| **Aislamiento** | Lógico (kernel) | Namespace + cgroups | Hipervisor (hardware) | Híbrido |
| **Nivel de confianza requerido** | Mutua absoluta | Hosts confiables | Puede ser no-confiable | Hosts mayormente confiables |
| **Overhead** | Bajo | Muy bajo | Medio-Alto | Medio |
| **Migración en vivo** | ✅ Sí (procesos) | ❌ Limitada | ✅ VMs | ⚠️ MicroVMs |
| **Verificación de integridad** | ❌ No | ✅ Firmas de imágenes | ✅ Attestation | ✅ Mediated access |
| **Defensa contra nodos hostiles** | ❌ No | ⚠️ Limitada | ✅ Fuerte | ✅ Fuerte |
| **Modelo de seguridad** | Confianza + sandbox | Defensa in depth | Aislamiento completo | Aislamiento +syscalls filtrados |

### Contenedores vs MOSIX

**Contenedores (Docker, containerd):**
- Usan namespaces para aislamiento de procesos, red, filesystem
- Usan cgroups para limitación de recursos
- Pueden ejecutarse con políticas de seguridad (SELinux, seccomp, AppArmor)
- **No proporcionan** las mismas garantías de aislamiento que VMs
- La migración en vivo es limitada (no true migration, sino restart)

**MOSIX:**
- Aislamiento basado en sandbox a nivel de kernel
- No requiere virtualización completa
- Migración nativa de procesos
- **No diseñado** para entornos no-confiables

**Fuente:** [Containerization vs. Virtualization: Key Differences Explained - Wiz](https://www.wiz.io/academy/containerization-vs-virtualization)

### Virtual Machines vs MOSIX

**Virtual Machines:**
- Aislamiento completo a nivel de hardware virtualizado
- Cada VM tiene su propio kernel
- Pueden ejecutarse en nubes públicas con aislamiento fuerte
- Overhead mayor que MOSIX o contenedores
- La migración de VMs (live migration) es una tecnología probada (KVM, VMware)

**MOSIX:**
- No hay hipervisor intermedário
- El kernel del host es compartido (en sandbox)
- Overhead muy bajo
- Solo para clusters de confianza mutua

**Fuente:** [What is the Major Disadvantage of Virtual Machines vs Containers? - CBT Nuggets](https://www.cbtnuggets.com/blog/technology/system-admin/what-is-the-major-disadvantage-of-virtual-machines-vs-containers)

### gVisor y alternativas modernas

**gVisor (Google):**
- Implementa un kernel de espacio de usuario para interceptar syscalls
- proporciona un barrier adicional entre la aplicación y el kernel del host
- Más seguro que contenedores tradicionales
- Rendimiento algo inferior

**Kata Containers:**
- Combina contenedores ligeros con VMs mínimas
- Aislamiento de nivel de VM con overhead de contenedor
- Ejecución en hardware virtualizado ligero

**MOSIX** no tiene equivalente directo en el ecosistema moderno, ya que representa un paradigma de "migración de procesos a nivel de kernel en cluster de confianza mutua" que ha sido supercedido por contenedores y schedulers.

---

## 9. Resumen del Modelo de Seguridad de MOSIX

### Fortalezas

✅ **Sandbox efectivo** para procesos guest dentro de un nodo
✅ **Checkpoint/Restart** para tolerancia a fallas y recuperación
✅ **Bajo overhead** comparado con soluciones basadas en virtualización
✅ **Modelo simple** que funciona bien en entornos de confianza

### Debilidades

❌ **Confianza mutua obligatoria** — no apta para nodos no-confiables
❌ **Sin verificación criptográfica** de integridad de procesos
❌ **Dependencia de la red** para seguridad
❌ **Obsoleto** — sin actualizaciones de seguridad desde 2017
❌ **No hay mecanismo** para defender contra nodos maliciosos internos

### Casos de uso apropiados

| Apropiado para | No apropiado para |
|----------------|-------------------|
| Clusters institucionales | Clouds públicos |
| grids de universidades | Entornos multi-tenant |
| Equipos de investigación queconfían entre sí | Ambientes con nodos no-confiables |
| Laboratorios cerrados | Producción en clouds comerciales |

---

## Fuentes

1. [MOSIX Administrator's Guide](https://mosix.cs.huji.ac.il/pub/Guide.pdf)
2. [MOSIX FAQ](https://mosix.cs.huji.ac.il/faq/output/faq_toc.html)
3. [MOSIX FAQ - Flat listing](https://mosix.cs.huji.ac.il/faq/output/faq_flat.html)
4. [MOSIX White Paper](https://mosix.cs.huji.ac.il/pub/MOSIX_wp.pdf)
5. [White Paper: Security and openMosix](http://midnightcode.org/papers/White%20Paper%20-%20Security%20and%20openMosix.pdf)
6. [DMTCP - NERSC Documentation](https://docs.nersc.gov/development/checkpoint-restart/dmtcp/)
7. [Requirements for Linux Checkpoint/Restart - OSTI](https://www.osti.gov/servlets/purl/793773)
8. [Containerization vs. Virtualization: Key Differences Explained - Wiz](https://www.wiz.io/academy/containerization-vs-virtualization)
9. [What is the Major Disadvantage of Virtual Machines vs Containers? - CBT Nuggets](https://www.cbtnuggets.com/blog/technology/system-admin/what-is-the-major-disadvantage-of-virtual-machines-vs-containers)
10. [Security in Live Virtual Machine Migration - SOAR Wichita](https://soar.wichita.edu/bitstreams/55130e1b-4465-4f73-8e6a-75a4d7cad363/download)

---

---
## Nota Académica — Fundamentos de SO

**Conceptos de la materia relacionados:**

- **§1.5 — Modo dual de operación**: El sandbox de MOSIX implementa un aislamiento *lógico* a nivel de kernel, no físico como máquinas virtuales. El proceso guest no tiene modo kernel real — opera dentro de un entorno restringido creado por el kernel del host. Esto difiere del modo dual de CPU (kernel/user) visto en la materia: aquí el guest corre en modo usuario normal pero con syscalls filtradas o restringidas por software.

- **§1.7 — Interrupciones y excepciones**: MOSIX intercepta y filtra ciertas llamadas al sistema (syscalls) para impedir que el proceso guest acceda a recursos del nodo host. Esta restricción de syscalls es análoga a cómo un sistema operativo maneja appels au système desde el espacio de usuario: el kernel decide qué operaciones permitir y cuáles rechazar. En MOSIX, el kernel del host actúa como filtro.

- **§1.8 — Llamadas al sistema**: El modelo de seguridad de MOSIX depende de la restricción de syscalls. Cuando un proceso guest intenta realizar una syscall privilegiada o potencialmente peligrosa, el kernel del host la intercepta. Este mecanismo es conceptualmente similar a `seccomp` en Linux moderno, que filtra syscalls para restringir capacidades de procesos.

- **§1.5 & §1.6 — Confianza vs. protección por hardware**: A diferencia de Zephyr (que usa MPU para imponer restricciones a nivel de hardware), MOSIX se basa en *confianza mutua entre nodos*. No hay verificación criptográfica de integridad ni aislamiento físico: el modelo confía en que los administradores de los nodos no son maliciosos. Esto ilustra la diferencia entre mecanismos de protección impuestos por hardware (§1.6) versus políticas de seguridad basadas en confianza (§1.5).

- **Checkpoint/Restart y estado de procesos**: El mecanismo de checkpoint/restart de MOSIX permite salvar el estado completo de un proceso (memoria, registros, descriptores). Esto conecta con el concepto de contexto de un proceso que aparece en temas de scheduling y cambios de contexto en la materia.
