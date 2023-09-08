import 'package:mysql1/mysql1.dart';

class RemoteDatabase {
  late MySqlConnection _connection;

  RemoteDatabase({
    required String host,
    required int port,
    required String user,
    required String password,
    required String db,
  }) {
    connect(host, port, user, password, db);
  }

  Future<void> connect(
      String host, int port, String user, String password, String db) async {
    try {
      _connection = await MySqlConnection.connect(ConnectionSettings(
        host: host,
        port: port,
        user: user,
        db: db,
        password: password,
      ));
    } catch (e) {
      print('Error connecting to database: $e');
    }
  }

  Future<bool> isUserName(String username) async {
    try {
      var result = await _connection
          .query('select * from admins where username = ?', [username]);
      return result.isNotEmpty;
    } catch (e) {
      print('Error querying database: $e');
      return false; // 在发生异常时，假设用户名不存在
    }
  }

  void closeConnection() async {
    try {
      await _connection.close();
    } catch (e) {
      print('Error closing connection: $e');
    }
  }
}
