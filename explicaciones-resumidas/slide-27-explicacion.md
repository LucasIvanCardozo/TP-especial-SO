# Slide 27 — Resumen: Comparativa Zephyr vs MOSIX

## Visión General

Esta slide compara **Zephyr OS** y **MOSIX**, dos sistemas operativos que solo comparten el nombre "sistema operativo". Son productos radicalmente diferentes en categoría, escala, dominio y filosofía de diseño.

**Punto clave**: No son comparables directamente — es como comparar un automóvil con un portaaviones. Cada uno está óptimamente diseñado para su dominio específico.

---

## 1. Arquitectura

### Zephyr OS: Microkernel Unificado
- **Microkernel**: El kernel solo tiene lo mínimo e irrompible (scheduling, gestión básica de memoria, IPC)
- **"Unificado"**: Toda la funcionalidad se compila en una **única imagen binaria estática**
- **Sin aislamiento de procesos**: Todos los subsistemas corren en el mismo dominio de privilegio (kernel mode), separados lógicamente por namespaces
- **¿Por qué?**: Microcontroladores tienen RAM muy limitada (a veces < 64 KB). El overhead de IPC entre procesos separados sería prohibitivo

### MOSIX: Sistema Distribuido (Cluster)
- **SSI (Single System Image)**: El cluster parece una **única máquina grande** con muchos CPUs y memoria
- **Arquitectura de dos componentes**:
  1. **Módulo de kernel Linux**: Se inserta en cada nodo, intercepta syscalls de creación de procesos, scheduling y migración
  2. **Daemon userspace**: Coordina migración, balanceo de carga y descubrimiento de recursos entre nodos
- **Migración transparente**: Un proceso puede crearse localmente pero ejecutarse en cualquier nodo del cluster

---

## 2. Memoria

### Zephyr OS: MPU + Memory Domains
- **MPU (Memory Protection Unit)**: Hardware más simple que MMU. Solo define 8-16 regiones de memoria con permisos independientes. **No traduce direcciones** — dirección virtual = dirección física
- **Memory Domains**: Mecanismo de protección group-based. Los threads pertenecen a dominios que definen qué regiones pueden acceder
- **User Mode**: Threads privilegiados pueden ejecutar código con restricciones de acceso
- **Sin paginación clásica**: No hay page faults en el sentido tradicional, no hay algoritmos de reemplazo de páginas

### MOSIX: Memory Ushering (Migración Proactiva)
- **Concepto**: El proceso es "guiado" hacia donde hay memoria disponible **antes** de que ocurra out-of-memory
- **Funcionamiento**:
  1. Cada nodo monitorea su memoria y la de otros nodos
  2. Cuando la memoria cae bajo un threshold, se identifican procesos candidatos a migrar
  3. Se migra el proceso **antes** del OOM
  4. La migración copia estado completo (memoria, registros, file descriptors) por red
- **Diferencia con swapping**: En paginación, se elige una página víctima para escribir a disco. En Memory Ushering, se migra un proceso entero a otro nodo. La granularidad es diferente (proceso vs página) y la latencia es órdenes de magnitud mayor (segundos vs microsegundos)
- **Shared-nothing**: Cada nodo tiene su propia RAM local. No hay coherencia de caché entre nodos.

---

## 3. Procesos

### Zephyr OS: Scheduling Local (3 modos)
- **Todo corre en el mismo nodo físico** — no hay migración

| Modo | Descripción | Ventaja | Desventaja | Uso |
|------|-------------|---------|------------|-----|
| **Preemptive** | Puede desalojar thread en cualquier momento | Response time garantizado para alta prioridad | Overhead de context switches | Tiempo real hard |
| **Cooperative** | Threads ceden CPU voluntariamente (yield) | Menos overhead | Un thread malicioso puede monopolizar CPU | Apps simples controladas por el developer |
| **Hybrid** | Alta prioridad = preemptive, baja = cooperative | Balance entre determinismo y overhead | Más complejo de configurar | Apps mixtas |

### MOSIX: Migración Preemptiva Automática
- **Funcionamiento**:
  1. Proceso se crea localmente (fork)
  2. Daemons detectan desbalance de carga
  3. Módulo de kernel decide migrar basándose en: CPU load, memoria, load average, velocidad de red
  4. Proceso puede migrar incluso en medio de operación de CPU
  5. Aplicación no sabe que migró — syscall se redirigen transparente
