import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/providers/todo_list.dart';
import 'package:todo_app/widgets/create_todo.dart';

class TodoTile extends ConsumerWidget {
  final Todo todo;

  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      key: ValueKey(todo.id),
      child: Slidable(
        key: ValueKey(todo.id),
        startActionPane: ActionPane(
            extentRatio: 0.35,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  _moveToNextDay(ref);
                },
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.primary,
                icon: Icons.keyboard_double_arrow_right,
                label: 'Do tomorrow',
              )
            ]),
        endActionPane: ActionPane(
          extentRatio: 0.35,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                ref
                    .read(todoListProvider.notifier)
                    .deleteTaskItemToServer(todo);
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.error,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Material(
            type: MaterialType.card,
            elevation: 2.0,
            borderRadius: BorderRadius.circular(12),
            surfaceTintColor: Theme.of(context).colorScheme.primary,
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onLongPress: () {
                showDialog(
                  useSafeArea: false,
                  context: context,
                  builder: (BuildContext context) {
                    return CreateTodo(
                      isEdit: true,
                      todo: todo,
                    );
                  },
                );
              },
              onTap: () => _updateDoneStatus(ref),
              title: Text(
                todo.title,
                style: TextStyle(
                    decoration:
                        todo.isDone ? TextDecoration.lineThrough : null),
              ),
              leading: Checkbox(
                value: todo.isDone,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                visualDensity: VisualDensity.comfortable,
                onChanged: (_) => _updateDoneStatus(ref),
              ),
              trailing: todo.isReminder
                  ? const Icon(Icons.notifications_active)
                  : null,
            )),
      ),
    );
  }

  Future<void> _moveToNextDay(WidgetRef ref) async {
    todo.todoDate = todo.todoDate.add(const Duration(days: 1));
    await ref.read(todoListProvider.notifier).updateTaskItemToServer(todo);
  }

  Future<void> _updateDoneStatus(WidgetRef ref) async {
    todo.isDone = !todo.isDone;
    await ref.read(todoListProvider.notifier).updateTaskItemToServer(todo);
  }
}
