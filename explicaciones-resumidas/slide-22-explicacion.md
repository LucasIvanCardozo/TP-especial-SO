# Slide 22 — Resumen: Soporte a Usuarios MOSIX

## Estado del Proyecto: Inactivo desde 2017

- **Último release**: MOSIX versión 4.4.4 (24 de octubre de 2017)
- **Naturaleza**: Proyecto de investigación de la Hebrew University of Jerusalem (Prof. Amnon Barak), no un producto comercial
- **Desde 2017**: Sin actualizaciones, parches de seguridad ni soporte activo

### Implicaciones prácticas

- **Seguridad comprometida**: Cualquier vulnerabilidad descubierta desde 2017 permanece sin corregir
- **Documentación desactualizada**: Solo cubre kernels Linux hasta serie 4.X; distribuciones modernas usan kernels 5.x-6.x
- **Compatibilidad limitada**: No soporta kernels modernos ni tecnologías actuales (Docker, Kubernetes, GPUs)

---

## Documentación Disponible

| Documento | Tipo |
|-----------|------|
| FAQ oficial | Básico, desactualizado |
| Administrator's Guide (PDF) | Teórico/arquitectónico |
| White Paper | Diseño y conceptos |
| Changelog | Hasta octubre 2017 |

### Limitaciones

- No cubre casos modernos (contenedores, orquestación, GPUs)
- No hay guías para kernels actuales ni documentación API para desarrolladores
- Es documentación de tipo **académico** (teoría y conceptos), no **comercial** (procedimientos operativos, troubleshooting, SLAs)

---

## Contacto de Soporte

- **Email**: mosix@cs.huji.ac.il (Hebrew University of Jerusalem)
- **Naturaleza**: Soporte académico, NO soporte técnico
- **Sin garantías**: Sin SLAs, sin tiempo de respuesta garantizado, puede ser ignorado

---

## Lo Que NO Existe para MOSIX

### 1. Soporte Comercial
- ❌ No existe empresa detrás
- ❌ No hay partners ni integradores certificados
- ❌ No hay mantenimiento (bug fixes, security patches, actualizaciones)

### 2. Comunidad Activa
- ❌ Sin foros activos (Stack Overflow: <20 preguntas, sin respuesta)
- ❌ GitHub no-oficial archivado (2 estrellas, inactivo)
- ❌ Sin canales modernos (Slack, Discord, etc.)

### 3. Actualizaciones
- ❌ Sin security patches desde 2017
- ❌ Sin soporte para kernels modernos (5.x, 6.x)
- ❌ Sin bug fixes

---

## Valor Histórico

- **Paper de Columbia (1998)**: "Scalable Cluster Computing with MOSIX" — 488+ citas académicas
- **Útil como caso de estudio** en:
  - Migración de procesos transparente
  - Single System Image (SSI)
  - Balanceo de carga adaptativo
  - Evolución del HPC (comparación con SLURM/Kubernetes)

---

## Comparación con Alternativas Activas

| Característica | MOSIX (Inactivo) | SLURM (Activo) | Kubernetes (Activo) |
|----------------|------------------|----------------|---------------------|
| Última actualización | Octubre 2017 | Diaria | Diaria |
| Parches de seguridad | ❌ | ✅ | ✅ |
| Soporte kernels modernos | Limitado | ✅ | ✅ |
| Comunidad | Inexistente | Miles de contribuidores | Masiva |
| Soporte comercial | ❌ | SchedMD | Múltiples vendors |

---

## Recomendación

| Contexto | Recomendación |
|----------|---------------|
| **Producción / Proyectos modernos** | ❌ **NO recomendado** — sin soporte, sin seguridad, sin compatibilidad |
| **Estudio académico / Caso de estudio** | ✅ Válido como referencia histórica en migración de procesos |

---

## Conexión con Temario FSO

- **§1.1 (Documentación como recurso)**: Sin mantenimiento, un SO se vuelve inoperable — la documentación de MOSIX data de 2017
- **§1.4 (Licencia y ciclo de vida)**: La licencia propietaria restrictiva impidió forks activos y contribuyó al aislamiento del proyecto
- **§2.1 (Scheduling)**: Los algoritmos de MOSIX fueron diseñados para la era Beowulf (1999-2010); sin actualización, no se benefician de investigación reciente

---

## Glosario

- **Soporte Académico**: Proveído por universidades, sin SLAs ni personal dedicado
- **Soporte Comunitario**: Foros, canales y documentación mantenida por voluntarios
- **Soporte Comercial**: Con empresa, SLAs contractuales y personal dedicado
- **SSI (Single System Image)**: Tecnología que hace que un cluster parezca una sola máquina
- **Production Readiness**: Incluye soporte activo, security patches, documentación actualizada y comunidad/empresa respaldo

---

*TP Especial Zephyr MOSIX — Fundamentos de Sistemas Operativos, Mayo 2026*