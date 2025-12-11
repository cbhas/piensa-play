# Misión: Veracidadville 📰

## Descripción
Veracidadville enseña a los niños a detectar noticias falsas analizando elementos como la fuente, el tono, el lenguaje emocional y datos verificables.

## Nodos Implementados

### Nodo 1: Quiz de Elementos Sospechosos
- **Intro**: `quiz_intro_page.dart`
- **Preguntas**: `quiz_question_page.dart`
- **Feedback**: `quiz_feedback_page.dart`
- **Resultados**: `quiz_results_page.dart`

El usuario debe seleccionar qué elementos de la noticia son sospechosos (autor, fuente, imagen, datos).

### Nodo 2: Quiz Verdadero/Falso
- **Intro**: `true_false_intro_page.dart`
- **Preguntas**: `true_false_question_page.dart`
- **Feedback**: `true_false_feedback_page.dart`
- **Resultados**: Reutiliza `quiz_results_page.dart`

El usuario debe decidir si una noticia es verdadera o falsa basándose en pistas.

## Archivos de Datos
- `veracidadville_quiz_data.dart` - 3 preguntas para el nodo 1
- `true_false_quiz_data.dart` - 3 preguntas para el nodo 2

## Entidades
- `quiz_element.dart` - Elemento de una noticia (autor, fuente, etc.)
- `quiz_question.dart` - Pregunta del quiz de elementos
- `true_false_question.dart` - Pregunta del quiz verdadero/falso

## Colores
- Color principal: `AppTheme.primaryDark` (Azul oscuro)
- Acentos: `AppTheme.accentBlue`, `AppTheme.accentGreen`, `AppTheme.accentYellow`, `AppTheme.accentPink`

## Características
- Diseño colorido y animado para niños
- Gradientes y efectos shimmer
- Tarjetas interactivas con animaciones
- Feedback educativo con explicaciones claras
