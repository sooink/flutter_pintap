import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../icons/pintap_icons.dart';

class ToolButton extends StatefulWidget {
  final PintapIconType icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDestructive;

  const ToolButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  State<ToolButton> createState() => _ToolButtonState();
}

class _ToolButtonState extends State<ToolButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.icon == PintapIconType.freeze
        ? PintapColors.freezeActive
        : (widget.icon == PintapIconType.check
            ? PintapColors.successGreen
            : PintapColors.selectActive);

    final bg = widget.isActive
        ? activeColor.withValues(alpha: 0.12)
        : (_isHovered ? PintapColors.buttonHover : Colors.transparent);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: PintapConstants.toolButtonSize,
          height: PintapConstants.toolButtonSize,
          decoration: BoxDecoration(
            color: bg,
            borderRadius:
                BorderRadius.circular(PintapConstants.toolButtonRadius),
            border: widget.isActive
                ? Border.all(color: activeColor.withValues(alpha: 0.4), width: 1)
                : Border.all(color: Colors.transparent),
          ),
          child: Center(
            child: PintapIcon(
              widget.icon,
              isActive: widget.isActive,
              color: widget.isDestructive && !widget.isActive
                  ? PintapColors.textSecondary
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
