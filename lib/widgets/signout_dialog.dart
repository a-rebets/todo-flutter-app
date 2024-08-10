import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/providers/logged_user.dart';

class SignOutDialog extends ConsumerWidget {
  final BuildContext parentContext;
  const SignOutDialog({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Center(child: Text('Wanna sign out ?')),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        FilledButton(
          style: FilledButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onError,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () {
            final method = ref.read(loggedUserProvider.notifier).signOutUser;
            _signOut(method);
          },
          child: const Text('Confirm'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        )
      ],
    );
  }

  Future<void> _signOut(Future<void> Function() signOutMethod) async {
    Navigator.of(parentContext).pushNamed('/splash');

    await Future.delayed(const Duration(milliseconds: 1000));
    
    await signOutMethod().then((_) => 
      Navigator.of(parentContext).pushNamedAndRemoveUntil('/auth', (_) => false));
  }
}
