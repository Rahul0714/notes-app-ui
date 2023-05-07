import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:makenotes/pages/add_new_note.dart';
import 'package:makenotes/provider/notes_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'models/Note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";
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

  TextEditingController _initController = TextEditingController();

  Future<void> _dialogBuilderInitial(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Username'),
          content: TextField(
            controller: _initController,
            decoration: const InputDecoration(
                hintText: "Enter Your Username Correctly"),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Provider.of<NoteProvider>(context, listen: false)
                      .fetchNotes(_initController.text);
                  _initController.text = "";
                  Navigator.pop(context);
                },
                child: const Text("Submit"))
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _dialogBuilderInitial(context));
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
      body: (!noteProvider.isLoading)
          ? SafeArea(
              child: noteProvider.notes.isEmpty
                  ? const Center(
                      child: Text("No Notes yet"),
                    )
                  : ListView(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                            decoration:
                                const InputDecoration(hintText: "Search "),
                            onChanged: (val) {
                              setState(() {
                                searchQuery = val;
                              });
                            }),
                      ),
                      (noteProvider.findNote(searchQuery).length > 0)
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemCount:
                                  noteProvider.findNote(searchQuery).length,
                              itemBuilder: (context, index) {
                                Note currentNote =
                                    noteProvider.findNote(searchQuery)[index];
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
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentNote.title!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 21),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          currentNote.content!,
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.grey[700]),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text("No Notes Found"),
                            ),
                    ]),
            )
          : const Center(child: CircularProgressIndicator()),
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
