# Slide 22 — Explicación Detallada: Soporte a Usuarios MOSIX

## Contexto de la Slide

La slide 22 aborda uno de los aspectos más críticos cuando se evalúa un sistema operativo para uso en producción: el ecosistema de soporte disponible. Mientras que las slides anteriores de esta presentación se enfocaron en aspectos técnicos de MOSIX (arquitectura, migración de procesos, algoritmos de balanceo), esta slide expone la realidad del soporte post-desarrollo y por qué la falta del mismo hace que MOSIX no sea viable para entornos de producción modernos.

Esta explicación es extensa porque el soporte a usuarios es un tema multidimensional que involucra documentación, comunidad, soporte comercial, actualizaciones de seguridad, ciclo de vida del software, y decisiones de selección de sistemas operativos basadas en criterios operativos más allá de las capacidades técnicas puras.

---

## 1. Estado del Proyecto: Inactividad desde 2017

### 1.1 La Advertencia Principal

La slide presenta un banner de advertencia en color rojo que establece claramente:

> "PROYECTO INACTIVO DESDE OCTUBRE 2017 — Sin actualizaciones, parches de seguridad ni soporte activo"

Esta no es una exageración ni un juicio negativo — es un hecho verificable. El último release de MOSIX (versión 4.4.4) fue publicado el 24 de octubre de 2017, y desde entonces no ha habido ninguna actualización oficial, ni parches de corrección de bugs, ni menos aún parches de seguridad.

### 1.2 Significado de "Proyecto de Investigación"

La slide subtitula que MOSIX es un "Proyecto de investigación sin soporte activo ni comunidad desde 2017". Esta distinción es fundamental para entender el contexto:

Un **proyecto de investigación** como MOSIX fue diseñado y mantenido por el equipo del Profesor Amnon Barak en la Hebrew University of Jerusalem con propósitos académicos. El objetivo era investigar y demostrar técnicas de clustering y migración de procesos. Cuando el equipo de investigación decidió discontinuar el proyecto (por razones que pueden incluir financiamiento, cambios en prioridades académicas, o simply que el código alcanzó un estado "completo" para sus fines), el soporte oficial se detuvo.

Esto contrasta radicalmente con un **producto comercial** como Red Hat Enterprise Linux, SUSE Linux Enterprise, o incluso alternativas HPC como SLURM (que tiene una empresa comercial llamada SchedMD detrás). En un producto comercial, existe un incentivo económico para mantener actualizaciones, security patches, y soporte al cliente.

### 1.3 Implicaciones de la Inactividad para un Ingeniero de Sistemas Operativos

Desde la perspectiva de un ingeniero de sistemas operativos que trabaja con temario FSO (§1.1 sobre documentación como recurso, §1.4 sobre ciclo de vida de tecnologías), la inactividad de un proyecto tiene consecuencias prácticas concretas:

**Documentación desactualizada**: El FAQ oficial, el Administrator's Guide en PDF, el White Paper, todos fueron escritos para versiones de Linux que eran actuales en 2017 o antes. Esto significa que las instrucciones de configuración, los parámetros de sysctl, las versiones de kernel soportadas — todo refleja un estado del software que no corresponde a las distribuciones Linux modernas (Ubuntu 22.04+, Debian 12, RHEL 9, etc.).

**Seguridad comprometida**: Sin security patches, cualquier vulnerabilidad descubierta en MOSIX desde 2017 permanece sin corregir. En un entorno de producción donde los estándares de seguridad requieren actualizaciones regulares y gestión de vulnerabilidades, esto constituye un blockers absoluto.

**Compatibilidad con hardware moderno**: Los kernels Linux modernos (5.x, 6.x) tienen cambios significativos en APIs internas, subsystems de memoria, scheduling, y gestión de dispositivos. Sin actualizaciones, MOSIX solo puede funcionar (en el mejor de los casos) con kernels hasta la serie 4.X, lo que limita la elección de distribuciones y versiones de kernel a sistemas que ya no reciben soporte extendido.

---

## 2. Documentación Disponible: Limitada y Desactualizada

### 2.1 Inventario de Documentos Oficiales

La slide enumera cuatro documentos que constituyen la documentación oficial de MOSIX:

1. **FAQ oficial** (mosix.cs.huji.ac.il): Preguntas frecuentes que cubren instalación, configuración y uso básico
2. **Administrator's Guide (PDF)**: Guía completa para administradores de clusters MOSIX
3. **White Paper**: Documento que describe la arquitectura general del sistema
4. **Changelog**: Historial de cambios por versión, actualizado hasta octubre 2017

