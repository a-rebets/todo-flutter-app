import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/providers/theme_switch.dart';
import 'package:todo_app/widgets/signout_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  final AppUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLightTheme = ref.watch(themeSwitchProvider) == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        title: Text("${user.name}'s Profile"),
        actions: [
          IconButton(
              icon: Icon((isLightTheme) ? Icons.dark_mode : Icons.light_mode),
              tooltip: 'Dark theme',
              onPressed: () {
                ref.read(themeSwitchProvider.notifier).update(
                    (isLightTheme) ? Brightness.dark : Brightness.light);
              }),
          IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Log out',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => SignOutDialog(parentContext: context));
              }),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.profilePicUrl),
            ),
            const SizedBox(height: 20),
            Text(
              'Completed Todos: ${user.completedTodosCount}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
