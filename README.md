# TaskAI 📋⚡ — Versión final (Flutter)

Aplicación móvil de gestión de tareas construida en **Flutter** con **Material
Design 3**. Integra **IA on-device** (voz y OCR), **persistencia en la nube con
Supabase**, **caché offline** y **autenticación de usuarios**. Es el proyecto
integrador del primer período (Asignaciones 2 → 5).

> Mismo backend Supabase compartido con una **mini-app en React Native** (repo
> aparte): ambas leen y escriben sobre la misma tabla `tasks`.

---

## ✨ Funcionalidades

### Gestión de tareas (Asignación 2)
- CRUD completo: crear, editar y eliminar tareas (swipe to delete).
- Categorías (trabajo, personal, estudio, urgente) y prioridades (alta, media, baja).
- Filtros por categoría y por estado (todas / pendientes / completadas).
- Dashboard con progreso del día, estadísticas y pantalla de perfil.

### IA on-device (Asignación 3)
- **🎙️ Captura por voz** (`speech_to_text`): dicta una tarea y la app la
  transcribe y la crea automáticamente, deduciendo título, categoría, prioridad
  y fecha del lenguaje natural ("reunión urgente mañana a las 8").
- **📷 Escaneo OCR** (`google_mlkit_text_recognition`): reconoce texto impreso o
  manuscrito desde la cámara o la galería y genera tareas a partir de las líneas
  detectadas.
- Todo el procesamiento ocurre **en el dispositivo**, sin enviar datos a
  servidores externos.

### Persistencia y sincronización (Asignación 4)
- **Supabase** (PostgreSQL + Auth + Realtime) como backend.
- **Caché offline** con **Hive**: la app funciona sin conexión y sincroniza al
  recuperar red (estrategia *offline-first*, resolución de conflictos
  *Last-Write-Wins*) y vía **Realtime**.
- Borrado lógico (`deleted_at`) y bandera de sincronización por tarea.

### Cuentas (Asignación 5)
- Registro e inicio de sesión con **Supabase Auth** (correo + contraseña).
- Cada usuario ve únicamente sus propias tareas.

---

## 🏗️ Arquitectura

Arquitectura en capas con patrón **Repository** y gestión de estado con
**Provider**:

```
UI (screens)
   │  context.watch / read
Providers (AuthProvider, TaskProvider)   ← estado y notificación a la UI
   │
Repository (TaskRepository)              ← orquesta local + sincronización
   │
Services
 ├─ HiveService        → caché local (offline-first)
 ├─ SupabaseService    → CRUD + Realtime en la nube
 ├─ SyncService        → push/pull, conectividad, Last-Write-Wins
 ├─ AuthService        → registro / login / logout
 ├─ SpeechService      → captura por voz (IA on-device)
 ├─ OcrService         → escaneo OCR (IA on-device)
 └─ TaskTextParser     → texto libre → tarea estructurada
```

```
lib/
├── config/        # Configuración de Supabase
├── models/        # Modelo Task (+ adapter Hive, toJson/fromJson)
├── providers/     # AuthProvider, TaskProvider
├── repositories/  # TaskRepository
├── services/      # Hive, Supabase, Sync, Auth, Speech, OCR, parser
├── screens/       # login, register, home, form, stats, profile, ai_assistant
├── theme/         # AppColors (paleta de la guía de diseño)
└── main.dart      # Inicialización, providers y rutas (go_router)
```

El enrutado usa **go_router** con un *guard* de autenticación: sin sesión, la
app redirige a `/login`.

---

## 📦 Paquetes principales

| Paquete | Uso |
|---------|-----|
| `provider` | Gestión de estado |
| `go_router` | Navegación declarativa + guard de auth |
| `supabase_flutter` | Backend: Auth, base de datos y Realtime |
| `hive` / `hive_flutter` | Caché local offline |
| `connectivity_plus` | Detección de conexión para sincronizar |
| `speech_to_text` | Captura por voz (IA on-device) |
| `google_mlkit_text_recognition` | OCR (IA on-device) |
| `image_picker` | Captura de imagen para el OCR |
| `uuid` | IDs de tarea generados en el cliente |

---

## 🚀 Instalación y ejecución

1. Clonar e instalar dependencias:
   ```bash
   git clone https://github.com/Tomjmp/task_ai.git
   cd task_ai
   flutter pub get
   ```
2. Ejecutar en un emulador o dispositivo físico (las funciones de voz, cámara y
   OCR requieren un dispositivo real):
   ```bash
   flutter run
   ```

> La configuración de Supabase ya viene incluida en `lib/config/supabase_config.dart`
> (se usa la *publishable key*, pensada para el cliente).

### Generar el APK (release)
```bash
flutter build apk --release
```
El archivo queda en `build/app/outputs/flutter-apk/app-release.apk`.

---

## 🔐 Permisos

- **Android**: `RECORD_AUDIO` (voz) y descubrimiento del servicio de
  reconocimiento de voz; cámara y galería para el OCR.
- **iOS**: descripciones de uso de micrófono, reconocimiento de voz, cámara y
  fotos en `Info.plist`.
- La app solicita los permisos en tiempo de ejecución y maneja las denegaciones
  con mensajes claros al usuario.

---

## ✅ Tests

```bash
flutter test
```
Cubre el parser de IA (lenguaje natural → tarea), la serialización del modelo
`Task` (round-trip con Supabase) y un widget test de la pantalla de login.

---

## 📸 Capturas

> _Agregar aquí las capturas desde un dispositivo real:_

| Login | Dashboard | Asistente IA (voz/OCR) | Crear tarea |
|-------|-----------|------------------------|-------------|
| _(captura)_ | _(captura)_ | _(captura)_ | _(captura)_ |

---

## 🧑‍💻 Equipo

Proyecto grupal — Desarrollo de Aplicaciones Móviles. _(Agregar integrantes.)_
