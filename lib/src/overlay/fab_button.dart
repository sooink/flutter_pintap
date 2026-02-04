import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/constants.dart';
import '../icons/pintap_icons.dart';

class PintapFab extends StatelessWidget {
  final VoidCallback onTap;
  final int badgeCount;
  final bool isOpen;

  const PintapFab({
    super.key,
    required this.onTap,
    this.badgeCount = 0,
    this.isOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOpen) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PintapConstants.fabBorderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: PintapConstants.fabSize,
            height: PintapConstants.fabSize,
            decoration: BoxDecoration(
              color: PintapColors.surfaceGlass,
              borderRadius:
                  BorderRadius.circular(PintapConstants.fabBorderRadius),
              border: Border.all(color: PintapColors.borderStrong),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                const Center(
                  child: PintapIcon(PintapIconType.logo, size: 24),
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: PintapColors.primary,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          badgeCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
