import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeartPage extends StatefulWidget {
  const HeartPage({super.key});

  @override
  State<HeartPage> createState() => _HeartPageState();
}

class _HeartPageState extends State<HeartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart'),
      ),
      body: Center(
          child: CustomPaint(
        size: const Size(200, 200),
        painter: HeartPainter(),
      )),
    );
  }
}

class HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Path path = Path();
// ハートの上部中央から開始
    path.moveTo(size.width * 0.5, size.height * 0.35);
// 左上のカーブ
    path.cubicTo(
      size.width * 0.15,
      size.height * 0.35,
      size.width * 0.1,
      size.height * 0.1,
      size.width * 0.5,
      size.height * 0.1,
    );
// 右上のカーブ
    path.cubicTo(
      size.width * 0.9,
      size.height * 0.1,
      size.width * 0.85,
      size.height * 0.35,
      size.width * 0.5,
      size.height * 0.35,
    );
// 下部の尖った部分
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.6,
      size.width * 0.5,
      size.height * 0.9,
    );
// パスを閉じる
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(HeartPainter oldDelegate) => false;
}