- **Checkpoint/Restart**: Guarda estado completo (registers, memoria, archivos abiertos) para poder reiniciar si la migración falla
- **Limitaciones**:
  - No puede migrar procesos que usen shared memory (POSIX shm, mmap MAP_SHARED)
  - Originalmente no migraba threads individuales

---

## 4. Sistema de Archivos

### Zephyr OS: VFS con 3 opciones

| Filesystem | Uso | Características |
|------------|-----|-----------------|
| **LittleFS** | Flash NAND/NOR en microcontroladores | Wear leveling (distribuye escrituras均匀emente), power-loss resilience, bajo overhead |
| **FAT FS** | Tarjetas SD, USB | Máximo portabilidad — cualquier SO lo lee |
| **NVS** | Configuración y datos pequeños persistentes | Sistema clave-valor análogo a Redis simplificado |

**VFS (Virtual File System)**: Capa de abstracción que permite usar la misma API (open, read, write, close) sin importar el filesystem subyacente.

### MOSIX: DFSA (Acceso Directo a Sistema de Archivos)
- **Idea central**: Un proceso en cualquier nodo puede abrir archivos que residen en otro nodo, transparentemente
- **Funcionamiento**:
  1. Proceso en nodo A abre `/home/user/data.txt` (archivo físicamente en nodo B)
  2. Módulo MOSIX intercepta el open()
  3. Redirige a nodo B por red
  4. Nodo B abre archivo localmente y crea "conexión"
  5. Read/write se redirigen a través de esta conexión
- **NO es parallel filesystem**: Toda operación se redirige a un único nodo ("dueño" del archivo). No distribuye datos como GPFS o Lustre.

---

## 5. Target (Destino de Uso)

### Zephyr OS: IoT / Microcontroladores
- **Dispositivos**: Sensores industriales, wearables médicos, termostatos inteligentes, cerraduras conectadas
- **Hardware típico**:
  - RAM: 2 KB a 8 MB (típicamente < 1 MB)
  - Storage: 16 KB a 64 MB flash
  - CPU: 32-bit ARM Cortex-M, RISC-V, ARC
  - Sin MMU, solo MPU
  - Energía: microwatts a milliwatts
  - Costo: $0.20 a $50 por chip
- **Constraints**: Footprint mínimo, batería puede durar años, tiempo real, confiabilidad por años

### MOSIX: HPC / Clusters
- **Uso**: Supercomputadoras, clusters para simulación científica, análisis de grandes datos
- **Hardware típico**:
  - Cada nodo: 8-64 cores, 64 GB a TB de RAM
  - Red: InfiniBand, 10GbE+ (baja latencia)
  - Almacenamiento: Parallel filesystem (Lustre, GPFS)
  - Energía: kilowatts a megawatts
  - Costo: $100K a cientos de millones
- **Constraints**: Maximizar throughput, escalar a cientos/miles de nodos, balanceo de carga

---

## 6. Licencia

### Zephyr OS: Apache 2.0 (Permisiva)
- ✅ Uso comercial sin regalías
- ✅ Modificar y distribuir
- ✅ No requiere publicar modificaciones
- ✅ Patentes protegidas
- **Gobernanza neutral**: Proyecto de Linux Foundation — ninguna empresa controla la dirección

### MOSIX: Propietaria (Restrictiva)
- ❌ Prohíbe modificación
- ❌ Prohíbe reverse engineering
- ❌ Prohíbe derivados
- **Modelo**: Venta de licencias + soporte ($61,141 USD inicial + $16,835 USD anuales)
- **Resultado**: Cuando el equipo académico dejó de mantenerlo (2017), nadie pudo heredarlo

---

## 7. Estado Actual

### Zephyr OS: ✅ ACTIVO (2026)
- LTS3 (Long Term Support 3)
- Miles de commits por mes
- 3,000+ contribuyentes
- Productos reales: Google Chromebook, Framework Laptop, Vestas, Oticon More
- Security subcommittee, OpenSSF Gold Badge desde 2018-03-10 (mantenido hasta 2024-06-05)

