# Resumen: Zephyr OS - Características Generales

## Overview

Zephyr es un sistema operativo de tiempo real (RTOS) diseñado para dispositivos embebidos con recursos limitados. Sus cuatro dominios técnicos principales son: **Arquitectura del Kernel**, **Scheduling**, **Modelo de Memoria** y **Arquitecturas Soportadas**.

---

## 1. Arquitectura del Kernel

### 1.1 Kernel Monolítico Unificado (desde v1.6)

Zephyr usa un kernel monolítico: todas las funcionalidades (scheduling, drivers, filesystem, networking) operan en modo kernel. Sin embargo, es **highly modular y configurable** — los subsistemas pueden incluirse/excluirse en tiempo de compilación mediante Kconfig, acercándose a la filosofía de un microkernel sin el overhead de comunicación entre procesos.

**Contexto histórico**: Antes de v1.6 (diciembre 2016), Zephyr tenía un **dual-kernel**:
- **Nanokernel**: para dispositivos muy limitados (~4-10 KB RAM)
- **Microkernel**: para dispositivos con más recursos

Desde v1.6 se unificaron en un único kernel donde "fibers" y "tasks" se fusionaron en el concepto de **thread**.

### 1.2 Single Address Space

Kernel y aplicaciones **comparten el mismo espacio de direcciones**. No hay MMU entre procesos de usuario y kernel.

**Ventajas**:
- System calls con overhead mínimo (son function calls directos, sin context switch)
- Comunicación entre hilos extremadamente rápida (comparten punteros directamente)
- Simplicidad en el modelo de programación

**Desventaja**: Un bug en una aplicación puede corromper memoria del kernel. La protección se logra con MPU.

### 1.3 System Calls como Function Calls

En sistemas tradicionales (UNIX), una system call implica trap + cambio de contexto. En Zephyr, como kernel y apps comparten espacio de direcciones, las system calls son **llamadas a función C directas**. No hay cambio de contexto.

### 1.4 Compilación Estática

Todo (kernel + apps + drivers) se compila en un **único binario estático**. No hay dynamic loader ni shared libraries. El tamaño mínimo del kernel puede ser ~16 KB para una configuración mínima del OS completo; el nanokernel histórico pre-v1.6 podía configuraciones ultra-minimales de ~4 KB.

---

## 2. Scheduling (Planificador)

### 2.1 Cooperative + Preemptive + Híbrido

| Tipo | Descripción |
|------|-------------|
| **Cooperative** | Los hilos ceden CPU solo cuando llaman a `k_yield()` o bloquean. Útil para tareas críticas que no deben ser interrumpidas. |
| **Preemptive** | Hilos de mayor prioridad pueden interrumpir a los de menor prioridad. Garantiza fairness. |
| **Híbrido** | Combinación de ambos en el mismo sistema. |

Zephyr usa **priority-based preemptive scheduling**: el hilo listo de mayor prioridad siempre se ejecuta.

### 2.2 SMP (Multi-core Simétrico)

Múltiples CPUs comparten la misma memoria y ejecutan el mismo kernel. Los hilos pueden ejecutarse en cualquier core disponible. Requiere sincronización con spinlocks.

### 2.3 AMP (Procesamiento Asimétrico via OpenAMP)

Cada core ejecuta un kernel diferente. Ejemplo típico:
- **Core 0**: Zephyr (tiempo real)
- **Core 1**: Linux (tareas generales)

**OpenAMP** es el framework para implementar AMP, permitiendo comunicación entre kernels mediante mailbox y shared memory.

### 2.4 Priority Inheritance

**Problema de inversión de prioridad**:
1. Hilo L (baja prioridad) tiene un mutex
2. Hilo H (alta prioridad) quiere ese mutex → queda bloqueado
3. Hilo M (media prioridad) preempt a L → H queda atrapado esperando

**Solución**: Cuando H se bloquea esperando el mutex de L, la prioridad de L se eleva temporalmente al nivel de H. Así M no puede preempt a L hasta que libere el mutex.

---

## 3. Modelo de Memoria

### 3.1 MPU-based Protection

**MPU** (Memory Protection Unit) permite definir ~8-16 regiones de memoria con permisos (lectura, escritura, ejecución). Es más simple que una MMU completa.

