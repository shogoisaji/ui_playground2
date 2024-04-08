import 'dart:math';

import 'package:flutter/material.dart';

class CardChangePage extends StatefulWidget {
  const CardChangePage({super.key});

  @override
  State<CardChangePage> createState() => _CardChangePageState();
}

class _CardChangePageState extends State<CardChangePage> with TickerProviderStateMixin {
  late AnimationController _moveController;
  late AnimationController _colorController;
  late Animation<double> _colorAnimation;

  final scaleTween = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
      weight: 0.5,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 1.2).chain(CurveTween(curve: Curves.easeInOut)),
      weight: 1.0,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
      weight: 1.3,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 1.0),
      weight: 0.7,
    ),
  ]);
  final moveTween = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 30.0, end: 170.0).chain(CurveTween(curve: Curves.easeOut)),
      weight: 1.0,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 170.0, end: 30.0).chain(CurveTween(curve: Curves.easeIn)),
      weight: 1.0,
    ),
  ]);

  final rotateTween = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 0.0, end: 0.0),
      weight: 0.5,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 0.0, end: pi * 3).chain(CurveTween(curve: Curves.easeInOut)),
      weight: 1.7,
    ),
    TweenSequenceItem(
      tween: Tween(begin: pi * 3, end: pi * 3),
      weight: 0.5,
    ),
  ]);

  static const Color bgColor1 = Color(0xffECEABE);
  static const Color bgColor2 = Color(0xff24283F);
  Color bgColor = bgColor1;

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _moveController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });

    _moveController.addListener(() {
      if (bgColor == bgColor1) {
        if (_moveController.value > 0.65) {
          _colorController.forward();
        }
      } else {
        if (_moveController.value < 0.35) {
          _colorController.forward();
        }
      }
    });
    _colorController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _colorController.reset();
        setState(() {
          print('change color');
          bgColor = bgColor == bgColor1 ? bgColor2 : bgColor1;
        });
      }
    });
    _colorAnimation = CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInQuart,
    );
  }

  @override
  void dispose() {
    _moveController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _colorController,
            builder: (context, child) {
              return Positioned(
                right: 70 - _colorAnimation.value * (w > h ? w : h),
                bottom: 50 - _colorAnimation.value * (w > h ? w : h),
                child: Container(
                  width: _colorAnimation.value * (w > h ? w : h) * 3,
                  height: _colorAnimation.value * (w > h ? w : h) * 3,
                  decoration: BoxDecoration(
                    color: bgColor == bgColor1 ? bgColor2 : bgColor1,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _moveController,
            builder: (context, child) {
              return Positioned(
                right: 70,
                bottom: moveTween.animate(_moveController).value,
                child: GestureDetector(
                  onTap: () {
                    if (_moveController.status == AnimationStatus.completed) {
                      _moveController.reverse();
                      return;
                    }
                    _moveController.forward();
                  },
                  child: Transform.rotate(
                    angle: rotateTween.animate(_moveController).value,
                    child: Container(
                      width: 50 * scaleTween.animate(_moveController).value,
                      height: 100 * scaleTween.animate(_moveController).value,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue.shade200,
                            Colors.blue.shade300,
                            Colors.blue.shade800,
                            Colors.blue.shade900,
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.sunny,
                            size: 36,
                            color: Colors.orange.shade700,
                          ),
                          Icon(
                            Icons.mode_night,
                            size: 32,
                            color: Colors.yellow.shade300,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(
                height: 80,
                padding: const EdgeInsets.only(bottom: 12),
                color: Colors.blueGrey[600],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.home,
                        size: 40,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        print('add');
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.map,
                        size: 40,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        print('add');
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings,
                        size: 40,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        print('add');
                      },
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
