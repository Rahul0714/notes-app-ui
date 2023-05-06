class Note {
  String? userId;
  String? title;
  String? content;
  DateTime? dateadded;

  Note({this.userId, this.title, this.content, this.dateadded});

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      userId: map['userId'],
      title: map['title'],
      content: map['content'],
      dateadded: DateTime.tryParse(map['dateadded']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
      'dateadded': dateadded!.toIso8601String(),
    };
  }
}
