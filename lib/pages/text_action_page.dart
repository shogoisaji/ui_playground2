import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class TextActionPage extends StatefulWidget {
  const TextActionPage({super.key});

  @override
  _TextActionPageState createState() => _TextActionPageState();
}

class _TextActionPageState extends State<TextActionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final _textController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  bool trigger = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: TextOnPathPainter(_animation.value,
                      text: _textController.text),
                  size: const Size(300, 300),
                );
              },
            ),
            SizedBox(
              width: 300,
              child: TextField(
                obscuringCharacter: ' ',
                controller: _textController,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                    // hintText: 'Enter text',
                    ),
                onChanged: (text) {
                  setState(() {});
                  print(text);
                },
              ),
            ),
            // Expanded(
            //   child: CharacterText(
            //     text: _textController.text,
            //     trigger: trigger,
            //   ),
            // ),
            // const SizedBox(height: 80),
            // ElevatedButton(
            //   onPressed: () {
            //     _focusNode.requestFocus();
            //     print('focus');
            //   },
            //   child: const Text('focus'),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       trigger = !trigger;
            //     });
            //   },
            //   child: const Text('Trigger'),
            // ),
          ],
        ),
      ),
    );
  }
}

class CharacterText extends StatelessWidget {
  final String text;
  final bool trigger;

  const CharacterText({
    super.key,
    required this.text,
    required this.trigger,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: text.split('').map((char) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: CharacterWidget(
              char: char,
              trigger: trigger,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CharacterWidget extends StatefulWidget {
  final String char;
  final bool trigger;

  const CharacterWidget({
    super.key,
    required this.char,
    required this.trigger,
  });

  @override
  _CharacterWidgetState createState() => _CharacterWidgetState();
}

class _CharacterWidgetState extends State<CharacterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  didUpdateWidget(CharacterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trigger != widget.trigger) {
      if (widget.trigger) {
        _controller.forward(from: 0.0);
      } else {
        _controller.reverse(from: 1.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: sin(_animation.value * pi * 2),
          child: child,
        );
      },
      child: Text(
        widget.char,
        style: const TextStyle(
          fontSize: 24,
          letterSpacing: -5.0,
        ),
      ),
    );
  }
}

class TextOnPathPainter extends CustomPainter {
  final double percent;
  final String text;

  TextOnPathPainter(this.percent, {required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.cubicTo(size.width, 0, size.width, size.height / 2, size.width / 2,
        size.height / 2);
    path.cubicTo(
        0, size.height / 2, 0, size.height, size.width / 2, size.height);

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 24, color: Colors.black),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // パスの長さを取得
    List<PathMetric> pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isNotEmpty) {
      // 複数のパスセグメントに対応するためにループを使用
      for (PathMetric pathMetric in pathMetrics) {
        double pathLength = pathMetric.length;

        final tangent = pathMetric.getTangentForOffset(pathLength * percent);
        if (tangent != null) {
          final offset = tangent.position;
          textPainter.paint(canvas, offset);
          // 一つのセグメントに対してのみ描画を行いたい場合は、ループを抜ける
          break;
        }
      }
    } else {
      print('pathMetrics is empty');
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