Esta documentación existe y es accesible públicamente. Sin embargo, el banner naranja en la slide indica claramente "LIMITADA Y DESACTUALIZADA", y esta calificación es correcta por las siguientes razones.

### 2.2 Limitaciones de la Documentación MOSIX

**No cubre casos de uso modernos**: La documentación no menciona integración con contenedores (Docker), orquestación (Kubernetes), GPUs para cómputo, o cualquier tecnología que haya emergido o se haya popularizado después de 2015-2017. Un administrador que quiera desplegar MOSIX en un cluster que usa Docker para virtualización de contenedores no encontrará guía alguna.

**No hay guías para kernels Linux modernos**: El último release de MOSIX soporta hasta Linux 4.X según documentación histórica. Las distribuciones Linux actuales vienen con kernels 5.15, 6.1, 6.8, etc. No existe documentación sobre cómo adaptar MOSIX a estos kernels, ni garantías de que funcione.

**No existe documentación API formal para desarrolladores**: Si un equipo quiere extender MOSIX, modificar comportamientos, o integrar con otras herramientas, no hay referencia API. En proyectos de investigación esto es común, pero limita severely las posibilidades de adopción.

**Los ejemplos pueden no funcionar en distribuciones actuales**: Los ejemplos de configuración, sysctl parameters, y procedimientos de instalación fueron escritos para versiones de herramientas y distribuciones que ya no existen o han cambiado significativamente.

### 2.3 Diferenciación entre Documentación Académica y Comercial

Esta sección es crucial para entender por qué la documentación de MOSIX, aunque existente, no cumple los requisitos de soporte para producción.

**Documentación académica** se caracteriza por:
- Describir conceptos, arquitectura, y diseño (el "qué" y "por qué")
- Estar orientada a la comprensión y el estudio
- No requerir actualizaciones frecuentes porque los conceptos subyacentes son estables
- Tener un público objetivo de estudiantes, investigadores, y académicos
- Estar disponible sin costo y libremente redistribuible
- No incluir procedimientos operativos críticos, runbooks de incidentes, o guías de troubleshooting producción

**Documentación comercial/profesional** se caracteriza por:
- Procedimientos paso a paso para instalación, configuración, y operación
- Guías de troubleshooting y resolución de problemas conocidos
- Actualizaciones frecuentes con cada release del software
- Alertas de seguridad y procedimientos de parcheo
- Acuerdos de nivel de servicio (SLAs) y tiempos de respuesta garantizados
- Training materials y certificaciones oficiales
- Support knowledge bases con artículos mantenidos activamente

