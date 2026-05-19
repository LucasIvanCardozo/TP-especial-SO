# Slide 25 — MOSIX: Casos de Uso

> **Nota**: Según la extracción del PPTX, "MOSIX — Casos de Uso" corresponde a slide 24, y "Zephyr OS — Costos" corresponde a slide 25. Este archivo sigue las instrucciones del task para cubrir Casos de Uso de MOSIX.

---

## 🎤 Qué Decir (Speaking Notes)

**"MOSIX fue diseñado para un nicho muy específico: clusters de HPC en el ámbito académico y de investigación. Su caso de uso ideal era un laboratorio universitario con varias máquinas que quería aprovechar como una única supercomputadora sin tener que reescribir aplicaciones. Durante los '90s y 2000s, MOSIX tuvo adopción real en universidades como Hebrew University, MIT, y centros de investigación de Europa. Sin embargo, desde octubre de 2017, el proyecto está completamente inactivo. No hay parches de seguridad, no hay soporte, no hay comunidad. Esto lo hace no recomendado para ningún uso en producción moderna."**

---

## 📌 Puntos Clave

### Contexto Histórico de Uso

| Período             | Uso Principal                            | Usuarios                                       |
| ------------------- | ---------------------------------------- | ---------------------------------------------- |
| **1990s**           | Clusters académicos pequeños             | Hebrew University, universidades de EE.UU.     |
| **2000-2005**       | Grid computing, investigación científica | Laboratorios de física, biología computacional |
| **2005-2010**       | Primeros clusters comerciales            | Pequeñas empresas de HPC                       |
| **2010-2017**       | Declive progresivo                       | Principalmente académico residual              |
| **2017-actualidad** | Proyecto inactivo                        | Ninguno en producción                          |

### Casos de Uso Originales (Ahora Históricos)

1. **Clusters Universitarios de Investigación**
   - Parallel computing para simulaciones científicas
   - Procesamiento paralelo sin reescribir código
   - Aprovechamiento de labs de computación existentes

2. **Grid Computing Distribuido**
   - Conectar múltiples máquinas como una sola unidad computacional
   - Migración transparente de procesos entre nodos
   - Balanceo de carga automático

3. **HPC Académico (Pre-SLURM/PBS)**
   - Anterior a la era de job schedulers modernos
   - Alternativa a escribir scripts de migración manuales

---

## 🔗 Relación con FSO

### §1.1 — ¿Qué es un Sistema Operativo?

MOSIX demuestra la aplicación de los conceptos de "máquina extendida" y "gestor de recursos" en un contexto distribuido:

- **Máquina extendida**: MOSIX extiende un cluster de máquinas individuales para aparecer como una única máquina (Single System Image). El programador ve un sistema, no 64 nodos separados.
- **Gestor de recursos distribuidos**: El SO debe coordinar CPU, memoria y red a través de múltiples nodos físicos.

### §2.1 y §2.2 — Administración del Procesador

La migración de procesos de MOSIX es una forma de scheduling distribuido que va más allá de lo cubierto en el temario:

- **Scheduling tradicional** (temas §2): Un scheduler decide qué proceso corre en qué CPU dentro de una máquina.
- **Scheduling distribuido MOSIX**: Decide qué proceso migra a qué nodo del cluster basándose en carga, memoria disponible, y latencia de red.

### §4.1 a §4.7 — Administración de Memoria

MOSIX implementa un modelo de **memoria distribuida shared-nothing** donde cada nodo tiene RAM local independiente. El Memory Ushering (slide 11) es su técnica para manejar la memoria a nivel de cluster:

- **Local vs Distribuido**: Los temas de memoria del temario asumen una memoria física única. MOSIX distribuye la memoria entre nodos.
- **No hay memoria compartida entre nodos**: Esta es una limitación crítica que no existe en sistemas single-machine.

### §3.1 a §3.9 — Sistemas de Archivos

MOSIX usa DFSA (Direct File System Access) para acceso transparente a archivos remotos. Esto conecta con:

- El concepto de sistema de archivos en sentido amplio (§3.1): DFSA es una capa de software que intercepta syscalls y las redirige al nodo que posee el archivo.
- **Limitación**: No hay paralelismo de E/S como en sistemas de archivos paralelos (Lustre, GPFS).

---

## ⚠️ Cosas a Tener en Cuenta

### Honestidad sobre el Estado Actual

1. **Proyecto Inactivo = Sin Seguridad**
   - 0 parches de seguridad desde 2017
   - Vulnerabilidades conocidas de kernel Linux de 2017-2026 no parcheadas
   - **Riesgo crítico** para cualquier uso conectado a red

2. **No Hay Comunidad ni Soporte**
   - El sitio mosix.org está online pero sin actualizaciones
   - Mailing lists inactivas
   - Documentación desactualizada (instrucciones para kernel 3.x que no aplican)

3. **Competencia Superior Disponible**
   - **SLURM**: Job scheduler estándar en supercomputadoras (60%+ del Top500)
   - **Kubernetes**: Orquestación moderna, comunidad masiva
   - **OpenMPI**: Paralelismo con comunicación explícita
   - **PBS Professional**: Solución comercial consolidada

4. **Limitaciones Técnicas No Resueltas**
   - No soporta memoria compartida entre nodos (HPC moderno requiere esto)
   - Basado en modelo de migración preemptiva que fue superado por contenedores
   - Arquitectura de kernel patch/overlay incompatible con kernels modernos

### Qué Decir en la Presentación

> **"MOSIX fue un proyecto de investigación académicamente significativo, pero tecnológicamente obsoleto. Para cualquier caso de uso que MOSIX intentaba resolver, existen soluciones modernas superiores que están activamente mantenidas y tienen comunidades activas. No recomendamos MOSIX para ningún uso en producción en 2026."**

---

## ⏱️ Tiempo Estimado

| Componente                         | Tiempo          |
| ---------------------------------- | --------------- |
| Introducción al contexto histórico | 15 segundos     |
| Casos de uso originales (breve)    | 10 segundos     |
| Advertencia sobre estado actual    | 15 segundos     |
| **Total recomendado**              | **40 segundos** |

---

## 📚 Glosario de Términos

| Término                              | Definición                                                                       |
| ------------------------------------ | -------------------------------------------------------------------------------- |
| **HPC (High Performance Computing)** | Computación de alto rendimiento en clusters de miles de nodos                    |
| **Single System Image (SSI)**        | Tecnología que hace que un cluster aparezca como una única máquina               |
| **Grid Computing**                   | Modelo de computación distribuida que conecta recursos geográficamente dispersos |
| **Job Scheduler**                    | Software que administra la cola de trabajos en clusters HPC (SLURM, PBS)         |
| **DFSA (Direct File System Access)** | Mecanismo de MOSIX para acceso transparente a archivos en cualquier nodo         |
| **Orquestación de contenedores**     | Gestión automatizada de contenedores (Kubernetes, Docker Swarm)                  |

---

## 🔗 Fuentes

- MOSIX Official Site: http://www.mosix.org/
- MOSIX History — Hebrew University: https://mosix.cs.huji.ac.il/txt_history.html
- Top500 Supercomputers: https://www.top500.org/
- Wikipedia — MOSIX: https://en.wikipedia.org/wiki/MOSIX

---

_Notas de presentación para slide de Casos de Uso de MOSIX_
_TP Especial — Zephyr OS vs MOSIX | Fundamentos de Sistemas Operativos | UNMDP_
