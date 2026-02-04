import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PintapIconPainter extends CustomPainter {
  final PintapIconType type;
  final bool isActive;
  final Color? color;

  PintapIconPainter({
    required this.type,
    this.isActive = false,
    this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double scale = size.width / 20.0;
    canvas.scale(scale, scale);

    final Paint paint = Paint()
      ..color = color ??
          (isActive ? PintapColors.primary : PintapColors.textSecondary)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (type == PintapIconType.freeze && isActive) {
      paint.color = PintapColors.freezeActive;
    }

    final Path path = Path();

    switch (type) {
      case PintapIconType.select:
        path.moveTo(4, 2);
        path.lineTo(4, 15);
        path.lineTo(7.5, 11.5);
        path.lineTo(11, 17);
        path.lineTo(13, 16);
        path.lineTo(9.5, 10);
        path.lineTo(14, 10);
        path.close();
        if (isActive) {
          paint.style = PaintingStyle.fill;
          paint.color = paint.color.withValues(alpha: 0.2);
          canvas.drawPath(path, paint);
          paint.style = PaintingStyle.stroke;
          paint.color = PintapColors.selectActive;
          canvas.drawPath(path, paint);
        } else {
          canvas.drawPath(path, paint);
        }
        break;

      case PintapIconType.note:
        path.moveTo(11.5, 3.5);
        path.lineTo(16.5, 8.5);
        path.lineTo(7, 18);
        path.lineTo(2, 18);
        path.lineTo(2, 13);
        path.close();
        path.moveTo(10, 5);
        path.lineTo(15, 10);
        canvas.drawPath(path, paint);
        break;

      case PintapIconType.freeze:
        if (isActive) {
          path.addRRect(RRect.fromRectAndRadius(
              const Rect.fromLTWH(4, 3, 4, 14), const Radius.circular(1)));
          path.addRRect(RRect.fromRectAndRadius(
              const Rect.fromLTWH(12, 3, 4, 14), const Radius.circular(1)));
        } else {
          path.addRRect(RRect.fromRectAndRadius(
              const Rect.fromLTWH(4, 3, 4, 14), const Radius.circular(1)));
          path.addRRect(RRect.fromRectAndRadius(
              const Rect.fromLTWH(12, 3, 4, 14), const Radius.circular(1)));
        }
        canvas.drawPath(path, paint);
        break;

      case PintapIconType.copy:
        Path backPath = Path();
        backPath.moveTo(3, 14);
        backPath.lineTo(3, 3.5);
        backPath.quadraticBezierTo(3, 2, 4.5, 2);
        backPath.lineTo(13, 2);
        canvas.drawPath(backPath, paint);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                const Rect.fromLTWH(6, 6, 11, 12), const Radius.circular(1.5)),
            paint);
        break;

      case PintapIconType.clear:
        canvas.drawCircle(const Offset(10, 10), 7, paint);
        path.moveTo(7, 7);
        path.lineTo(13, 13);
        path.moveTo(13, 7);
        path.lineTo(7, 13);
        canvas.drawPath(path, paint);
        break;

      case PintapIconType.logo:
        // Centered hexagon (canvas 20x20, center at 10,10)
        path.moveTo(10, 1);
        path.lineTo(2, 6);
        path.lineTo(2, 14);
        path.lineTo(10, 19);
        path.lineTo(18, 14);
        path.lineTo(18, 6);
        path.close();
        canvas.drawPath(path, paint);
        canvas.drawCircle(const Offset(10, 10), 3, paint);
        break;

      case PintapIconType.check:
        // Centered checkmark (canvas 20x20, icon ~10x7)
        path.moveTo(5, 10);
        path.lineTo(8.5, 13.5);
        path.lineTo(15, 6.5);
        paint.strokeWidth = 2.0;
        if (isActive) paint.color = PintapColors.successGreen;
        canvas.drawPath(path, paint);
        break;

      case PintapIconType.list:
        // Three horizontal lines with circle bullets (centered)
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(const Offset(4.5, 5), 1.5, paint);
        canvas.drawCircle(const Offset(4.5, 10), 1.5, paint);
        canvas.drawCircle(const Offset(4.5, 15), 1.5, paint);
        paint.style = PaintingStyle.stroke;
        path.moveTo(8.5, 5);
        path.lineTo(17.5, 5);
        path.moveTo(8.5, 10);
        path.lineTo(17.5, 10);
        path.moveTo(8.5, 15);
        path.lineTo(17.5, 15);
        canvas.drawPath(path, paint);
        break;

      case PintapIconType.delete:
        // Trash icon
        path.moveTo(3, 5);
        path.lineTo(17, 5);
        path.moveTo(7, 5);
        path.lineTo(7, 3.5);
        path.quadraticBezierTo(7, 2, 8.5, 2);
        path.lineTo(11.5, 2);
        path.quadraticBezierTo(13, 2, 13, 3.5);
        path.lineTo(13, 5);
        canvas.drawPath(path, paint);
        Path binPath = Path();
        binPath.moveTo(5, 5);
        binPath.lineTo(6, 17);
        binPath.quadraticBezierTo(6, 18, 7.5, 18);
        binPath.lineTo(12.5, 18);
        binPath.quadraticBezierTo(14, 18, 14, 17);
        binPath.lineTo(15, 5);
        canvas.drawPath(binPath, paint);
        // Vertical lines inside
        Path linesPath = Path();
        linesPath.moveTo(8, 8);
        linesPath.lineTo(8, 15);
        linesPath.moveTo(10, 8);
        linesPath.lineTo(10, 15);
        linesPath.moveTo(12, 8);
        linesPath.lineTo(12, 15);
        canvas.drawPath(linesPath, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant PintapIconPainter oldDelegate) {
    return oldDelegate.type != type ||
        oldDelegate.isActive != isActive ||
        oldDelegate.color != color;
  }
}

enum PintapIconType {
  select,
  note,
  freeze,
  copy,
  clear,
  logo,
  check,
  list,
  delete,
}

class PintapIcon extends StatelessWidget {
  final PintapIconType type;
  final bool isActive;
  final Color? color;
  final double size;

  const PintapIcon(
    this.type, {
    super.key,
    this.isActive = false,
    this.color,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: PintapIconPainter(
        type: type,
        isActive: isActive,
        color: color,
      ),
    );
  }
}
