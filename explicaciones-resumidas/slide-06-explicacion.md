# Resumen: MOSIX — Características Generales

## 1. ¿Qué es MOSIX?

**MOSIX** (*Multi-Operating System Intellect System*) es un **sistema operativo distribuido para clusters** que convierte múltiples máquinas Linux independientes en un sistema unificado. No reemplaza Linux: funciona como una capa sobre el kernel Linux existente.

### Clasificación técnica

| Categoría | Tipo |
|-----------|------|
| **Tipo de sistema** | Distributed OS / Cluster Operating System |
| **Modelo de cluster** | Single System Image (SSI) |
| **Paradigma central** | Migración preemptiva de procesos a nivel kernel |
| **Plataforma** | Linux (x86, x86_64) |
| **Última versión** | MOSIX-4.4.4 (octubre 2017) |

### Arquitectura

Desde MOSIX-4 (2014), el sistema funciona como **módulo de kernel + daemon**:

1. **Kernel Module**: Intercepta syscalls relacionadas con procesos y memoria en cada nodo.
2. **Daemon Userspace**: Proceso en segundo plano que maneja:
   - Descubrimiento automático de nodos
   - Comunicación entre nodos
   - Monitoreo de recursos (CPU, memoria, carga)
   - Decisiones de balanceo de carga

---

## 2. Single System Image (SSI)

**SSI** es el concepto central de MOSIX: un cluster se presenta al usuario como **un único sistema computacional**, aunque esté físicamente distribuido.

**Ejemplo visual:**
```
Usuario ve: "1 sistema Linux con 256 CPUs y 1TB RAM"
Físicamente: 4 nodos × 64 CPUs × 256 GB RAM cada uno
```

### Sin SSI vs. Con SSI

| Sin SSI | Con SSI |
|---------|---------|
| Usuario debe conocer los nodos | Usuario ve un sistema único |
| Decidir manualmente dónde ejecutar procesos | Procesos se ejecutan automáticamente "en algún lugar" |
| Gestionar distribución de archivos manualmente | Acceso transparente a archivos en cualquier nodo |
| Monitorear carga manualmente | Balanceo de carga automático |

---

## 3. Migración de Procesos

### Definición

La **migración de procesos** es la característica central de MOSIX: mover un proceso en ejecución de un nodo a otro, de forma **preemptiva y transparente**, sin que la aplicación lo perciba.

### Pasos de la migración

1. **Decisión**: El daemon decide que el proceso debe migrar (balanceo de carga, nodo saturado)
2. **Preemption**: Se interrumpe el proceso en el nodo origen
3. **Serialización del contexto**: Se empaqueta el estado completo de la CPU (registros, PC, flags)
4. **Transferencia de memoria**: Se copia el espacio de memoria completo al nodo destino
5. **Reinicio**: El proceso se reanuda en el nodo destino continuando desde donde estaba
6. **Actualización de tablas**: Se actualizan las estructuras internas de MOSIX

### Propiedades

| Propiedad | Descripción |
|-----------|-------------|
| **Preemptiva** | El sistema puede migrar un proceso incluso mientras está ejecutando |
| **Contexto completo** | Se transfiere estado de CPU + espacio de memoria completo |
| **Transparente** | El proceso no sabe que fue migrado; syscalls siguen funcionando |
| **Reversible** | Un proceso migrado puede volver al nodo original si las condiciones cambian |

### Factores para decidir la migración

- Velocidad de CPU del nodo destino
- Carga actual de cada nodo
- Memoria disponible en destino
- Comunicación inter-procesos (procesos que se comunican se mantienen cerca)

### Limitaciones

- **No soporta threads**: Procesos multi-threaded no pueden migrar
- **No soporta memoria compartida**: Procesos con `shared memory` no pueden migrar
- **Overhead en procesos grandes**: Procesos con mucha memoria generan tráfico de red significativo
- **Modelo "shared-nothing"**: No hay memoria compartida entre nodos

---

## 4. Memory Ushering

**Memory Ushering** es un mecanismo que implementa **migración proactiva de memoria**: detecta nodos con poca memoria libre y migra procesos **antes** de que ocurra "out of memory" (OOM).

### Funcionamiento

