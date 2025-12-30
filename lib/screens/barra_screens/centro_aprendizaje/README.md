# Centro de Aprendizaje

Esta es la estructura del módulo de aprendizaje de Green Cloud, anteriormente conocido como `mapa_study`. Ha sido reorganizado para mayor claridad y mantenibilidad.

## 📁 Estructura de Carpetas

```
centro_aprendizaje/
├── models/                 # Modelos de datos
│   ├── etapa_models.dart   # Modelos de etapas (EtapaData, etapasData)
│   ├── seccion_models.dart # Modelos de secciones (SectionInfo, SectionData, LevelInfo)
│   └── index.dart          # Exportaciones centralizadas
├── screens/               # Pantallas de la aplicación
│   ├── principal/         # Pantalla principal del mapa
│   │   └── mapa_de_progreso.dart
│   ├── etapas/           # Pantallas relacionadas con etapas
│   │   ├── etapa_detalle_screen.dart
│   │   └── mapa_etapa_screen.dart
│   └── actividades/      # Pantallas de actividades y juegos
│       ├── juego_actividad_screen.dart
│       └── juegos_seccion_screen.dart
├── widgets/              # Widgets reutilizables específicos
└── README.md            # Este archivo
```

## 🎯 Funcionalidades

### Pantallas Principales

1. **Mapa de Progreso**: Vista general del progreso del estudiante
2. **Cartas de Etapas**: Navegación y detalle de cada etapa de aprendizaje
3. **Secciones de Etapa**: Actividades específicas por etapa
4. **Actividades**: Juegos y ejercicios interactivos

### Navegación

- **Sistema integrado con BottomNavBar**: Mantiene la barra de navegación en todas las pantallas
- **Navegación sin pérdida de estado**: Preserva el contexto al cambiar de pestañas
- **Callbacks inteligentes**: Sistema de navegación que evita el uso de Navigator.push()

## 🔧 Uso

Para usar los modelos, importa desde el archivo índice:

```dart
import 'package:green_cloud/screens/barra_screens/centro_aprendizaje/models/index.dart';
```

Para importar pantallas específicas:

```dart
import 'package:green_cloud/screens/barra_screens/centro_aprendizaje/screens/principal/mapa_de_progreso.dart';
```

## 🚀 Beneficios de la Nueva Estructura

1. **Separación clara de responsabilidades**
2. **Modelos reutilizables y centralizados**
3. **Navegación más fluida**
4. **Mejor mantenibilidad del código**
5. **Estructura escalable para futuras funcionalidades**
