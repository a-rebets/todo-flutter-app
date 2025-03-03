import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable()
class Todo {
  //used to store document id from firestore
  String? id;
  DateTime todoDate;
  DateTime createdAt;
  String title;
  bool isReminder;
  bool isDone;
  int? notificationId;

  Todo({
    this.id,
    required this.todoDate,
    required this.createdAt,
    required this.title,
    required this.isReminder,
    required this.isDone,
    this.notificationId,
  });

  //to make Todo object from json
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  //to create json from the todo instance
  Map<String, dynamic> toJson() => _$TodoToJson(this);

  @override
  String toString() {
    return 'Todo{title: $title}';
  }
}
