# slide-26-explicacion.md — Resumen: MOSIX, Costos y Modelo de Licenciamiento

## 1. Advertencia Central — Proyecto Inactivo

> **⚠ PROYECTO INACTIVO — NO RECOMENDADO PARA PRODUCCIÓN EN 2026**

MOSIX no es un producto "funcional pero caro". Es un proyecto **sin desarrollo activo desde octubre de 2017** (versión MOSIX-4.4.4). Esto implica:

- **Seguridad**: Vulnerabilidades descubiertas después de 2017 no tienen parche oficial
- **Compatibilidad**: No soporta kernels Linux modernos ni hardware nuevo
- **Evolución**: Sin nuevas features, optimizaciones ni correcciones
- **Comunidad**: No existe masa crítica de usuarios para soporte peer-to-peer

Un proyecto inactivo durante más de 8 años es un **descalificatorio automático** para uso en producción.

---

## 2. Modelo de Licencia Propietaria

### 2.1 Naturaleza

MOSIX utiliza una **licencia propietaria restrictiva** propia del grupo de investigación de la Hebrew University of Jerusalem. No es GPL, MIT, BSD ni Apache. Es un documento legal personalizado de los años 1980-1990.

### 2.2 Restricciones

| Restricción | Implicancia |
|-------------|-------------|
| **Prohibido modificar** | No se puede adaptar a necesidades específicas del cluster |
| **Prohibido ingeniería reversa** | No se puede estudiar el funcionamiento interno para debugging o integración |
| **Sin código fuente disponible** | No hay forma de auditar seguridad ni verificar comportamiento |
| **Sin obras derivadas** | Si se corrige un bug, no se puede distribuir la corrección |
| **Contribuciones = propiedad del autor** | Desincentiva completamente las contribuciones externas |

### 2.3 Modelo de Negocio

MOSIX fue diseñado como un **proyecto de investigación con intenciones comerciales**, pero sin la infraestructura de una empresa dedicada:

1. Investigación académica → desarrollo del core tecnológico
2. Licencia restrictiva → intentar monetizar la tecnología
3. Sin empresa dedicada → sin soporte comercial formal, sin SLAs

Este patrón es común en tecnología nacida en universidades entre 1980-2000, pero raramente escala hacia productos comerciales exitosos.

### 2.4 Comparación con Casos Similares

| Sistema | Origen | Evolución |
|---------|--------|-----------|
| **MINIX** | Propietaria (1987) | Reescrita como open source (2000) cuando Linux la superó |
| **XNU** | Basado en FreeBSD + componentes propietarias de Apple | Estado actual mixto |
| **Solaris** | Sun Microsystems | Parcialmente open source (OpenSolaris, OpenIndiana) |
| **Zephyr** | Open source (Apache 2.0) + Linux Foundation | Activo y creciente |

La diferencia clave con Zephyr es que este **deliberadamente evita las barreras de entrada** del modelo propietario. Cuando el SO es un recurso compartido bajo gobernanza neutral, los costos de transacción para todos los participantes se reducen dramáticamente.

---

## 3. Información Histórica de Precios

### 3.1 Datos USENIX 2000 (OBSOLETOS — NO VÁLIDOS)

| Concepto | Monto (USD) |
|----------|-------------|
| **Licencia inicial** (cluster de producción) | **$61,141.25** |
| **Mantenimiento anual** | **$16,835.00** |

**Fuente**: USENIX Documentation 2000 (datos históricos, actualmente obsoletos y proyecto inactivo desde 2017) — https://www.usenix.org/02/archive/highights/html/mosix.html

### 3.2 Contexto del Año 2000

- $61,141 USD era aproximadamente **3-4 veces el salario anual** de un ingeniero de sistemas en USA
- $16,835 USD anual equivalía a ~30% del costo inicial por año
- TCO en ciclo de 5 años: $61,141 + (4 × $16,835) = **$128,481 USD**

En 2000, MOSIX se posicionaba en un nicho "middle-market": más caro que clusters Beowulf DIY ($10,000-20,000), pero más barato que supercomputadoras comerciales ($500K+). La diferencia era que un cluster Beowulf podía modificarse y mantenerse por cualquier equipo técnico, mientras que MOSIX dependía del grupo de Jerusalem.

### 3.3 Por Qué el Precio Fue una Barrera

1. **Inversión inicial alta**: $61K upfront era prohibitiva para universidades
2. **Mantenimiento recurrente**: 27% anual sobre el costo inicial
3. **Sin soporte garantizable**: Grupo de investigación académico, no empresa
4. **Riesgo de lock-in**: Migrar a otra solución era costoso

Desde la teoría de costos de transacción, estos factores aumentaban:
- Costos de búsqueda y evaluación de alternativas
- Costos de negociación de la licencia
- Costos de monitoreo del cumplimiento
- Costos de switching si el vendor abandonaba el producto

