import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_playground2/widgets/cloud_container.dart';
import 'package:ui_playground2/widgets/cloud_r_container.dart';

class CloudPage extends StatefulWidget {
  const CloudPage({super.key});

  @override
  State<CloudPage> createState() => _CloudPageState();
}

class _CloudPageState extends State<CloudPage> with TickerProviderStateMixin {
  double waveBaseRectWidth = 300;
  double waveBaseRectHeight = 150;

  void handleChangeWidth(double width) {
    setState(() {
      waveBaseRectWidth = width;
    });
  }

  void handleChangeHeight(double height) {
    setState(() {
      waveBaseRectHeight = height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade600,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CloudRContainer(
                  waveCount: 35,
                  color: Colors.blue.shade200,
                  width: waveBaseRectWidth,
                  height: waveBaseRectHeight,
                  waveRadius: 18,
                  touchStrength: 1.0,
                  borderWidth: 3,
                  borderColor: Colors.blue,
                ),
                CloudRContainer(
                  waveCount: 35,
                  color: Colors.blue.shade200,
                  width: waveBaseRectWidth,
                  height: waveBaseRectHeight,
                  waveRadius: 18,
                  touchStrength: 1.0,
                  borderWidth: 3,
                  borderColor: Colors.blue,
                  isShowBaseLine: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'World',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 22,
                                // fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          print('Hello');
                        },
                        icon: const Icon(Icons.delete, size: 36),
                      ),
                    ],
                  ),
                ),
                CloudContainer(
                  waveCount: 20,
                  color: Colors.green.shade300,
                  width: waveBaseRectWidth,
                  height: waveBaseRectHeight,
                  waveRadius: 25,
                  touchStrength: 2.5,
                ),
                const SizedBox(height: 50),
                const Text('width'),
                Slider(
                  value: waveBaseRectWidth,
                  min: 100,
                  max: 300,
                  onChanged: (value) {
                    handleChangeWidth(value);
                  },
                ),
                const Text('height'),
                Slider(
                  value: waveBaseRectHeight,
                  min: 100,
                  max: 200,
                  onChanged: (value) {
                    handleChangeHeight(value);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
