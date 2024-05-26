import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

class OverlayTest extends StatefulWidget {
  const OverlayTest({super.key});

  @override
  State<OverlayTest> createState() => _OverlayTestState();
}

class _OverlayTestState extends State<OverlayTest>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  double _blurValue = 0.0;

  late AnimationController _animationController;
  late Animation _animation;

  StateMachineController? controller;
  SMITrigger? trigger;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
        if (_animationController.status == AnimationStatus.completed) {
          _animationController.reverse();
        }
        setState(() {
          _blurValue = _animation.value * 5;
        });
      });
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutQuad));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void showModal() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Dialog(
        child: Center(
          child: Container(
            color: Colors.red,
            height: 200,
            child: Column(
              children: [
                const Text('This is a modal dialog'),
                ElevatedButton(
                  onPressed: hideModal,
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void hideModal() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Transform.scale(
              scale: 1.05 - 0.05 * _animation.value,
              child: Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0030)
                  // ..scale(1.00, 1.00, 1.00)
                  ..rotateX(-0.15 * _animation.value),
                // ..setEntry(1, 3, 0),
                child: Align(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: SizedBox(
                      width: w,
                      height: h,
                      child: Image.asset(
                        'assets/images/wallpaper.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: _blurValue, sigmaY: _blurValue),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                // color: Colors.black.withOpacity(0.5),
              ),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => Align(
                  alignment: Alignment(0.0, 0.7 - _animation.value * 2.0),
                  child: GestureDetector(
                      onTap: () {
                        trigger?.fire();
                        _animationController.reset();
                        _animationController.forward();
                      },
                      child: SizedBox(
                        width: 100.0 + 500 * _animation.value,
                        height: 100.0 + 500 * _animation.value,
                        child: RiveAnimation.asset(
                          'assets/rive/green.riv',
                          animations: const ['init'],
                          fit: BoxFit.contain,
                          onInit: (artboard) {
                            controller = StateMachineController.fromArtboard(
                                artboard, 'state')!;
                            if (controller == null) {
                              throw Exception(
                                  'Unable to initialize state machine controller');
                            }
                            artboard.addController(controller!);
                            trigger = controller!.findInput<bool>('show')
                                as SMITrigger;
                          },
                        ),
                      )
                      // Image.asset(
                      //   'assets/images/ball.png',
                      //   width: 100.0 + 150 * _animation.value,
                      //   height: 100.0 + 150 * _animation.value,
                      //   fit: BoxFit.cover,
                      // ),
                      )),
            )
          ],
        ));
  }
}
