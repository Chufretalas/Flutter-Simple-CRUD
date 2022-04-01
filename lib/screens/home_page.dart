import 'package:flutter/material.dart';
import 'package:notas_simple_crud/database/database_helper.dart';

import '../models/note.dart';
import 'note_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notas"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: DatabaseHelper.instance.getNotes(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());

                case ConnectionState.done:
                  final List<Note> notes = snapshot.data as List<Note>;
                  if (notes.isEmpty) {
                    return const Expanded(
                      child: Center(child: Text("Lista vazia")),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final Note note = notes[index];
                          return Card(
                            color: ThemeData.dark().backgroundColor,
                            child: ListTile(
                              title: Text(note.title),
                              subtitle: Text(note.content),
                              trailing: GestureDetector(
                                child: Icon(Icons.edit),
                                onTap: () {
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NoteForm.editing(
                                                  editId: note.id,
                                                )),
                                      )
                                      .then(
                                        (value) => setState(() {}),
                                      );
                                },
                              ),
                              onLongPress: () {
                                DatabaseHelper.instance.delete(note.id!);
                                setState(() {});
                              },
                              onTap: () {
                                if (selectedId == note.id) {
                                  //_clearTextInputs();
                                  selectedId = null;
                                } else {
                                  selectedId = note.id;
                                }
                                setState(() {});
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }

                default:
                  return Text("Bruh");
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          selectedId = null;
          Navigator.of(context)
              .push(
                MaterialPageRoute(builder: (context) => NoteForm()),
              )
              .then(
                (value) => setState(() {}),
              );
        },
      ),
    );
  }
}