### 3.4 Precio Actual

**NO HAY PRECIO DISPONIBLE PÚBLICAMENTE.** El sitio mosix.org permite descarga del software pero no presenta lista de precios ni canal comercial formal. Solo un email de contacto académico: mosix@cs.huji.ac.il.

Esto es característico de un proyecto en **estado de abandono comercial**. Cuando un producto propietario pierde soporte comercial, generalmente desaparece completamente porque el código no es redistribuible.

---

## 4. Soporte Comercial

### 4.1 Estado Actual

| Tipo de Soporte | Disponible |
|-----------------|------------|
| Soporte técnico comercial | ❌ No |
| Empresa dedicada | ❌ No existe |
| Canal de soporte pago | ❌ No hay |
| Contratos de mantenimiento | ❌ No hay información pública |
| Actualizaciones de seguridad | ❌ No |

### 4.2 Solo Disponible

- Documentación en línea (FAQs, guías, manuales PDF)
- Publicaciones académicas y white papers
- Twitter: [@MOSIX_cluster](https://twitter.com/MOSIX_cluster) — actividad esporádica

Esto es **soporte de comunidad académica**, no soporte comercial. La diferencia es crítica:

- **Soporte comercial**: SLAs con tiempos de respuesta garantizados, parches de seguridad en <24h, soporte telefónico 24/7
- **Soporte comunitario**: Leer documentación, quizás esperar respuesta por email, sin garantías

### 4.3 Production Readiness

MOSIX falla en todos los aspectos para uso en 2026:

| Criterio | Estado |
|----------|--------|
| Estabilidad | Última versión 2017, sin updates en 8+ años |
| Seguridad | Cero parches en 8 años |
| Escalabilidad | Diseñado para hardware de su época |
| Mantenibilidad | Documentación desactualizada, comunidad pequeña |
| Soporte | No existe canal comercial |

---

## 5. Comparación con Alternativas Modernas

### 5.1 Tabla Comparativa

| Criterio | MOSIX | SLURM | Kubernetes |
|----------|-------|-------|------------|
| **Licencia** | Propietaria (restrictiva) | GPL v2 (libre) | Apache 2.0 (libre) |
| **Costo** | No disponible | **Gratis** | **Gratis** |
| **Estado** | ❌ Inactivo (2017) | ✅ Muy activo | ✅ Muy activo |
| **Soporte comercial** | ❌ No disponible | ✅ SchedMD | ✅ Multi-vendor |
| **Single System Image** | ✅ Sí | ❌ No | ❌ No |
| **Migración de procesos** | ✅ Sí (preemptive) | ❌ No (job re-scheduling) | ❌ No (container rescheduling) |
| **Adopción en Top500** | ❌ 0% | ✅ >60% | ❌ N/A |

### 5.2 MOSIX vs SLURM — Diferencia Técnica Fundamental

```
MOSIX: Single System Image
┌─────────────────────────────────┐
│  Kernel Linux modificado       │
│  (MOSIX extensions)             │
├─────────────────────────────────┤
│  Proceso migrable en NODO-1     │◄── Puede migrar EN VIVO a NODO-2
│  Proceso migrable en NODO-2     │◄── Puede migrar EN VIVO a NODO-3
│  Proceso migrable en NODO-3     │
└─────────────────────────────────┘

SLURM: Job Scheduling (NO migration)
┌─────────┐  ┌─────────┐  ┌─────────┐
│ NODO-1  │  │ NODO-2  │  │ NODO-3  │
│ Linux   │  │ Linux   │  │ Linux   │
│ Job A   │  │ Job B   │  │ Job C   │
└─────────┘  └─────────┘  └─────────┘
     ▲           ▲
     │           │
  SLURM decide allocation de recursos,
  pero NO migra procesos entre nodos
```

MOSIX ofrece migración de procesos preemptive (mover procesos vivos entre nodos automáticamente). SLURM simplemente asigna jobs a nodos — no migra procesos vivos.

MOSIX es conceptualmente superior para **load balancing dinámico**, pero inferior en **simplicidad, robustez y costos** porque requiere kernel patches y mantenimiento de código propietario.

### 5.3 Por Qué las Alternativas Ganaron

1. **Modelo de licenciamiento**: GPL y Apache 2.0 permiten uso, modificación y redistribución libre, habilitando comunidades grandes y múltiples vendors
2. **Soporte comercial**: Red Hat, Google, Amazon tienen interés económico en mantener estas tecnologías
3. **Timing**: El declive de MOSIX coincidió con la explosión de Linux en HPC, emergencia de virtualización y containers
4. **Governance**: SLURM (SchedMD) y Kubernetes (CNCF) tienen gobernanza neutral multi-stakeholder que evita lock-in

---

## 6. TCO — Total Cost of Ownership

### 6.1 Componentes del TCO para MOSIX

| Componente | Costo |
|------------|-------|
| **Licencia inicial** | ~$61K (histórico, obsoleto) |
| **Hardware de cluster** | $50K-$500K |
| **Administración** | 0.5-2 FTEs dedicados, conocimiento especializado |
| **Mantenimiento** | $16,835/year (histórico, obsoleto) |
| **Capacitación** | $5K-$20K |
| **Migración futura** | $30K-$100K (cuando quedó obsoleto) |
| **Riesgo de seguridad** | Muy alto (sin parches) |

### 6.2 Comparación con Alternativas

| Componente | MOSIX | SLURM | Kubernetes |
|------------|-------|-------|------------|
| **Software** | ~$61K (histórico) | **Gratis** | **Gratis** |
| **Administración** | Alto (conocimiento propietario) | Medio | Medio |
| **Mantenimiento** | $16K/year (histórico) | **Gratis** o ~$10K-50K/year (vendor) | **Gratis** o ~$10K-100K/year (vendor) |
| **Capacitación** | Caro (recursos limitados) | Barato (muchos cursos) | Barato (cursos massivos) |
| **Riesgo futuro** | Muy alto | Bajo | Bajo |

El TCO de MOSIX era prohibitivo comparada con alternativas open source, incluso sin contar que esas alternativas ofrecen mejor soporte, comunidad más grande y evolución continua.

---

## 7. Glosario de Términos

| Término | Definición |
|---------|------------|
| **Licencia propietaria** | Software propiedad del autor/vendor, con restricciones de uso, modificación y redistribución. Código fuente típicamente no disponible. |
| **TCO** | Costo total de adquirir, implementar, operar y mantener un sistema a lo largo de su lifecycle. Incluye costos directos e indirectos. |
| **Soporte comercial** | Soporte técnico por empresa dedicada a cambio de pago, con SLAs que garantizan tiempos de respuesta. |
| **Production readiness** | Atributo que indica que un sistema está listo para uso en producción empresarial. |
| **Lock-in** | Situación donde los costos de cambiar a otra tecnología son tan altos que el cliente queda "atrapado". |
| **Costos de transacción** | Costos asociados con transacciones económicas: búsqueda, negociación y cambio de proveedor. |
| **Single System Image (SSI)** | Arquitectura donde un cluster aparece como una única máquina, con un único namespace de procesos, memoria y recursos. |
| **Migración preemptive** | Capacidad de detener un proceso en ejecución, transferir su estado a otro nodo, y continuar sin que la aplicación lo perciba. |
| **GPL** | Licencia open source que requiere que cualquier obra derivada también sea libre. |
| **Apache 2.0** | Licencia open source permisiva que permite uso comercial sin requerir que derivadas usen la misma licencia. |
| **CNCF** | Fundación bajo Linux Foundation que gobierna proyectos cloud-native (Kubernetes, Prometheus, Envoy). |
| **SchedMD** | Empresa comercial que ofrece soporte y desarrollo para SLURM. |
| **Top500** | Lista de las 500 supercomputadoras más poderosas del mundo. SLURM domina con >60% de participación. |

---

## 8. Conclusión

MOSIX representa un **experimento técnico exitoso pero un fracaso comercial**. Su modelo de licenciamiento propietaria y costos históricamente altos crearon barreras de entrada que limitaron su adopción.

La slide 26 sirve como **contraste explícito con Zephyr**:

| | MOSIX | Zephyr |
|--|-------|--------|
| Licencia | Propietaria restrictiva | Apache 2.0 (open source) |
| Gobernanza | Hebrew University (vendor único) | Linux Foundation (neutral) |
| Costos de transacción | Altos (barreras de entrada) | Bajos (libre uso) |
| Supervivencia | Inactivo desde 2017 | Activo y creciente |

**El mensaje central**: el modelo de gobernanza y licenciamiento impacta directamente la viabilidad a largo plazo de un sistema operativo. El movimiento desde software propietario hacia open source no es solo técnico, sino también económico y social.

---

## Fuentes

- [MOSIX Distributions - Licensing](https://mosix.cs.huji.ac.il/txt_distributions.html)
- [USENIX Documentation 2000 - Historical pricing (obsoleto)](https://www.usenix.org/02/archive/highights/html/mosix.html)
- [MOSIX Official Site](http://www.mosix.org/)
- [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)
- [Slurm Workload Manager](https://slurm.schedmd.com/)
- [Kubernetes Official Documentation](https://kubernetes.io/)
- Temario FSO — §1.1 (modelos de licenciamiento, SO como producto comercial)
