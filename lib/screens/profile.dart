import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/database.dart';

// ignore: must_be_immutable
class ProfilePage1 extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const ProfilePage1({Key? key});
  @override
  _ProfilePage1State createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<ProfilePage1> {
  late int userCount = 0;
  late int wellCovercount = 0;
  late int logCount = 0;
  bool isLoading = true; // 控制加载指示器显示
  @override
  void initState() {
    super.initState();
    fetchCount();
  }

  Future<void> fetchCount() async {
    final dbHelper = DatabaseHelper();
    final isConnected = await dbHelper.connect();

    if (isConnected) {
      try {
        final usercount = await dbHelper.getUserCount();
        final wellcovercount = await dbHelper.getWellCoverCount();
        final logcount = await dbHelper.getLogCount();
        setState(() {
          userCount = usercount;
          wellCovercount = wellcovercount;
          logCount = logcount;
          isLoading = false; // 数据加载完成后停止加载指示器
        });
      } catch (e) {
        // 显示错误提示
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('数据获取失败，请稍后重试'),
          ),
        );
        setState(() {
          isLoading = false; // 数据加载失败后停止加载指示器
        });
      } finally {
        await dbHelper.closeConnection();
      }
    } else {
      // 显示连接超时提示
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('数据获取超时，请稍后重试'),
        ),
      );
      setState(() {
        isLoading = false; // 连接超时后停止加载指示器
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "管理员",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          _launchURL('tel:12345678912'); // 传入要拨打的电话号码
                        },
                        heroTag: 'phone',
                        elevation: 0,
                        label: const Text("联系工作人员"),
                        icon: const Icon(Icons.phone),
                      ),
                      const SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        onPressed: () async {
                          // 清除登录状态
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool('isLoggedIn', false);

                          // 导航回登录页面
                          // ignore: use_build_context_synchronously
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                (const SignInPage2()), // 这里使用你的登录页面的构建器
                          ));
                        },
                        heroTag: 'mesage',
                        elevation: 0,
                        backgroundColor: Colors.red,
                        label: const Text("退出登入"),
                        icon: const Icon(Icons.logout),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    // _TopPortion(),
                    _ProfileInfoRow(
                        userCount: userCount,
                        wellCovercount: wellCovercount,
                        logCount: logCount),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw '无法拨打电话 $url';
    }
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final int userCount; // 接受 userCount 参数
  final int wellCovercount;
  final int logCount;

  const _ProfileInfoRow(
      {Key? key,
      required this.userCount,
      required this.wellCovercount,
      required this.logCount})
      : super(key: key);

  List<ProfileInfoItem> get _items => [
        ProfileInfoItem("井盖数量", wellCovercount),
        ProfileInfoItem("日志总数", logCount),
        ProfileInfoItem("员工人数", userCount),
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
                    child: Row(
                  children: [
                    if (_items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://img.ixintu.com/download/jpg/20200804/ca13015cc94391873609f59343587302_512_512.jpg!con')),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
