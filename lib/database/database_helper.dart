import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class DatabaseHelper {
  DatabaseHelper.privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  static Database? _database;

  static const String tableName = 'notes';
  static const String tableId = 'id';
  static const String tableTitle = 'title';
  static const String tableContent = 'content';

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName(
        $tableId INTEGER PRIMARY KEY,
        $tableTitle TEXT,
        $tableContent TEXT
      )
    ''');
  }

  Future<int> add(Note note) async {
    Database db = await instance.database;
    debugPrint('add: ${note.toMap().toString()}');
    return await db.insert(
      tableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<Note> getOneNote(int id) async {
    List<Note> notes = await instance.getNotes();
    late Note selectedNote;
    for(Note note in notes){
      if(note.id == id){
        selectedNote = note;
        break;
      }
    }
    return selectedNote;
  }

  Future<List<Note>> getNotes() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i][tableId],
        title: maps[i][tableTitle],
        content: maps[i][tableContent],
      );
    });
  }

  Future<int> update(Note note) async {
    Database db = await instance.database;
    return await db.update(tableName, note.toMap(),
        where: 'id = ?', whereArgs: [note.id]);
  }

}
