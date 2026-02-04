import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/annotation.dart';

class AnnotationOverlay extends StatelessWidget {
  final List<Annotation> annotations;
  final Annotation? selectedAnnotation;

  const AnnotationOverlay({
    super.key,
    required this.annotations,
    this.selectedAnnotation,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final annotation in annotations) _buildHighlight(annotation),
        for (final annotation in annotations) _buildPin(annotation),
      ],
    );
  }

  Widget _buildHighlight(Annotation annotation) {
    final w = annotation.widgetData;
    if (w.size == null) return const SizedBox();

    return Positioned(
      left: w.position.dx,
      top: w.position.dy,
      width: w.size!.width,
      height: w.size!.height,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: annotation == selectedAnnotation
                  ? PintapColors.highlightBorder
                  : PintapColors.highlightBorder.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPin(Annotation annotation) {
    final w = annotation.widgetData;
    if (w.size == null) return const SizedBox();

    // Pin position: Top-Right corner (-8, -8) relative to widget corner
    final pinX = w.position.dx + w.size!.width - 10;
    final pinY = w.position.dy - 10;

    return Positioned(
      left: pinX,
      top: pinY,
      child: IgnorePointer(
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: PintapColors.pinBackground,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: PintapColors.pinShadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              annotation.index.toString(),
              style: const TextStyle(
                color: PintapColors.pinText,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                height: 1, // important for vertical centering
              ),
            ),
          ),
        ),
      ),
    );
  }
}