1. **Monitoreo continuo**: Cada daemon monitorea la memoria disponible en su nodo
2. **Detección de umbral**: Cuando la memoria libre cae bajo un umbral configurable
3. **Selección de víctima**: Se selecciona un proceso "migrable" (sin threads ni shared memory)
4. **Migración preventiva**: El proceso se migra a un nodo con más memoria
5. **Evaluación post-migración**: Se verifica que la condición haya mejorado

**Analogía**: Es como un "swapping distribuido" — pero en lugar de mover páginas individuales entre memoria y disco, se mueve el proceso completo entre nodos.

---

## 5. DFSA — Direct File System Access

MOSIX **no** proporciona su propio sistema de archivos distribuido. En cambio, **DFSA** (*Direct File System Access*) permite que procesos migrados accedan archivos en **cualquier nodo** de forma transparente.

### Funcionamiento

Cuando un proceso migrado hace una operación de archivo:

1. El proceso ejecuta `open()`, `read()`, `write()`, etc. normalmente
2. El módulo kernel de MOSIX intercepta la syscall
3. Si el archivo está en otro nodo, MOSIX redirige la operación al nodo correcto
4. El resultado se retorna al proceso como si fuera local

**Analogía**: Es como una "interrupción software a nivel de cluster" — la syscall cruza límites de nodo de forma transparente.

---

## 6. Glosario

| Término | Definición |
|---------|------------|
| **MOSIX** | Sistema operativo distribuido para clusters de Linux |
| **SSI** | Abstracción que presenta un cluster como un único sistema |
| **Process Migration** | Capacidad de mover un proceso en ejecución entre nodos |
| **Kernel Module** | Módulo de kernel que intercepta syscalls |
| **Daemon** | Proceso en espacio de usuario que coordina el cluster |
| **Memory Ushering** | Migración proactiva de procesos antes de OOM |
| **DFSA** | Acceso transparente a archivos en cualquier nodo |
| **Checkpoint/Restart** | Capacidad de salvar estado de proceso para recuperación |
| **Shared-Nothing** | Arquitectura donde cada nodo tiene memoria local, sin memoria compartida entre nodos |
| **Load Balancing** | Distribución equitativa de carga entre nodos |

---

## 7. Conexiones con Conceptos de Sistemas Operativos

| Concepto FSO | Aplicación en MOSIX |
|--------------|---------------------|
| **Programa vs Proceso** | El proceso puede migrar entre máquinas manteniendo contexto completo |
| **Scheduling** | MOSIX es un "scheduler de cluster" — decide dónde ejecutar cada proceso |
| **Scheduler de medio plazo** | Memory Ushering equivale a swapping pero a nivel de cluster |
| **PCB (Process Control Block)** | Extendido a nivel distribuido con transferencia de estado completo |
| **Modo usuario/kernel** | Procesos migrados corren en entorno "sandbox" con privilegios limitados |

---

## 8. Limitaciones y Contexto Histórico

### Limitaciones técnicas

- No soporta threads ni memoria compartida → limita aplicaciones modernas
- No es open source → sin comunidad ni desarrollo activo desde 2017
- No替代 sistemas de archivos paralelos como Lustre o GPFS

### Contexto histórico

MOSIX fue pionero en migración de procesos pero fue superado por tecnologías modernas:

| Período | Tecnología |
|---------|------------|
| 1998-2008 | Era Beowulf/MOSIX — clusters de PCs |
| 2003+ | SLURM, PBS Professional — job schedulers especializados |
| 2010s+ | Kubernetes, Docker — contenedores |
| 2020s+ | K8s + Slurm hybrid |

### Relevancia pedagógica

MOSIX se estudia como **caso de estudio clásico** de:
1. Migración preemptiva de procesos
2. Single System Image
3. Balanceo de carga distribuido
4. Evolución histórica de sistemas distribuidos

---

## Fuentes

- Wikipedia — MOSIX: https://en.wikipedia.org/wiki/MOSIX
- MOSIX Official Site: http://www.mosix.org/
- MOSIX Administrator's Guide: http://www.mosix.cs.huji.ac.il/pub/Guide.pdf

---

*Resumen creado para Fundamentos de Sistemas Operativos — Mayo 2026*