import 'package:flutter/material.dart';

class ListImageHover extends StatefulWidget {
  const ListImageHover({super.key});

  @override
  State<ListImageHover> createState() => _ListImageHoverState();
}

class _ListImageHoverState extends State<ListImageHover> {
  final scrollController = ScrollController();
  final contents = List.generate(
      100, (index) => "https://picsum.photos/200/300?random=$index");

  double tapedPosition = 0;
  int? tappedIndex;
  final oneContentHeight = 110;

  @override
  void initState() {
    super.initState();

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
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
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
                    index: tappedIndex!,
                    imageLink: contents[tappedIndex!],
                  ),
                )
              : const SizedBox.shrink()
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
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade300,
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

class SelectedWidget extends StatefulWidget {
  final int index;
  final String imageLink;
  const SelectedWidget(
      {super.key, required this.index, required this.imageLink});

  @override
  State<SelectedWidget> createState() => _SelectedWidgetState();
}

class _SelectedWidgetState extends State<SelectedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  final imageSize = 150.0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOutBack);
    super.initState();
    animationController.reset();
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
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
    return IgnorePointer(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Image ${widget.index}"),
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
            ],
          ),
        ),
      ),
    );
  }
}
