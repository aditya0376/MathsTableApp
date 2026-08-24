import 'package:flutter/material.dart';

/// An original cartoon character drawn with CustomPainter.
/// These are original creations (not copyrighted characters).
enum CartoonType {
  robot,
  sun,
  cat,
  star,
  rocket,
  owl,
}

/// A widget that draws an original cartoon character.
class CartoonCharacterView extends StatelessWidget {
  final CartoonType type;
  final double size;
  final Color primaryColor;

  const CartoonCharacterView({
    super.key,
    required this.type,
    this.size = 120,
    this.primaryColor = const Color(0xFFFFB300),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _CartoonPainter(type: type, color: primaryColor),
    );
  }
}

class _CartoonPainter extends CustomPainter {
  final CartoonType type;
  final Color color;

  _CartoonPainter({required this.type, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case CartoonType.robot:
        _drawRobot(canvas, size);
        break;
      case CartoonType.sun:
        _drawSun(canvas, size);
        break;
      case CartoonType.cat:
        _drawCat(canvas, size);
        break;
      case CartoonType.star:
        _drawStar(canvas, size);
        break;
      case CartoonType.rocket:
        _drawRocket(canvas, size);
        break;
      case CartoonType.owl:
        _drawOwl(canvas, size);
        break;
    }
  }

  void _drawRobot(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // Body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: w * 0.6, height: h * 0.55),
      Radius.circular(w * 0.1),
    );
    canvas.drawRRect(bodyRect, Paint()..color = color);

    // Head
    canvas.drawCircle(
        Offset(center.dx, h * 0.22), w * 0.18, Paint()..color = color);

