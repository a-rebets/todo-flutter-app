import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/providers/firebase.dart';
import 'package:todo_app/providers/logged_user.dart';
import 'package:todo_app/screens/onboarding.dart';
import 'package:todo_app/screens/splash.dart';
import 'package:todo_app/screens/todo.dart';
import 'package:todo_app/screens/profile.dart';

class StartApp extends ConsumerWidget {
  final Widget _loadingScreen =
      const Scaffold(body: Center(child: CircularProgressIndicator.adaptive()));
  final bool afterAppLaunch;

  StartApp({super.key, this.afterAppLaunch = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(loggedUserProvider);
    return currentUser.when(
      loading: () => (afterAppLaunch) ? _loadingScreen : const SplashScreen(),
      error: (err, trace) => const Scaffold(
          body: Center(child: Text('Oops, could not fetch user data'))),
      data: (user) => _getScreen(user, ref),
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    _selectedIndex = index;
  }

  Widget _getScreen(AppUser? user, WidgetRef ref) {
    if (user == null) {
      if (ref.read(authProvider).currentUser != null) {
        return _loadingScreen;
      } else {
        return const OnboardingScreen();
      }
    } else {
      return Scaffold(
          body: _selectedIndex == 0 ? TodoScreen(user: user) : ProfileScreen(user: user),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Todos'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        );
    }
  }
}
