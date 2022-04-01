import 'package:flutter/material.dart';
import 'package:notas_simple_crud/database/database_helper.dart';

import '../models/note.dart';

class NoteForm extends StatefulWidget {
  final int? editId;

  NoteForm({this.editId});

  NoteForm.editing({required this.editId});

  @override
  State<NoteForm> createState() => _NoteFormState(editId);
}

class _NoteFormState extends State<NoteForm> {
  late final String appBarTitle;
  final int? editId;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  _NoteFormState(this.editId) {
    if (editId != null) {
      appBarTitle = "Editar nota";
      _setEditMode(editId);
    } else {
      appBarTitle = "Nova nota";
    }
  }

  void _setEditMode(id) async {
    Note note = await DatabaseHelper.instance.getOneNote(id);
    titleController.text = note.title;
    contentController.text = note.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(Icons.save),
            ),
            onTap: () async {
              if (titleController.text == '')
                _callSnackBar("Título vazio");
              else if (contentController.text == '')
                _callSnackBar("Texto vazio");
              else {
                if (editId == null) {
                  await DatabaseHelper.instance.add(Note(
                    title: titleController.text,
                    content: contentController.text,
                  ));
                } else {
                  await DatabaseHelper.instance.update(Note(
                    id: editId,
                    title: titleController.text,
                    content: contentController.text,
                  ));
                }
                _clearTextInputs();
                setState(() {});
                Navigator.of(context).pop(context);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InputBox(hintText: "Título", controller: titleController),
            InputBox(
              hintText: "Digite algo...",
              controller: contentController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }

  void _clearTextInputs() {
    titleController.text = '';
    contentController.text = '';
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _callSnackBar(
      String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }
}

class InputBox extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int? maxLines;

  InputBox({
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: hintText),
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }
}
