import 'package:mysql1/mysql1.dart';

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

  Future<void> closeConnection() async {
    await _conn.close();
  }
}