**¿Por qué MPU y no MMU?** La mayoría de los microcontroladores target de Zephyr (Cortex-M0, M3, M4, M7, RISC-V sin MMU) **no tienen MMU**. Implementar memoria virtual completa tiene overhead prohibitivo en dispositivos con 32KB-256KB de RAM total.

### 3.2 User Mode + Kernel Mode

El kernel corre en modo privilegiado; los hilos de aplicación pueden correr en modo no privilegiado. Intentos de ejecutar instrucciones privilegiadas desde user mode generan excepciones (faults).

** Beneficio en embebidos**: Incluso con recursos limitados, user mode aísla aplicaciones para que un bug no corrompa el kernel ni afecte todo el sistema.

### 3.3 Demand Paging

Solo disponible en arquitecturas **con MMU** (ej: Cortex-A). Carga páginas del disco a RAM solo cuando son referenciadas (page fault).

### 3.4 Heap, Memory Slabs, Memory Blocks

| Mecanismo | Descripción | Uso típico |
|-----------|-------------|------------|
| **Heap** | malloc/free clásico | Asignación de tamaño variable |
| **Memory Slabs** | Bloques de tamaño fijo pre-allocated | Tiempo real sin fragmentación |
| **Memory Blocks** | Sistema de bloques estructurados | Arrays de objetos del mismo tipo |

---

## 4. Arquitecturas Soportadas

### 4.1 Lista Principal
- **ARM**: Cortex-M, Cortex-R, Cortex-A
- **RISC-V**: 32 y 64-bit
- **x86**: 32 y 64-bit
- **ARC**: HS, EM
- **Nios II**: Soft-core de Altera/Intel
- **Xtensa**: Usado en ESP32
- **MIPS**, **SPARC**

### 4.2 Escalabilidad
- **+1,000 boards** soportadas
- **~16 KB** footprint mínimo del kernel (configuración mínima del OS completo; nanokernel histórico ~4 KB)
- Tamaño depende de: features habilitados, arquitectura target, nivel de optimización

---

## 5. Zephyr vs Unix/Linux

| Aspecto | Unix/Linux | Zephyr |
|---------|------------|--------|
| Arquitectura | Monolítico (tradicional) | Monolítico (microkernel-like) |
| Espacio de direcciones | Separado por proceso (MMU) | Compartido (single address space) |
| System calls | Trap + cambio de contexto | Function calls |
| Memoria virtual | Sí (MMU completo) | Opcional (demand paging, solo con MMU) |
| Protección | Tablas de páginas separadas | MPU o ninguna |
| Tamaño típico | MB a GB | KB (~16 KB mínimo, nanokernel histórico ~4 KB) |
| Target | PCs, servidores | Microcontroladores, IoT |

---

## 6. Glosario Rápido

- **Kernel Monolítico**: Todo corre en modo kernel en un único espacio de direcciones.
- **Microkernel**: Solo funcionalidades mínimas en kernel; servicios como filesystem/driver corren en espacio de usuario.
- **MPU**: Hardware de protección que define regiones de memoria con permisos (no provee memoria virtual).
- **Single Address Space**: Kernel y apps comparten el mismo espacio de direcciones.
- **Preemptive Scheduling**: El SO puede interrumpir un proceso en cualquier momento.
- **Priority Inheritance**: Mecanismo para evitar inversión de prioridad.
- **SMP**: Múltiples CPUs simétricas comparten memoria y ejecutan el mismo kernel.
- **AMP**: Cada CPU ejecuta un kernel/SO diferente.
- **OpenAMP**: Framework para implementar AMP entre Zephyr y otros sistemas.
- **Demand Paging**: Carga de páginas del disco a RAM solo cuando son referenciadas.

---

## 7. Conexión con Temas FSO

| Tema FSO | En Zephyr |
|----------|-----------|
| Proceso/Thread | Thread unificado (desde v1.6) |
| Multitarea | Cooperative + Preemptive + Híbrido |
| Kernel monolítico | Sí |
| Modo dual (user/kernel) | Sí, via privilege levels + MPU |
| Scheduling | Priority-based preemptive, cooperative, round-robin |
| Priority inheritance | Sí |
| Memoria virtual | Solo en arquitecturas con MMU |

---

*Resumen basado en slide-05-explicacion.md — Fuentes: Zephyr Project Documentation, Wikipedia*