MOSIX tiene documentación del tipo académico (White Paper, Administrator's Guide con teoría de arquitectura). No tiene documentación del tipo comercial (ningún artículo de KB sobre errores comunes, ningún troubleshooting guide, ninguna guía de upgrade).

### 2.4 Relación con el Temario FSO: §1.1 (Documentación como Recurso)

El temario FSO en §1.1 establece que un sistema operativo tiene como objetivo ser una "máquina extendida" que oculta la complejidad del hardware, y como "gestor de recursos" que administra CPU, memoria, y dispositivos eficientemente. La documentación es parte integral de este recurso — sin documentación actualizada y accesible, el SO se convierte en una "caja negra" que nadie sabe cómo operar.

MOSIX ilustra el caso extremo: tener excelente documentación técnica de 2017 pero sin mantenimiento desde entonces. Para un ingeniero que evalúa sistemas, la pregunta no es solo "¿existe documentación?" sino también "¿esta documentación refleja el estado actual del software y del ecosistema tecnológico?".

---

## 3. Contacto Académico: mosix@cs.huji.ac.il

### 3.1 Información de Contacto

La slide muestra el contacto mosix@cs.huji.ac.il asociado a la Hebrew University of Jerusalem. Este es el único canal de soporte directo disponible para usuarios de MOSIX.

### 3.2 Qué Significa "Contacto Académico"

Un contacto académico no es un canal de soporte técnico. Las implicaciones prácticas son:

**No hay garantía de respuesta**: A diferencia de un ticket de soporte comercial donde hay SLAs (tiempos de respuesta garantizados por contrato), un email a una dirección académica puede ser ignorado, respondido después de semanas, o respondido por un estudiante de posgrado que no tiene toda la información.

**No hay persona dedicada a soporte**: En una universidad, el equipo de MOSIX (principalmente el Prof. Barak y colaboradores) tiene responsabilidades de investigación, enseñanza, y administración. El soporte a usuarios externos no es su prioridad contractual.

**Proyecto de investigación, no un producto**: El mensaje en la slide "Proyecto de investigación — no un producto con soporte" explicita esta distinción. Los usuarios que contactan a mosix@cs.huji.ac.il están solicitando ayuda a investigadores, no a un equipo de soporte profesional.

### 3.3 Especificidad de Respuestas

Incluso si se recibe respuesta, la calidad y aplicabilidad puede ser limitada:

- **Problemas de instalación en distribuciones modernas**: Probablemente sin ayuda, porque no hay desarrollo activo que permita reproducir en esos entornos
- **Problemas de compatibilidad con kernels actuales**: Sin respuesta posible, porque no hay desarrollo que soporte esos kernels
- **Reportes de bugs**: Inútiles — no hay desarrollo activo para corregir errores
- **Consultas sobre licenciamiento comercial**: Posiblemente respondida si hay alguien disponible, pero sin garantía

### 3.4 Análisis: ¿Es Útil el Contacto Académico?

Para fines prácticos, el contacto académico tiene utilidad limitada en 2026:

- Si se busca resolver un problema técnico en un cluster MOSIX activo, es improbable recibir ayuda útil
- Si se busca información sobre licenciamiento o uso comercial, puede haber alguien que responda
- Si se busca documentación adicional o papers académicos, el canal sigue funcionando para ese fin

La slide hace bien en presentar el contacto como una posibilidad sin garantía, para que los usuarios no asuman que pueden obtener soporte tipo "vendor" contacting esa dirección.

---

## 4. Lo Que No Existe: Tres Áreas Críticas

La slide dedica una sección completa (con fondo rojo en el header) a enumerar lo que NO existe para MOSIX. Esto es deliberado — busca dejar absolutamente claro que ciertas expectativas de soporte moderno no pueden cumplirse con este proyecto.

### 4.1 Soporte Comercial

La primera columna de "LO QUE NO EXISTE" establece:

- ❌ No existe empresa
- ❌ No hay partners
- ❌ No hay mantenimiento

**Explicación detallada**:

**No existe empresa**: A diferencia de sistemas como SLURM (con SchedMD como empresa comercial), Kubernetes (con múltiples vendors: Red Hat, Google, Microsoft, etc.), o incluso productos propietaries como PBS Professional (Altair), MOSIX no tiene una empresa detrás. El desarrollo fue realizado por académicos en una universidad, no por una compañía que pudiera generar revenue para pagar un equipo de soporte.

**No hay partners**: En el ecosistema de soluciones empresariales, "partners" son empresas que revenden, implementan, o dan soporte certificado sobre un producto. Mosix no tiene este ecosistema. No hay integradores de sistemas capacitados, no hay consultores certificados, no hay empresas que ofrezcan servicios profesionales alrededor de MOSIX.

**No hay mantenimiento**: En el contexto de software, "mantenimiento" incluye:
- Bug fixes (corrección de errores reportados)
- Security patches (parches para vulnerabilidades)
- Compatibilidad con nuevas versiones de dependencias
- Actualizaciones de documentación

Ninguno de estos tipos de mantenimiento existe para MOSIX desde 2017.

### 4.2 Comunidad Activa

La segunda columna establece:

- ❌ Sin foros activos
- ❌ GitHub no-oficial (archivado)
- ❌ Sin canales modernos

**Explicación detallada**:

**Sin foros activos**: La investigación en soporte-usuarios-mosix.md documenta que no existen foros dedicados a MOSIX con actividad reciente. Stack Overflow tiene menos de 20 preguntas, la mayoría sin respuesta. Spiceworks tiene un hilo de 2026 sobre configuración, sin respuestas oficiales. Reddit tiene menciones ocasionales en hilos de HPC histórico, casi nada.

**GitHub no-oficial (archivado)**: No existe un repositorio oficial de MOSIX en GitHub. El repositorio no-oficial kurhula/mosix tiene apenas 2 estrellas, 2 forks, y 3 commits — está completamente inactivo. El fork histórico openMosix (que fue una alternativa open source) está archivado desde 2008.

**Sin canales modernos**: No hay canales en Slack, Discord, Matrix, o cualquier plataforma de comunicación moderna donde usuarios de MOSIX puedan colaborar, preguntar, o compartir soluciones. En 2026, la mayoría de proyectos de software tienen presencia en múltiples canales — la ausencia total de estos para MOSIX indica comunidad inexistente.

### 4.3 Actualizaciones

La tercera columna establece:

- ❌ Sin security patches
- ❌ Sin soporte kernels modernos
- ❌ Sin bug fixes

**Explicación detallada**:

**Sin security patches**: Cualquier vulnerabilidad descubierta en el código de MOSIX desde octubre de 2017 permanece sin parche. Esto es crítico para uso en producción donde las políticas de seguridad requieren actualización de todos los componentes. En un entorno donde CVE-2021-xxxx podría afectar algún subsystem de MOSIX, no hay manera de mitigar el riesgo.

**Sin soporte kernels modernos**: La última versión de MOSIX fue diseñada para Linux 4.X. Los kernels modernos (5.x, 6.x) tienen cambios significativos en subsystems como memory management, scheduling, cgroups, namespaces, y device drivers. No existe desarrollo activo para portar MOSIX a estos kernels.

**Sin bug fixes**: Cualquier bug conocido o desconocido en MOSIX 4.4.4 permanece en el código. No habrá corrección de problemas descubiertos post-2017.

### 4.4 Implicaciones para Producción

Para un ingeniero que lee esta slide en el contexto de una evaluación de sistemas operativos para un entorno de producción HPC, las implicaciones son claras:

- SiMOSIX falla en producción, no hay a quién llamar
- Si surge un security vulnerability, no hay parche disponible
- Si hay incompatibilidad con herramientas modernas (Docker, Kubernetes), no hay soporte
- Si se necesita integrar con sistemas de monitoreo, logging, o gestión, no hay comunidad que haya resuelto estos problemas

SLURM, Kubernetes, y otras alternativas activas tienen equipos dedicados, comunidad activa, y actualizaciones constantes. MOSIX no tiene nada de eso.

---

## 5. Valor Histórico: Contexto Académico

La slide incluye un box verde que dice:

> "💡 Valor histórico: 488+ citas académicas (paper de Columbia 1998). Útil como caso de estudio en migración de procesos."

Esta sección es importante para balancear la presentación — no es solo una lista de deficiencias, sino que también reconoce el valor legítimo de MOSIX como proyecto de investigación histórico.

### 5.1 Significado del Paper de Columbia (1998)

El paper "Scalable Cluster Computing with MOSIX for LINUX" publicado por investigadores de Columbia University ha recibido más de 488 citas académicas. Esto indica que MOSIX tuvo impacto significativo en la comunidad científica — fue un trabajo pionero en:

- Migración de procesos transparente en clusters
- Single System Image (SSI) para clusters de PCs
- Balanceo de carga adaptativo en entornos distribuidos

### 5.2 MOSIX como Caso de Estudio

Para estudiantes e investigadores de sistemas operativos distribuidos, MOSIX sigue siendo útil como:

- **Referencia histórica**: Muestra cómo se abordaba el problema de cluster computing antes de que Kubernetes y SLURM se estandarizaran
- **Caso de estudio de migración de procesos**: Los algoritmos de migration de MOSIX son referencia clásica en la literatura
- **Comparación con tecnologías actuales**: Entender qué resolvió MOSIX y qué resuelven tecnologías modernas (SLURM, Kubernetes) ayuda a comprender la evolución del HPC
- **Análisis de ciclo de vida tecnológico**: Cómo un proyecto puede perder relevancia no por fallas técnicas sino por falta de mantenimiento y evolución del ecosistema

### 5.3 Limitaciones del Valor Histórico

Es importante no sobrestimar el valor práctico actual. Ser un "caso de estudio válido" no significa que sea una opción tecnológica viable para proyectos actuales. La slide distingue claramente entre el valor académico (que existe) y la recomendación de uso en producción (que es negativa).

---

## 6. Nota Académica: Conexión con Temario FSO

La slide cierra con una nota académica que referencia dos secciones del temario FSO:

> "Nota académica: §1.1 (documentación como recurso — sin mantenimiento un SO se vuelve inútil), §1.4 (licencia y ciclo de vida)"

### 6.1 §1.1 — La Documentación como Recurso

El temario FSO establece que un sistema operativo actúa como:
- **Máquina extendida**: Oculta complejidad del hardware
- **Gestor de recursos**: Administra CPU, memoria, dispositivos eficientemente

La documentación es parte integral del "recurso" que constituye el sistema operativo. Sin documentación actualizada y mantenida, el SO se convierte en inoperable. MOSIX ejemplifica esto: existe documentación técnica, pero data de 2017 y no refleja el estado actual del ecosistema Linux.

Un ingeniero que avalia sistemas debe considerar no solo las capacidades técnicas actuales, sino también la sostenibilidad del soporte y mantenimiento.

### 6.2 §1.4 — El Rol de la Licencia en la Adopción

El temario no incluye explícitamente una sección 1.4 sobre licencias en la versión leída, pero el concepto de licencia es relevante aquí. MOSIX usa una licencia propietaria restrictiva que indica: "You are not allowed to modify or reverse-engineer THE PRODUCT" y "sin garantía de ningún tipo".

Esta licencia:
- Impide que la comunidad cree forks activos (a diferencia de proyectos open source que pueden ser bifurcados)
- Limita la capacidad de otros de mantener el proyecto
- No proporciona las garantías legales y comerciales que existen en software open source con licencias permisivas

La lección: la licencia de un SO influencia directamente su capacidad de generar comunidad y mantenimiento a largo plazo. El modelo de licenciamiento de MOSIX contribuyó a su aislamiento post-2017.

### 6.3 Conexión con Planificación y Scheduling

Aunque la slide no lo menciona explícitamente, la falta de soporte y mantenimiento en MOSIX se relaciona con conceptos de scheduling y ciclo de vida de tecnologías del temario FSO:

- **§2.1 — Scheduling**: Los algoritmos de scheduling de MOSIX fueron diseñados para una era específica (Beowulf clusters, Linux 2.4-4.X). Sin actualización, esos algoritmos no se benefician de investigación reciente en scheduling, NUMA-aware scheduling, cgroup integration, etc.
- **Concepto de ciclo de vida tecnológico**: Tecnologías de una generación pueden quedar obsoletas no por fallas técnicas sino por evolución del ecosistema. MOSIX peaked durante la era Beowulf (1999-2010). SLURM y Kubernetes lo reemplazaron no necesariamente porque sus algoritmos sean intrínsecamente mejores para todos los casos, sino porque resuelven problemas diferentes con mejor soporte y mantenimiento.

---

## 7. Comparación con Alternativas Activas

### 7.1 Tabla Comparativa de Soporte

La documentación de soporte-usuarios-mosix.md proporciona esta comparación:

| Característica | MOSIX (Inactivo) | SLURM (Activo) | Kubernetes (Activo) |
|----------------|------------------|----------------|---------------------|
| Última actualización | Octubre 2017 | Diaria | Diaria |
| Parches de seguridad | ❌ | ✅ | ✅ |
| Soporte kernels modernos | Limitado | ✅ | ✅ |
| Comunidad activa | ❌ | Miles de contribuidores | Masiva |

### 7.2 SLURM como Alternativa con Soporte Activo

SLURM (Simple Linux Utility for Resource Management) es ahora el estándar de facto para job scheduling en clusters HPC. La empresa SchedMD ofrece:
- Documentación exhaustiva y actualizada
- Respuesta a issues en GitHub
- Canal de comunidad activo
- Soporte comercial disponible
- Certificaciones oficiales

Un cluster que necesita job scheduling y gestión de recursos en 2026 no tiene razón técnica para elegir MOSIX sobre SLURM — SLURM ofrece toda la funcionalidad de scheduling con soporte activo y comunidad extensa.

### 7.3 Por Qué la Comparación Importa

Para un ingeniero evaluando opciones, la comparación no es solo "MOSIX vs alternativas" en términos de features. Es también una evaluación de sostenibilidad, riesgo operativo, y costo total de propiedad.

Un proyecto sin soporte implica:
- Mayor riesgo operacional (cualquier problema es interno)
- Mayor carga de trabajo interno (sin documentación actualizada, hay que resolver todo desde cero)
- Incompatibilidad con evolución del ecosistema (no hay updates para nuevos kernels, nuevas distribuciones, nuevas herramientas)
- Precarización del entorno (vulnerabilidades sin remediación)

---

## 8. Recomendación de la Slide

La slide 22, al presentar toda esta información, deja una recomendación clara:

**Para uso en producción o proyectos modernos**: MOSIX no es recomendado debido a la falta total de soporte activo, actualizaciones de seguridad, y compatibilidad con tecnologías actuales.

**Para fines educativos/académicos**: MOSIX sigue siendo útil como caso de estudio histórico de migración de procesos y sistemas distribuidos, pero debe entenderse como tecnología obsoleta.

Esta recomendación balanceada reconoce el valor histórico de MOSIX mientras deja absolutamente claro que no es una opción viable para proyectos que requieren soporte activo.

---

## 9. Glosario de Términos

### Academic Support (Soporte Académico)
Tipo de soporte proporcionado por instituciones educativas (universidades, centros de investigación) en lugar de empresas comerciales. Se caracteriza por no tener SLAs, tiempos de respuesta garantizados, ni personal dedicado al soporte. Es típico de proyectos de investigación como MOSIX.

### Community Support (Soporte Comunitario)
Soporte proporcionado por usuarios y contribuidores de un proyecto open source. Se basa en foros, canales de chat, GitHub issues, y documentación mantenida por voluntarios. La calidad y disponibilidad varían según el tamaño y actividad de la comunidad. Ejemplo: la comunidad de Kubernetes o Linux kernel.

### Commercial Support (Soporte Comercial)
Soporte proporcionado por una empresa a cambio de pago. Incluye SLAs contractuales, tiempos de respuesta garantizados, personal de soporte dedicado, y frecuentemente actualizaciones de seguridad como parte del contrato. Ejemplo: Red Hat Enterprise Linux, SLURM (via SchedMD).

### Documentation Quality (Calidad de Documentación)
Métrica que evalúa qué tan completa, actualizada, y accesible es la documentación de un sistema. Alta calidad implica documentación actualizada con cada release, procedimientos paso a paso, troubleshooting guides, y ejemplos funcionales. Baja calidad (como la de MOSIX post-2017) implica documentación desactualizada, faltante, o solo teórica.

### Production Readiness (Preparación para Producción)
Conjunto de características que hacen a un sistema software adecuado para uso en entornos de producción empresarial. Incluye: soporte activo, security patches, documentación actualizada, comunidad activa o soporte comercial, compatibilidad con sistemas actuales, y capacidad de escalar y operar sin desarrolladores originales.

### Security Patches (Parches de Seguridad)
Actualizaciones de software específicamente diseñadas para corregir vulnerabilidades de seguridad (CVE). En un proyecto activo, los security patches se publican cuando se descubre una vulnerabilidad y pueden ser críticos para proteger sistemas en producción. MOSIX no tiene security patches desde 2017, lo que significa cualquier vulnerabilidad descubierta permanece sin remediar.

### Single System Image (SSI)
Tecnología que hace que un cluster de computadoras aparezca como una sola máquina lógica. MOSIX fue pionero en esto, permitiendo que procesos migraran transparentemente entre nodos y que usuarios vieran el cluster como un solo sistema. Esta funcionalidad es parte del concepto de "máquina extendida" del temario FSO.

### Project Lifecycle (Ciclo de Vida de Proyecto)
Las fases que atraviesa un proyecto de software desde su inicio hasta su eventual discontinuación o absorción. MOSIX muestra un ciclo de vida típico de proyecto de investigación: desarrollo activo (1977-2017), luego abandono. Esto contrasta con proyectos mantenidos comercialmente que pueden operar indefinidamente mientras hay demanda y financiamiento.

---

## 10. Resumen de Conceptos Clave para FSO

### Por Qué el Soporte Importa en la Evaluación de SOs

Esta slide encapsula un tema importante de FSO que trasciende la específicamente técnica:

1. **Un SO no es solo código; es un ecosistema**: Documentación, soporte, comunidad, actualizaciones — todo esto constituye lo que significa "usar" un sistema operativo en producción.

2. **La sostenibilidad importa tanto como la funcionalidad**: Un sistema puede tener capacidades técnicas excelentes (como MOSIX para migración de procesos en su época) pero volverse inútil por falta de mantenimiento.

3. **La selección de SO incluye factores operativos**: Cuando se elige un SO para un entorno de producción, la evaluación debe incluir:
   - ¿Existe soporte activo (comercial o comunitario)?
   - ¿Se publican security patches?
   - ¿La documentación está actualizada?
   - ¿Hay comunidad o empresa que pueda ayudar con problemas?

4. **El temario FSO proporciona el marco técnico; la evaluación de soporte lo complementa**: Saber cómo funciona un scheduler (tema FSO) es necesario para evaluar SLURM vs MOSIX, pero saber si hay soporte activo (tema de esta slide) determina si esa evaluación técnica tiene relevancia práctica.

---

*Explicación generada para la presentación TP Especial Zephyr MOSIX — Fundamentos de Sistemas Operativos, Mayo 2026*
*Fuentes: slide-22.js (estructura y contenido), soporte-usuarios-mosix.md (investigación de soporte), temario_FSO.md (marco conceptual)*