# Administración del Procesador en MOSIX

MOSIX implementa un sistema de administración del procesador basado en **migración preemptiva automática de procesos** y **balanceo de carga dinámico** entre nodos del cluster. Este enfoque permite que el cluster se presente como un único sistema (Single System Image) donde los procesos pueden ejecutarse en el nodo más adecuado sin intervención del usuario.

---

## 1. Migración Preemptiva Automática de Procesos

La migración preemptiva es el mecanismo central de la administración del procesador en MOSIX. A diferencia de sistemas donde los procesos se ejecutan exclusivamente en el nodo donde fueron iniciados, MOSIX permite que los procesos sean **migrados automáticamente** de un nodo a otro durante su ejecución.

### ¿Cómo funciona?

El sistema opera de la siguiente manera:

1. **Monitoreo continuo**: Cada nodo del cluster monitorea su propia carga de CPU, memoria y otros recursos.
2. **Decisión de migración**: Cuando el algoritmo determina que un proceso se beneficiaría de ejecutarse en otro nodo, se inicia la migración.
3. **Transferencia del contexto**: El proceso (incluyendo su estado de CPU, memoria y archivos abiertos) se transfiere al nodo destino.
4. **Continuación transparente**: El proceso continúa ejecutándose en el nodo destino como si nunca se hubiera movido.

La migración es **preemptiva**, lo que significa que el sistema puede mover un proceso incluso si este no ha sido diseñado para ello, sin que el usuario o administrador intervenga.

