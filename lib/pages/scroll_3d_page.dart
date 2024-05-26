import 'package:flutter/material.dart';

class Scroll3dPage extends StatefulWidget {
  const Scroll3dPage({super.key});

  @override
  State<Scroll3dPage> createState() => _Scroll3dPageState();
}

class _Scroll3dPageState extends State<Scroll3dPage> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
      ),
      body: Center(
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0005)
            ..translate(100.0, 0.0, 0.0)
            ..rotateX(-1.26)
            ..rotateY(0.19)
            ..rotateZ(0.50),
          child: SizedBox(
              width: w * 0.8,
              height: h * 0.5,
              child: ListView.builder(
                clipBehavior: Clip.none,
                itemCount: 100,
                itemBuilder: (context, index) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0005)
                      ..rotateX(1.26),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Center(
                          child: Column(
                            children: [
                              Text(
                                'Item $index',
                                style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Content $index',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )),
        ),
      ),
    );
  }
}
