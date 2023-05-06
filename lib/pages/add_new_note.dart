import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:makenotes/provider/notes_provider.dart';
import 'package:provider/provider.dart';

import '../models/Note.dart';

class AddNewNotePage extends StatefulWidget {
  final bool isUpdate;
  final Note? note;
  const AddNewNotePage({super.key, required this.isUpdate, this.note});

  @override
  State<AddNewNotePage> createState() => _AddNewNotePageState();
}

class _AddNewNotePageState extends State<AddNewNotePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  FocusNode noteFocus = FocusNode();

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Title Cannot be Empty'),
          content: const Text('The Title of Your Note Cannot be Empty'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void addNewNote() {
    Note newNote = Note();
    newNote.userId = 'rahul007';
    newNote.title = _titleController.text;
    newNote.content = _contentController.text;
    newNote.dateadded = DateTime.now();

    NoteProvider noteProvider =
        Provider.of<NoteProvider>(context, listen: false);
    noteProvider.addNote(newNote);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      _titleController.text = widget.note!.title!;
      _contentController.text = widget.note!.content!;
    }
  }

  void updateNote() {
    widget.note!.title = _titleController.text;
    widget.note!.content = _contentController.text;
    widget.note!.dateadded = DateTime.now();
    Provider.of<NoteProvider>(context, listen: false).updateNode(widget.note!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (widget.isUpdate) {
                updateNote();
              } else {
                addNewNote();
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                onSubmitted: (val) {
                  if (val.isNotEmpty) {
                    noteFocus.requestFocus();
                  } else {
                    // print("Title cannot be Empty");
                    _dialogBuilder(context);
                  }
                },
                autofocus: (widget.isUpdate) ? false : true,
                style:
                    const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                    hintText: "Title", border: InputBorder.none),
              ),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  focusNode: noteFocus,
                  maxLines: null,
                  style: const TextStyle(fontSize: 21),
                  decoration: const InputDecoration(
                      hintText: "Note", border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
