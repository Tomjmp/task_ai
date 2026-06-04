# TaskAI v1.0 📋

Aplicación móvil de gestión de tareas desarrollada en **Flutter** con
**Material Design 3**. Permite crear, organizar y dar seguimiento a tus
tareas con categorías, prioridades y estadísticas. Los datos se almacenan
en memoria (versión 1.0).

## ✨ Características

- Lista de tareas con título, categoría y estado (pendiente/completada)
- CRUD completo: crear, editar y eliminar tareas (swipe to delete)
- Filtros dinámicos por categoría y por estado
- Pantalla de estadísticas (resumen por estado y categoría)
- Pantalla de perfil con métricas de productividad
- Navegación multipantalla con go_router
- Gestión de estado con Provider
- Interfaz con Material Design 3

## 🛠️ Tecnologías

- Flutter 3.x / Dart 3.x
- Provider (gestión de estado)
- go_router (navegación)
- Material Design 3

## 📁 Estructura del proyecto

\`\`\`
lib/
├── models/      # Modelo de datos (Task)
├── providers/   # Lógica de estado (TaskProvider)
├── screens/     # Pantallas (home, formulario, estadísticas, perfil)
├── theme/       # Colores de la app (AppColors)
└── main.dart    # Punto de entrada y rutas
\`\`\`

## 🚀 Instalación y ejecución

1. Clona el repositorio:
   \`\`\`
   git clone https://github.com/Tomjmp/task_ai.git
   cd task_ai
   \`\`\`
2. Instala las dependencias:
   \`\`\`
   flutter pub get
   \`\`\`
3. Ejecuta la app:
   \`\`\`
   flutter run -d chrome      # en navegador
   flutter run                # en emulador o dispositivo
   \`\`\`

## 📦 Generar el APK

\`\`\`
flutter build apk --release
\`\`\`

El archivo queda en \`build/app/outputs/flutter-apk/app-release.apk\`.


## 👤 Autor

Tomás Polanco — Asignación 2, Desarrollo Móvil Moderno