import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';


class LocalDatabaseFactory {
  Future<Database> createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'grup.db');

    var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
    return database;
  }

  void populateDb(Database db, int version) async {
    await _createChatTable(db);
    await _createMessagesTable(db);
  }

  _createChatTable(Database db) async {
    await db
        .execute(
      """CREATE TABLE chats(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            isGroup INTEGER DEFAULT 0,
            count INTEGER DEFAULT 0,
            members BLOB DEFAULT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
            )""",
    )
        .then((_) => print('creating table chats...'))
        .catchError((e) => print('error creating chats table: $e'));
  }

  _createMessagesTable(Database db) async {
    await db
        .execute("""
          CREATE TABLE messages(
            chat_id TEXT NOT NULL,
            id INTEGER PRIMARY KEY,
            sender TEXT NOT NULL,
            receiver TEXT NOT NULL,
            message TEXT NOT NULL,
            received_at TIMESTAMP NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
            )
      """)
        .then((_) => print('creating table messages'))
        .catchError((e) => print('error creating messages table: $e'));
  }
}