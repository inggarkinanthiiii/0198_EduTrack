import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:edutrack/models/siswa/tugas_model.dart';

class TugasDatabase {
  static final TugasDatabase instance = TugasDatabase._init();
  static Database? _database;

  TugasDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tugas.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade, 
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tugas (
        id INTEGER PRIMARY KEY,
        judul TEXT,
        deskripsi TEXT,
        deadline TEXT,
        isSelesai INTEGER,
        status TEXT,
        file TEXT
      )
    ''');
  }


  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE tugas ADD COLUMN status TEXT');
      await db.execute('ALTER TABLE tugas ADD COLUMN file TEXT');
    }
  }

  Future<void> insertTugas(TugasModel tugas) async {
    final db = await instance.database;
    await db.insert(
      'tugas',
      tugas.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TugasModel>> getAllTugas() async {
    final db = await instance.database;
    final result = await db.query('tugas');
    return result.map((json) => TugasModel.fromMap(json)).toList();
  }

  Future<void> updateStatus(int id, bool isSelesai) async {
    final db = await instance.database;
    await db.update(
      'tugas',
      {'isSelesai': isSelesai ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('tugas');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
