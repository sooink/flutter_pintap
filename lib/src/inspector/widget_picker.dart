import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import '../models/widget_data.dart';

/// Widget selection result
class WidgetPickResult {
  final Element? element;
  final List<ChildWidgetInfo> childWidgets;

  const WidgetPickResult({this.element, this.childWidgets = const []});
}

/// Class that finds user project widgets at screen coordinates.
class WidgetPicker {
  final WidgetInspectorService _service = WidgetInspectorService.instance;
  final bool verbose;

  WidgetPicker({this.verbose = false});

  /// Performs hitTest only within a specific RenderObject to find widgets.
  WidgetPickResult findWidgetInRenderObject(
    Offset globalPosition,
    RenderObject? targetRenderObject,
  ) {
    if (targetRenderObject == null || targetRenderObject is! RenderBox) {
      return const WidgetPickResult();
    }

    final RenderBox renderBox = targetRenderObject;

    // Convert global coordinates to local coordinates
    final localPosition = renderBox.globalToLocal(globalPosition);

    // Check if within target RenderObject bounds
    if (!renderBox.size.contains(localPosition)) {
      return const WidgetPickResult();
    }

    // Perform hitTest on the target RenderObject
    final hitTestResult = BoxHitTestResult();
    renderBox.hitTest(hitTestResult, position: localPosition);

    // Find deepest Element from hitTest results, then find meaningful widget in ancestor tree
    _log('🎯 hitTest path count: ${hitTestResult.path.length}');

    // 1. Find deepest Element
    Element? deepestElement;
    for (final entry in hitTestResult.path) {
      if (entry.target is RenderObject) {
        final renderObject = entry.target as RenderObject;
        final creator = renderObject.debugCreator;
        if (creator is DebugCreator) {
          deepestElement = creator.element;
          break; // Use the first (deepest) one
        }
      }
    }

    if (deepestElement == null) {
      _log('  ❌ No element found in hitTest');
      return const WidgetPickResult();
    }

    _log('  🔽 Deepest: ${deepestElement.widget.runtimeType}');

    // 2. Traverse ancestor tree to find user project widget
    // Also collect inner widget info
    final childWidgetInfos = <ChildWidgetInfo>[];
    Element? current = deepestElement;
    Element? selectedElement;

    while (current != null) {
      final widget = current.widget;
      final typeName = widget.runtimeType.toString();

      _log('  📦 $typeName');

      // Check if user project widget
      if (_isUserProjectWidget(current)) {
        _log('  ✅ Selected: $typeName');
        selectedElement = current;
        break;
      }

      // Collect inner widget info (user project widgets only)
      final childInfo = _extractChildWidgetInfo(current);
      if (childInfo != null) {
        childWidgetInfos.add(childInfo);
      }

      // Move to parent
      Element? parent;
      current.visitAncestorElements((ancestor) {
        parent = ancestor;
        return false; // First ancestor only
      });
      current = parent;
    }

    if (selectedElement == null) {
      _log('  ❌ No significant widget found');
      return const WidgetPickResult();
    }

    return WidgetPickResult(
      element: selectedElement,
      childWidgets: childWidgetInfos.reversed.toList(), // Ordered closest to selected widget
    );
  }

  /// Extract inner widget info from Element (user project widgets only)
  ChildWidgetInfo? _extractChildWidgetInfo(Element element) {
    final widget = element.widget;

    // Check if user project widget
    if (!debugIsLocalCreationLocation(widget)) {
      return null;
    }

    // Extract creationLocation
    try {
      final renderObject = element.renderObject;
      if (renderObject == null) return null;

      _service.selection.current = renderObject;
      final jsonString = _service.getSelectedSummaryWidget(null, 'pintap_child');
      final json = jsonDecode(jsonString);
      if (json is Map<String, dynamic> && json.containsKey('creationLocation')) {
        final loc = json['creationLocation'];
        if (loc is Map<String, dynamic>) {
          return ChildWidgetInfo(
            type: widget.runtimeType.toString(),
            file: loc['file'] ?? 'unknown',
            line: loc['line'] ?? 0,
          );
        }
      }
    } catch (e) {
      // Ignore errors
    }

    return null;
  }

  /// Check if user project widget
  bool _isUserProjectWidget(Element element) {
    // Exclude private widgets
    final typeName = element.widget.runtimeType.toString();
    if (typeName.startsWith('_')) return false;

    // Only select widgets created in user project files
    return debugIsLocalCreationLocation(element.widget);
  }

  /// Output logs only when verbose is enabled in debug mode
  void _log(String message) {
    if (verbose && kDebugMode) {
      debugPrint('[Pintap] $message');
    }
  }
}
