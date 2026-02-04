import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/constants.dart';
import '../models/widget_data.dart';

class NoteDialog extends StatefulWidget {
  final WidgetData widgetData;
  final Function(String) onSave;
  final VoidCallback onCancel;

  const NoteDialog({
    super.key,
    required this.widgetData,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  double _inputHeight = 120.0; // Initial height
  static const double _minHeight = 80.0;
  static const double _maxHeight = 240.0;

  @override
  void initState() {
    super.initState();
    // Auto focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;
    widget.onSave(_controller.text);
  }

  void _onVerticalDrag(DragUpdateDetails details) {
    setState(() {
      _inputHeight =
          (_inputHeight + details.delta.dy).clamp(_minHeight, _maxHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.widgetData;
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 500 ? 420.0 : screenWidth - 40;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              width: dialogWidth,
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
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header - Selected widget
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: PintapColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${w.type} — ${w.file.split('/').last}:${w.line} · (${w.position.dx.toInt()}, ${w.position.dy.toInt()})',
                            style: const TextStyle(
                              color: PintapColors.textPrimary,
                              fontFamily: 'monospace',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // Inner widget info (if any)
                    if (w.childWidgets.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: PintapColors.border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Contains:',
                              style: TextStyle(
                                color: PintapColors.textMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ...w.childWidgets.map((child) => Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, top: 2),
                                  child: Text(
                                    '└ ${child.type} (${child.file.split('/').last}:${child.line})',
                                    style: const TextStyle(
                                      color: PintapColors.textSecondary,
                                      fontFamily: 'monospace',
                                      fontSize: 11,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Input with resize handle
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: PintapColors.border),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: _inputHeight,
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              style: const TextStyle(
                                color: PintapColors.textPrimary,
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'feedback?',
                                hintStyle:
                                    TextStyle(color: PintapColors.textMuted),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(14),
                              ),
                              maxLines: null,
                              expands: true,
                              textAlignVertical: TextAlignVertical.top,
                              onSubmitted: (_) => _submit(),
                            ),
                          ),
                          // Resize handle
                          GestureDetector(
                            onVerticalDragUpdate: _onVerticalDrag,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeRow,
                              child: Container(
                                height: 20,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 32,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: PintapColors.textMuted
                                          .withValues(alpha: 0.4),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: widget.onCancel,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: PintapColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PintapColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Add',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
