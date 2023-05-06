import 'package:flutter/material.dart';
import 'package:makenotes/services/api_services.dart';

import '../models/Note.dart';

class NoteProvider with ChangeNotifier {
  bool isLoading = true;
  List<Note> notes = [];

  NoteProvider() {
    fetchNotes();
  }

  void sortNotes() {
    notes.sort((a, b) => b.dateadded!.compareTo(a.dateadded!));
  }

  void addNote(Note note) {
    print(note.userId);
    notes.add(note);
    sortNotes();
    notifyListeners();
    print(note.title);
    ApiServices.addNote(note);
  }

  void updateNode(Note note) {
    int indexOfNote = notes
        .indexOf(notes.firstWhere((element) => element.userId == note.userId));
    notes[indexOfNote] = note;
    sortNotes();
    notifyListeners();
    ApiServices.addNote(note);
  }

  void deleteNote(Note note) {
    int indexOfNote = notes
        .indexOf(notes.firstWhere((element) => element.userId == note.userId));
    notes.removeAt(indexOfNote);
    sortNotes();
    notifyListeners();
    ApiServices.deleteNote(note);
  }

  List<Note> findNote(String query) {
    return notes
        .where((element) =>
            element.title!.toLowerCase().contains(query.toLowerCase()) ||
            element.content!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void fetchNotes() async {
    notes = await ApiServices.fetchNotes('rahul007');
    sortNotes();
    isLoading = false;
    notifyListeners();
  }
}
