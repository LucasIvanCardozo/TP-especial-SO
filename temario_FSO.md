# Temario Completo — Fundamentos de Sistemas Operativos

> Resumen de todos los temas vistos en la materia, basado en los TPs resueltos.

---

## Índice General

1. [Introducción a Sistemas Operativos](#1-introducción)
2. [Administración del Procesador](#2-administración-del-procesador)
3. [Sistemas de Archivos](#3-sistemas-de-archivos)
4. [Administración de la Memoria](#4-administración-de-la-memoria)
5. [Memoria Virtual](#5-memoria-virtual)

---

## 1. Introducción

### 1.1 ¿Qué es un Sistema Operativo?

- **Definición**: Software que actúa como intermediario entre el hardware y las aplicaciones de usuario
- **Objetivos principales**:
  - **Máquina extendida**: Oculta complejidad del hardware presentando una interfaz más simple
  - **Gestor de recursos**: Administra CPU, memoria, dispositivos E/S eficientemente

### 1.2 Generaciones de Sistemas Operativos

| Gen | Período | Tecnología | Elementos Distintivos |
|-----|---------|------------|----------------------|
| 1ª | 1945-1955 | Tubos de vacío | Sin SO, programación en lenguaje máquina |
| 2ª | 1955-1965 | Transistores | Batch processing, monitor residente |
| 3ª | 1965-1980 | Circuitos integrados | **Multiprogramación**, **spooling**, **time-sharing** |
| 4ª | 1980-1990 | Microprocesadores | Computadoras personales, MS-DOS, UNIX, Linux |
| 5ª | 1990-presente | Móvil y nube | Smartphones, cloud computing, virtualización |

### 1.3 Conceptos Fundamentales

| Concepto | Definición |
|-----------|------------|
| **Tarea** | Unidad de trabajo del SO (sinónimo histórico de proceso) |
| **Programa** | Código almacenado en disco (pasivo) |
| **Proceso** | Programa en ejecución con su contexto de CPU completo |
| **Multiprogramación** | Múltiples programas en memoria simultáneamente |
| **Multitarea** | Ejecución aparentemente simultánea de múltiples tareas |
| **Multiprocesamiento** | Uso de múltiples CPUs/núcleos en paralelo |

### 1.4 Arquitecturas de SO

| Arquitectura | Descripción | Ejemplos |
|--------------|-------------|----------|
| **Monolítica** | Todo en modo kernel | UNIX, Linux |
| **Por capas** | SO dividido en capas jerárquicas | THE, MULTICS |
| **Microkernel** | Kernel mínimo, servicios en usuario | MINIX, QNX, macOS |
| **Cliente-Servidor** | Servicios como servidores | Sistemas modernos |
| **Máquinas Virtuales** | Múltiples SO simulados | VMware, KVM, Xen |

### 1.5 Modo Dual de Operación

```
Usuario → (system call / interrupción) → Kernel
```

- **Modo Kernel**: Ejecuta el SO, acceso completo al hardware, instrucciones privilegiadas
- **Modo Usuario**: Ejecuta aplicaciones, acceso limitado a memoria/instrucciones

### 1.6 Instrucciones Privilegiadas

| Privilegiadas | No Privilegiadas |
|---------------|-----------------|
| Halt, I/O | ADD, SUB, MOV |
| STI/CLI | PUSH, POP |
| LGDT/SGDT | CALL, RET |
| MOV to CR0-CR3 | JMP, JE, JNE |
| HLT | AND, OR, XOR |

### 1.7 Interrupciones

| Tipo | Origen | Ejemplo |
|------|--------|----------|
| Hardware | Dispositivos físicos | Tecla, disco, red |
| Software | Instrucción `syscall` | `int 0x80`, `syscall` |
| Excepción | Error de ejecución | División por cero, page fault |
| Reloj | Timer del sistema | Scheduler periódica |

### 1.8 Llamadas al Sistema

- **Definición**: Interfaz entre programas de usuario y servicios del kernel
- **Ejemplos**:
  - Procesos: `fork()`, `exec()`, `exit()`
  - Archivos: `open()`, `read()`, `write()`, `close()`
  - Directorios: `mkdir()`, `rmdir()`

---

## 2. Administración del Procesador

### 2.1 Necesidad del Scheduling

- **Multiprogramación**: Mantener CPU ocupada mientras procesos esperan E/S
- **Objetivos del scheduler**:
  - Maximizar utilización de CPU
  - Maximizar throughput
  - Minimizar tiempo de turnaround
  - Minimizar tiempo de respuesta
  - Equidad entre procesos

### 2.2 Estados de un Proceso

```
        ┌─────────────────────────────┐
        │                         │
        ▼                         │
    EJECUTANDO ───quantum agotado──→ LISTO
        │
        │ inicia E/S
        ▼
    BLOQUEADO
        │
        │ E/S completa
        ▼
    LISTO
```

### 2.3 PCB (Process Control Block)

| Campo | Descripción |
|-------|-------------|
| PID | Identificador único |
| Estado | Running, Ready, Blocked, Zombie |
| PC | Contador de programa |
| Registros | Estado de CPU |
| Planificación | Prioridad, quantum, tiempo CPU |
| Memoria | Límites, tablas de páginas |
| Archivos | Descriptores abiertos |
| Accounting | Tiempos de CPU |

### 2.4 Tipos de Schedulers

| Scheduler | Nivel | Frecuencia | Función |
|-----------|-------|------------|---------|
| **Largo plazo** | Job admission | Seg-min | Controla grado multiprogramación |
| **Medio plazo** | Swapping | Seg | Mover procesos a/de memoria |
| **Corto plazo** | CPU scheduling | ms | Seleccionar siguiente proceso |

### 2.5 Algoritmos de Scheduling

| Algoritmo | Descripción | Características |
|-----------|-------------|-----------------|
| **FCFS** | First Come First Served | Simple, efecto convoy |
| **SJF** | Shortest Job First | Óptimo en tiempo de espera, requiere conocer duración |
| **SRTF** | SJF con desalojo | Versión preemptive de SJF |
| **Round Robin** | Quantum fijo, rotación | Justo, зависит del quantum |
| **Por prioridad** | Procesos con mayor prioridad primero | Puede causar starvation |
| **Colas multinivel** | Múltiples colas con diferentes algoritmos | Combina ventajas |

### 2.6 Efecto Convoy

- Proceso CPU-bound largo monopoliza la CPU
- Procesos cortos quedan esperando
- **Solución**: Round Robin, SJF, colas multinivel

### 2.7 Quantum óptimo

| Condición | Efecto |
|-----------|--------|
| Q muy grande | FCFS-like, monopolización |
| Q → 0 | Overhead excesivo de context switch |
| Q ≈ E (tiempo CPU típico) | Balance óptimo |

### 2.8 Dispatcher

Funciones:
1. Cambio de contexto
2. Cambio a modo usuario
3. Reinicialización de registros
4. Salto al PC del nuevo proceso

---

## 3. Sistemas de Archivos

### 3.1 Sistema de Archivos en Sentido Amplio vs Estricto

| Sentido | Definición |
|---------|------------|
| **Amplio** | Todo el software de gestión de archivos + estructuras de datos + servicios |
| **Estricto** | Solo la estructura de datos en disco (i-nodos, FAT, etc.) |

### 3.2 Conceptos de Archivos

| Concepto | Descripción |
|----------|------------|
| **Dato** | Valor raw sin contexto |
| **Campo** | Datos relacionados representando un atributo |
| **Registro** | Campos de una entidad completa |
| **Archivo** | Colección de registros relacionados |
| **Información** | Datos procesados con significado |

### 3.3 Atributos de un Archivo

- Nombre, identificador (i-nodo)
- Tipo (regular, directorio, dispositivo)
- Ubicación (puntero a bloques)
- Tamaño, timestamps
- Propietario, permisos
- Contador de enlaces

### 3.4 Operaciones sobre Archivos

| Operación | Descripción |
|-----------|------------|
| Create/Delete | Crear o eliminar archivos |
| Open/Close | Establecer conexión con proceso |
| Read/Write | Transferencia de datos |
| Seek | Mover puntero de posición |
| Get/Set Attributes | Consultar/modificar metadata |

### 3.5 Métodos de Acceso

| Método | Descripción |
|--------|-------------|
| **Secuencial** | Byte por byte en orden |
| **Directo** | Saltar a posición arbitraria |
| **Indexado** | Índices para búsqueda eficiente |

### 3.6 Métodos de Asignación de Espacio

| Método | Descripción | Fragmentación |
|--------|-------------|---------------|
| **Contiguo** | Bloques físicos adyacentes | Externa |
| **Enlazado** | Bloques con punteros al siguiente | Ninguna externa |
| **FAT** | Tabla en memoria con cadena de bloques | Ninguna externa |
| **I-nodos** | Bloque índice con punteros directos/indirectos | Ninguna externa |

### 3.7 Estructura de Directorios

| Estructura | Descripción |
|------------|-------------|
| **Single-level** | Un directorio único |
| **Two-level** | Directorio maestro + uno por usuario |
| **Jerárquico (árbol)** | Subdirectorios任意 profundidad |

### 3.8 Enlaces

| Tipo | Descripción |
|------|-------------|
| **Hard link** | Múltiples nombres → mismo i-nodo |
| **Soft/Symbolic link** | Archivo especial con ruta al destino |

### 3.9 UNIX vs DOS

| Aspecto | UNIX | DOS/Windows |
|----------|-------|-------------|
| Modelo | Secuencia de bytes | Secuencia de bytes |
| Nombres | Flexible, extensión informativa | 8.3 caracteres, significativa |
| Directorios | Jerárquico | Jerárquico |
| I-nodos | Separados del nombre | Mezclados en entrada |

---

## 4. Administración de la Memoria

### 4.1 Concepto de Administración de Memoria

- **Problema**: Múltiples procesos compiten por memoria limitada
- **Soluciones**: Particiones fijas/variables, paginación, segmentación

### 4.2 MFT (Multiprogramming with Fixed number of Tasks)

- Memoria dividida en particiones **fijas** de tamanhos predetermined
- Un proceso por partición
- **Ventaja**: Simple
- **Desventaja**: Desperdicio de memoria (fragmentación interna)

### 4.3 MVT (Multiprogramming with Variable number of Tasks)

- Particiones **dinámicas** según necesidades de cada proceso
- **Ventaja**: Mejor uso de memoria
- **Desventaja**: Fragmentación externa, compactación necesaria

### 4.4 Paginación

- Memoria lógica dividida en **páginas** de tamaño fijo
- Memoria física dividida en **marcos de página** (frames)
- Tabla de páginas mapea páginas → frames
- **Ventaja**: Elimina fragmentación externa
- **Desventaja**: Fragmentación interna leve

### 4.5 Segmentación

- Memoria lógica dividida en **segmentos** de tamanho variable
- Tabla de segmentos con base/límite
- **Ventaja**: División lógica natural (código, datos, pila)
- **Desventaja**: Fragmentación externa posible

### 4.6 Fragmentación

| Tipo | Descripción | Causa |
|------|-------------|-------|
| **Interna** | Espacio no usado dentro de partición/asignación | Asignación mayor a necesidad |
| **Externa** | Huecos libres no contiguos entre particiones | Liberación de procesos |

### 4.7 Compactación

- **Definición**: Mover procesos para combinar huecos libres
- **Problema**: Tiempo indeterminado, inadecuada para tiempo real
- **Solución**: Buddy system, listas de bloques libres

---

## 5. Memoria Virtual

### 5.1 Concepto de Memoria Virtual

- **Definición**: Técnica que crea la ilusión de más memoria de la físicamente disponible
- **Funcionamiento**: Tablas de páginas en disco + RAM
- **Beneficios**:
  - Procesos pueden usar más memoria que la física
  - Aislamiento entre procesos
  - Simplifica programación

### 5.2 Fallo de Página (Page Fault)

| Paso | Acción |
|------|--------|
| 1 | Hardware detecta página no válida |
| 2 | SO identifica página en disco |
| 3 | Selecciona víctima (si memoria llena) |
| 4 | Si víctima modificada, escribe a disco |
| 5 | Carga página nueva |
| 6 | Actualiza tabla de páginas |
| 7 | Reanuda proceso |

### 5.3 Algoritmos de Reemplazo de Páginas

| Algoritmo | Descripción |
|-----------|-------------|
| **FIFO** | La más antigua es víctima |
| **LRU** | Least Recently Used |
| **LFU** | Least Frequently Used |
| **MFU** | Most Frequently Used |
| **OPT** | Algoritmo óptimo (tasa mínima de fallos) |

### 5.4 Algoritmos Globales vs Locales

| Tipo | Pool de frames | Víctima puede ser de otro proceso |
|------|----------------|----------------------------------|
| **Global** | Compartido | Sí |
| **Local** | Fijo por proceso | No |

### 5.5 Anomalía de Belady

- Fenómeno donde **más frames → más page faults** (en FIFO)
- Algoritmos de pila (LRU, OPT) no sufren este problema

### 5.6 Thrashing e Hiperpaginación

| Concepto | Descripción |
|----------|-------------|
| **Thrashing** | Page faults excesivos causando degradación severa |
| **Hiperpaginación** | Actividad constante de paging |
| **Condiciones** | Working set > memoria disponible, CPU idle |

### 5.7 Working Set

- **Definición**: Conjunto de páginas activamente usadas por un proceso
- **Modelo**: Mantener working set en memoria para evitar thrashing

---

## Temas no alcanzados en TPs

- Sincronización de procesos (semáforos, mutex, monitores)
- Deadlocks (condiciones, detección, resolución)
- Entrada/Salida y Scheduling de E/S
- Sistemas Distribuidos
- Protección y seguridad

---

*Documento generado enbase a TPs 1-5 resueltos de Fundamentos de Sistemas Operativos, UNMDP*