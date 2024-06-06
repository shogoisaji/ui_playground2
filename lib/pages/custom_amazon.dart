import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

class CustomAmazon extends StatefulWidget {
  const CustomAmazon({super.key});

  @override
  State<CustomAmazon> createState() => _CustomAmazonState();
}

class _CustomAmazonState extends State<CustomAmazon>
    with SingleTickerProviderStateMixin {
  late AnimationController shoppingAnimationController;
  late Animation<double> shoppingAnimation;
  final GlobalKey<_BottomNavigatorState> bottomNavKey = GlobalKey();
  final GlobalKey<_SelectedWidgetState> selectedWidgetKey = GlobalKey();
  final scrollController = ScrollController();
  final contents = List.generate(
      100, (index) => "https://picsum.photos/200/300?random=$index");

  double tapedPosition = 0;
  int? tappedIndex;
  final oneContentHeight = 110;

  void toCart() {
    selectedWidgetKey.currentState?.onPlay();
    bottomNavKey.currentState?.onPlay();
    shoppingAnimationController.reset();
    shoppingAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        tappedIndex = null;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    shoppingAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    shoppingAnimation = CurvedAnimation(
        parent: shoppingAnimationController, curve: Curves.easeInOut);

    shoppingAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        shoppingAnimationController.reverse();
      }
    });

    /// スクロールしたらimageを消す
    scrollController.addListener(() {
      setState(() {
        tappedIndex = null;
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade300,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          ListView.builder(
              controller: scrollController,
              itemCount: contents.length,
              itemBuilder: (context, index) => _cardWidget(index)),
          tappedIndex != null
              ? Positioned(
                  top: tapedPosition,
                  left: 0,
                  right: 0,
                  child: SelectedWidget(
                    key: selectedWidgetKey,
                    index: tappedIndex!,
                    imageLink: contents[tappedIndex!],
                    tapedPosition: tapedPosition,
                    toCart: toCart,
                  ),
                )
              : const SizedBox.shrink(),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigator(
              key: bottomNavKey,
              shoppingAnimation: shoppingAnimation,
            ),
          ),
          // Align(
          //     alignment: Alignment.topCenter,
          //     child: ElevatedButton(
          //       child: const Text('button'),
          //       onPressed: () {
          //         selectedWidgetKey.currentState?.onPlay();
          //         bottomNavKey.currentState?.onPlay();
          //         shoppingAnimationController.reset();
          //         shoppingAnimationController.forward();
          //       },
          //     )),
        ],
      ),
    );
  }

  Widget _cardWidget(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          /// タップしたらindexを設定
          tappedIndex = index;

          /// タップしたら位置を設定
          tapedPosition = (index * oneContentHeight) - scrollController.offset;
        });
      },
      child: Card(
        color: Colors.blueGrey.shade600,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey.shade600,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Image $index"),
              Image(
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                image: NetworkImage(
                  contents[index],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavigator extends StatefulWidget {
  final Animation<double> shoppingAnimation;
  const BottomNavigator({super.key, required this.shoppingAnimation});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  late StateMachineController controller;
  late SMITrigger play;

  void onPlay() {
    play.fire();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      color: Colors.blueGrey.shade500,
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.home, color: Colors.white),
            const Icon(Icons.search, color: Colors.white),
            GestureDetector(
              onTap: onPlay,
              child: AnimatedBuilder(
                animation: widget.shoppingAnimation,
                builder: (context, child) => Transform.scale(
                  alignment: Alignment.bottomCenter,
                  scale: 1 + 5 * widget.shoppingAnimation.value,
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: RiveAnimation.asset(
                      'assets/rive/shopping.riv',
                      fit: BoxFit.contain,
                      onInit: (artboard) {
                        controller = StateMachineController.fromArtboard(
                            artboard, 'state')!;
                        artboard.addController(controller);
                        play = controller.findInput<bool>('play') as SMITrigger;
                      },
                    ),
                  ),
                ),
              ),
            ),
            const Icon(Icons.account_box, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class SelectedWidget extends StatefulWidget {
  final int index;
  final String imageLink;
  final double tapedPosition;
  final Function toCart;
  const SelectedWidget(
      {super.key,
      required this.index,
      required this.imageLink,
      required this.tapedPosition,
      required this.toCart});

  @override
  State<SelectedWidget> createState() => _SelectedWidgetState();
}

class _SelectedWidgetState extends State<SelectedWidget>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  late AnimationController shoppingAnimationController;
  late Animation<double> shoppingAnimation;
  final imageSize = 150.0;

  void onPlay() {
    shoppingAnimationController.forward();
  }

  void toCart() {
    widget.toCart();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOutBack);
    shoppingAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    shoppingAnimation = CurvedAnimation(
        parent: shoppingAnimationController, curve: Curves.easeInOut);
    shoppingAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        shoppingAnimationController.reset();
      }
    });
    animationController.reset();
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    shoppingAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SelectedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      animationController.reset();
      animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Card(
      color: Colors.blueGrey.shade100,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Image ${widget.index}"),
                ElevatedButton(
                    onPressed: () {
                      toCart();
                    },
                    child: Text('Cart',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey.shade700,
                          fontWeight: FontWeight.bold,
                        ))),
              ],
            ),
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) => Transform(
                /// タップした際の動きを設定
                transform: Matrix4.identity()
                  ..translate(imageSize / 2, 0, 0)
                  ..rotateX(0.2)
                  ..rotateY(3.5 * animation.value)
                  ..translate(-imageSize / 2, -10 * animation.value, 0)
                  ..scale(1.0 + 0.5 * animation.value,
                      1.0 + 0.5 * animation.value, 1),
                child: AnimatedBuilder(
                  animation: shoppingAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(
                        -shoppingAnimation.value * 40,
                        shoppingAnimation.value *
                            (h - widget.tapedPosition - 300)),
                    child: Transform(
                      transform: Matrix4.identity()
                        ..translate(imageSize / 2, 0, 0)
                        ..rotateX(0.2)
                        ..rotateY(3.5 * shoppingAnimation.value)
                        ..translate(-imageSize / 2, 0, 0)
                        ..scale(1.0 - 0.8 * shoppingAnimation.value,
                            1.0 - 0.8 * shoppingAnimation.value, 1),
                      child: Image(
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget.imageLink,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
