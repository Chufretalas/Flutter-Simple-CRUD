import 'package:notas_simple_crud/database/database_helper.dart';

class Note {
  int? id;
  String title;
  String content;

  Note({
    this.id,
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.tableId: id,
      DatabaseHelper.tableTitle: title,
      DatabaseHelper.tableContent: content,
    };
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content}';
  }
}
