import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DownLightPage extends StatefulWidget {
  const DownLightPage({super.key});

  @override
  State<DownLightPage> createState() => _DownLightPageState();
}

class _DownLightPageState extends State<DownLightPage>
    with SingleTickerProviderStateMixin {
  final Size containerSize = const Size(300, 200);

  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation =
        Tween<double>(begin: 0, end: containerSize.width + containerSize.height)
            .animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  Size shadowSize = const Size(0, 0);
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    const double containerPositionY = 100.0;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final double shadowSizeHeight =
                    (_animation.value).clamp(0, containerSize.height);
                final double shadowSizeWidth =
                    _animation.value > containerSize.height
                        ? _animation.value - containerSize.height
                        : 0;

                return Positioned(
                  top: containerPositionY,
                  left: containerSize.width - shadowSizeWidth - 50,
                  child: Container(
                    width: shadowSizeWidth + 50,
                    height: shadowSizeHeight,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange
                              .withOpacity(0.5 * _controller.value),
                          blurRadius: 25,
                          spreadRadius: 10,
                          offset: const Offset(15, 25),
                        ),
                        BoxShadow(
                          color: Colors.yellow
                              .withOpacity(0.5 * _controller.value),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: const Offset(7, 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: containerPositionY,
              left: 0,
              child: Container(
                width: containerSize.width,
                height: containerSize.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 3,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      AppSettings.openAppSettings();
                    },
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Switch(
                  activeTrackColor: Colors.orange,
                  value: isOn,
                  onChanged: (value) => setState(() {
                    isOn = value;
                    isOn ? _controller.forward() : _controller.reverse();
                  }),
                )),
          ],
        ),
      ),
    );
  }
}
