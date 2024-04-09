import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PastImage {
  final Offset position;
  final Uint8List imageBytes;

  PastImage({required this.position, required this.imageBytes});
}

class SpinImagePickPage extends StatefulWidget {
  const SpinImagePickPage({super.key});

  @override
  State<SpinImagePickPage> createState() => _SpinImagePickPageState();
}

class _SpinImagePickPageState extends State<SpinImagePickPage> with TickerProviderStateMixin {
  PastImage? pastImage;
  Offset _pickImagePosition = const Offset(0, 0);
  late AnimationController _controller;
  late AnimationController _idleController;
  late AnimationController _pastController;
  late Animation<double> _animation;
  late Animation<double> _idleAnimation;

  final double pickImageSize = 150.0;

  Size imageSize = const Size(0, 0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _pastController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _idleAnimation = CurvedAnimation(parent: _idleController, curve: Curves.easeInOut);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _idleController.repeat(reverse: true);
      }
    });
    _pastController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        imagePast();
        _pastController.reset();
      }
    });
  }

  Uint8List? imageBytes;
  Future<void> pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      final Uint8List? convertedImageBytes = await image?.readAsBytes();
      if (convertedImageBytes == null) return;
      final Size size = await getImageSize(convertedImageBytes);
      setState(() {
        imageSize = size;
        imageBytes = convertedImageBytes;
      });
      pastImage = null;
      if (imageBytes == null) return;
      appearImage();
    } on PlatformException catch (_) {
      return;
    }
  }

  Future<Size> getImageSize(Uint8List imageBytes) async {
    final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return Size(
      frameInfo.image.width.toDouble(),
      frameInfo.image.height.toDouble(),
    );
  }

  void appearImage() {
    setState(() {
      _pickImagePosition = const Offset(0, 0);
    });
    _controller.reset();
    _controller.forward();
  }

  void imagePast() {
    _controller.reset();
    _idleController.reset();
    setState(() {
      pastImage = PastImage(position: _pickImagePosition, imageBytes: imageBytes!);
    });
    imageBytes = null;
    _pickImagePosition = const Offset(0, 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    // void moveImg() {
    //   final top = h / 2 - h / 2 * sin(_animation.value * pi / 2);
    //   final left = _animation.value * w - pickImageSize;
    //   setState(() {
    //     _pickImagePosition = Offset(left, top);
    //   });
    // }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.green.shade200,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // title: const Text('Spin Image Pick'),
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            pastImage != null
                ? Positioned(
                    top: pastImage!.position.dy,
                    left: pastImage!.position.dx,
                    child: Image.memory(
                      pastImage!.imageBytes,
                      width: pickImageSize,
                      // height: pickImageSize,
                    ),
                  )
                : const SizedBox.shrink(),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final top = h / 2 - h / 2 * sin(_animation.value * pi / 2) + pickImageSize / 2;
                final left = _animation.value * w - pickImageSize - 50;
                if (_controller.isAnimating) {
                  _pickImagePosition = Offset(left, top);
                }
                return Positioned(
                  top: _pickImagePosition.dy,
                  left: _pickImagePosition.dx,
                  child: imageBytes == null
                      ? const SizedBox.shrink()
                      : GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              print('dx: ${details.delta.dx}, dy: ${details.delta.dy}');
                              _pickImagePosition += details.delta;
                            });
                          },
                          child: AnimatedBuilder(
                              animation: _idleAnimation,
                              builder: (context, child) {
                                return SizedBox(
                                  width: pickImageSize,
                                  height: pickImageSize,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        child: SizedBox(
                                          width: pickImageSize,
                                          height: pickImageSize * imageSize.height / imageSize.width,
                                          child: CustomPaint(
                                            painter: MarkerPaint(
                                                color: Colors.black.withOpacity(0.7 * (_idleController.value * 2 % 1))),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: AnimatedBuilder(
                                          animation: _pastController,
                                          builder: (context, child) {
                                            return Transform(
                                              transform: Matrix4.identity()
                                                ..translate(100.0 - _pastController.value * 30,
                                                    0.0 - _idleAnimation.value * 20 + _pastController.value * 60, 0.0)
                                                ..scale(1.10 - 0.1 * _pastController.value,
                                                    1.10 - 0.1 * _pastController.value, 1.00)
                                                ..setEntry(3, 2, 0.0020 - _pastController.value * 0.0020)
                                                ..rotateX(0.82 - _pastController.value * 0.82)
                                                ..rotateY(pi * 2 * _animation.value + 0.4)
                                                ..rotateZ(0.2 - _pastController.value * 0.2),
                                              child: Transform.translate(
                                                offset: Offset(-pickImageSize / 2, -pickImageSize / 2),
                                                child: Image.memory(
                                                  imageBytes!,
                                                  fit: BoxFit.contain,
                                                  width: pickImageSize * _animation.value,
                                                  height: pickImageSize * _animation.value,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                );
              },
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: IconButton(
                onPressed: () async {
                  await pickImage();
                },
                icon: const Icon(Icons.add_a_photo),
              ),
            ),
            imageBytes != null
                ? Positioned(
                    bottom: 20,
                    left: 20,
                    child: IconButton(
                      onPressed: () {
                        _pastController.forward();
                      },
                      icon: const Icon(Icons.check),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class MarkerPaint extends CustomPainter {
  final Color color;
  const MarkerPaint({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const double length = 15.0;
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Path path1 = Path()
      ..moveTo(length, 0)
      ..lineTo(0, 0)
      ..lineTo(0, length);
    final Path path2 = Path()
      ..moveTo(0, size.height - length)
      ..lineTo(0, size.height)
      ..lineTo(length, size.height);
    final Path path3 = Path()
      ..moveTo(size.width - length, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, length);
    final Path path4 = Path()
      ..moveTo(size.width, size.height - length)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - length, size.height);

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
    canvas.drawPath(path3, paint);
    canvas.drawPath(path4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
