# Slide 02 — Resumen: ¿Por qué comparar Zephyr y MOSIX?

## Propósito de la Comparación

Se comparan **Zephyr OS** (RTOS para microcontroladores) y **MOSIX** (sistema operativo de cluster HPC) por ser ejemplos opuestos de diseño de sistemas operativos. Esta comparación académica permite entender cómo las **restricciones del dominio** determinan las decisiones de diseño de un SO.

---

## Posicionamiento en el Mercado

Los dos productos se ubicam en extremos opuestos del espectro:

```
                    Recursos de Hardware
                         (Ilimitados)
                              ↑
                              │
         ┌────────────────────┼────────────────────┐
         │   HPC / Clusters   │  Servidores / DC   │
         │    MOSIX [0.85]    │                    │
         ├────────────────────┼────────────────────┤
         │  Sistemas embebidos│                    │
         │    medianos        │                    │
         ├────────────────────┼────────────────────┤
         │  IoT / Microcontrol│                    │
         │      Zephyr [0.2]  │                    │
         └────────────────────┴────────────────────┘
         ──────────────────────────────────────────→ 
              Alcance de Uso (Pequeño → Grande)
```

**Eje Y (Recursos)**: RAM (~4 KB vs GB), CPU (1 core vs cientos), almacenamiento, conectividad  
**Eje X (Escala)**: Dispositivo individual vs cluster de cientos de nodos

---

## Zephyr OS — Ficha Técnica

| Característica | Descripción |
|----------------|-------------|
| **Tipo** | RTOS (Sistema Operativo de Tiempo Real) |
| **Hardware destino** | Microcontroladores (MCU) — ARM Cortex-M, RISC-V, x86, ARC |
| **Footprint mínimo** | ~4 KB |
| **Dominio** | IoT, wearables, industria, médico |
| **Arquitectura** | Microkernel |
| **Licencia** | Apache 2.0 (open source, neutral) |
| **Estado** | Activo (2026) |
| **Organización** | Linux Foundation |

**Conceptos clave del temario FSO:**
- **§1.1 — Máquina extendida**: Abstrae hardware heterogéneo de MCUs detrás de una API unificada
- **§1.1 — Gestor de recursos**: Administra CPU, memoria, timers, E/S en entorno de recursos extremadamente limitados
- **§1.4 — Microkernel**: Baja latencia de interrupciones, footprint mínimo, comunicación por paso de mensajes
- **§1.5 — Modo dual**: Implementa privilege levels (Supervisor vs User)

---

## MOSIX — Ficha Técnica

| Característica | Descripción |
|----------------|-------------|
| **Tipo** | Cluster OS (Sistema Operativo de Cluster) |
| **Hardware destino** | Servidores/estaciones de trabajo en cluster |
| **Dominio** | HPC, investigación científica |
| **Single System Image (SSI)** | Cluster aparece como una única máquina |
| **Arquitectura** | Overlay sobre kernel Linux (no es standalone) |
| **Licencia** | Propietario restrictivo |
| **Estado** | **Inactivo desde 2017** (último release: MOSIX-4.4.4, octubre 2017) |
| **Organización** | Hebrew University of Jerusalem |

**Historia destacada:**
- 1977–1979: Primeros experimentos con migración de procesos en PDP-11
- 1999: Transición a Linux
- 2001: Se vuelve propietario
- 2002: Fork open source **openMosix** (discontinuado 2008)
- 2014: Funciona como módulo/overlay (sin parche de kernel)
- 2017: Último release oficial

**Conceptos clave del temario FSO:**
- **§1.1 — Máquina extendida**: Extiende cluster heterogeneous hacia una única máquina virtualizada
- **§1.1 — Gestor de recursos**: Gestión adaptativa de recursos a nivel de cluster
- **§1.4 — Arquitectura**: Overlay sobre kernel Linux (híbrida, ni microkernel ni monolítico puro)
- **§1.5 — Modo dual**: Migración de procesos requiere zonas críticas en modo kernel

---

## Comparación Directa

