class Note {
  String? id;
  String? userId;
  String? title;
  String? content;
  DateTime? dateadded;

  Note({this.id, this.userId, this.title, this.content, this.dateadded});

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      content: map['content'],
      dateadded: DateTime.tryParse(map['dateadded']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'dateadded': dateadded!.toIso8601String(),
    };
  }
}
