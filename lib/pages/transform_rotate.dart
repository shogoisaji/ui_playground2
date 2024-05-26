import 'dart:math';

import 'package:flutter/material.dart';

class TransformRotate extends StatefulWidget {
  const TransformRotate({super.key});

  @override
  State<TransformRotate> createState() => _TransformRotateState();
}

class _TransformRotateState extends State<TransformRotate>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transform Rotate'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
              alignment: const Alignment(0, 0.9),
              child: SizedBox(
                  width: 400,
                  height: 50,
                  child: Slider(
                    value: controller.value,
                    onChanged: (value) {
                      controller.value = value;
                    },
                  ))),
          AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Align(
                  alignment: const Alignment(0, 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..translate(w / 2 * animation.value - 100, 0.0, 0.0)
                      ..rotateY(animation.value * pi / 4),
                    child: Container(
                      color: Colors.blue,
                      width: 200,
                      height: 200,
                      child: const Center(
                        child: Text(
                          'Hello',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