> Los algoritmos de MOSIX utilizan migración preemptiva de procesos para el balanceo de carga y el "memory ushering", creando un entorno de ejecución multiusuario compartido conveniente. [Scalable cluster computing with MOSIX for LINUX](https://www.researchgate.net/publication/2808168_Scalable_cluster_computing_with_MOSIX_for_LINUX)

### Características clave

- **Transparencia**: Las aplicaciones se ejecutan sin modificaciones ni recompilación.
- **Automaticidad**: La decisión de migración es tomada por el sistema, no por el usuario.
- **Continuidad**: El proceso migrado mantiene su estado y продолжает ejecutándose sin errores.
- **Reversibilidad**: Un proceso puede ser migrado múltiples veces según las condiciones del cluster.

---

## 2. Balanceo de Carga Dinámico entre Nodos

MOSIX emplea algoritmos de **balanceo de carga dinámico** que distribuyen los procesos entre los nodos del cluster de manera óptima. El objetivo es maximizar la utilización de los recursos disponibles y minimizar el tiempo de ejecución de los procesos.

### Criterios de balanceo

El sistema utiliza múltiples criterios para tomar decisiones de migración:

| Criterio | Descripción |
|----------|-------------|
| **Velocidad de CPU** | Los procesos migran a nodos con procesadores más rápidos cuando se detecta un desbalance. |
| **Carga actual** | Se considera la cantidad de procesos ejecutándose actualmente en cada nodo. |
| **Memoria disponible** | Nodos con más memoria libre reciben procesos que requieren mucha memoria. |
| **Número de procesadores** | Los nodos con más cores disponibles reciben mayor carga de trabajo. |

### Algoritmo de decisión

El algoritmo de balanceo de MOSIX sigue estos pasos:

1. **Recolección de información**: Cada nodo comparte estadísticas de carga con sus vecinos o con un nodo administrador.
2. **Evaluación comparativa**: Se comparan las cargas relativas de todos los nodos.
3. **Identificación de desbalance**: Se detectan nodos sobrecargados y nodos con capacidad disponible.
4. **Selección de procesos**: Se eligen los procesos candidatos para migración.
5. **Ejecución de migración**: Los procesos seleccionados son transferidos al nodo destino.

> La eficiencia de los algoritmos de balanceo de carga de MOSIX ha sido demostrada comparando su rendimiento con políticas óptimas para la ejecución de tareas paralelas. [The NOW MOSIX and its Preemptive Process Migration Scheme](https://yuval.yarom.org/pdfs/mosix.pdf)

---

## 3. Descubrimiento Automático de Recursos

MOSIX implementa un sistema de **descubrimiento automático de recursos** que permite al cluster identificar y adaptarse a la configuración de hardware disponible sin configuración manual.

### Funcionamiento

- **Detección de nodos**: Cuando un nuevo nodo se conecta al cluster, es detectado automáticamente.
- **Inventario de recursos**: Se identifican CPU, memoria, velocidad de reloj y otros atributos de cada nodo.
- **Actualización dinámica**: Los cambios en la disponibilidad de recursos se reflejan en tiempo real.
- **Integración con balanceo**: La información de recursos se utiliza para las decisiones de migración.

### Información descubierta

El sistema puede detectar:
- Cantidad y tipo de procesadores
- Velocidad de CPU (MHz/GHz)
- Memoria total y disponible
- Número de cores
- Estado de carga actual

---

## 4. Migración Basada en Múltiples Parámetros

La decisión de migración en MOSIX no se basa en un único factor, sino en una combinación de parámetros que evalúan holísticamente el estado del cluster.

### Parámetros principales

1. **Velocidad de CPU**: Los procesos migran hacia nodos con procesadores más rápidos cuando el nodo actual tiene un CPU lento. Esto es especialmente útil en clusters Heterogéneos que combinan equipos de diferentes características.

2. **Carga actual**: Se evita migrar procesos a nodos que ya están altamente cargados. El algoritmo busca nodos con menor cantidad de procesos en ejecución.

3. **Memoria disponible**: Como parte del sistema de **Memory Ushering**, los procesos migran a nodos con más memoria disponible cuando se detecta presión de memoria en el nodo actual.

### Consideraciones adicionales

- **Sobrecarga de migración**: El algoritmo considera el costo de transferir el contexto del proceso antes de decidir la migración.
- **Localidad de datos**: Se intenta mantener los procesos cerca de los datos que acceden, para minimizar la sobrecarga de comunicación.
- **Tiempo de ejecución estimado**: Procesos cortos pueden no ser migrados si el costo de migración supera el beneficio.

---

## 5. Soporte para Clusters de Cientos de Nodos

MOSIX está diseñado para escalar a **clusters de cientos de nodos**. Desde la versión 9 (2003), el sistema soporta clusters con cientos de estaciones de trabajo, y las versiones posteriores mejoraron esta capacidad.

### Escalabilidad

- **Arquitectura descentralizada**: No existe un punto único de failure; la carga de gestión se distribuye entre los nodos.
- **Comunicación eficiente**: Los protocolos de comunicación entre nodos están optimizados para minimizar la sobrecarga.
- **Algoritmos adaptativos**: Los algoritmos de balanceo escalan sin degradación significativa de rendimiento.

### Evolución histórica

| Versión | Año | Capacidad |
|---------|-----|-----------|
| MOSIX v7 | 1999 | 64 nodos |
| MOSIX v9 | 2003 | Clusters de cientos de nodos |
| MOSIX v10 | 2004-2006 | Gestión de multiclusters y grids |

> MOSIX fue diseñado para gestionar clusters de cientos de estaciones de trabajo, demostrando escalabilidad en entornos académicos e industriales. [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)

---

## 6. Checkpoint/Restart

El mecanismo de **Checkpoint/Restart** es una funcionalidad que permite salvar el estado de un proceso en ejecución y posteriormente recuperarlo, ya sea en el mismo nodo o en uno diferente.

### ¿Qué es un checkpoint?

Un **checkpoint** es una instantánea del estado completo de un proceso en un momento determinado, que incluye:
- Estado de la CPU (registros, contador de programa)
- Memoria del proceso (espacio de direcciones)
- Descriptor de archivos abiertos
- Estado de conexiones de red
- Cualquier otro contexto necesario para continuar la ejecución

### ¿Para qué sirve?

1. **Recuperación ante fallos**: Si un nodo falla, los procesos pueden reiniciarse en otro nodo desde el último checkpoint guardado.
2. **Mantenimiento sin interrupciones**: Permite apagar nodos para mantenimiento sin perder el trabajo en progreso de los procesos.
3. **Balanceo de carga avanzado**: Facilita la migración de procesos largos al permitir transferir el estado completo.
4. **Tolerancia a desconexiones**: Procesos que pierden conexión con su nodo original pueden continuar en otro nodo.

### Limitaciones

- **No todas las aplicaciones lo soportan**: Aplicaciones con estados complejos o dependientes de hardware específico pueden tener limitaciones.
- **Sobrecarga de rendimiento**: Guardar checkpoints introduce overhead en la ejecución.
- **Compatibilidad**: MOSIX puede presentar limitaciones con ciertos tipos de aplicaciones, especialmente aquellas con hilos (threads).

---

## 7. Limitaciones

### Soporte Multinúcleo

> **Información no disponible públicamente** sobre el soporte específico de MOSIX para CPUs multinúcleo dentro de un nodo individual.

Lo que se sabe es que:
- MOSIX soporta clusters donde cada nodo puede tener múltiples cores.
- El FAQ indica que el parámetro `/proc/cpuinfo` puede mostrar menos CPUs de las esperadas debido a cómo MOSIX cuenta los recursos.
- El sistema está optimizado para集群 de múltiples nodos, cada uno con sus propios procesadores.

### Otras limitaciones conocidas

- **No soporta aplicaciones con threads** de la forma tradicional.
- **No soporta memoria compartida** entre procesos.
- **Ciertos mecanismos de IPC** tienen mejor rendimiento que otros.
- **Sobrecarga de red** al migrar procesos con grandes espacios de memoria.

---

## Fuentes

- [MOSIX FAQ](http://www.mosix.cs.huji.ac.il/faq/output/faq_toc.html)
- [Scalable cluster computing with MOSIX for LINUX](https://www.researchgate.net/publication/2808168_Scalable_cluster_computing_with_MOSIX_for_LINUX)
- [The NOW MOSIX and its Preemptive Process Migration Scheme](https://yuval.yarom.org/pdfs/mosix.pdf)
- [Performance of PVM with the MOSIX Preemptive Process Migration](https://dl.acm.org/doi/10.5555/857173.857265)
- [MOSIX Official Site](http://www.mosix.org/)
- [Wikipedia: MOSIX](https://en.wikipedia.org/wiki/MOSIX)

---
## Nota Académica — Fundamentos de SO
**Conceptos de la materia relacionados:**

- **§2.1 — Necesidad del scheduling y multiprogramación**: MOSIX lleva la multiprogramación al nivel del cluster. Donde un SO tradicional reparte CPU entre procesos de un mismo nodo, MOSIX reparte procesos entre nodos, buscando maximizar la utilización global del cluster.

- **§2.2 — Estados de un proceso y migración**: La migración preemptiva de MOSIX implica transferir un proceso que está en estado "running" a otro nodo. Esto requiere salvar todo el contexto (equivalente a un PCB/Process Control Block) y reconstituirlo en el destino. El checkpoint/restart (sección 6) es precisamente la serialización del estado de un proceso para poder continuarlo.

- **§2.3 — PCB y accounting**: MOSIX debe transferir el PCB completo del proceso: registros de CPU, contador de programa, estado de memoria, archivos abiertos, y prioridad. El concepto de accounting de proceso se vuelve complejo porque la ejecución puede continuar en nodos diferentes.

- **§2.4 — Tipos de schedulers**: La migración de procesos en MOSIX es análoga a un scheduler de largo plazo (job admission) que decide en qué nodo размещается cada proceso. Las decisiones de migración también tienen características de scheduler de medio plazo (swapping) cuando mueven procesos entre nodos para balancear memoria (memory ushering).

- **§2.5 — Algoritmos de scheduling**: MOSIX usa balanceo de carga dinámico basado en múltiples parámetros (velocidad de CPU, carga actual, memoria disponible). No es FCFS ni Round Robin clásico — es más parecido a un algoritmo de scheduling por prioridad multidimensional que evalúa constantemente dónde conviene ejecutar cada proceso.

- **§2.6 — Efecto convoy**: MOSIX mitiga el efecto convoy inherente a clusters donde algunos nodos quedan sobrecargados. Al migrar procesos preemptivamente, evita que nodos lentos o cargados se conviertan en cuellos de botella.

- **§2.8 — Dispatcher y cambio de contexto**: La migración de un proceso implica un "context switch" entre nodos que es mucho más costoso que un context switch local (involucra transferir estado de memoria, archivos abiertos, conexiones de red). MOSIX debe considerar el overhead de migración antes de decidir mover un proceso — análogo al trade-off de quantum vs overhead en §2.7.

- **Single System Image (SSI)**: El concepto de que el cluster se presente como un único sistema operativo es una extensión del concepto de abstracción de proceso — el usuario ve muchos procesos pero no ve la complejidad de la distribución.