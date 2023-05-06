import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:makenotes/pages/add_new_note.dart';
import 'package:makenotes/provider/notes_provider.dart';
import 'package:provider/provider.dart';

import 'models/Note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _dialogBuilder(BuildContext context, Note currentNote) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove this Note?'),
          content: const Text('This will permanantly remove the Note'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Keep'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Remove'),
              onPressed: () {
                Provider.of<NoteProvider>(context, listen: false)
                    .deleteNote(currentNote);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    NoteProvider noteProvider = Provider.of<NoteProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Make Notes"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: noteProvider.notes.isEmpty
            ? const Center(
                child: Text("No Notes yet"),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: noteProvider.notes.length,
                itemBuilder: (context, index) {
                  Note currentNote = noteProvider.notes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => AddNewNotePage(
                            isUpdate: true,
                            note: currentNote,
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      _dialogBuilder(context, currentNote);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentNote.title!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 21),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            currentNote.content!,
                            style: TextStyle(
                                fontSize: 17, color: Colors.grey[700]),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => const AddNewNotePage(
              isUpdate: false,
            ),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
