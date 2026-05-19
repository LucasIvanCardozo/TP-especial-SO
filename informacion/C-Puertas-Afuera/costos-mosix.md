# Costos del Producto — MOSIX

## 1. Modelo de Licencia Propietaria

MOSIX es **software propietario** distribuido bajo una licencia restrictiva propia del Grupo de Investigación en Sistemas Distribuidos de la Hebrew University of Jerusalem.

**Restricciones clave de la licencia:**

- ❌ **Prohibido** modificar el software
- ❌ **Prohibido** realizar ingeniería reversa
- ❌ **Prohibido** crear obras derivadas
- ❌ Sin código fuente disponible
- ❌ Las contribuciones son propiedad intelectual del propietario (Prof. Amnon Barak)

> _"The following license applies to most parts of the MOSIX package... MOSIX SOFTWARE LICENSE AGREEMENT... You are not allowed to modify or reverse-engineer THE PRODUCT."_
> — [MOSIX Distributions](https://mosix.cs.huji.ac.il/txt_distributions.html)

**Nota legal:** La ley aplicable es la del Estado de Israel. El software se distribuye **sin garantía** de ningún tipo.

**Fuente:** [MOSIX Distributions - Licensing](https://mosix.cs.huji.ac.il/txt_distributions.html)

---

## 2. Información Histórica de Precios

> ⚠️ **INFORMACIÓN OBSOLETA — NO VÁLIDA EN 2026**

Según documentación histórica de **USENIX (2000)**, los costos eran:

| Concepto                                 | Monto (USD)                                     |
| ---------------------------------------- | ----------------------------------------------- |
| Licencia inicial (cluster de producción) | ⚠ $61,141.25 correspondía a **LSF**, no a MOSIX |
| Mantenimiento anual (soporte)            | **$16,835.00**                                  |

**Fuente original:** [USENIX Documentation 2000 - Historical pricing](https://www.usenix.org/02/archive/highlights/html/mosix.html)

> ⚠️ **Esta información tiene más de 25 años y no refleja la realidad actual del producto. No se recomienda utilizar estos valores para ninguna estimación moderna.**

---

## 3. Precio Actual

### Estado: NO DISPONIBLE PÚBLICAMENTE

**No se encontró información de pricing actualizada** en el sitio oficial de MOSIX ni en ninguna fuente pública verificada. El sitio oficial (mosix.org) no presenta valores, tarifas ni opciones de licenciamiento comerciales.

**Modelo actual observado:**

- El sitio oficial permite la descarga del software
- No hay lista de precios pública
- No se encontró evidencia de una empresa comercial dedicada al soporte de MOSIX
- Última versión disponible: **MOSIX-4.4.4** (24 de octubre de 2017)

> 📧 **Para información actualizada sobre licenciamiento, se recomienda contactar directamente a los desarrolladores.**

**Fuente:** [MOSIX Official Site](http://www.mosix.org/)

---

## 4. Contacto para Licensing

| Medio             | Detalle                      |
| ----------------- | ---------------------------- |
| **Email**         | mosix@cs.huji.ac.il          |
| **Sitio oficial** | http://www.mosix.org/        |
| **Documentación** | https://mosix.cs.huji.ac.il/ |

> **Nota:** Este es el canal oficial de contacto con el grupo de investigación de la Hebrew University of Jerusalem. No existe un canal comercial formal.

**Fuente:** [MOSIX Official Site](http://www.mosix.org/)

---

## 5. Opciones de Soporte Comercial

### Estado: **NO DISPONIBLE**

| Tipo de soporte             | Disponible                        |
| --------------------------- | --------------------------------- |
| Soporte técnico comercial   | ❌ **No encontrado**              |
| Empresa dedicada al soporte | ❌ **No existe evidencia**        |
| Canal de soporte pago       | ❌ **No hay información**         |
| Contratos de mantenimiento  | ❌ **No hay información pública** |

**Soporte disponible (no comercial):**

- Documentación en línea (FAQs, guías, manuales PDF)
- Publicaciones académicas y white papers
- Twitter oficial: [@MOSIX_cluster](https://twitter.com/MOSIX_cluster)

**Fuente:** [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)

> ⚠️ **Dado que el proyecto no tiene desarrollo activo desde 2017, cualquier soporte disponible es limitado y no hay garantías de respuesta.**

---

## 6. Comparación con Alternativas Gratuitas y Activas

MOSIX se compara favorablemente en concepto con alternativas modernas, pero pierde en todos los aspectos operativos debido a su estado inactivo.

### 6.1 SLURM (Simple Linux Utility for Resource Management)

| Aspecto                   | MOSIX                      | SLURM                     |
| ------------------------- | -------------------------- | ------------------------- |
| **Licencia**              | Propietaria (restrictiva)  | GPL (libre)               |
| **Costo**                 | No disponible públicamente | **Gratis** (open source)  |
| **Estado**                | Inactivo (desde 2017)      | **Muy activo**            |
| **Soporte comercial**     | ❌ No disponible           | ✅ SchedMD                |
| **Migración de procesos** | ✅ Sí (nativa)             | ❌ No (job re-scheduling) |
| **Single System Image**   | ✅ Sí                      | ❌ No                     |
| **Adopción en Top500**    | ❌ 0%                      | ✅ >60%                   |

**Sitio:** [slurm.schedmd.com](https://slurm.schedmd.com/)

### 6.2 Kubernetes

| Aspecto               | MOSIX                 | Kubernetes                                |
| --------------------- | --------------------- | ----------------------------------------- |
| **Licencia**          | Propietaria           | Apache 2.0 (libre)                        |
| **Costo**             | No disponible         | **Gratis**                                |
| **Estado**            | Inactivo (desde 2017) | **Muy activo**                            |
| **Soporte comercial** | ❌ No disponible      | ✅ Multi-vendor (Red Hat, Google, Amazon) |
| **Ecosistema**        | Limitado              | Massive (Helm, Operators, CSI)            |

**Sitio:** [kubernetes.io](https://kubernetes.io/)

### 6.3 OpenMPI

| Aspecto        | MOSIX                 | OpenMPI                   |
| -------------- | --------------------- | ------------------------- |
| **Licencia**   | Propietaria           | BSD (3-clause)            |
| **Costo**      | No disponible         | **Gratis**                |
| **Estado**     | Inactivo (desde 2017) | **Muy activo**            |
| **Tipo**       | Migración de procesos | Message Passing Interface |
| **Uso típico** | HPC histórico         | Complemento a SLURM/PBS   |

**Sitio:** [open-mpi.org](https://www.open-mpi.org/)

### 6.4 Tabla Comparativa Resumida

| Criterio              | MOSIX            | SLURM          | Kubernetes      | OpenMPI        |
| --------------------- | ---------------- | -------------- | --------------- | -------------- |
| **Costo**             | ❓ No disponible | ✅ Gratis      | ✅ Gratis       | ✅ Gratis      |
| **Licencia**          | ⚠️ Propietaria   | ✅ GPL         | ✅ Apache 2.0   | ✅ BSD         |
| **Estado activo**     | ❌ No (2017)     | ✅ Sí          | ✅ Sí           | ✅ Sí          |
| **Soporte comercial** | ❌ No            | ✅ SchedMD     | ✅ Multi-vendor | ❌ No          |
| **Para HPC moderno**  | ❌ Obsoleto      | ✅ Recomendado | ✅ Alternativa  | ✅ Complemento |

---

## 7. Conclusión sobre Costos

| Aspecto                     | Detalle                                                                                |
| --------------------------- | -------------------------------------------------------------------------------------- |
| **Modelo de licencia**      | Propietaria restrictiva — sin derechos de modificación                                 |
| **Costo inicial histórico** | ⚠ $61,141.25 correspondía a **LSF** (año 2000). MOSIX era gratuito para uso académico. |
| **Costo anual histórico**   | $16,835.00 USD (obsoleto, año 2000)                                                    |
| **Precio actual**           | ❌ **No disponible públicamente**                                                      |
| **Contacto**                | mosix@cs.huji.ac.il                                                                    |
| **Soporte comercial**       | ❌ **No disponible**                                                                   |

### Recomendación

> Para cualquier uso en producción moderno, se recomienda evaluar alternativas open source activas como **SLURM** (para HPC clásico) o **Kubernetes** (para orquestación moderna), dado que:
>
> 1. Son gratuitas
> 2. Tienen soporte comercial disponible
> 3. Están activamente desarrolladas
> 4. Tienen comunidades masivas

---

## Fuentes

1. [MOSIX Distributions - Licensing](https://mosix.cs.huji.ac.il/txt_distributions.html)
2. [USENIX Documentation 2000 - Historical pricing (obsoleto)](https://www.usenix.org/02/archive/highlights/html/mosix.html)
3. [MOSIX Official Site](http://www.mosix.org/)
4. [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)
5. [Slurm Workload Manager](https://slurm.schedmd.com/)
6. [Kubernetes Official Documentation](https://kubernetes.io/)
7. [OpenMPI Official Site](https://www.open-mpi.org/)

---

_Documento preparado para Fundamentos de Sistemas Operativos — Sección "Puertas Afuera" — Mayo 2026_

---

## Nota Académica — Fundamentos de SO

**Conceptos de la materia relacionados:**

- **Modelo propietario vs. open source**: MOSIX bajo licencia propietaria restrictiva (sin modificación, sin código fuente) ilustra el modelo de distribución tradicional de SO; su reemplazo por alternativas open source (SLURM, Kubernetes) demuestra cómo el modelo de licenciamiento impacta directamente la supervivencia de un sistema en el mercado.

- **Costos de transacción en adopción de SO**: El histórico precio de $61,141.25 USD (LSF, no MOSIX) para una licencia de cluster representa las "barreras de entrada" que el software propietario imponía; MOSIX en cambio era gratuito para uso académico. Esto conecta con cómo los modelos de distribución determinan la adopción institucional.

- **§1.1 — SO como producto comercial**: El caso MOSIX muestra la tensión histórica entre innovación académica (investigación de migración de procesos) y comercialización (licencia restrictiva), mientras que Zephyr bajo gobernanza neutral (Linux Foundation) representa un modelo donde el SO como recurso compartido reduce costos de transacción para todos los participantes.
