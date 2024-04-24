import 'dart:ui';

import 'package:flutter/material.dart';

class NavItem {
  Icon icon;
  Function onTap;
  Path? path;
  Offset? moveOffset;
  NavItem(
      {required this.icon, this.path, this.moveOffset, required this.onTap});

  NavItem copyWith({Offset? moveOffset, Path? path}) {
    return NavItem(
      icon: icon,
      onTap: onTap,
      path: path ?? this.path,
      moveOffset: moveOffset ?? this.moveOffset,
    );
  }
}

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BottomNav(
              navItems: [
                NavItem(
                    icon:
                        Icon(Icons.home, color: Colors.grey.shade100, size: 36),
                    onTap: () {}),
                NavItem(
                    icon: Icon(Icons.search,
                        color: Colors.grey.shade100, size: 36),
                    onTap: () {}),
                NavItem(
                    icon:
                        Icon(Icons.add, color: Colors.grey.shade100, size: 36),
                    onTap: () {}),
                NavItem(
                    icon: Icon(Icons.favorite,
                        color: Colors.grey.shade100, size: 32),
                    onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CusotomCurve extends Curve {
  final strength = 5.0;
  double _bounce(double t) {
    if (t < 1.2 / 2.75) {
      return 7.4 * t * t;
    } else if (t < 2.0 / 2.75) {
      t -= 1.05 / 2.75;
      return 7.4 * t * t + 0.95;
    } else if (t < 2.5 / 2.75) {
      t -= 1.5 / 2.75;
      return 7.4 * t * t + 0.97;
    }
    t -= 2.2 / 2.75;
    return 7.4 * t * t + 0.99;
  }

  @override
  double transformInternal(double t) {
    return _bounce(t);
  }
}

class BottomNav extends StatefulWidget {
  final List<NavItem> navItems;
  const BottomNav({super.key, required this.navItems});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _controller;
  late Animation<double> _animation;
  final double _height = 100.0;
  final double _itemWidth = 50.0;

  final int _currentIndex = 0;

  List<NavItem> _navItems = [];
  List<Offset> _initialItemsOffsetList = List.filled(4, Offset.zero);
  final List<Offset> _itemsOffsetList = List.filled(4, Offset.zero);
  int _pushedIndex = 0;
  bool isShowPath = false;
  double moveProgress = 0.0;

  Path createPath(double width, Offset position, int index) {
    const strength = 60.0;
    final p1 = Offset(position.dx, 0.3 * -strength);
    final p2 = Offset(width / 2, 1.5 * -strength);
    final p3 = Offset(width / 2, 0);

    final p01 = Offset(position.dx, 0.8 * -strength);
    final p02 = Offset(position.dx + width / 5, 1.5 * -strength);
    final p03 = Offset(position.dx + width / 5, -_itemWidth / 2.2);

    final p04 = Offset(position.dx + width / 5, 0.7 * -strength);
    final p05 = Offset(width / 2, 1.5 * -strength);
    final p06 = Offset(width / 2, 0);

    final p11 = Offset(position.dx, 1.0 * -strength);
    final p12 = Offset(width / 2.3, -strength / 2);
    final p13 = Offset(width / 2.2, -_itemWidth / 2.8);

    final p14 = Offset(width / 2.1, -strength * 0.8);
    final p15 = Offset(width / 2, 0.3 * -strength);
    final p16 = Offset(width / 2, 0);

    final p21 = Offset(position.dx, 2.0 * -strength);
    final p22 = Offset(width / 2.3, -strength / 2);
    final p23 = Offset(width / 2.2, -_itemWidth / 2.8);

    final p24 = Offset(width / 2.1, -strength * 0.8);
    final p25 = Offset(width / 2, 1.5 * -strength);
    final p26 = Offset(width / 2, 0);

    final p31 = Offset(position.dx, 0.8 * -strength);
    final p32 = Offset(width - 20, -strength);
    final p33 = Offset(width - _itemWidth / 2.8, -strength);

    final p34 = Offset(width - _itemWidth / 2.8, -strength * 2);
    final p35 = Offset(width / 2, 1.5 * -strength);
    final p36 = Offset(width / 2, 0);
    final path = Path();
    path.moveTo(position.dx, position.dy);

    if (index == 0) {
      path.cubicTo(
        p01.dx,
        p01.dy,
        p02.dx,
        p02.dy,
        p03.dx,
        p03.dy,
      );
      path.cubicTo(
        p04.dx,
        p04.dy,
        p05.dx,
        p05.dy,
        p06.dx,
        p06.dy,
      );
    } else if (index == 1) {
      path.cubicTo(
        p11.dx,
        p11.dy,
        p12.dx,
        p12.dy,
        p13.dx,
        p13.dy,
      );
      path.cubicTo(
        p14.dx,
        p14.dy,
        p15.dx,
        p15.dy,
        p16.dx,
        p16.dy,
      );
    } else if (index == 2) {
      path.cubicTo(
        p21.dx,
        p21.dy,
        p22.dx,
        p22.dy,
        p23.dx,
        p23.dy,
      );
      path.cubicTo(
        p24.dx,
        p24.dy,
        p25.dx,
        p25.dy,
        p26.dx,
        p26.dy,
      );
    } else if (index == 3) {
      path.cubicTo(
        p31.dx,
        p31.dy,
        p32.dx,
        p32.dy,
        p33.dx,
        p33.dy,
      );
      path.cubicTo(
        p34.dx,
        p34.dy,
        p35.dx,
        p35.dy,
        p36.dx,
        p36.dy,
      );
    } else {
      path.cubicTo(
        p1.dx,
        p1.dy,
        p2.dx,
        p2.dy,
        p3.dx,
        p3.dy,
      );
    }

    return path;
  }

  void initMoveOffset(List<Offset> offsetList) {
    for (int i = 0; i < _navItems.length; i++) {
      _navItems[i] = _navItems[i].copyWith(
        moveOffset: offsetList[i],
      );
    }
  }

  Offset? getOffset(Path path, double progress) {
    List<PathMetric> pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isEmpty) {
      return null;
    }
    double pathLength = pathMetrics.first.length;
    final distance = pathLength * progress;
    final Tangent? tangent = pathMetrics.first.getTangentForOffset(distance);
    final offset = tangent?.position;
    if (offset == null) {
      return null;
    }
    return Offset(offset.dx, -offset.dy + _itemWidth);
  }

  @override
  void initState() {
    super.initState();

    _navItems = widget.navItems;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: CusotomCurve(),
    );
    _controller.addListener(() {
      setState(() {
        initMoveOffset(_initialItemsOffsetList);
        moveProgress = _animation.value;
        _navItems[_pushedIndex] = _navItems[_pushedIndex].copyWith(
            moveOffset: getOffset(
          _navItems[_pushedIndex].path ?? Path(),
          moveProgress,
        ));
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final w = MediaQuery.sizeOf(context).width;
      setState(() {
        _initialItemsOffsetList = [
          Offset(w / 7, _height / 5),
          Offset(w * 2.4 / 7, _height / 5),
          Offset(w * 4.6 / 7, _height / 5),
          Offset(w * 6 / 7, _height / 5),
        ];
      });
      for (int i = 0; i < _navItems.length; i++) {
        _navItems[i] = _navItems[i].copyWith(
          path: createPath(w, _initialItemsOffsetList[i], i),
        );
      }
      for (int i = 0; i < _navItems.length; i++) {
        _navItems[i] = _navItems[i].copyWith(
          moveOffset: _initialItemsOffsetList[i],
        );
      }
      print(_navItems[2].moveOffset);
      setState(() {});
      // initMoveOffset(_initialItemsOffsetList);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    return Container(
      color: Colors.grey.shade300,
      height: h - kToolbarHeight - 80,
      width: w,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  child: PageView(
                controller: _pageController,
                children: [
                  Container(
                    color: const Color.fromARGB(255, 153, 113, 99),
                    child: const Center(
                      child: Text('Home',
                          style: TextStyle(color: Colors.white, fontSize: 60)),
                    ),
                  ),
                  Container(
                      color: Colors.indigo,
                      child: const Center(
                        child: Text(
                          'Search',
                          style: TextStyle(color: Colors.white, fontSize: 60),
                        ),
                      )),
                  Container(
                    color: const Color.fromARGB(255, 69, 195, 217),
                    child: const Center(
                      child: Text('Add',
                          style: TextStyle(color: Colors.white, fontSize: 60)),
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 187, 206, 79),
                    child: const Center(
                      child: Text('Favorite',
                          style: TextStyle(color: Colors.white, fontSize: 60)),
                    ),
                  ),
                ],
              )),
            ],
          ),
          Positioned(
            bottom: 0,
            child: CustomPaint(
              painter: BottomNavStagePainter(
                itemWidth: _itemWidth,
                height: _height,
                color: Colors.green.shade400,
              ),
              size: Size(w, _height),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    initMoveOffset(_initialItemsOffsetList);
                  },
                  child: const Text('reset'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isShowPath = !isShowPath;
                    });
                  },
                  child: const Text('path'),
                ),
              ],
            ),
          ),
          ..._navItems.map((item) {
            final index = _navItems.indexOf(item);
            return Positioned(
              // bottom: 20,
              bottom: (_navItems[index].moveOffset != null
                      ? _navItems[index].moveOffset!.dy
                      : -_initialItemsOffsetList[index].dy) +
                  _itemWidth / 2,
              left: (_navItems[index].moveOffset != null
                      ? _navItems[index].moveOffset!.dx
                      : _initialItemsOffsetList[index].dx) -
                  _itemWidth / 2,
              // left: 120 * index.toDouble(),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _pageController.jumpToPage(index);
                    _pushedIndex = index;
                    _controller.reset();
                    _controller.forward();
                  });
                },
                child: Container(
                  width: _itemWidth,
                  height: _itemWidth,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/ball.png'),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blueGrey.withOpacity(0.2),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 3.0,
                        spreadRadius: 1.0,
                        offset: const Offset(0, 1.5),
                      ),
                    ],
                  ),
                  child: item.icon,
                ),
              ),
            );
          }),
          ..._navItems.map((item) {
            final index = _navItems.indexOf(item);
            return isShowPath
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: ItemOrbitPainter(
                          path: _navItems[index].path != null
                              ? _navItems[index].path!
                              : Path(),
                        ),
                        size: Size(w, _height),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

class BottomNavStagePainter extends CustomPainter {
  final double itemWidth;
  final double height;
  final Color color;
  const BottomNavStagePainter(
      {required this.itemWidth, required this.height, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const double itemWidthOffsetValue = 5;
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color.fromARGB(255, 90, 152, 150),
          Color.fromARGB(255, 89, 107, 167),
          Color.fromARGB(255, 22, 72, 105),
          // Color.fromARGB(255, 52, 195, 190),
          // Color.fromARGB(255, 52, 187, 155),
          // Color.fromARGB(255, 16, 115, 129),
        ],
        begin: Alignment(-0.1, -1.9),
        end: Alignment(0.0, 1.9),
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    var path = Path();
    path.moveTo(0, 2 * height);
    path.lineTo(0, height);
    path.lineTo(size.width / 2 - itemWidth / 2 - itemWidthOffsetValue, height);
    path.arcToPoint(
      Offset(size.width / 2 + itemWidth / 2 + itemWidthOffsetValue, height),
      radius: Radius.circular(itemWidth / 2 + itemWidthOffsetValue),
      clockwise: false,
    );
    path.lineTo(size.width, height);
    path.lineTo(size.width, 2 * height);
    path.close();

    canvas.drawPath(path.shift(Offset(0, -height)), shadowPaint);
    canvas.drawPath(path.shift(Offset(0, -height)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ItemOrbitPainter extends CustomPainter {
  final Path path;
  const ItemOrbitPainter({required this.path});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
