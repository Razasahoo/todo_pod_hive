import 'dart:convert';

class Task {
  final int id;
  final String title;
  final String subTitle;
  final DateTime datetime;
  Task({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.datetime,
  });

  Task copyWith({
    int? id,
    String? title,
    String? subTitle,
    DateTime? datetime,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      datetime: datetime ?? this.datetime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subTitle': subTitle,
      'datetime': datetime.millisecondsSinceEpoch,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      subTitle: map['subTitle'] ?? '',
      datetime: DateTime.fromMillisecondsSinceEpoch(map['datetime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Task(id: $id, title: $title, subTitle: $subTitle, datetime: $datetime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Task &&
      other.id == id &&
      other.title == title &&
      other.subTitle == subTitle &&
      other.datetime == datetime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      subTitle.hashCode ^
      datetime.hashCode;
  }
}