| Dimensión | Zephyr OS | MOSIX |
|-----------|-----------|-------|
| **Tipo** | RTOS | Cluster OS |
| **Hardware** | Microcontroladores | Servidores en cluster |
| **Memoria típica** | ~4 KB mínimo | GB por nodo |
| **Escala** | Dispositivo individual | Docenas a cientos de nodos |
| **Dominio** | IoT, wearables, médico | HPC, investigación |
| **Arquitectura** | Microkernel | Overlay sobre Linux |
| **Licencia** | Apache 2.0 | Propietario |
| **Estado** | Activo (2026) | Inactivo desde 2017 |
| **Scheduling** | Priority-based, Round Robin | Balanceo de carga adaptativo entre nodos |
| **Gestión de memoria** | Paginación simple, sin MMU en muchos casos | Memoria virtual completa, swap |
| **Comunicación** | Message queues, FIFOs locales | Migración de procesos, memoria compartida distribuida |

---

## Qué Determina las Diferencias

### Zephyr: Constraints de IoT embebido
- **Memoria limitada**: MCU típico tiene 32 KB a 512 KB de RAM
- **Energía limitada**: Dispositivos funcionan con baterías
- **Tiempo real**: Deadlines estrictos (sensores industriales, audífonos)
- **Heterogeneidad de hardware**: Docenas de arquitecturas (ARM, RISC-V, ARC)

### MOSIX: Constraints de HPC
- **Gran escala**: Cientos de nodos en cluster
- **Comunicación inter-nodo**: Latencia de red es el bottleneck
- **Recursos abundantes**: GB de RAM por nodo
- **Modelo**: Intentaba ofrecer SSI sobre hardware distribuido

---

## Glosario de Términos Clave

| Término | Definición |
|---------|------------|
| **RTOS** | Sistema operativo que garantiza respuesta dentro de deadlines estrictos. No es necesariamente "rápido", sino *determinístico*. Tipos: Hard real-time (fallo si no cumple), Soft real-time (deseable pero no crítico) |
| **MCU (Microcontrolador)** | Circuito integrado que integra CPU, memoria y periféricos en un chip. Recursos limitados (KB de RAM) |
| **Footprint** | Cantidad de RAM que el sistema requiere para operar |
| **Cluster OS** | SO diseñado para gestionar un cluster como una unidad única |
| **HPC** | Computación de alto rendimiento, agrega potencia usando múltiples nodos |
| **SSI (Single System Image)** | Técnica que hace que un cluster aparezca como una única máquina |
| **Microkernel** | Kernel con solo funciones mínimas; servicios corren en modo usuario |
| **Monolítico** | Todo el SO corre en modo kernel como proceso único |
| **Overlay** | Capa que extiende capacidades sin modificar el kernel base |
| **Migración de procesos** | Mover procesos en ejecución entre nodos sin interrumpirlos |

---

## Relevancia Académica (§temario FSO)

| Tema | Zephyr | MOSIX |
|------|--------|-------|
| **§1.1 — Máquina extendida** | Abstrae periféricos heterogéneos de MCUs | Cluster aparece como una única máquina |
| **§1.1 — Gestor de recursos** | Administra recursos limitados (CPU, memoria, E/S) | Gestión adaptativa a nivel de cluster |
| **§1.4 — Arquitectura** | **Microkernel** puro | Overlay sobre kernel Linux |
| **§1.5 — Modo dual** | Privilege levels (Supervisor/User) | Zonas críticas en modo kernel para migración |
| **§1.2 — Generaciones** | 5ª Generación (2016, era IoT/cloud) | 4ª-5ª Generación (1977-2017) |
| **§2 — Scheduling** | Priority-based, Round Robin, cooperativa | Balanceo de carga adaptativo, migración preemptiva |
| **§4/§5 — Memoria** | Sin MMU en muchos casos, gestión simple | Memoria virtual completa de Linux |

---

## Nota sobre MOSIX en Contexto Moderno

MOSIX ha sido **superado por tecnologías modernas** (SLURM, Kubernetes, OpenMPI). Su modelo de migración de procesos a nivel kernel es incompatible con el paradigma de contenedores. **No se recomienda para uso en producción moderna**. Para contexto académico/educativo, sigue siendo relevante como caso de estudio histórico de evolución de SO.

---

*Resumen generado para TP Especial de Evaluación de Productos — Fundamentos de Sistemas Operativos, Mayo 2026.*
