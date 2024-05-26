import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class CloudPage extends StatefulWidget {
  const CloudPage({super.key});

  @override
  State<CloudPage> createState() => _CloudPageState();
}

class _CloudPageState extends State<CloudPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  List<double> randomRadiusList = [];

  int pointCount = 5;
  double rectWidth = 100;
  double rectHeight = 100;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 0.1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    getRandomList();
  }

  void getRandomList() {
    final oneLength = (rectWidth * 2 + rectHeight * 2) / pointCount;
    randomRadiusList.clear();
    for (int i = 0; i < pointCount; i++) {
      final v = Random().nextDouble() * oneLength / 10 + oneLength / 2;
      randomRadiusList = [...randomRadiusList, v];
    }
    print(randomRadiusList);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade300,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => CustomPaint(
                  painter: CloudPainter(
                      rectSize: Size(rectWidth, rectHeight),
                      animationValue: _animation.value,
                      pointCount: pointCount,
                      randomRadiusList: randomRadiusList),
                  size: Size(rectWidth, rectHeight),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Point Count'),
                        Slider(
                          value: pointCount.toDouble(),
                          min: 5,
                          max: 20,
                          onChanged: (value) {
                            setState(() {
                              pointCount = value.toInt();
                              getRandomList();
                            });
                          },
                        ),
                        const Text('width'),
                        Slider(
                          value: rectWidth,
                          min: 100,
                          max: 300,
                          onChanged: (value) {
                            setState(() {
                              rectWidth = value;
                            });
                          },
                        ),
                        const Text('height'),
                        Slider(
                          value: rectHeight,
                          min: 100,
                          max: 300,
                          onChanged: (value) {
                            setState(() {
                              rectHeight = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      getRandomList();
                    },
                    child: const Text('R'),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class CloudPainter extends CustomPainter {
  final Size rectSize;
  final double animationValue;
  final int pointCount;
  final List<double> randomRadiusList;
  CloudPainter(
      {required this.rectSize,
      required this.animationValue,
      required this.pointCount,
      required this.randomRadiusList});

  Offset? getOffset(Path path, double progress) {
    List<PathMetric> pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isEmpty) {
      return null;
    }
    double pathLength = pathMetrics.first.length;
    final distance = pathLength * progress;
    final Tangent? tangent = pathMetrics.first.getTangentForOffset(distance);
    final offset = tangent?.position;
    if (offset == null) {
      return null;
    }
    return Offset(offset.dx, offset.dy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final pointList = <Offset>[];
    const p1 = Offset(0, 0);
    final p2 = Offset(rectSize.width, 0);
    final p3 = Offset(rectSize.width, rectSize.height);
    final p4 = Offset(0, rectSize.height);

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final fillPaint = Paint()
      ..color = Colors.blue.shade100
      ..style = PaintingStyle.fill;

    final basePath = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..lineTo(p4.dx, p4.dy)
      ..close();

    for (int i = 0; i < pointCount; i++) {
      final progress = (i / pointCount + animationValue) % 1;

      final offset = getOffset(basePath, progress) ?? const Offset(0, 0);
      pointList.add(offset);
    }

    final path = Path();
    for (int i = 0; i < pointCount; i++) {
      if (i == 0) {
        path.moveTo(pointList[i].dx, pointList[i].dy);
        continue;
      }
      path.arcToPoint(
        Offset(pointList[i].dx, pointList[i].dy),
        radius: Radius.circular(randomRadiusList[i]),
        // largeArc: true,
        clockwise: true,
      );
      if (i == pointCount - 1) {
        path.arcToPoint(
          Offset(pointList[0].dx, pointList[0].dy),
          radius: Radius.circular(randomRadiusList[0]),
          // largeArc: true,
          clockwise: true,
        );
      }
    }
    // path.close();

    // canvas.drawPath(basePath, basePaint);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
