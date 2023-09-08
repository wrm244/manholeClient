import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Mainpage createState() => _Mainpage();
}

class _Mainpage extends State<Mainpage> {
  String? debugLable = 'Unknown';
  final JPush jpush = JPush();
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String? platformVersion;
    jpush.setAuth(enable: true);
    jpush.setup(
      appKey: "d322fd7dc53f6519184cdbae", //应用的 AppKey
      channel: "theChannel",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(
        const NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      print("flutter get registration id : $rid");
      setState(() {
        debugLable = "flutter getRegistrationID: $rid";
      });
    });

    // iOS要是使用应用内消息，请在页面进入离开的时候配置pageEnterTo 和  pageLeave 函数，参数为页面名。
    jpush.pageEnterTo("HomePage"); // 在离开页面的时候请调用 jpush.pageLeave("HomePage");

    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
  }

// 编写视图
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('井盖监控'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VlcPlayerScreen(), // 放置VlcPlayer
              const SizedBox(height: 20), // 增加间距
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomButton(
                    title: "发本地推送",
                    onPressed: () {
                      {
                        // 0.5秒后出发本地推送
                        var fireDate = DateTime.fromMillisecondsSinceEpoch(
                            DateTime.now().millisecondsSinceEpoch + 500);
                        var localNotification = LocalNotification(
                            id: 234,
                            title: '测试成功',
                            buildId: 1,
                            content: '推送测试成功',
                            fireTime: fireDate,
                            subtitle: '推送测试成功',
                            badge: 5,
                            extra: {"fa": "0"});
                        jpush
                            .sendLocalNotification(localNotification)
                            .then((res) {
                          setState(() {
                            debugLable = res;
                          });
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 20), // 增加间距
                  CustomButton(
                    title: "通知授权是否打开",
                    onPressed: () {
                      jpush.isNotificationEnabled().then((bool value) {
                        setState(() {
                          debugLable = "通知授权是否打开: $value";
                        });

                        // 显示通知
                        Fluttertoast.showToast(
                          msg: value ? "通知已打开" : "通知未打开",
                          toastLength: Toast.LENGTH_SHORT, // 设置通知显示时间
                          gravity: ToastGravity.TOP, // 设置通知位置
                          timeInSecForIosWeb: 1, // 设置通知显示时间（iOS和Web）
                          backgroundColor:
                              value ? Colors.green : Colors.red, // 根据通知状态设置背景颜色
                          textColor: Colors.white, // 设置通知文本颜色
                        );
                      }).catchError((onError) {
                        setState(() {
                          debugLable = "通知授权是否打开: ${onError.toString()}";
                        });

                        // 显示通知
                        Fluttertoast.showToast(
                          msg: "获取通知状态失败",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      });
                    },
                  ),
                  const SizedBox(width: 20), // 增加间距
                  CustomButton(
                    title: "打开系统设置",
                    onPressed: () {
                      jpush.openSettingsForNotification();
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomButton(
                      onPressed: () async {
                        // 清除登录状态
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('isLoggedIn', false);

                        // 导航回登录页面
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              (const SignInPage2()), // 这里使用你的登录页面的构建器
                        ));
                      },
                      title: "退出登陆"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// 封装控件
class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? title;

  const CustomButton(
      {super.key, @required this.onPressed, @required this.title});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        overlayColor: MaterialStateProperty.all(const Color(0xff888888)),
        backgroundColor: MaterialStateProperty.all(const Color(0xff585858)),
        padding:
            MaterialStateProperty.all(const EdgeInsets.fromLTRB(10, 5, 10, 5)),
      ),
      child: Text("$title"),
    );
  }
}

class VlcPlayerScreen extends StatefulWidget {
  @override
  _VlcPlayerScreenState createState() => _VlcPlayerScreenState();
}

class _VlcPlayerScreenState extends State<VlcPlayerScreen> {
  late VlcPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VlcPlayerController.network(
      'http://192.168.3.48:8081/0/stream', // 替换为你的直播流链接
      autoPlay: true,
      hwAcc: HwAcc.full,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.liveCaching(1000),
          VlcAdvancedOptions.networkCaching(1000)
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VlcPlayer(
        controller: _controller,
        aspectRatio: 640 / 480, // 根据你的视频流比例设置
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
