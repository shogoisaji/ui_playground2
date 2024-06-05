import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class CloudContainer extends StatefulWidget {
  /// [waveCount] - 波の数,
  /// [color] - コンテナの色,
  /// [width] - コンテナの幅,
  /// [height] - コンテナの高さ,
  /// [waveRadius] - 波の半径,
  /// [touchStrength] - タッチの強さ,
  /// [child] - 子ウィジェット,
  /// [borderWidth] - 境界線の幅,
  /// [borderColor] - 境界線の色（デフォルトは黒）
  const CloudContainer({
    super.key,
    required this.waveCount,
    required this.color,
    required this.width,
    required this.height,
    required this.waveRadius,
    required this.touchStrength,
    this.child,
    this.borderWidth,
    this.borderColor = Colors.black,
  });

  final int waveCount;
  final Color color;
  final double width;
  final double height;
  final double waveRadius;
  final double touchStrength;
  final Widget? child;
  final double? borderWidth;
  final Color borderColor;

  @override
  State<CloudContainer> createState() => _CloudContainerState();
}

class _CloudContainerState extends State<CloudContainer>
    with TickerProviderStateMixin {
  /// wave animation controller and animation
  late AnimationController _waveAnimationController;
  late Animation _waveAnimation;

  /// tap animation controller and animation
  late AnimationController _touchAnimationController;
  late Animation _touchAnimation;

  /// wave radius add random value
  final List<double> randomRadiusAdjustList = [];

  /// is show base line
  ///
  /// for TEST
  ///
  bool isShowBaseLine = true;
  // bool isShowBaseLine = false;

  /// touch position management numbering clockwise
  int touchIndex = 0;

  /// wave shape base point list
  final List<Offset> basePointList = [];

  /// touch move point delta list : touch to change delta
  final touchPointDeltas = List.generate(12, (_) => const Offset(0.0, 0.0));

  /// variable
  double waveBaseRectWidth = 0.0;
  double waveBaseRectHeight = 0.0;

  void setWaveBaseRectSize() {
    setState(() {
      waveBaseRectWidth = widget.width - widget.waveRadius * 2;
      waveBaseRectHeight = widget.height - widget.waveRadius * 2;
    });
  }

  void setBasePointList() {
    basePointList.clear();
    basePointList.addAll([
      const Offset(0, 0),
      Offset(waveBaseRectWidth / 4, 0),
      Offset(waveBaseRectWidth / 2, 0),
      Offset(waveBaseRectWidth * 3 / 4, 0),
      Offset(waveBaseRectWidth, 0),
      Offset(waveBaseRectWidth, waveBaseRectHeight / 2),
      Offset(waveBaseRectWidth, waveBaseRectHeight),
      Offset(waveBaseRectWidth * 3 / 4, waveBaseRectHeight),
      Offset(waveBaseRectWidth / 2, waveBaseRectHeight),
      Offset(waveBaseRectWidth / 4, waveBaseRectHeight),
      Offset(0, waveBaseRectHeight),
      Offset(0, waveBaseRectHeight / 2),
    ]);
  }

  /// set random radius adjust list
  void setRandomList() {
    final oneLength =
        (waveBaseRectWidth * 2 + waveBaseRectHeight * 2) / widget.waveCount;
    randomRadiusAdjustList.clear();
    randomRadiusAdjustList.addAll(
      List.generate(
          widget.waveCount, (_) => Random().nextDouble() * oneLength / 8),
    );
  }

  /// point をタッチした時のデルタを計算
  void setPointDelta(
    int index,
  ) {
    switch (index) {
      case 0:
        touchPointDeltas[index] = Offset(
                waveBaseRectWidth / 7 * _touchAnimation.value,
                waveBaseRectHeight / 5 * _touchAnimation.value) *
            widget.touchStrength;
      case 1:
        touchPointDeltas[index] = Offset(
                waveBaseRectWidth / 15 * _touchAnimation.value,
                waveBaseRectHeight / 5 * _touchAnimation.value) *
            widget.touchStrength;
      case 2:
        touchPointDeltas[index] = Offset(0 * _touchAnimation.value as double,
                waveBaseRectHeight / 4 * _touchAnimation.value) *
            widget.touchStrength;
      case 3:
        touchPointDeltas[index] = Offset(
                -waveBaseRectWidth / 15 * _touchAnimation.value,
                waveBaseRectHeight / 5 * _touchAnimation.value) *
            widget.touchStrength;
      case 4:
        touchPointDeltas[index] = Offset(
                -waveBaseRectWidth / 7 * _touchAnimation.value,
                waveBaseRectHeight / 5 * _touchAnimation.value) *
            widget.touchStrength;
      case 5:
        touchPointDeltas[index] = Offset(
                -waveBaseRectWidth / 10 * _touchAnimation.value,
                0 * _touchAnimation.value as double) *
            widget.touchStrength;
      case 6:
        touchPointDeltas[index] = Offset(
                -waveBaseRectWidth / 7 * _touchAnimation.value,
                -waveBaseRectHeight / 5 * _touchAnimation.value) *
            widget.touchStrength;
      case 7:
        touchPointDeltas[index] = Offset(
                -waveBaseRectWidth / 15 * _touchAnimation.value,
                -waveBaseRectHeight / 5 * _touchAnimation.value) *
            widget.touchStrength;
      case 8:
        touchPointDeltas[index] = Offset(0 * _touchAnimation.value as double,
                -waveBaseRectHeight / 4 * _touchAnimation.value) *
            widget.touchStrength;
      case 9:
        touchPointDeltas[index] = Offset(
                waveBaseRectWidth / 15 * _touchAnimation.value,
                -waveBaseRectHeight / 5 * _touchAnimation.value) *
            widget.touchStrength;
      case 10:
        touchPointDeltas[index] = Offset(
                waveBaseRectWidth / 7 * _touchAnimation.value,
                -waveBaseRectHeight / 5 * _touchAnimation.value) *
            widget.touchStrength;
      case 11:
        touchPointDeltas[index] = Offset(
                waveBaseRectWidth / 10 * _touchAnimation.value,
                0 * _touchAnimation.value as double) *
            widget.touchStrength;
      default:
    }
  }

  @override
  void initState() {
    super.initState();

    /// wave animation
    _waveAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);
    _waveAnimation = Tween<double>(begin: 0, end: 0.03).animate(CurvedAnimation(
        parent: _waveAnimationController, curve: Curves.easeInOut));

    /// touch animation
    _touchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _touchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _touchAnimationController, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {
          setPointDelta(touchIndex);
        });
      });

    setWaveBaseRectSize();
    setRandomList();
    setBasePointList();
  }

  @override
  void dispose() {
    _waveAnimationController.dispose();
    _touchAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CloudContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.width != oldWidget.width || widget.height != oldWidget.height) {
      setWaveBaseRectSize();
      setRandomList();
      setBasePointList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        color: Colors.transparent,
        width: widget.width,
        height: widget.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _waveAnimation,
                builder: (context, child) => CustomPaint(
                  painter: CloudPainter(
                      color: widget.color,
                      waveBaseRectWidth: waveBaseRectWidth,
                      waveBaseRectHeight: waveBaseRectHeight,
                      animationValue: _waveAnimation.value,
                      waveRadius: widget.waveRadius,
                      waveCount: widget.waveCount,
                      randomRadiusList: randomRadiusAdjustList,
                      isShowBaseLine: isShowBaseLine,
                      pointDeltas: touchPointDeltas,
                      basePointList: basePointList,
                      borderWidth: widget.borderWidth,
                      borderColor: widget.borderColor),
                  size: Size(waveBaseRectWidth, waveBaseRectHeight),
                ),
              ),
            ),
            Center(
              child: Container(
                  width: waveBaseRectWidth,
                  height: waveBaseRectHeight,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: widget.child),
            ),
            SizedBox(
              width: double.infinity,
              height: widget.height,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: widget.width / widget.height * 3 / 5,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                ),
                itemCount: 15,
                itemBuilder: (context, index) {
                  /// touch action object
                  return GestureDetector(
                    onTap: () {
                      _touchAnimationController.reset();
                      setState(() {
                        if (index < 5) {
                          touchIndex = index;
                        } else if (index == 5) {
                          touchIndex = 11;
                        } else if (index == 9) {
                          touchIndex = 5;
                        } else {
                          touchIndex = 10 - (1 + (index - 11));
                        }

                        _touchAnimationController.forward().then((value) {
                          _touchAnimationController.reverse();
                        });
                      });
                    },

                    /// 確認用
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isShowBaseLine
                                ? Colors.black
                                : Colors.transparent),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CloudPainter extends CustomPainter {
  CloudPainter({
    required this.color,
    required this.waveBaseRectWidth,
    required this.waveBaseRectHeight,
    required this.animationValue,
    required this.waveRadius,
    required this.waveCount,
    required this.randomRadiusList,
    required this.isShowBaseLine,
    required this.pointDeltas,
    required this.basePointList,
    required this.borderWidth,
    required this.borderColor,
  });
  final Color color;
  final double waveBaseRectWidth;
  final double waveBaseRectHeight;
  final double animationValue;
  final double waveRadius;
  final int waveCount;
  final List<double> randomRadiusList;
  final List<Offset> pointDeltas;
  final List<Offset> basePointList;
  final bool isShowBaseLine;
  final double? borderWidth;
  final Color borderColor;

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

  /// 確認用
  void _drawPoint(Canvas canvas, List<Offset> points) {
    final fillPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final point in points) {
      canvas.drawCircle(point, 4, fillPaint);
      canvas.drawCircle(point, 4, strokePaint);
    }
  }

  void _drawCloud(Canvas canvas, Path basePath, List<Offset> pointList) {
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    /// shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final cloudPath = Path();

    for (int i = 0; i < waveCount; i++) {
      if (i == 0) {
        cloudPath.moveTo(pointList[i].dx, pointList[i].dy);
        continue;
      }
      cloudPath.arcToPoint(
        Offset(pointList[i].dx, pointList[i].dy),
        radius: Radius.circular(waveRadius - randomRadiusList[i]),
        // largeArc: true,
        clockwise: true,
      );
      if (i == waveCount - 1) {
        cloudPath.arcToPoint(
          Offset(pointList[0].dx, pointList[0].dy),
          radius: Radius.circular(waveRadius - randomRadiusList[0]),
          // largeArc: true,
          clockwise: true,
        );
      }
    }
    cloudPath.close();

    /// shadow paint
    canvas.drawPath(cloudPath.shift(const Offset(3, 3)), shadowPaint);

    /// fill paint
    canvas.drawPath(cloudPath, fillPaint);

    /// borderを描画する場合
    if (borderWidth != null) {
      final strokePaint = Paint()
        ..color = borderColor
        ..strokeWidth = borderWidth!
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      canvas.drawPath(cloudPath, strokePaint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final pointList = <Offset>[];
    const p1 = Offset(0, 0);
    final p2 = Offset(waveBaseRectWidth, 0);
    final p3 = Offset(waveBaseRectWidth, waveBaseRectHeight);
    final p4 = Offset(0, waveBaseRectHeight);

    final basePath = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..lineTo(p4.dx, p4.dy)
      ..close();

    final adjustedBpList = List<Offset>.generate(basePointList.length, (i) {
      return basePointList[i] + pointDeltas[i];
    });

    final basePath1 = Path();
    for (int i = 0; i < adjustedBpList.length; i++) {
      if (i == 0) {
        basePath1.moveTo(adjustedBpList[i].dx, adjustedBpList[i].dy);
        continue;
      } else {
        basePath1.lineTo(adjustedBpList[i].dx, adjustedBpList[i].dy);
      }
    }
    basePath1.close();

    final basePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    /// 動く点ををリストに追加
    for (int i = 0; i < waveCount; i++) {
      final progress = (i / waveCount + animationValue) % 1
          //  +0.02
          -
          randomRadiusList[i] / 500; // ランダムを加える

      final offset = getOffset(basePath1, progress) ?? const Offset(0, 0);
      pointList.add(offset);
    }

    _drawCloud(canvas, basePath, pointList);

    /// 確認用
    if (isShowBaseLine) {
      canvas.drawPath(basePath1, basePaint);
      _drawPoint(canvas, adjustedBpList);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
