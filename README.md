# **Planificación del Proyecto PiensaPlay**

**Integrantes:**  
1. Dara Van Gijsel  
2. Carlos Mejía  
3. Sebastián Calderón  
4. Alex Ramírez  

**Fecha de inicio:** 1 de octubre de 2025  
**Duración:** 15 semanas  

---

## 1. Introducción

El presente documento describe la planificación detallada para el desarrollo de la aplicación móvil **PiensaPlay**, un proyecto orientado a promover la alfabetización mediática e informacional en niños de 8 a 12 años mediante actividades lúdicas y educativas.  
La temática principal aborda la **prevención del bullying** y el **uso responsable de los medios digitales**.  
Este plan abarca desde la etapa de planificación hasta las pruebas finales, con una duración total de **quince semanas**. 

---

## 2. Objetivos del Proyecto

**Objetivo General:**  
Desarrollar una aplicación móvil educativa que fomente el pensamiento crítico y la seguridad digital en niños de 8 a 12 años, utilizando actividades interactivas que sensibilicen sobre el bullying y la desinformación.

**Objetivos Específicos:**
- Implementar una estructura modular que permita a los niños aprender mediante juegos y desafíos.  
- Garantizar la funcionalidad offline de la aplicación y la sincronización automática con Firebase.  
- Diseñar una interfaz accesible y amigable para el público infantil.  
- Evaluar el progreso y desempeño de los usuarios mediante métricas almacenadas localmente y en la nube.

---

## 3. Alcance del Proyecto

El proyecto **PiensaPlay** contempla el desarrollo de una versión móvil funcional para Android y iOS, centrada en el aprendizaje interactivo sobre bullying y seguridad digital.  
En su versión inicial, la aplicación funcionará **sin conexión a internet** utilizando una base de datos local.  
Cuando haya conexión, los datos de progreso y resultados de los niños se **sincronizarán automáticamente con Firebase**, permitiendo la actualización de preguntas y la recopilación de estadísticas de uso.

---

## 4. Tecnologías y Herramientas

- **Flutter:** Framework principal para el desarrollo multiplataforma.  
- **Firebase:** Servicio backend para sincronización de datos y almacenamiento en la nube.  
- **SQLite / Hive:** Base de datos local para funcionamiento offline.  
- **GitHub:** Control de versiones y trabajo colaborativo.  
- **Figma:** Prototipado y diseño de interfaces.  
- **Visual Studio Code:** Entorno de desarrollo principal.

---

## 5. Estructura del Equipo y Roles

El equipo de trabajo está conformado por cuatro integrantes, distribuidos de la siguiente manera:

- **Dara Van Gijsel:** Diseñadora UX/UI y documentación.  
- **Carlos Mejía:** Desarrollador Frontend (Flutter).  
- **Sebastián Calderón:** Desarrollador Backend y sincronización Firebase.  
- **Alex Ramírez:** Líder técnico, planificación y control de versiones.

El trabajo colaborativo se realizará mediante **GitHub**, utilizando ramas de desarrollo y revisiones de código semanales.

---

## 6. Planificación del Proyecto 

La ejecución del proyecto durará 15 semanas desde la elaboración de su [**planificación**](https://github.com/cbhas/piensa-play/wiki/Planificaci%C3%B3n) hasta la fase final de pruebas.

![Piensa Play](https://github.com/user-attachments/assets/c62ed0c8-cf3a-4d0e-a40e-7eb20a40dd00)

---

## 7. Estrategia de Sincronización y Almacenamiento Local

El sistema empleará una arquitectura **offline-first**.  
Los datos de progreso, respuestas y preguntas se almacenarán localmente.
Cuando se detecte una conexión activa a internet, el sistema **sincronizará con Firebase**, enviando los resultados generados por los niños y recibiendo actualizaciones de preguntas o contenidos.  

Se implementará control de versiones de datos y **timestamps** para evitar conflictos durante la sincronización.

---

## 8. Control de Versiones y Colaboración

El desarrollo se gestionará mediante **GitHub** siguiendo la metodología **GitHub Flow**.  
Cada integrante trabajará en ramas específicas según su módulo, realizando **commits descriptivos** y **pull requests** revisados por el líder técnico.  

Se establecerán revisiones de código semanales y control de incidencias mediante **GitHub Projects**.

---

## 9. Plan de Pruebas y Evaluación

Las pruebas se desarrollarán en tres niveles:

1. **Pruebas Unitarias:** Validan la funcionalidad individual de cada módulo.  
2. **Pruebas de Integración:** Aseguran la correcta comunicación entre componentes y sincronización con Firebase.  
3. **Pruebas de Usabilidad:** Realizadas con niños y docentes para evaluar accesibilidad, comprensión y experiencia general.

Cada fase de pruebas generará un **informe técnico** con hallazgos, correcciones y mejoras recomendadas.

---

## 10. Conclusiones

La planificación presentada establece una hoja de ruta clara y realista para el desarrollo de la aplicación **PiensaPlay**.  
El enfoque **offline-first** combinado con **sincronización Firebase** garantiza una experiencia fluida y adaptable.  

El trabajo colaborativo y la distribución de roles permitirán cumplir con los plazos establecidos y alcanzar los objetivos pedagógicos del proyecto.

---