    // Eyes
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(center.dx - w * 0.06, h * 0.22), w * 0.04, eyePaint);
    canvas.drawCircle(Offset(center.dx + w * 0.06, h * 0.22), w * 0.04, eyePaint);
    final pupilPaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(center.dx - w * 0.06, h * 0.22), w * 0.02, pupilPaint);
    canvas.drawCircle(Offset(center.dx + w * 0.06, h * 0.22), w * 0.02, pupilPaint);

    // Antenna
    canvas.drawLine(Offset(center.dx, h * 0.04), Offset(center.dx, h * 0.1),
        Paint()..color = color..strokeWidth = w * 0.02);
    canvas.drawCircle(Offset(center.dx, h * 0.04), w * 0.03, Paint()..color = Colors.red);

    // Mouth
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx, h * 0.3), width: w * 0.12, height: h * 0.06),
      0, 3.14, false, Paint()..color = Colors.black..style = PaintingStyle.stroke..strokeWidth = w * 0.015,
    );

    // Arms
    canvas.drawLine(Offset(center.dx - w * 0.3, center.dy), Offset(center.dx - w * 0.42, center.dy + h * 0.1),
        Paint()..color = color..strokeWidth = w * 0.04..strokeCap = StrokeCap.round);
    canvas.drawLine(Offset(center.dx + w * 0.3, center.dy), Offset(center.dx + w * 0.42, center.dy + h * 0.1),
        Paint()..color = color..strokeWidth = w * 0.04..strokeCap = StrokeCap.round);
  }

  void _drawSun(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // Rays
    final rayPaint = Paint()..color = color..strokeWidth = w * 0.03..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final angle = i * 3.14159 / 4;
      final start = Offset(center.dx + (w * 0.28) * _cos(angle), center.dy + (w * 0.28) * _sin(angle));
      final end = Offset(center.dx + (w * 0.38) * _cos(angle), center.dy + (w * 0.38) * _sin(angle));
      canvas.drawLine(start, end, rayPaint);
    }

    // Face
    canvas.drawCircle(center, w * 0.28, Paint()..color = color);
    canvas.drawCircle(Offset(center.dx - w * 0.08, center.dy - w * 0.04), w * 0.03, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(center.dx + w * 0.08, center.dy - w * 0.04), w * 0.03, Paint()..color = Colors.black);
    // Smile
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx, center.dy + w * 0.06), width: w * 0.16, height: w * 0.1),
      0, 3.14, false, Paint()..color = Colors.black..style = PaintingStyle.stroke..strokeWidth = w * 0.02,
    );
  }

  void _drawCat(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // Ears
    final earPaint = Paint()..color = color;
    final earPath = Path()
      ..moveTo(center.dx - w * 0.25, h * 0.25)
      ..lineTo(center.dx - w * 0.15, h * 0.05)
      ..lineTo(center.dx - w * 0.05, h * 0.25)
      ..close();
    canvas.drawPath(earPath, earPaint);
    final earPath2 = Path()
      ..moveTo(center.dx + w * 0.05, h * 0.25)
      ..lineTo(center.dx + w * 0.15, h * 0.05)
      ..lineTo(center.dx + w * 0.25, h * 0.25)
      ..close();
    canvas.drawPath(earPath2, earPaint);

    // Head
    canvas.drawCircle(center, w * 0.3, Paint()..color = color);

    // Eyes
    canvas.drawCircle(Offset(center.dx - w * 0.1, center.dy - w * 0.02), w * 0.035, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(center.dx + w * 0.1, center.dy - w * 0.02), w * 0.035, Paint()..color = Colors.black);

    // Nose
    canvas.drawCircle(Offset(center.dx, center.dy + w * 0.05), w * 0.02, Paint()..color = Colors.pink);

    // Whiskers
    final whiskerPaint = Paint()..color = Colors.black..strokeWidth = w * 0.012;
    canvas.drawLine(Offset(center.dx - w * 0.05, center.dy + w * 0.05), Offset(center.dx - w * 0.25, center.dy + w * 0.02), whiskerPaint);
    canvas.drawLine(Offset(center.dx - w * 0.05, center.dy + w * 0.07), Offset(center.dx - w * 0.25, center.dy + w * 0.08), whiskerPaint);
    canvas.drawLine(Offset(center.dx + w * 0.05, center.dy + w * 0.05), Offset(center.dx + w * 0.25, center.dy + w * 0.02), whiskerPaint);
    canvas.drawLine(Offset(center.dx + w * 0.05, center.dy + w * 0.07), Offset(center.dx + w * 0.25, center.dy + w * 0.08), whiskerPaint);
  }

  void _drawStar(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final paint = Paint()..color = color;

    final path = Path();
    for (var i = 0; i < 10; i++) {
      final radius = i.isEven ? w * 0.4 : w * 0.18;
      final angle = -3.14159 / 2 + i * 3.14159 / 5;
      final point = Offset(center.dx + radius * _cos(angle), center.dy + radius * _sin(angle));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    // Eyes
    canvas.drawCircle(Offset(center.dx - w * 0.08, center.dy - w * 0.02), w * 0.03, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(center.dx + w * 0.08, center.dy - w * 0.02), w * 0.03, Paint()..color = Colors.black);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx, center.dy + w * 0.06), width: w * 0.14, height: w * 0.08),
      0, 3.14, false, Paint()..color = Colors.black..style = PaintingStyle.stroke..strokeWidth = w * 0.015,
    );
  }

  void _drawRocket(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // Body
    final bodyPaint = Paint()..color = color;
    final bodyPath = Path()
      ..moveTo(center.dx, h * 0.05)
      ..quadraticBezierTo(center.dx + w * 0.25, h * 0.3, center.dx + w * 0.2, h * 0.6)
      ..lineTo(center.dx - w * 0.2, h * 0.6)
      ..quadraticBezierTo(center.dx - w * 0.25, h * 0.3, center.dx, h * 0.05)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    // Window
    canvas.drawCircle(Offset(center.dx, h * 0.35), w * 0.1, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(center.dx, h * 0.35), w * 0.06, Paint()..color = Colors.lightBlue);

    // Fins
    final finPaint = Paint()..color = Colors.red;
    final finPath = Path()
      ..moveTo(center.dx - w * 0.2, h * 0.55)
      ..lineTo(center.dx - w * 0.35, h * 0.8)
      ..lineTo(center.dx - w * 0.12, h * 0.6)
      ..close();
    canvas.drawPath(finPath, finPaint);
    final finPath2 = Path()
      ..moveTo(center.dx + w * 0.2, h * 0.55)
      ..lineTo(center.dx + w * 0.35, h * 0.8)
      ..lineTo(center.dx + w * 0.12, h * 0.6)
      ..close();
    canvas.drawPath(finPath2, finPaint);

    // Flame
    final flamePaint = Paint()..color = Colors.orange;
    final flamePath = Path()
      ..moveTo(center.dx - w * 0.08, h * 0.62)
      ..quadraticBezierTo(center.dx, h * 0.95, center.dx + w * 0.08, h * 0.62)
      ..close();
    canvas.drawPath(flamePath, flamePaint);
  }

  void _drawOwl(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // Body
    canvas.drawOval(
      Rect.fromCenter(center: center, width: w * 0.7, height: h * 0.8),
      Paint()..color = color,
    );

    // Ears
    final earPaint = Paint()..color = color;
    final earPath = Path()
      ..moveTo(center.dx - w * 0.2, h * 0.2)
      ..lineTo(center.dx - w * 0.15, h * 0.02)
      ..lineTo(center.dx - w * 0.02, h * 0.2)
      ..close();
    canvas.drawPath(earPath, earPaint);
    final earPath2 = Path()
      ..moveTo(center.dx + w * 0.2, h * 0.2)
      ..lineTo(center.dx + w * 0.15, h * 0.02)
      ..lineTo(center.dx + w * 0.02, h * 0.2)
      ..close();
    canvas.drawPath(earPath2, earPaint);

    // Eyes (big owl eyes)
    canvas.drawCircle(Offset(center.dx - w * 0.15, center.dy - w * 0.05), w * 0.12, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(center.dx + w * 0.15, center.dy - w * 0.05), w * 0.12, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(center.dx - w * 0.15, center.dy - w * 0.05), w * 0.06, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(center.dx + w * 0.15, center.dy - w * 0.05), w * 0.06, Paint()..color = Colors.black);

    // Beak
    final beakPaint = Paint()..color = Colors.orange;
    final beakPath = Path()
      ..moveTo(center.dx, center.dy + w * 0.02)
      ..lineTo(center.dx - w * 0.05, center.dy + w * 0.1)
      ..lineTo(center.dx + w * 0.05, center.dy + w * 0.1)
      ..close();
    canvas.drawPath(beakPath, beakPaint);

    // Wings
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx - w * 0.32, center.dy + w * 0.1), width: w * 0.2, height: w * 0.4),
      Paint()..color = color.withValues(alpha: 0.7),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx + w * 0.32, center.dy + w * 0.1), width: w * 0.2, height: w * 0.4),
      Paint()..color = color.withValues(alpha: 0.7),
    );
  }

  double _cos(double angle) => _cosTable[((angle / 3.14159 * 180).round() % 360 + 360) % 360] ?? 0;
  double _sin(double angle) => _sinTable[((angle / 3.14159 * 180).round() % 360 + 360) % 360] ?? 0;

  static const Map<int, double> _cosTable = {
    0: 1.0, 45: 0.7071, 90: 0.0, 135: -0.7071, 180: -1.0,
    225: -0.7071, 270: 0.0, 315: 0.7071,
  };
  static const Map<int, double> _sinTable = {
    0: 0.0, 45: 0.7071, 90: 1.0, 135: 0.7071, 180: 0.0,
    225: -0.7071, 270: -1.0, 315: -0.7071,
  };

  @override
  bool shouldRepaint(covariant _CartoonPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.color != color;
}