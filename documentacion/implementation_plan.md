# 🎮 Plan: Gamificación Estilo Duolingo

## Alcance

| Feature | Estado |
|---------|--------|
| Tienda: Avatares | ✅ |
| Tienda: Congelar Racha | ✅ |
| Widget Home Screen | ✅ |
| Notificaciones | ✅ |

---

## 1. 🛍️ Tienda de Monedas

### Avatares (Inspirados en el Contenido)

| Avatar | Precio | Inspiración |
|--------|--------|-------------|
| Vizcacha Detective 🔍 | 100 🪙 | Veracidadville (fake news) |
| Vizcacha Pacifista ☮️ | 100 🪙 | Zona Cero Odio |
| Vizcacha Guardián 🛡️ | 120 🪙 | Fortaleza Privacidad |
| Vizcacha Ciberexperta 💻 | 120 🪙 | Ciberseguridad |
| Vizcacha Huella Digital 👣 | 150 🪙 | Huella Digital |
| **Vizcacha Arcoíris 🌈** | **1000 🪙** | **Premium exclusivo** |

### Power-up

| Item | Precio | Efecto |
|------|--------|--------|
| Congelar Racha ❄️ | 50 🪙 | Protege racha 1 día |

---

## 2. 📱 Widget Home Screen

Widget nativo para pantalla inicio (Duolingo-style).

```yaml
home_widget: ^0.4.1
```

---

## 3. 🔔 Notificaciones

| Tipo | Mensaje |
|------|---------|
| Recordatorio diario | "¡La pregunta del día te espera! 📚" |
| Racha en riesgo | "¡Tu racha de X días está en peligro! 🔥" |

```yaml
flutter_local_notifications: ^17.0.0
```

---

## 📅 Fases

1. **Tienda de Monedas** - Avatares + Congelar Racha
2. **Notificaciones** - Recordatorios
3. **Widget Home Screen** - Código nativo

---

## 🔍 Verificación

- Comprar avatar → monedas descontadas → avatar en perfil
- Comprar congelar → perder día → racha se mantiene
- Notificación → llega a la hora configurada
- Widget → muestra racha actual
