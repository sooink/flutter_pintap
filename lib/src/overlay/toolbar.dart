import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/constants.dart';
import '../icons/pintap_icons.dart';
import 'tool_button.dart';

class PintapToolbar extends StatelessWidget {
  final bool isSelectMode;
  final bool isFreezeMode;
  final int annotationCount;
  final VoidCallback onToggleSelect;
  final VoidCallback onToggleFreeze;
  final VoidCallback onShowList;
  final VoidCallback onCopy;
  final VoidCallback onClear;
  final bool copySuccess;

  const PintapToolbar({
    super.key,
    required this.isSelectMode,
    required this.isFreezeMode,
    required this.annotationCount,
    required this.onToggleSelect,
    required this.onToggleFreeze,
    required this.onShowList,
    required this.onCopy,
    required this.onClear,
    this.copySuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(PintapConstants.toolbarRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 56,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: PintapColors.surfaceGlass,
            borderRadius: BorderRadius.circular(PintapConstants.toolbarRadius),
            border: Border.all(
                color: PintapColors.borderStrong,
                width: PintapConstants.toolbarBorderWidth),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _DragHandle(),
              const _Divider(),
              ToolButton(
                icon: PintapIconType.select,
                label: 'Select',
                isActive: isSelectMode,
                onTap: onToggleSelect,
              ),
              const SizedBox(width: 4),
              ToolButton(
                icon: PintapIconType.freeze,
                label: isFreezeMode ? 'Resume' : 'Freeze',
                isActive: isFreezeMode,
                onTap: onToggleFreeze,
              ),
              const _Divider(),
              ToolButton(
                icon: copySuccess ? PintapIconType.check : PintapIconType.copy,
                label: 'Copy ($annotationCount)',
                onTap: onCopy,
                isActive: copySuccess,
              ),
              const SizedBox(width: 4),
              ToolButton(
                icon: PintapIconType.list,
                label: 'List',
                isActive: false,
                onTap: onShowList,
              ),
              const SizedBox(width: 4),
              ToolButton(
                icon: PintapIconType.clear,
                label: 'Clear',
                isActive: false,
                onTap: onClear,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < 3; i++)
            Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: PintapColors.textMuted.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: PintapColors.border,
    );
  }
}
