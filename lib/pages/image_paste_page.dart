import 'package:flutter/material.dart';

class ImagePastePage extends StatefulWidget {
  const ImagePastePage({super.key});

  @override
  State<ImagePastePage> createState() => _ImagePastePageState();
}

class _ImagePastePageState extends State<ImagePastePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Image Paste'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(width: 300, color: Colors.red, child: Image.asset('assets/images/sky.jpg')),
          ),
        ],
      ),
    );
  }
}
