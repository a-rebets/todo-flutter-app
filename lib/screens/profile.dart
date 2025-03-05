import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/providers/todo_list.dart';
import 'package:todo_app/widgets/todo_activity_grid.dart';

class ProfileScreen extends StatelessWidget {
  final AppUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    user.name[0],
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Joined ${DateFormat("MMM yyyy").format(user.creationDate)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Completed Todos',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Consumer(
                      builder: (context, ref, child) {
                        final todos = ref.watch(todoListProvider);
                        final completedCount = todos.asData!.value.values
                            .expand((list) => list)
                            .where((todo) => todo.isDone)
                            .length;
                        return Text(
                          completedCount.toString(),
                          style: Theme.of(context).textTheme.headlineMedium,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const TodoActivityGrid(),
          ],
        ),
      ),
    );
  }
}
