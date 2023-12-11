import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/providers/logged_user.dart';
import 'package:todo_app/screens/onboarding.dart';
import 'package:todo_app/screens/todo.dart';

class StartApp extends ConsumerStatefulWidget {
  const StartApp({super.key});

  @override
  ConsumerState<StartApp> createState() => _StartAppState();
}

class _StartAppState extends ConsumerState<StartApp> {
  final Widget _loadingScreen =
      const Scaffold(body: Center(child: CircularProgressIndicator.adaptive()));
  bool _afterLogin = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(loggedUserProvider);
    return currentUser.when(
      loading: () => _loadingScreen,
      error: (err, trace) => const Scaffold(
          body: Center(child: Text('Oops, could not fetch user data'))),
      data: (user) => _getScreen(user),
    );
  }

  Widget _getScreen(AppUser? user) {
    if (user == null) {
      if (_afterLogin) {
        return _loadingScreen;
      } else {
        _afterLogin = true;
        return const OnboardingScreen();
      }
    } else {
      _afterLogin = false;
      return TodoScreen(user: user);
    }
  }
}
