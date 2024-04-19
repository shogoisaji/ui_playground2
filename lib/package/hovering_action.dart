library hovering_action;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui_playground2/package/hovering_type.dart';

class HoveringAction extends StatefulWidget {
  final AnimationController? animationController;
  final Duration duration;
  final double bounceMaxHeight;
  final bool shadow;
  final HoveringType type;
  final double width;
  final double height;
  final Widget child;
  const HoveringAction({
    super.key,
    this.animationController,
    this.duration = const Duration(milliseconds: 3000),
    this.bounceMaxHeight = 10.0,
    this.shadow = true,
    this.type = HoveringType.normal,
    required this.width,
    required this.height,
    required this.child,
  }) : assert(bounceMaxHeight > 0);

  @override
  State<HoveringAction> createState() => _HoveringActionState();
}

class _HoveringActionState extends State<HoveringAction> with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  late AnimationController _animationController;
  late Animation<double> _animation;

  Size renderingSize = Size.zero;
  final double _currentBounceHeight = 0;

  // void calcBounceHeight(AnimationController controller, int bounceCount) {
  //   final tween = Tween(begin:  0.0 , end: index % 2 == 0 ? 1.0 : 0.0);
  //   setState(() {
  //     _currentBounceHeight = tween.animate(controller).value * widget.bounceMaxHeight;
  //   });
  // }

  @override
  void initState() {
    super.initState();

    _animationController = widget.animationController ??
        AnimationController(
          vsync: this,
          duration: widget.duration,
        );
    _animationController.repeat(reverse: true);
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    // _animationController.addListener(() {
    //   calcBounceHeight(_animationController, 2);
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          renderingSize = renderBox.size;
        });
      } else {
        print('Error: Expected a RenderBox, but did not find one.');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 200,
      // height: 200,
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              children: [
                widget.shadow
                    ? Positioned.fill(
                        child: RepaintBoundary(
                          child: CustomPaint(
                            painter: ShadowPainter(
                              shadowSize: Size(widget.width, widget.height * 0.1),
                            ),
                          ),
                        ),
                      )
                    :  const SizedBox.shrink(),
                Transform(
                  transform: Matrix4.identity()..translate(0, -_animation.value * widget.bounceMaxHeight, 0.0),
                  child: SizedBox(key: _key, child: widget.child),
                ),
              ],
            );
          }),
    );
  }
}

class ShadowPainter extends CustomPainter {
  final Size shadowSize;
  final double opacity;
  ShadowPainter({required this.shadowSize, this.opacity = 0.2});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black.withOpacity(opacity)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    // final double shadowWidth = ((size.width - currentBounceHeight * 1) * 0.9).clamp(0.0, size.width);
    // final Paint paint = Paint()
    //   ..color = Colors.black.withOpacity((hoveringObjectWidth - currentBounceHeight) / hoveringObjectWidth * 0.2)
    //   ..style = PaintingStyle.fill
    //   ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    // final double shadowWidth = ((hoveringObjectWidth - currentBounceHeight * 1) * 0.9).clamp(0.0, hoveringObjectWidth);

    final Rect rect = Rect.fromLTWH(0, 0, shadowSize.width, shadowSize.height);

    final Path path = Path()..addOval(rect);

    canvas.drawPath(path.shift(Offset(0, size.height - shadowSize.height / 2)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
