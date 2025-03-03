import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/providers/firebase.dart';

part 'todo_list.g.dart';

@riverpod
class TodoList extends _$TodoList {
  @override
  Future<Map<DateTime, List<Todo>>> build() async {
    final user = ref.watch(authProvider).currentUser;
    if (user != null) {
      final db = ref.watch(firestoreProvider);
      final data =
          await db.collection('users').doc(user.uid).collection('todos').get();
      return _createMapFromTodos(_processSnapshot(data));
    } else {
      throw Exception('User not logged in');
    }
  }

  Future<void> putTaskItemsToServer(Todo taskItem) async {
    await _performActionOnTaskItem(
        taskItem,
        (user, db, taskItem) => db
            .collection('users')
            .doc(user.uid)
            .collection('todos')
            .add(taskItem.toJson()));
    ref.invalidateSelf();
  }

  Future<void> updateTaskItemToServer(Todo taskItem) async {
    await _performActionOnTaskItem(
        taskItem,
        (user, db, taskItem) => db
            .collection('users')
            .doc(user.uid)
            .collection('todos')
            .doc(taskItem.id)
            .update(taskItem.toJson()));
    ref.invalidateSelf();
  }

  Future<void> deleteTaskItemToServer(Todo taskItem) async {
    await _performActionOnTaskItem(
        taskItem,
        (user, db, taskItem) => db
            .collection('users')
            .doc(user.uid)
            .collection('todos')
            .doc(taskItem.id)
            .delete());
    ref.invalidateSelf();
  }

  Future<void> _performActionOnTaskItem(
      Todo taskItem,
      Future<void> Function(User user, FirebaseFirestore db, Todo taskItem)
          action) async {
    final user = ref.read(authProvider).currentUser;
    if (user != null) {
      final db = ref.read(firestoreProvider);
      await action(user, db, taskItem);
    }
  }

  List<Todo> _processSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      Todo todo = Todo.fromJson(doc.data());
      todo.id = doc.reference.id;
      final localDate = todo.todoDate.toLocal();
      final dateKey = DateTime(localDate.year, localDate.month, localDate.day);
      todo.todoDate = dateKey;
      return todo;
    }).toList();
  }

  Map<DateTime, List<Todo>> _createMapFromTodos(List<Todo> list) {
    list.sort((a, b) {
      if (!a.isDone && b.isDone) {
        return 1;
      } else if (a.isDone && !b.isDone) {
        return -1;
      }
      return a.createdAt.compareTo(b.createdAt);
    });
    final Map<DateTime, List<Todo>> map = {};
    for (var element in list) {
      if (map.containsKey(element.todoDate)) {
        map[element.todoDate]!.add(element);
      } else {
        map[element.todoDate] = [element];
      }
    }
    return map;
  }
}
