import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String profilePicUrl;
  final int completedTodos;

  const ProfileScreen({
    Key? key,
    required this.profilePicUrl,
    required this.completedTodos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profilePicUrl),
                ),
                const SizedBox(height: 16),
                Text(
                  'Completed Todos',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 8),
                Text(
                  completedTodos.toString(),
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}