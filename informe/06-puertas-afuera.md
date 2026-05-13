## 9. Puertas Afuera

### 9.1 Difusión y Presencia en el Mundo

| Aspecto | Zephyr OS | MOSIX |
|---------|----------|-------|
| **Adopción global** | 3,000+ contribuidores en 70+ países | Décadas de desarrollo académico, comunidad prácticamente inactiva desde 2017 |
| **Soporte de plataformas** | 1,000+ boards soportadas (ARM Cortex-M/RISC-V/x86/MIPS/ARC/SPARC) | Desplegado históricamente en clusters universitarios (Columbia, TU Dresden, Hebrew U) |
| **Backing corporativo** | Intel, Nordic, Renesas, NXP, Wind River (membresía Platinum/Gold en Linux Foundation) | Ninguno — proyecto de investigación de la Hebrew University of Jerusalem |
| **Eventos y conferencias** | Open Source Summit, Embedded World, Zephyr Tech Day, Zephyr Developer Summit (anual) | Papers publicados en conferencias académicas (1998-2010), valor histórico |
| **Presencia en productos comerciales** | Vestas Wind Turbines, Google Chromebook, Oticon More, Framework Laptop 13 DIY, HealthyPi Move, GARDENA | Cero casos de uso moderno en producción |
| **Tendencia** | 69% de organizaciones planea aumentar el uso | Proyecto inactivo desde octubre 2017 |

---

### 9.2 Posibilidad de Soporte a Usuarios

| Aspecto | Zephyr OS | MOSIX |
|---------|----------|-------|
| **Documentación oficial** | Completa y actualizada en docs.zephyrproject.org: Getting Started, API Reference, Kernel Guide, Security, Samples | Limitada y desactualizada: FAQ básico, Administrator's Guide (PDF), White Paper — sin actualización desde 2017 |
| **Canal comunitario** | Discord (miles de miembros, canales por arquitectura y subsystem), GitHub Discussions, mailing lists (Developer/User/Annonce) | Prácticamente inactiva: <20 preguntas en Stack Overflow sin respuesta, GitHub no-oficial archivado (2 estrellas) |
| **Soporte comercial** | Available via empresas miembro (Nordic, Intel, NXP, Renesas) y Wind River Rocket (soporte dedicado con SLA) | No disponible — sin empresa dedicada, sin partners, sin integradores certificados |
| **Actualizaciones de seguridad** | Security Subcommittee dedicado, parches backporteados a versiones LTS (soporte 10-20 años) | Zero — sin parches de seguridad desde hace más de 8 años |
| **Training oficial** | Training Partners autorizados (ModularMX, Golioth, Hacod) con currículo oficial | No disponible |

---

### 9.3 Casos de Uso Recomendados

| Dominio | Zephyr OS | MOSIX |
|---------|----------|-------|
| **IoT y sensotización industrial** | ✅ Ideal: +1,000 boards, conectividad multi-protocolo (BLE/Wi-Fi/Thread/802.15.4/LoRa/Cellular), LittleFS, NVS | ❌ No applicable — proyecto inactivo sin soporte para tecnologías actuales |
| **Wearables y dispositivos médicos** | ✅ Oticon More (audífonos BLE), HealthyPi Move (ECG wearable), footprint mínimo (~4 KB) | ❌ No applicable |
| **Microcontroladores de 32-bit** | ✅ Soporte nativo: ARM Cortex-M/RISC-V/x86, arquitectura microkernel configurable | ❌ No applicable |
| **Aplicaciones de tiempo real embebidas** | ✅ Scheduler preemptive con prioridades configurables, tickless kernel, deep sleep modes | ❌ No applicable |
| **Clusters HPC académico** | ❌ No es el target primario — existen alternativas como SLURM | ⚠️ Uso histórico (1999-2010): genómica, dinámica molecular, CFD, predicción meteorológica, crash testing automotriz |
| **Grids de computadoras universitarias** | ❌ No es el target | ⚠️ Uso histórico: múltiples universidades compartían recursos bajo políticas conjuntas |
| **Migración transparente de procesos** | ❌ No ofrecida | ⚠️ Concepto válido históricamente, pero obsolete en 2026 |

---

### 9.4 Costos y Licenciamiento

| Aspecto | Zephyr OS | MOSIX |
|---------|----------|-------|
| **Licencia** | Apache License 2.0 (permisiva) — libre uso comercial y privado, sin copyleft, sin regalías | Propietaria restrictiva — prohibida modificación, redistribución e ingeniería reversa |
| **Código fuente** | Completo en GitHub, sin feature gates | No disponible públicamente |
| **Costo de entrada** | **$0** — SDK gratuito, toolchain open source, boards desde $20 | Histórico: ~$61,000 USD (año 2000, obsoleto); actualmente sin información comercial pública |
| **Costo por unidad** | **$0** — sin regalías independientemente del volumen de producción | Desconocido (producto inactivo) |
| **Soporte comercial** | Opt-in: empresas miembro ofrecen soporte pago con SLA, Wind River Rocket | No disponible — proyecto sin empresa dedicada |
| **TCO (Costo Total de Propiedad)** | Muy bajo: $0 en licencia, SDK gratuito, comunidad activa, gobernanza neutral (bajo riesgo de lock-in) | Prohibitivo históricamente y sin valor actual: sin soporte, sin seguridad, sin evolución |
| **Gobernanza** | Linux Foundation (organización sin fines de lucro, neutral, multi-stakeholder) | Hebrew University of Jerusalem (vendor único, sin estructura comercial) |
| **Conclusión de viabilidad** | ✅ Viable a largo plazo: proyecto activo con múltiples sponsors y gobernanza neutral | ❌ No viable para producción en 2026: inactivo desde 2017, sin parches de seguridad, modelo propietario restrictivo |