import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class NetflixLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const NetflixLogo({
    super.key,
    this.size = 80,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.27, // Netflix logo aspect ratio
      child: CustomPaint(
        painter: NetflixLogoPainter(color: color ?? AppColors.netflixRed),
      ),
    );
  }
}

class NetflixLogoPainter extends CustomPainter {
  final Color color;

  NetflixLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final width = size.width;
    final height = size.height;

    // Draw the Netflix "N" logo
    final path = Path();

    // Left vertical bar
    path.addRect(Rect.fromLTWH(0, 0, width * 0.15, height));

    // Right vertical bar
    path.addRect(Rect.fromLTWH(width * 0.85, 0, width * 0.15, height));

    // Diagonal bar
    path.moveTo(width * 0.15, height);
    path.lineTo(width * 0.85, 0);
    path.lineTo(width * 0.85, height * 0.2);
    path.lineTo(width * 0.3, height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NetflixTextLogo extends StatelessWidget {
  final double fontSize;
  final Color? color;

  const NetflixTextLogo({
    super.key,
    this.fontSize = 32,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'NETFLIX',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        color: color ?? AppColors.netflixRed,
        letterSpacing: 2,
        // fontFamily: 'Netflix',
      ),
    );
  }
}