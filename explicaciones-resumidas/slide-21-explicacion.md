# Resumen: Zephyr OS - Soporte a Usuarios

## Visión General

Zephyr OS (RTOS open source gobernado por la Linux Foundation) ofrece un modelo de soporte **multinivel**:
- Recursos comunitarios gratuitos (documentación, Discord, GitHub, mailing lists)
- Soporte comercial de empresas miembro (Nordic, Intel, NXP, Renesas, Wind River)

Este ecosistema permite que desde makers hasta OEMs de electrónica embebida encuentren ayuda adaptée a sus necesidades.

---

## 1. Documentación Oficial (docs.zephyrproject.org)

Portal de documentación actualizado con cada release. Incluye:

| Sección | Contenido |
|---------|-----------|
| **Getting Started Guide** | Guía paso a paso para nuevos usuarios (instalación toolchain hasta "Hello World") |
| **API Reference** | Referencia completa de APIs: threads, mutexes, semaphores, timers, interrupt handling, Bluetooth, Wi-Fi, storage |
| **Kernel Guide** | Diseño y arquitectura del kernel: scheduling, memory management, power management |
| **Security Documentation** | PSA Certified compliance, secure boot, CVEs y parches |
| **Samples and Tutorials** | Ejemplos de código: demos básicos, BLE, Thread, Wi-Fi, sistemas de archivos |

**Características técnicas**: búsqueda integrada multi-version y selector de versiones para diferentes releases.

---

## 2. Comunidad Activa

### Canales de comunicación

- **Discord** (canal primario en tiempo real): canales temáticos por arquitectura (ARM, RISC-V, x86), subsystem (Bluetooth, networking), y nivel de experiencia. Ingenieros del proyecto participan directamente.
- **GitHub Discussions**: foro asíncrono para preguntas generales, ideas, y proyectos. No es para bugs (eso son Issues).
- **Mailing Lists**: tres tipos
  - Developer Lists → discusiones técnicas y patches
  - Users Lists → soporte general (archivable y searchable)
  - Announce Lists → anuncios oficiales (solo maintainers pueden posting)
- **Wiki de GitHub**: conocimiento generado por la comunidad (proyectos basados en Zephyr, guías, dispositivos comerciales).

### Gobernanza

- **TSC (Technical Steering Committee)**: reuniones públicas documentadas. Roadmap técnico y decisiones arquitectónicas son transparentes.
- **Dato de escala**: 3,000+ contribuidores únicos en el historial del repositorio (2016-2026).

---

## 3. Soporte Comercial (Opcional)

### Modelo dual

| Nivel | Descripción |
|-------|-------------|
| Comunitario gratuito | Documentación, Discord, GitHub, mailing lists |
| Comercial de miembros | Empresas ofrecen soporte en contexto de sus propios productos (chips, hardware) |

### Empresas miembro principales

| Empresa | Rol en Zephyr |
|---------|---------------|
| **Nordic Semiconductor** | Mayor contribuidor de código. Soporte para chips nRF (BLE, Thread, Zigbee, Matter). |
| **Intel** | Miembro fundador. Soporte para plataformas Intel. |
| **NXP** | Soporte extensivo para microcontroladores (LPC, i.MX). |
| **Renesas** | Nivel Platinum (2025). Soporte para sus plataformas. |
| **Wind River** | Miembro fundador. Versión comercial "Rocket" con soporte dedicado. |

### Training Partners (Programa oficial)

Partners autorizados por la Zephyr Foundation que ofrecen capacitación profesional:
- **ModularMX**: currículo oficial desde básico hasta avanzado
- **Golioth**: trainings en vivo mensuales y bajo demanda (participantes solo traen su board)
- **Hacod**: cursos especializados globalmente distribuidos

---

## 4. Desarrollo Activo

### Ciclo de releases

- Nuevas versiones del kernel cada **2-3 meses**
- Cada release incluye: nuevas features, mejoras de performance, soporte nuevo hardware, security patches
- Se publican en GitHub y se anuncian en mailing list

### Bug tracking

- GitHub Issues con labels: subsystem afectado, severidad, target release
- Template estructurado para reporte: board/configuración, pasos para reproducir, output esperado vs actual, versión

### Seguridad

