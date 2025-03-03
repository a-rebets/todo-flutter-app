import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/providers/todo_list.dart';

class ProfileScreen extends ConsumerWidget {
  final AppUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    final completedCount = todos.when(
      data: (data) {
        int count = 0;
        for (var dayTodos in data.values) {
          count += dayTodos.where((todo) => todo.isDone).length;
        }
        return count;
      },
      loading: () => 0,
      error: (_, __) => 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60.r,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  user.name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 48.sp,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                user.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 32.h),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Completed Todos',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            completedCount.toString(),
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}