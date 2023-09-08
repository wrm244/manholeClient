import 'package:mysql1/mysql1.dart';
import '../data/wellcoverLog.dart';
import '../data/camera.dart';

class DatabaseHelper {
  late MySqlConnection _conn;

  Future<bool> connect() async {
    try {
      _conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'server.gxist.cn',
        port: 3306,
        user: 'manhole',
        db: 'manhole',
        password: 'WiRxFFiBrTcZ4K58',
      ));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isUserExists(String username, String password) async {
    try {
      var result = await _conn.query(
          'select * from admins where username = ? and password = ?',
          [username, password]);
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<List<WellCoverLog>> getWellCoverLogs() async {
    try {
      final result = await _conn.query('SELECT * FROM wellcoverlogs');
      final logs = <WellCoverLog>[];
      for (var row in result) {
        final log = WellCoverLog(
          logID: row['LogID'],
          wellCoverID: row['WellCoverID'],
          dateTime: row['DateTime'],
          status: row['Status'],
          location: row['Location'],
          recognitionResult: row['RecognitionResult'],
          cameraID: row['CameraID'],
          algorithmVersion: row['AlgorithmVersion'],
          additionalInfo: row['AdditionalInfo'],
        );
        logs.add(log);
      }
      return logs;
    } catch (e) {
      return [];
    }
  }

  Future<List<Camera>> getCameras() async {
    try {
      final result = await _conn.query('SELECT * FROM cameras');
      final cameras = <Camera>[];
      for (var row in result) {
        final camera = Camera(
          cameraID: row['CameraID'],
          cameraName: row['CameraName'],
          location: row['Location'],
          description: row['Description'],
          installationDate: row['InstallationDate'],
          url: row['url'],
        );
        cameras.add(camera);
      }
      return cameras;
    } catch (e) {
      return [];
    }
  }

  Future<int> getUserCount() async {
    //获取员工数量
    try {
      final result = await _conn.query('SELECT COUNT(*) FROM admins');
      return result.first[0];
    } catch (e) {
      return 0;
    }
  }

  Future<int> getWellCoverCount() async {
    //获取井盖数量
    try {
      final result = await _conn.query('SELECT COUNT(*) FROM wellcovers');
      return result.first[0];
    } catch (e) {
      return 0;
    }
  }

  Future<int> getLogCount() async {
    //获取井盖日志数量
    try {
      final result = await _conn.query('SELECT COUNT(*) FROM wellcoverlogs');
      return result.first[0];
    } catch (e) {
      return 0;
    }
  }

  Future<void> closeConnection() async {
    await _conn.close();
  }
}
