import 'package:sqflite/sqflite.dart' as sql;

class SqlHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute(""" 
    CREATE TABLE weatherReport(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, temperature DOUBLE,wind_speed DOUBLE)
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'weatherStationApp',
      version: 1,
      onCreate: (db, version) async {
        await createTable(db);
        print('db created');
      },
    );
  }

  static Future<int> saveWeatherTosqflite(double temp, double windSpeed) async {
    final db = await SqlHelper.db();
    final data = {'temperature': temp, "wind_speed": windSpeed};
    final id = await db.insert('weatherReport', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getSavedWeatherFromSqflite() async {
    final db = await SqlHelper.db();
    return db.query(
      'weatherReport',
      orderBy: 'id DESC',
    );
  }
}
