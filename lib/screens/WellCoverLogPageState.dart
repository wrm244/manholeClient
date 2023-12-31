// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../data/wellcoverLog.dart';
import '../services/database.dart';
import 'package:intl/intl.dart';

class WellCoverLogPage extends StatefulWidget {
  const WellCoverLogPage({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _WellCoverLogPageState createState() => _WellCoverLogPageState();
}

class _WellCoverLogPageState extends State<WellCoverLogPage> {
  late List<WellCoverLog> wellCoverLogs = [];
  bool isLoading = true; // 控制加载指示器显示

  @override
  void initState() {
    super.initState();
    fetchWellCoverLogs();
  }

  Future<void> fetchWellCoverLogs() async {
    final dbHelper = DatabaseHelper();
    final isConnected = await dbHelper.connect();

    if (isConnected) {
      try {
        final logs = await dbHelper.getWellCoverLogs();
        setState(() {
          wellCoverLogs = logs;
          isLoading = false; // 数据加载完成后停止加载指示器
        });
      } catch (e) {
        // 显示错误提示
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('日志数据获取失败，请稍后重试'),
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
          content: Text('日志数据获取超时，请稍后重试'),
        ),
      );
      setState(() {
        isLoading = false; // 连接超时后停止加载指示器
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      body: Column(
        children: [
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(), // 显示加载指示器
            )
          else if (wellCoverLogs.isEmpty)
            const Center(
              child: Text('暂无日志数据，请稍后再试或检查连接。'),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('编号')),
                  DataColumn(label: Text('状态')),
                  DataColumn(label: Text('位置')),
                  DataColumn(label: Text('时间')),
                  // 添加其他要显示的列
                ],
                rows: wellCoverLogs.map((log) {
                  Color rowColor = Colors.transparent; // 默认背景颜色为透明
                  // 根据log.status的值设置背景颜色
                  if (log.status == 1) {
                    rowColor = const Color.fromARGB(
                        166, 130, 226, 133); // 井盖识别成功，设置为绿色
                  } else {
                    rowColor = const Color.fromRGBO(
                        241, 134, 126, 0.753); // 井盖丢失，设置为红色
                  }
                  return DataRow(
                    color: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return rowColor; // 返回根据log.status计算的背景颜色
                      },
                    ),
                    cells: [
                      DataCell(Text('${log.logID}')),
                      DataCell(Text(log.status == 1 ? '井盖识别成功' : '井盖丢失')),
                      DataCell(Text(log.location ?? '')),
                      DataCell(
                        Text(dateFormatter.format(log.dateTime.toLocal())),
                      ),
                      // 添加其他要显示的数据单元格
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
