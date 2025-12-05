# PiensaPlay - Project Context

## 📌 Project Overview

PiensaPlay is a Flutter educational app for children that gamifies cybersecurity learning through missions, achievements, and interactive games.

---

# 🧱 Architecture

The project follows **Clean Architecture** with separation of concerns:

<pre class="overflow-visible!" data-start="410" data-end="1008"><div class="contain-inline-size rounded-2xl relative bg-token-sidebar-surface-primary"><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre!"><span><span>lib/
├── core/                    </span><span># Shared resources</span><span>
│   ├── constants/        
│   ├── routes/           
│   └── theme/            
└── features/             
    ├── splash/
    ├── welcome/
    ├── onboarding/
    └── home/
        ├── </span><span>data</span><span>/
        │   ├── datasources/
        │   │   ├── *_local_datasource.dart
        │   │   └── *_remote_datasource.dart
        │   └── repositories/
        │       └── *_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   └── usecases/
        └── presentation/
            ├── pages/
            └── widgets/
</span></span></code></div></div></pre>

---

# 🛠 Tech Stack

* **Framework:** Flutter 3.9.0
* **State Management:** StatefulWidget
* **Local Storage:** shared_preferences ^2.2.2
* **Backend:** Firebase (cloud_firestore ^5.4.4, firebase_core ^3.6.0)
* **Navigation:** Named Routes (MaterialApp)

---

# 📐 Core Patterns

## 1. Entity Pattern

<pre class="overflow-visible!" data-start="1320" data-end="1576"><div class="contain-inline-size rounded-2xl relative bg-token-sidebar-surface-primary"><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-dart"><span>class EntityName {
  final Type field;
  
  const EntityName({required this.field});
  
  Map<String, dynamic> toJson() => {'field': field};
  
  factory EntityName.fromJson(Map<String, dynamic> json) => 
    EntityName(field: json['field']);
}
</span></code></div></div></pre>

## 2. UseCase Pattern

<pre class="overflow-visible!" data-start="1600" data-end="1901"><div class="contain-inline-size rounded-2xl relative bg-token-sidebar-surface-primary"><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-dart"><span>class GetSomething {
  final Repository _repository = Repository();
  
  Future<Entity> execute(String userId) async {
    return await _repository.getSomething(userId);
  }
  
  Future<void> save(String userId, Entity data) async {
    await _repository.saveSomething(userId, data);
  }
}
</span></code></div></div></pre>

## 3. Repository Pattern

<pre class="overflow-visible!" data-start="1928" data-end="2682"><div class="contain-inline-size rounded-2xl relative bg-token-sidebar-surface-primary"><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-dart"><span>class RepositoryImpl {
  final LocalDatasource localDatasource = LocalDatasource();
  final RemoteDatasource remoteDatasource = RemoteDatasource();
  
  Future<Entity> getData(String userId) async {
    try {
      final remote = await remoteDatasource.getData(userId);
      if (remote != null) {
        await localDatasource.saveData(remote);
        return remote;
      }
    } catch (e) {
      print('Remote failed, using cache: $e');
    }
    return await localDatasource.getData();
  }
  
  Future<void> saveData(String userId, Entity data) async {
    await localDatasource.saveData(data);
    try {
      await remoteDatasource.saveData(userId, data);
    } catch (e) {
      print('⚠️ Sync error, saved locally: $e');
    }
  }
}
</span></code></div></div></pre>

## 4. Datasource Pattern

### Local Datasource

<pre class="overflow-visible!" data-start="2731" data-end="3197"><div class="contain-inline-size rounded-2xl relative bg-token-sidebar-surface-primary"><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-dart"><span>class LocalDatasource {
  Future<void> saveData(Entity data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('key', jsonEncode(data.toJson()));
  }
  
  Future<Entity> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('key');
    if (jsonString != null) {
      return Entity.fromJson(jsonDecode(jsonString));
    }
    return defaultEntity;
  }
}
</span></code></div></div></pre>

### Remote Datasource