- **Security Subcommittee dedicado**: recibe reportes, coordina CVEs, mantiene process de advisories, revisa código
- **LTS (Long Term Support)**: versiones con soporte de **10-20 años** para productos de largo lifecycle (médicos, automotive, industriales)
  - Reciben backports de security patches
  - No se agregan nuevas features (estabilidad)

---

## 5. Estructura de Membresía Corporativa

| Nivel | Beneficios | Miembros ejemplo |
|-------|------------|------------------|
| **Platinum** | Representación garantizada en TSC, mayor influencia en roadmap | Nordic, Renesas, Wind River |
| **Gold** | Voz en gobernanza | Intel, NXP (miembros fundadores) |
| **Silver** | Acceso a recursos y participación comunitaria | Blecon, Embeint |

### Lo que genera cada membresía

- **Voz en gobernanza**: Platinum/Gold tienen representación en TSC
- **Código y soporte de hardware**: cada empresa contribuye código para sus productos (Nordic → nRF, NXP → LPC/i.MX, Intel → plataformas)
- **Documentación específica**: cada miembro mantiene documentación en sus portales
- **Training partners**: Platinum/Gold pueden convertirse en Training Partners
- **Soporte técnico indirecto**: usuarios pueden buscar ayuda en foros del miembro

---

## Glosario de Términos

| Término | Definición |
|---------|------------|
| **Bug Tracking** | Sistema de registro/seguimiento de bugs via GitHub Issues. Estados: open, in progress, closed. |
| **Commercial Support** | Soporte pago con garantías de tiempo de respuesta. En Zephyr: Wind River Rocket y soporte de miembros corporativos. |
| **Community Support** | Soporte gratuito vía foros, Discord, mailing lists, GitHub. Sin garantías de tiempo de respuesta. |
| **LTS (Long Term Support)** | Versiones con updates de seguridad por 10-20 años. Para productos con ciclos de vida largos. |
| **TSC (Technical Steering Committee)** | Comité que define roadmap técnico y decisiones arquitectónicas. Reuniones públicas. |
| **Training Partner** | Empresa autorizada por Zephyr Foundation para dar capacitación oficial. |
| **Wind River Rocket** | Producto comercial de Wind River basado en Zephyr: soporte dedicado, updates de seguridad, servicios cloud, certificaciones. |
| **Open-core** | Modelo donde la base es open source y se construye una capa comercial encima (Zephyr + Rocket). |

---

## Comparación con Competidores

| RTOS | Sponsor | Integración Cloud | Modelo de Soporte |
|------|---------|-------------------|-------------------|
| **Zephyr** | Linux Foundation | No tiene | Comunitario + Miembros corporativos + Wind River |
| **FreeRTOS** | Amazon (AWS) | AWS IoT integrado | Comunitario + AWS documentation + SafeRTOS |
| **ThreadX** | Microsoft | Azure integrado | Comunitario + Microsoft support |
| **NuttX** | Apache | No tiene | Comunitario |
| **RIOT OS** | Comunidad | No tiene | Comunitario + Académico |

### Diferenciadores de Zephyr

1. **Gobernanza neutral**: no pertenece a Amazon ni Microsoft (evita vendor lock-in)
2. **Training Partner Program oficial**: capacitación estructurada con partners autorizados
3. **Soporte multi-vendor**: diversidad de miembros para múltiples ecosistemas de hardware
4. **Security Subcommittee dedicado**: comité específico para seguridad
5. **LTS con soporte 10-20 años**: para productos de largo lifecycle

---

## Conexiones con FSO

### §1.1 — Gestión de recursos

El "recurso" se extiende más allá del hardware (CPU, memoria, E/S) al **recurso humano**: comunidad de desarrolladores y usuarios. Sin documentación exhaustiva, training partners, y committees técnicos, incluso el mejor kernel fracasa.

### §1.2 — Comunidad como diferenciador (5ª generación 1990-presente)

Éxito de un SO depende tanto de su comunidad como de su código. Zephyr con 3,000+ contribuidores vs MOSIX que murió por falta de comunidad demuestra este patrón.

### §1.4 — Gobernanza y evolución arquitectónica

Estructura Platinum/Gold/Silver refleja cómo las arquitecturas modernas incorporan governance structures. Neutralidad de Linux Foundation evita vendor lock-in (como POSIX para UNIX).

---

*Resumen generado para slide 21 — TP Especial Zephyr-MOSIX — FSO UNMDP*