import 'package:flutter/material.dart';
import 'package:todo_app/models/user.dart';

class ProfileScreen extends StatelessWidget {
  final AppUser user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user.profilePictureUrl ?? ''),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: Theme.of(context).textTheme.headline5,
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
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.completedTodosCount.toString(),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}