import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/constants.dart';
import '../models/annotation.dart';
import '../icons/pintap_icons.dart';

class AnnotationListModal extends StatelessWidget {
  final List<Annotation> annotations;
  final Function(String id) onDelete;
  final VoidCallback onClose;
  final int maxAnnotations;

  const AnnotationListModal({
    super.key,
    required this.annotations,
    required this.onDelete,
    required this.onClose,
    this.maxAnnotations = 10,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final dialogWidth = screenWidth > 500 ? 420.0 : screenWidth - 40;
    final maxDialogHeight = screenHeight * 0.7;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              width: dialogWidth,
              constraints: BoxConstraints(maxHeight: maxDialogHeight),
              decoration: BoxDecoration(
                color: PintapColors.surfaceGlass,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: PintapColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
                    child: Row(
                      children: [
                        const PintapIcon(PintapIconType.list, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Annotations (${annotations.length}/$maxAnnotations)',
                            style: const TextStyle(
                              color: PintapColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: onClose,
                          icon: const Icon(Icons.close, size: 20),
                          color: PintapColors.textSecondary,
                          splashRadius: 18,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: PintapColors.border),

                  // List
                  if (annotations.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No annotations yet',
                        style: TextStyle(
                          color: PintapColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: annotations.length,
                        separatorBuilder: (_, __) => const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: PintapColors.border,
                        ),
                        itemBuilder: (context, index) {
                          final annotation = annotations[index];
                          return _AnnotationListItem(
                            annotation: annotation,
                            onDelete: () => onDelete(annotation.id),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnnotationListItem extends StatelessWidget {
  final Annotation annotation;
  final VoidCallback onDelete;

  const _AnnotationListItem({
    required this.annotation,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final w = annotation.widgetData;
    final fileName = w.file.split('/').last;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Index badge
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: PintapColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${annotation.index}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Widget type and location
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      height: 1.3,
                    ),
                    children: [
                      TextSpan(
                        text: w.type,
                        style: const TextStyle(
                          color: PintapColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: ' · $fileName:${w.line}',
                        style: const TextStyle(
                          color: PintapColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Note preview
                Text(
                  annotation.note,
                  style: const TextStyle(
                    color: PintapColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Delete button
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const PintapIcon(
                PintapIconType.delete,
                size: 16,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