<pre class="overflow-visible!" data-start="3221" data-end="3922"><div class="contain-inline-size rounded-2xl relative bg-token-sidebar-surface-primary"><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-dart"><span>class RemoteDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  Future<void> saveData(String userId, Entity data) async {
    await firestore
      .collection('users')
      .doc(userId)
      .collection('subcollection')
      .doc('document')
      .set({
        ...data.toJson(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
  }
  
  Future<Entity?> getData(String userId) async {
    final doc = await firestore
      .collection('users')
      .doc(userId)
      .collection('subcollection')
      .doc('document')
      .get();
  
    if (doc.exists) {
      return Entity.fromJson(doc.data() ?? {});
    }
    return null;
  }
}
</span></code></div></div></pre>

---

# 🎮 Existing Features

## Home Feature

### Entities

* **DashboardStats**
* **UserProgress**
* **Mission**

### UseCases

* GetDashboardStats
* GetUserProgress

### Widgets

* DashboardCard
* DashboardHeader
* MissionBanner
* ProgressCircle
* CustomBottomNavBar

---

# 🚀 Onboarding Feature

### Entities

* **UserProfile**
* **Avatar**

### UseCases

* GetUserProfile
* SaveUserProfile
* GetAvatars

---

# 🎨 Design System

## Colors (AppTheme)

<pre class="overflow-visible!" data-start="4392" data-end="4612"><div class="contain-inline-size rounded-2xl relative bg-token-sidebar-surface-primary"><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre!"><span><span>primaryDark:</span><span></span><span>#4A5F7F</span><span>
</span><span>secondaryDark:</span><span></span><span>#2C3E5F</span><span>
</span><span>tertiaryDark:</span><span></span><span>#1A2645</span><span>
</span><span>accentYellow:</span><span></span><span>#FDD835</span><span>
</span><span>accentGreen:</span><span></span><span>#7FA891</span><span>
</span><span>mascotBackground:</span><span></span><span>#CFE89C</span><span>

</span><span>Dashboard Colors:</span><span>
</span><span>Green:</span><span></span><span>#A4D65E</span><span>
</span><span>Blue:</span><span></span><span>#6EC6FF</span><span>
</span><span>Yellow:</span><span></span><span>#F4D03F</span><span>
</span><span>Pink:</span><span></span><span>#E91E63</span><span>
</span></span></code></div></div></pre>

## Typography

* Font: **Roboto**
* Card titles: **15px bold**
* Card subtitles: **12px medium**

## Components

* Border radius: **20px**
* Border width: **2.5px**
* Shadow: opacity .2, blur 12, offset (0,4)
* Padding: **16px**

---

# 🧭 Navigation

File: `core/routes/app_routes.dart`

* `/` – SplashPage
* `/welcome`
* `/onboarding`
* `/home`

---

# 🔥 Firebase Structure

<pre class="overflow-visible!" data-start="4996" data-end="5125"><div class="contain-inline-size rounded-2xl relative bg-token-sidebar-surface-primary"><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre!"><span><span>users/
  {userId}/
    profile/
      current: {...}
    dashboard/
      stats: {...}
    progress/
      current: {...}
</span></span></code></div></div></pre>

---

# 📌 Development Workflow

1. Create feature folder
2. Domain layer (entities, usecases)
3. Data layer (datasources, repositories)
4. Presentation layer (pages, widgets)
5. Register routes
6. Test

---

# 🌟 Common Patterns

* Use `const` constructors
* Implement `copyWith()`
* Debug logs with emojis
* Use `??` safely
* Use `super.key`

---

# 🌄 **Mapa de Misiones - Rediseño Completo**

## 📅 **Fase 1 — Sistema de Diseño**

* AppTheme con paleta centralizada
* AchievementsPage rediseñada
* HomePage modernizada

---

# 🌍 **Fase 2 — Implementación Inicial**

* MissionMapPage creada
* Scroll vertical
* MapPathPainter: camino serpenteante
* Primeros nodos

---

# ✨ **Fase 3 — Rediseño Estilo Duolingo + Animaciones**

## 1. **Refinamiento Visual**

* Fondo: `assets/images/map_background.png`
* Eliminación de gráficos generados por código
* Mascota integrada desde asset

## 2. **Componentes Avanzados**

### MissionNodeWidget

* Esferas con gradientes, brillos y sombras (look 3D)
* Estados:
  * locked (gris, candado)
  * unlocked (verde, estrella)
  * chest (cofre 3D)
* Botón "JUGAR" con posicionamiento estable

### MissionBanner

* Animado con AnimatedSwitcher
* Slide + Fade suave
* Shimmer al cambiar misión

## 3. **Sistema de Animaciones (flutter_animate)**

| Elemento   | Animación             | Descripción               |
| ---------- | ---------------------- | -------------------------- |
| Nodos      | Staggered fade + scale | Aparición en cascada      |
| Selección | Elastic scale          | Rebote suave               |
| Botón     | SlideY + scale         | Entrada flotante           |
| Mascota    | MoveY (loop)           | Flotación continua        |
| Cofres     | MoveY                  | Movimientos independientes |

## 4. **Lógica Implementada**

* Gestión de `selectedMissionId`
* Misiones desbloqueadas:
  * Misión 1: **El Muro de los Mensajes**
  * Misión 2: **La Fuente de la Verdad**
* Botón JUGAR solo visible en misiones desbloqueadas

## 5. **Archivos Modificados**

* `pubspec.yaml`
* `mission_map_page.dart`
* `mission_node.dart`
* `mission_banner.dart`

---

# ✅ **Estado Actual**

El mapa de misiones funciona con animaciones modernas, diseño pulido y comportamiento fluido, alineado con estándares de apps educativas gamificadas (estilo Duolingo).
