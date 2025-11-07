# Guía súper simple: trabajo con 4 ramas personales + `main` (Flutter)

## 🌿 Estructura básica de ramas (4 personas + main)
Tendrán **5 ramas** en total:

```
main          ← rama principal (versión estable)
│
├── cbhas      ← Sebastián Calderón
├── cdm18      ← Carlos Mejia
├── daravan1   ← Dara Van Gijsel
└── ALISrj     ← Alex Ramirez
```

Cada uno trabaja **solo en su rama** y cuando ya probó que su parte funciona, **fusiona (merge) a `main`** mediante un Pull Request (PR).

---

## 🔧 Configuración inicial
> *Solo una persona (quien creó el repositorio) lo hace una vez.*

**Cada compañero se va a su rama con:**
```bash
git checkout <tu_rama>   # ej. git checkout cbhas
```

---

## 💻 Flujo de trabajo diario
Supongamos que eres **Sebastian** (ejemplo) y trabajas en tu rama `cbhas`:

**1) Trae lo más nuevo de `main` antes de empezar:**
```bash
git checkout main
git pull origin main
git checkout cbhas     # reemplaza por tu rama: cdm18 / daravan1 / ALISrj
git merge main
```
*(Así evitas conflictos más adelante)*

**2) Haz tus cambios** (por ejemplo, pantalla de login).

**3) Guarda y sube tu trabajo:**
```bash
git add .
git commit -m "feat: pantalla de login terminada"
git push origin cbhas
```

**4) Cuando todo esté probado y quieras unir a `main`:**
- Ve a **GitHub → Pull Requests**.
- Crea un nuevo **PR** de `cbhas` → `main` *(o tu rama → `main`)*.
- Alguien del grupo revisa y, si está bien → **Merge**.

---

## 🔁 Después del merge
Todos actualizan su `main` y su **rama personal**:

```bash
git checkout main
git pull origin main

git checkout cbhas       # o tu rama
git merge main
```
Así todos tienen la última versión del proyecto.

---

## ⚠️ Consejos importantes
- **No trabajen en `main`** directamente. Siempre en su **propia rama**.
- Hagan **commits pequeños** y con mensajes claros:
  ```
  feat: agrega pantalla principal
  fix: corrige error al cargar imagen nula
  ```
- Si hay **conflictos**, arréglenlos antes del merge (GitHub avisa cuáles archivos).
- **No suban** la carpeta `build/` ni artefactos generados; solo **código fuente y assets**.

---

## 🏷️ ¿Qué significan `feat`, `fix`, `chore`, etc.? (Conventional Commits básico)
- **feat**: agrega una **funcionalidad** nueva.  
  *Ej.:* `feat: formulario de registro`
- **fix**: corrige un **error/bug**.  
  *Ej.:* `fix: evita crash al no tener sesión`
- **chore**: tareas de **mantenimiento** (limpieza, scripts, actualizar dependencias) que no cambian la lógica de negocio.  
  *Ej.:* `chore: actualiza paquetes y ajusta .gitignore`
- **docs** *(opcional)*: cambios en **documentación**.  
  *Ej.:* `docs: agrega guía de instalación`
- **refactor** *(opcional)*: mejora de **código interno** sin cambiar comportamiento.  
  *Ej.:* `refactor: extrae widget Header a componente`
- **style** *(opcional)*: formateo/estilo (espacios, comas), **sin** lógica.  
  *Ej.:* `style: aplica formato con dart format`
- **test** *(opcional)*: agrega/actualiza **tests**.  
  *Ej.:* `test: añade pruebas para LoginController`

> Con usar `feat`, `fix` y `chore` ya están ✅. Los demás son útiles pero opcionales.
