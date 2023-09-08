import 'package:mysql1/mysql1.dart';
import '../data/wellcoverLog.dart';

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
      print('Error connecting to database: $e');
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
      print('Error querying database: $e');
      return false;
    }
  }

  Future<List<WellCoverLog>> getWellCoverLogs() async {
    try {
      final result = await _conn.query('SELECT * FROM wellcoverlogs');
      final logs = <WellCoverLog>[];
      print('result: $result');
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
      print('Error querying wellcoverlogs table: $e');
      return [];
    }
  }

  Future<void> closeConnection() async {
    await _conn.close();
  }
}
