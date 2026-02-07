<div align="center">

# Flutter Pintap

**Visual feedback tool for AI Agents in Flutter**

[![pub package](https://img.shields.io/pub/v/flutter_pintap.svg?style=flat-square)](https://pub.dev/packages/flutter_pintap)
[![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?style=flat-square&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?style=flat-square&logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-BSD--3--Clause-blue?style=flat-square)](LICENSE)

</div>

---

## The Problem

When using **AI coding agents** to develop Flutter apps, you need to communicate which widget to modify. But describing UI elements in text is imprecise:

> "Change the button color in the card"
> "Make the text bigger in the list"

The AI doesn't know exactly which widget you mean, what file it's in, or what line number.

**Flutter Pintap solves this.** Tap any widget on screen, add a note, and get structured markdown with exact `file:line` locations - ready to paste into your AI agent.

Inspired by [Agentation](https://github.com/benjitaylor/agentation).

<div align="center">

<img src="https://github.com/sooink/flutter_pintap/raw/main/screenshots/demo.gif" width="300px" alt="Flutter Pintap Demo">

</div>

## Quick Start

```yaml
# pubspec.yaml
dependencies:
  flutter_pintap: ^0.1.0
```

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter_pintap/flutter_pintap.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlutterPintap(
        enabled: kDebugMode,  // Only in debug mode
        child: const HomeScreen(),
      ),
    );
  }
}
```

## Features

| Feature | Description |
|---------|-------------|
| **Widget Selection** | Tap any widget with precise hit testing |
| **Hover Preview** | See widget info before clicking (Web/Desktop) |
| **Visual Highlight** | Selected widgets show border + file:line label |
| **Note Dialog** | Add feedback notes with glassmorphism UI |
| **Annotation List** | View all annotations, delete individually (max 10) |
| **Markdown Export** | Copy structured markdown for AI agents (Copy disabled when list is empty) |
| **Freeze Mode** | Stop animations completely for easier selection |
| **Zero Dependencies** | Pure Flutter SDK only |

## Usage

<img src="https://github.com/sooink/flutter_pintap/raw/main/screenshots/toolbar_open.png" width="200px" style="padding-left: 25px" alt="Flutter Pintap Toolbar Open">

1. **Open Toolbar** — Tap the floating action button (FAB)
2. **Select Mode** — Click **Select**, then tap any widget
3. **Add Note** — Enter your feedback in the dialog
4. **Manage List** — Click **List** to view/delete annotations
5. **Copy Markdown** — Click **Copy** and paste to your AI agent (enabled only when annotation count > 0)

## Markdown Output

```markdown
## UI Feedback (2 annotations)

### #1 ElevatedButton
- 📍 screens/home.dart:47:12
- 📐 Size: 120×48
- 🎨 backgroundColor: Color(0xFFE0E0E0)
- 🌳 Parent: Column > Card > Scaffold
- 💬 "Change background color to blue"

### #2 Card
- 📍 screens/home.dart:30:8
- 📐 Size: 300×200
- 🌳 Parent: Column > Scaffold
- 🔽 Contains:
  - TextField (screens/home.dart:35:12)
- 💬 "Update TextField style inside"
```

## How It Works

| Component | Description |
|-----------|-------------|
| **Widget Detection** | Uses Flutter's `hitTest` API to find widgets at tap position |
| **Source Location** | Extracts `creationLocation` via `WidgetInspectorService` |
| **Overlay** | Uses `DisableWidgetInspectorScope` to exclude UI from selection |

## Platform Support

| Platform | Selection | Hover Preview |
|----------|-----------|---------------|
| Android  | ✅ | ❌ (no mouse) |
| iOS      | ✅ | ❌ (no mouse) |
| Web      | ✅ | ✅ |
| macOS    | ✅ | ✅ |
| Windows  | ✅ | ✅ |
| Linux    | ✅ | ✅ |

## Configuration

```dart
FlutterPintap(
  enabled: kDebugMode,               // Enable/disable
  verbose: false,                    // Debug logs (default: false)
  initialPosition: Offset(16, 16),   // FAB position (default)
  child: YourApp(),
)
```

## Credits

- [Agentation](https://github.com/benjitaylor/agentation) - The visual feedback tool for agents
- [Flutter DevTools](https://docs.flutter.dev/tools/devtools/inspector) - Widget Inspector API

## License

BSD-3-Clause License — see [LICENSE](LICENSE) for details.
