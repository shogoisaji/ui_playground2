import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_playground2/package/hovering_action.dart';

class PackageTestPage extends StatefulWidget {
  const PackageTestPage({super.key});

  @override
  State<PackageTestPage> createState() => _PackageTestPageState();
}

class _PackageTestPageState extends State<PackageTestPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Package Test Page'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 100),
              Container(
                width: 400,
                height: 100,
                // padding: const EdgeInsets.all(8),
                color: Colors.red.shade300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 250,
                      child: HoveringAction(
                        bounceMaxHeight: 100,
                        width: 100,
                        height: 150,
                        duration: const Duration(milliseconds: 1000),
                        // type: HoveringType.normal,
                        child: Container(
                            width: 100,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(child: Text('This is a package test page'))),
                      ),
                    ),
                    Container(
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(child: Text('This is a package test page')))
                  ],
                ),
              ),
              const SizedBox(height: 100),
              Container(
                width: 400,
                height: 100,
                // padding: const EdgeInsets.all(8),
                color: Colors.red.shade300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HoveringAction(
                      width: 100,
                      height: 150,
                      // shadow: false,
                      child: Container(
                          width: 50,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(child: Text('This is a package test page'))),
                    ),
                    Container(
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(child: Text('This is a package test page')))
                  ],
                ),
              ),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HoveringAction(
                      width: 100,
                      height: 150,
                      bounceMaxHeight: 100,
                      child: Image.asset('assets/images/sky.jpg', width: 200, height: 200, fit: BoxFit.cover)),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget customCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: [
          // 画像
          SizedBox(
            width: double.infinity,
            height: 128,
            child: Image.network(
              'https://source.unsplash.com/300x200/?bag',
              fit: BoxFit.cover,
            ),
          ),
          // タイトル
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              'タイトル',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          // 値段
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 4),
            child: const Text(
              '1000円',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // アイコンといいね数
          const Visibility(
            visible: true, // いいねが無い場合はfalseを設定する
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.black45,
                    size: 16,
                  ),
                ),
                Text(
                  '3',
                  style: TextStyle(color: Colors.black45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
