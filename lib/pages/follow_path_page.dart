import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class FollowPathPage extends StatefulWidget {
  const FollowPathPage({super.key});

  @override
  State<FollowPathPage> createState() => _FollowPathPageState();
}

class _FollowPathPageState extends State<FollowPathPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => CustomPaint(
                      painter: TextOnPathPainter(progress: _controller.value, text: 'move'),
                      size: const Size(200, 200),
                    )),
            ElevatedButton(
              onPressed: () {
                if (_controller.isAnimating) {
                  _controller.stop();
                } else {
                  _controller.repeat(reverse: true);
                }
              },
              child: const Text('Start/Stop'),
            ),
          ],
        ),
      ),
    );
  }
}

class TextOnPathPainter extends CustomPainter {
  final double progress;
  final String text;

  TextOnPathPainter({
    required this.progress,
    required this.text,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pathPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final followPath = Path();
    followPath.moveTo(size.width / 2, 0);
    followPath.cubicTo(size.width, 0, size.width, size.height / 2, size.width / 2, size.height / 2);
    followPath.cubicTo(0, size.height / 2, 0, size.height, size.width / 2, size.height);

    final spiralPath = Path();
    const double start = 0.0;
    const double end = 4 * pi;
    const double radiusStart = 10.0;
    const double radiusEnd = 100.0;
    const int steps = 100;
    const double radiusStep = (radiusEnd - radiusStart) / steps;
    const double angleStep = (end - start) / steps;

    for (int i = 0; i <= steps; i++) {
      final double radius = radiusStart + radiusStep * i;
      final double angle = start + angleStep * i;
      final Offset point = Offset(
        size.width / 2 + radius * cos(angle),
        size.height / 2 + radius * sin(angle),
      );
      if (i == 0) {
        spiralPath.moveTo(point.dx, point.dy);
      } else {
        spiralPath.lineTo(point.dx, point.dy);
      }
    }
    // canvas.drawPath(spiralPath, pathPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 24, color: Colors.black),
      ),
      textDirection: TextDirection.ltr,
    );

    // canvas.drawPath(followPath, pathPaint);

    Offset? getOffset(Path path) {
      List<PathMetric> pathMetrics = path.computeMetrics().toList();
      double pathLength = pathMetrics.first.length;
      final distance = pathLength * progress;
      final Tangent? tangent = pathMetrics.first.getTangentForOffset(distance);
      return tangent?.position;
    }

    final offset = getOffset(spiralPath) ?? Offset.zero;

    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
