import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';

class Database {
  Future<PostgreSQLConnection> openConnection() async {
    return PostgreSQLConnection(
      env['DATABASE_HOST'] ?? env['databaseHost'] ?? '',
      int.tryParse(env['DATABASE_PORT'] ?? env['databasePort'] ?? '') ?? 5432,
      env['DATABASE_NAME'] ?? env['databaseName'] ?? '',
      username: env['DATABASE_USER'] ?? env['databaseUser'],
      password: env['DATABASE_PASSWORD'] ?? env['databasePassword'],
    );
  }
}
