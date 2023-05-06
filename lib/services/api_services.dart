import 'dart:convert';
import 'dart:math';

import '../models/Note.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static String baseUrl = 'https://notes-app-api-qlwb.onrender.com/notes';
  static void addNote(Note note) async {
    Uri reqUri = Uri.parse("$baseUrl");
    var res = await http.post(reqUri);
    var decoded = jsonDecode(res.body);
    print(decoded.toString());
  }

  static void deleteNote(Note note) async {
    Uri reqUri = Uri.parse("$baseUrl/delete");
    var res = await http.post(reqUri, body: note.toMap());
    var decoded = jsonDecode(res.body);
    print(decoded.toString());
  }

  static Future<List<Note>> fetchNotes(String userId) async {
    Uri reqUri = Uri.parse("$baseUrl/list");
    var res = await http.post(reqUri, body: {"userId": userId});
    var decoded = jsonDecode(res.body);
    print("hi" + decoded.toString());
    print(res.body);
    return [];
  }
}
