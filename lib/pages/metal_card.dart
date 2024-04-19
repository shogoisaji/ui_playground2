import 'dart:math';

import 'package:flutter/material.dart';

class MetalCard extends StatefulWidget {
  const MetalCard({super.key});

  @override
  State<MetalCard> createState() => _MetalCardState();
}

class _MetalCardState extends State<MetalCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1700),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform(
              origin: const Offset(150, 100),
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0005)
                ..rotateX(cos(_animation.value * 2 * 3.14) * 0.2)
                ..rotateY(sin(_animation.value * 2 * 3.14) * 0.1),
              child: Container(
                  width: 300,
                  height: 200,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueGrey[600]!,
                        Colors.blueGrey[500]!,
                        Colors.blueGrey[400]!,
                        Colors.blueGrey[200]!,
                        Colors.blueGrey[200]!,
                        Colors.blueGrey[400]!,
                        Colors.blueGrey[500]!,
                        Colors.blueGrey[600]!,
                      ],
                      begin: Alignment(4 - 8 * _animation.value, -1),
                      end: Alignment(5 - 8 * _animation.value, 1),
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(4 + sin(_animation.value * 2 * 3.14),
                              7 + 2 * sin(_animation.value * 2 * 3.14)),
                          blurRadius: 3 + 3 * sin(_animation.value * 2 * 3.14),
                          spreadRadius:
                              2 + 2 * sin(_animation.value * 2 * 3.14)),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _animationController.forward();
                      _animationController.addStatusListener((status) {
                        if (status == AnimationStatus.completed) {
                          _animationController.reverse();
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blueGrey[900]!,
                            Colors.blueGrey[800]!,
                            Colors.blueGrey[900]!,
                          ],
                          begin: Alignment(4 - 8 * _animation.value, -1),
                          end: Alignment(5 - 8 * _animation.value, 1),
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('CREDIT CARD',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold)),
                          Text('1234 5678 9012 3456',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('1,000,000円',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 28)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            );
          },
        ),
      ),
    );
  }
}