### MOSIX: ❌ INACTIVO desde 2017
- Último release: MOSIX-4.4.4 (24 de octubre de 2017)
- Zero casos de producción modernos
- Vulnerabilidades de seguridad sin parchear desde hace 8+ años

---

## Tabla Comparativa Resumida

| Característica | Zephyr OS | MOSIX |
|----------------|-----------|-------|
| **Arquitectura** | Microkernel unificado | Distribuido SSI (cluster) |
| **Memoria** | MPU + Memory Domains | Memory Ushering (migración proactiva) |
| **Procesos** | Scheduling local (3 modos) | Migración preemptiva entre nodos |
| **Filesystem** | LittleFS / FAT / NVS (VFS) | DFSA + extN (acceso transparente) |
| **Target** | IoT / Microcontroladores | HPC / Clusters |
| **Licencia** | Apache 2.0 (permisiva) | Propietaria (restrictiva) |
| **Estado** | ✅ Activo (LTS3, 2026) | ❌ Inactivo desde 2017 |

---

## Conceptos Clave Explicados

### ¿Qué es un Microkernel?
Solo la funcionalidad mínima corre en kernel mode (scheduling, memoria básica, IPC). Drivers, filesystems, networking corren en **user space** como procesos separados.

**Diferencia con monolítico**: En Linux/Windows (monolíticos), todo corre en kernel mode en un único address space.

**Zephyr**: Microkernel en filosofía, pero "unificado" porque todo se compila estáticamente en una imagen — pragmatic choice para footprint mínimo.

### ¿Qué es MPU vs MMU?
- **MMU**: Permite paginación y memoria virtual con traducción de direcciones. Tablas de páginas en disco.
- **MPU**: Solo protege regiones de memoria con permisos, **sin traducción**. Más simple, común en microcontroladores.

### ¿Qué es SSI (Single System Image)?
El cluster se presenta como una **única máquina lógica**. Usuarios no saben cuántos nodos hay ni dónde están los recursos.

### ¿Qué es Memory Ushering?
Algoritmo de scheduling de memoria **proactivo**: migra procesos antes de que ocurra out-of-memory, guándolos hacia nodos con recursos disponibles. Análogo a swapping pero a través de la red (proceso entero vs página).

### ¿Qué es DFSA?
Mecanismo de acceso transparente a archivos remotos. Intercepta operaciones de archivo y las redirige al nodo que posee el archivo físico. **No es parallel filesystem** — no distribuye datos.

---

## Por Qué Son Incomparables

| Aspecto | Zephyr | MOSIX |
|---------|--------|-------|
| **Problema** | Software confiable en hardware limitado | Administrar cluster como recurso único |
| **Mide** | Footprint (KB), latency (μs), energía (μW) | Throughput (jobs/hora), utilization, speedup |
| **Optimiza** | Mínimo footprint, máximo determinismo | Máximo throughput, máxima utilización |
| **Dominio** | Sistemas embebidos de alta confiabilidad | Computación científica de alto rendimiento |

**Conclusión**: La comparativa tiene valor **académico e ilustrativo**, no para selección de producto. Cada sistema está óptimamente diseñado para su dominio, y los dominios no se superponen.

---

## Conexiones con el Temario FSO

| Tema | Zephyr | MOSIX |
|------|--------|-------|
| **§1.4 Arquitectura** | Híbrido microkernel — no encaja en categorías clásicas | Sistema operativo distribuido (5ta categoría) |
| **§2.5 Scheduling** | Priority-based con quantum (local) | Load balancing distribuido (migración preemptiva) |
| **§2.7 Scheduling medio plazo** | No aplica (sin swap) | Análogo a swapping pero a través de red |
| **§4.4 Paginación** | Sin paginación (MPU no MMU) | Memoria local de cada nodo, no paginada por cluster |
| **§5.3 Algoritmos de reemplazo** | No aplica sin demand paging | Memory Ushering = reemplazo a nivel proceso |
| **§3.6 Asignación de espacio** | LittleFS = enlazada, FAT = tabla de asignación | Asignación local del filesystem de cada nodo |

---

## Fuentes
- Zephyr Project: https://www.zephyrproject.org
- Documentación Zephyr: https://docs.zephyrproject.org/latest/
- MOSIX: http://www.mosix.org/
- Historia MOSIX: https://mosix.cs.huji.ac.il/txt_history.html
