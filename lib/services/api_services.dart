import 'dart:convert';
import 'dart:math';

import '../models/Note.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static String baseUrl = 'https://notes-app-api-qlwb.onrender.com/notes';
  static Future<void> addNote(Note note) async {
    try {
      Uri reqUri = Uri.parse("$baseUrl/add");
      var res = await http.post(
        reqUri,
        body: note.toMap(),
      );

      var decoded = jsonDecode(res.body);
      // print(decoded.toString());
    } catch (err) {
      print(err);
    }
  }

  static Future<void> deleteNote(Note note) async {
    Uri reqUri = Uri.parse("$baseUrl/delete");
    var res = await http.post(reqUri, body: note.toMap());
    var decoded = jsonDecode(res.body);
    print(decoded.toString());
  }

  static Future<List<Note>> fetchNotes(String userId) async {
    Uri reqUri = Uri.parse("$baseUrl/list");
    var res = await http.post(reqUri, body: {"userId": userId});
    var decoded = jsonDecode(res.body);

    List<Note> notes = [];
    for (var note in decoded) {
      Note newNote = Note.fromMap(note);
      notes.add(newNote);
    }
    return notes;
  }
}
