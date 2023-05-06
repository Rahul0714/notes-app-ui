import 'package:flutter/material.dart';
import 'package:makenotes/services/api_services.dart';

import '../models/Note.dart';

class NoteProvider with ChangeNotifier {
  List<Note> notes = [];

  NoteProvider() {
    fetchNotes();
  }

  void addNote(Note note) {
    print(note.userId);
    notes.add(note);
    notifyListeners();
    print(note.title);
    ApiServices.addNote(note);
  }

  void updateNode(Note note) {
    int indexOfNote = notes
        .indexOf(notes.firstWhere((element) => element.userId == note.userId));
    notes[indexOfNote] = note;
    notifyListeners();
    ApiServices.addNote(note);
  }

  void deleteNote(Note note) {
    int indexOfNote = notes
        .indexOf(notes.firstWhere((element) => element.userId == note.userId));
    notes.removeAt(indexOfNote);
    notifyListeners();
    ApiServices.deleteNote(note);
  }

  void fetchNotes() async {
    List<Note> fetchedNotes = await ApiServices.fetchNotes('rahul007');
    print(fetchedNotes);
  }
}
