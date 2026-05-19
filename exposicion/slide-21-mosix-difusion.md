# Slide 21: MOSIX — Difusión y Presencia

## 🎤 Qué Decir (Speaking Notes)

"Esta diapositiva muestra la trayectoria histórica de MOSIX y su declive. A diferencia de Zephyr, que tiene 10 años de crecimiento activo, MOSIX es un proyecto que nació en el mundo académico y murió en el mismo. La línea de tiempo muestra casi 40 años de historia, pero el punto crítico es octubre de 2017: el último release. Después de eso, nada."

"Lo importante para entender es que MOSIX tuvo relevancia académica real — fue usado en investigación, en papers, en clusters universitarios de todo el mundo. Pero nunca hizo la transición a producto comercial viable. Cuando en 2001 se volvió propietario, la comunidad se fue a openMosix. Cuando openMosix murió en 2008, se fue a LinuxPMI. Y cuando LinuxPMI también murió, MOSIX quedó huérfano."

"Hoy compite contra SLURM, que está en más del 60% de los supercomputadores Top500, y contra Kubernetes, que es el estándar de facto para orquestación. MOSIX no está en ninguno."

---

## 📌 Puntos Clave

### Trayectoria Histórica

| Período       | Evento                                        | Significado                                 |
| ------------- | --------------------------------------------- | ------------------------------------------- |
| **1977-1979** | MOS Version 0 en PDP-11 (Unix v6)             | Primer experimento de migración de procesos |
| **1981-1983** | MOS Version 1                                 | Primer sistema multicomputadora funcional   |
| **1988-1989** | Nace MOSIX, cluster de 16 nodos NS32532       | Nombre definitivo                           |
| **1998-1999** | MOSIX v7 en Linux 2.2, cluster de 64 nodos    | Transición a Linux                          |
| **2001**      | Se vuelve propietario                         | Comienza el declive comunitario             |
| **2002**      | openMosix (fork GPL) emerge como respuesta    | Migración de la comunidad                   |
| **2007-2008** | openMosix se discontinúa                      | Segundo fork, segundo fracaso               |
| **2014**      | MOSIX-4: funciona como módulo, no como parche | Cambio arquitectural tardío                 |
| **Oct 2017**  | MOSIX-4.4.4 — ÚLTIMO RELEASE                  | Fin oficial del desarrollo                  |

### Por qué murió MOSIX

1. **Modelo propietario (2001)**: Al cerrarse el código, la comunidad se fue a openMosix. Perdía el modelo de desarrollo abierto que hace exitosos a proyectos como Linux o Zephyr.

2. **Obsolescencia tecnológica**: El paradigma de migración de procesos a nivel kernel fue superado por contenedores (Docker), orquestadores (Kubernetes) y schedulers de jobs (SLURM).

3. **Sin soporte comercial sostenible**: A diferencia de Zephyr con sus Platinum members (Nordic, Intel, Renesas), MOSIX nunca tuvo un modelo de sponsors corporativos.

4. **Fragmentación de forks**: openMosix → LinuxPMI → muerte. Cada fork perdió momentum.

### Estado Actual

| Indicador                 | Valor                    |
| ------------------------- | ------------------------ |
| Último release            | MOSIX-4.4.4 (24/10/2017) |
| Desarrollo activo         | ❌ NO                    |
| Soporte comercial         | ❌ NO                    |
| Adopción en producción    | ❌ NULA                  |
| Comunidad activa          | ❌ NO                    |
| Documentación actualizada | ❌ NO                    |

---

## 🔗 Relación con FSO

### §1.2 — Generaciones de Sistemas Operativos

MOSIX nació en la **4ª generación** (microprocesadores, clusters, UNIX). Sobrevivió tres décadas porque el problema que resolvía — migración transparente de procesos — era genuinamente difícil.

Su muerte coincide con la **5ª generación** (contenedores, cloud, Kubernetes). El paradigma cambió: en lugar de migrar procesos a nivel kernel, la industria migró contenedores a nivel usuario. Más simple, más portable, más controlable.

