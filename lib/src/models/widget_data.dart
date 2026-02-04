import 'dart:ui';

/// Inner widget brief info (widgets between tap position and selected widget)
class ChildWidgetInfo {
  const ChildWidgetInfo({
    required this.type,
    required this.file,
    required this.line,
  });

  final String type;
  final String file;
  final int line;
}

/// Widget info data model
class WidgetData {
  const WidgetData({
    required this.type,
    required this.file,
    required this.line,
    this.column,
    this.key,
    this.size,
    this.position = Offset.zero,
    this.properties = const {},
    this.parentChain = const [],
    this.childWidgets = const [],
    this.textContent,
  });

  final String type; // "ElevatedButton"
  final String file; // "lib/screens/home.dart"
  final int line; // 47
  final int? column; // 12
  final String? key; // "sidebar_btn" (if Key is set)
  final Size? size; // Size(120, 48)
  final Offset position;
  final Map<String, String>
      properties; // {"backgroundColor": "Color(0xFFE0E0E0)"}
  final List<String> parentChain; // ["Column", "Card", "Scaffold"]
  final List<ChildWidgetInfo> childWidgets; // Inner widgets between tap position and selected widget
  final String? textContent; // Display text for Text widget
}
