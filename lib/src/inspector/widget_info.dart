import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import '../models/widget_data.dart';

class WidgetInfoExtractor {
  final WidgetInspectorService _service = WidgetInspectorService.instance;

  WidgetData extractWidgetData(
    Element element, {
    List<ChildWidgetInfo> childWidgets = const [],
  }) {
    final widget = element.widget;
    final renderObject = element.renderObject;

    // 1. Basic Info
    final type = widget.runtimeType.toString();
    final key = widget.key?.toString();

    // 2. Size & Position (Calculate bounding box with Transform applied)
    Size? size;
    Offset position = Offset.zero;
    if (renderObject is RenderBox && renderObject.hasSize) {
      try {
        final originalSize = renderObject.size;
        final transform = renderObject.getTransformTo(null);

        // Transform four corners to global coordinates
        final corners = [
          MatrixUtils.transformPoint(transform, Offset.zero),
          MatrixUtils.transformPoint(transform, Offset(originalSize.width, 0)),
          MatrixUtils.transformPoint(transform, Offset(originalSize.width, originalSize.height)),
          MatrixUtils.transformPoint(transform, Offset(0, originalSize.height)),
        ];

        // Calculate bounding box
        final minX = corners.map((c) => c.dx).reduce(math.min);
        final maxX = corners.map((c) => c.dx).reduce(math.max);
        final minY = corners.map((c) => c.dy).reduce(math.min);
        final maxY = corners.map((c) => c.dy).reduce(math.max);

        position = Offset(minX, minY);
        size = Size(maxX - minX, maxY - minY);
      } catch (e) {
        // Fallback: default method
        size = renderObject.size;
        try {
          position = renderObject.localToGlobal(Offset.zero);
        } catch (_) {}
      }
    }

    // 3. Properties from DiagnosticsNode
    final properties = <String, String>{};
    final diagnostics = widget.toDiagnosticsNode();
    for (final prop in diagnostics.getProperties()) {
      if (!prop.isFiltered(DiagnosticLevel.info)) {
        properties[prop.name ?? ''] = prop.toDescription();
      }
    }

    // 4. Content (Text)
    String? textContent;
    if (widget is Text) {
      textContent = widget.data;
    }
    // Add more specialized widgets here if needed

    // 5. Parent Chain (up to 5 project widgets)
    final parentChain = <String>[];
    element.visitAncestorElements((ancestor) {
      if (debugIsLocalCreationLocation(ancestor.widget)) {
        parentChain.add(ancestor.widget.runtimeType.toString());
      }
      return parentChain.length < 5;
    });

    // 6. Location (File/Line)
    String file = 'unknown';
    int line = 0;
    int? column;

    // Extract creationLocation via WidgetInspectorService JSON API.
    // Requires --track-widget-creation flag (enabled by default in debug mode).
    try {
      if (_service.isWidgetCreationTracked()) {
        _service.selection.current = element.renderObject;
        final jsonString =
            _service.getSelectedSummaryWidget(null, 'pintap_info');
        // ignore: unnecessary_null_comparison
        if (jsonString != null) {
          final json = jsonDecode(jsonString);
          if (json is Map<String, dynamic> &&
              json.containsKey('creationLocation')) {
            final loc = json['creationLocation'];
            if (loc is Map<String, dynamic>) {
              file = loc['file'] ?? file;
              line = loc['line'] ?? line;
              column = loc['column'];
            }
          }
        }
      }
    } catch (e) {
      debugPrint('[Pintap] Failed to extract location: $e');
    }

    return WidgetData(
      type: type,
      file: file,
      line: line,
      column: column,
      key: key,
      size: size,
      position: position,
      properties: properties,
      parentChain: parentChain,
      childWidgets: childWidgets,
      textContent: textContent,
    );
  }
}