**Lección**: Los SO que no evolucionan con su generación mueren, aunque la tecnología subyacente sea brillante.

### §2.3 — PCB y Estados de Proceso

La migración de procesos de MOSIX es un caso de estudio de cómo el concepto de PCB (§2.3) se extiende a sistemas distribuidos. El PCB no solo viajaba entre estados LOCALES (listo → ejecutando → bloqueado), sino entre NODOS físicos diferentes. Esto requería serializar el estado completo del proceso — registros, memoria, archivos abiertos — y transferirlo por la red.

### §1.4 — Arquitecturas de SO

MOSIX implementa una arquitectura de **extensión de kernel**: no es monolítico ni microkernel puro, sino un overlay sobre Linux. Esta arquitectura tiene pros y contras:

- **Pros**: Aprovecha la estabilidad de Linux, no reinventa la rueda
- **Contras**: Depende del kernel base, cambios en Linux pueden romper compatibilidad

Zephyr tomó el enfoque opuesto: kernel propio minimalista. La diferencia de estrategias explica en parte por qué uno creció y el otro murió.

---

## ⚠️ Cosas a Tener en Cuenta

### Contraste con Zephyr

| Aspecto                | Zephyr                              | MOSIX                              |
| ---------------------- | ----------------------------------- | ---------------------------------- |
| **Trayectoria**        | 2016-presente (10 años crecimiento) | 1977-2017 (40 años, declive final) |
| **Comunidad**          | 3000+ contribuyentes                | Muerta                             |
| **Modelo**             | Open source (Apache 2.0)            | Propietario restrictivo            |
| **Relevancia**         | Comercial + Académica               | Solo histórica                     |
| **Competidores vivos** | FreeRTOS, ThreadX, NuttX            | SLURM, Kubernetes, OpenMPI         |

### Qué PREGUNTAS esperar

- **"¿Se puede usar MOSIX hoy?"** → Solo para investigación histórica. No recomendado para producción.
- **"¿Por qué no sobrevivió?"** → Modelo propietario + obsolescencia del paradigma de migración vs contenedores.
- **"¿Qué pasó con openMosix?"** → Fork GPL que murió en 2008. LinuxPMI continuó el desarrollo hasta ~2014, también discontinuado.

### Momentos para enfatizar

1. **"1977-1979"**: Mostrar que MOSIX tuvo casi 40 años de vida — no fue un proyecto menor
2. **"2001"**: El año del quiebre — cuando se volvió propietario y la comunidad se fue
3. **"Oct 2017"**: El final oficial — más de 8 años de inactividad

---

## ⏱️ Tiempo Estimado

**45-60 segundos**

- Introducción a la línea de tiempo: 15s
- Explicación del declive (2001, forks): 20s
- Estado actual y contraste con Zephyr: 15s
- Transición a próxima slide: 5s

---

## 📝 Texto Sugerido para la Exposición

> "MOSIX tuvo casi 40 años de historia — empezó en 1977 en la Universidad Hebrea de Jerusalem con el Profesor Amnon Barak. Durante décadas fue una de las implementaciones más importantes de migración transparente de procesos. Pero en 2001, cuando se volvió propietario, la comunidad migró a openMosix. openMosix murió en 2008, LinuxPMI murió después. Y en octubre de 2017, MOSIX-4.4.4 fue el último release.
>
> Hoy compite contra SLURM, que está en el 60% de los supercomputadores del Top500, y contra Kubernetes, que es el estándar de la industria. MOSIX no está en ninguno. Es un proyecto históricamente significativo pero técnicamente obsoleto — relevante para entender sistemas distribuidos, pero no para usar en producción."

---

## 🔗 Fuentes para Profundizar

- [MOSIX Official History](http://www.mosix.org/)
- [MOSIX History — Hebrew University](https://mosix.cs.huji.ac.il/txt_history.html)
- [Wikipedia — MOSIX](https://en.wikipedia.org/wiki/MOSIX)
- [openMosix Wikipedia](https://en.wikipedia.org/wiki/OpenMosix)
- [LinuxPMI](https://en.wikipedia.org/wiki/LinuxPMI)
