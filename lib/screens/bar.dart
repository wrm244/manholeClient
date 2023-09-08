import 'package:flutter/material.dart';
import 'mainpage.dart';
import 'login.dart';
import 'WellCoverLogPageState.dart';

class Material3BottomNav extends StatefulWidget {
  const Material3BottomNav({Key? key}) : super(key: key);

  @override
  State<Material3BottomNav> createState() => _Material3BottomNavState();
}

class _Material3BottomNavState extends State<Material3BottomNav> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  String _appBarTitle = "井盖识别监控"; // 默认标题为首页

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle), // 使用标题变量
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // 禁止页面左右滑动
        onPageChanged: (int index) {
          setState(() {
            // 根据页面索引更新标题
            switch (index) {
              case 0:
                _appBarTitle = "井盖识别监控";
                break;
              case 1:
                _appBarTitle = "井盖监控日志";
                break;
              case 2:
                _appBarTitle = "个人";
                break;
            }
          });
        },
        children: const [
          Mainpage(),
          WellCoverLogPage(),
          Mainpage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(seconds: 1),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          });
        },
        destinations: _navBarItems,
      ),
    );
  }
}

const _navBarItems = [
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home_rounded),
    label: '主页',
  ),
  NavigationDestination(
    icon: Icon(Icons.bookmark_border_outlined),
    selectedIcon: Icon(Icons.bookmark_rounded),
    label: '日志',
  ),
  NavigationDestination(
    icon: Icon(Icons.person_outline_rounded),
    selectedIcon: Icon(Icons.person_rounded),
    label: '个人',
  ),
];
