import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import '../services/database.dart';
import '../data/camera.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Mainpage createState() => _Mainpage();
}

class _Mainpage extends State<Mainpage> {
  String? debugLable = 'Unknown';
  bool isLoading = true; // 控制加载指示器显示
  late List<Camera> cameras = [];
  int selectedCameraID = 1;
  bool changeVedio = false;
  final JPush jpush = JPush();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    fetchCamera();
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

  Future<void> fetchCamera() async {
    final dbHelper = DatabaseHelper();
    final isConnected = await dbHelper.connect();

    if (isConnected) {
      try {
        final Cameras = await dbHelper.getCameras();
        setState(() {
          cameras = Cameras;
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

// 编写视图
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cameras.isNotEmpty && !changeVedio
                ? Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "摄像头ID: ${cameras[selectedCameraID - 1].cameraID}",
                                style: const TextStyle(fontSize: 15)),
                            Text(
                                "    地点: ${cameras[selectedCameraID - 1].location}",
                                style: const TextStyle(fontSize: 15)),
                          ]),
                      VlcPlayerScreen(
                          videoUrl: cameras[selectedCameraID - 1].url),
                    ],
                  )
                : const CircularProgressIndicator(), // 加载指示器
            const SizedBox(height: 20), // 增加间距
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomButton(
                  title: "测试推送",
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
              children: [
                CameraSelectionButton(
                  // 摄像头选择按钮
                  cameras: cameras,
                  onCameraSelected: (selectedCamera) {
                    // 选择摄像头后更新视图
                    setState(() {
                      changeVedio = !changeVedio;
                      selectedCameraID = int.parse(selectedCamera);
                    });
                  },
                ),
              ],
            )
          ],
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
        overlayColor:
            MaterialStateProperty.all(Color.fromARGB(255, 22, 95, 206)),
        backgroundColor:
            MaterialStateProperty.all(const Color.fromARGB(193, 7, 62, 180)),
        padding:
            MaterialStateProperty.all(const EdgeInsets.fromLTRB(10, 5, 10, 5)),
      ),
      child: Text("$title"),
    );
  }
}

class VlcPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VlcPlayerScreen({super.key, required this.videoUrl});
  @override
  // ignore: library_private_types_in_public_api
  _VlcPlayerScreenState createState() => _VlcPlayerScreenState();
}

class _VlcPlayerScreenState extends State<VlcPlayerScreen> {
  late VlcPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VlcPlayerController.network(
      widget.videoUrl, // 替换为你的直播流链接
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

class CameraSelectionButton extends StatefulWidget {
  final List<Camera> cameras; // 摄像头URL列表
  final Function(String) onCameraSelected; // 回调函数，用于选择摄像头

  const CameraSelectionButton(
      {super.key, required this.cameras, required this.onCameraSelected});

  @override
  // ignore: library_private_types_in_public_api
  _CameraSelectionButtonState createState() => _CameraSelectionButtonState();
}

class _CameraSelectionButtonState extends State<CameraSelectionButton> {
  String selectedCamera = '';

  void _showCameraSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '选择摄像头',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                for (int i = 0; i < widget.cameras.length; i++)
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedCamera = widget.cameras[i].cameraID.toString();
                      });
                      Navigator.of(context).pop(); // 关闭对话框
                      widget.onCameraSelected(selectedCamera);
                    },
                    child: ListTile(
                      title: Text(
                          '监控ID:${i + 1}    地点:${widget.cameras[i].location}'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            _showCameraSelectionDialog(context);
          },
          child: const Text('选择摄像头'),
        ),
      ],
    );
  }
}
