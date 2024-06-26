import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_playground2/pages/bottom_nav_page.dart';
import 'package:ui_playground2/pages/card_change_page.dart';
import 'package:ui_playground2/pages/cloud_page.dart';
import 'package:ui_playground2/pages/custom_amazon.dart';
import 'package:ui_playground2/pages/down_light_page.dart';
import 'package:ui_playground2/pages/follow_path_page.dart';
import 'package:ui_playground2/pages/heart.dart';
import 'package:ui_playground2/pages/image_paste_page.dart';
import 'package:ui_playground2/pages/list_image_hover.dart';
import 'package:ui_playground2/pages/metal_card.dart';
import 'package:ui_playground2/pages/overlay_test.dart';
import 'package:ui_playground2/pages/package_test_page.dart';
import 'package:ui_playground2/pages/rive_pull_to_refresh_page.dart';
import 'package:ui_playground2/pages/scroll_3d_page.dart';
import 'package:ui_playground2/pages/spin_image_pick_page.dart';
import 'package:ui_playground2/pages/text_action_page.dart';
import 'package:ui_playground2/pages/text_run/text_run_page.dart';
import 'package:ui_playground2/pages/transform_rotate.dart';

// 新しいpageを追加する場合は、pagesリストにMapを追加する
List<Map<String, dynamic>> pages = [
  {
    'name': 'custom_amazon',
    'page': const CustomAmazon(),
  },
  {
    'name': 'list_image_hover',
    'page': const ListImageHover(),
  },
  {
    'name': 'cloud',
    'page': const CloudPage(),
  },
  {
    'name': 'overlay_test',
    'page': const OverlayTest(),
  },
  {
    'name': 'transform_rotate',
    'page': const TransformRotate(),
  },
  {
    'name': 'scroll_3d',
    'page': const Scroll3dPage(),
  },
  {
    'name': 'bottom_nav',
    'page': const BottomNavPage(),
  },
  {
    'name': 'heart',
    'page': const HeartPage(),
  },
  {
    'name': 'metal_card',
    'page': const MetalCard(),
  },
  {
    'name': 'follow_path',
    'page': const FollowPathPage(),
  },
  {
    'name': 'text_action',
    'page': const TextActionPage(),
  },
  {
    'name': 'package_test',
    'page': const PackageTestPage(),
  },
  {
    'name': 'text_run',
    'page': TextRunPage(),
  },
  {
    'name': 'spin_image_pick',
    'page': const SpinImagePickPage(),
  },
  {
    'name': 'down_light',
    'page': const DownLightPage(),
  },
  {
    'name': 'rive_pull_to_refresh',
    'page': const RivePullToRefreshPage(),
  },
  {
    'name': 'card_change',
    'page': const CardChangePage(),
  },
  {
    'name': 'image_paste',
    'page': const ImagePastePage(),
  },
];

GoRouter router() {
  final routes = [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        const BREAKPOINT = 800;
        final w = MediaQuery.sizeOf(context).width;
        return Scaffold(
          backgroundColor: Colors.red[100],
          appBar: AppBar(
            backgroundColor: Colors.red[200],
            title: const Text('UI playground',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
          ),
          body: Center(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 8),
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: ListView.builder(
                      itemCount: pages.length,
                      itemBuilder: (context, index) => Card(
                        margin: const EdgeInsets.all(8),
                        color: Colors.pink[200],
                        child: ListTile(
                          onTap: () {
                            context.go('/${pages[index]['name']}');
                          },
                          title: Center(
                            child: Text(
                              '${pages[index]['name']}',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: w > BREAKPOINT ? 24 : 20,
                                  fontWeight: FontWeight.bold),
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
      },
      routes: [
        ...List.generate(
          pages.length,
          (index) => GoRoute(
            path: '${pages[index]['name']}',
            builder: (BuildContext context, GoRouterState state) {
              return pages[index]['page'];
            },
          ),
        ),
      ],
    ),
  ];

  return GoRouter(
    initialLocation: '/custom_amazon',
    routes: routes,
  );
}
