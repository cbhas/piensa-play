# Firebase Seed Script

Este script pobla Firestore con todos los datos del juego PiensaPlay.

## Pre-requisitos

1. Node.js instalado (v18 o superior)
2. Acceso a Firebase Console del proyecto

## Configuración

### 1. Obtener Service Account Key

1. Ve a [Firebase Console](https://console.firebase.google.com)
2. Selecciona tu proyecto
3. Click en ⚙️ → **Project Settings**
4. Ve a la pestaña **Service Accounts**
5. Click en **Generate new private key**
6. Guarda el archivo como `serviceAccountKey.json` en esta carpeta (`scripts/`)

> ⚠️ **IMPORTANTE**: Nunca subas `serviceAccountKey.json` a git. Ya está en `.gitignore`.

### 2. Instalar dependencias

```bash
cd scripts
npm install
```

## Uso

### Modo Dry Run (prueba sin cambios)

Primero ejecuta en modo "dry run" para verificar qué se va a crear:

```bash
npm run seed:dry
```

### Ejecutar Seed

Una vez verificado, ejecuta el seed real:

```bash
npm run seed
```

## Colecciones que se crean

| Colección | Documentos | Descripción |
|-----------|------------|-------------|
| `badges` | 5 | Catálogo global de badges |
| `mission_categories` | 4 | Categorías de misiones |
| `missions` | 7 | Misiones individuales |
| `questions` | 22 | Preguntas de quiz |

## Estructura de datos

### badges
```json
{
  "title": "Investigador Junior",
  "description": "Completa tu primera misión...",
  "iconName": "search",
  "order": 1
}
```

### mission_categories
```json
{
  "title": "Veracidadville",
  "description": "Detecta la desinformación...",
  "iconName": "shield",
  "colorHex": "0xFF6EC6FF",
  "order": 1
}
```

### missions
```json
{
  "categoryId": "veracidadville",
  "title": "Cazadores de Fake News",
  "subtitle": "Veracidadville",
  "description": "Aprende a identificar noticias engañosas",
  "iconName": "check",
  "order": 1
}
```

### questions
```json
{
  "missionId": "fake_news",
  "type": "quiz",
  "newsTitle": "Científicos descubren...",
  "newsContent": "...",
  "elements": [...],
  "explanation": "...",
  "order": 1
}
```

## Notas

- El script usa los mismos IDs que están hardcodeados en Flutter para mantener compatibilidad
- La colección `glossary` NO se toca porque ya está poblada
- La colección `users` NO se toca
