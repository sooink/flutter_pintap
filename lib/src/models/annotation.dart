import 'widget_data.dart';

/// Single annotation data
class Annotation {
  Annotation({
    required this.id,
    required this.widgetData,
    required this.note,
    required this.index,
    required this.createdAt,
  });

  final String id; // Unique ID
  final WidgetData widgetData; // Widget info
  String note; // User memo (Mutable for update)
  final int index; // Index (starts from 1)
  final DateTime createdAt; // Created time
}
