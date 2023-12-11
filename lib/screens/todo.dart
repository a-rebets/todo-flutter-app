import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/providers/theme_switch.dart';
import 'package:todo_app/providers/todo_list.dart';
import 'package:todo_app/widgets/calendar.dart';
import 'package:todo_app/widgets/create_todo.dart';
import 'package:todo_app/widgets/empty_tile.dart';
import 'package:todo_app/widgets/signout_dialog.dart';
import 'package:todo_app/widgets/todo_tile.dart';

class TodoScreen extends ConsumerStatefulWidget {
  final AppUser user;
  const TodoScreen({super.key, required this.user});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  late DateTime _selectedDay;
  late DateTime _lastSelectedDay;
  late ConfettiController _confettiController;
  bool _wasListCompleted = true;

  @override
  void initState() {
    super.initState();
    final DateTime curr = DateTime.now();
    _selectedDay = DateTime(curr.year, curr.month, curr.day);
    _lastSelectedDay = DateTime(2023);
    _confettiController =
        ConfettiController(duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLightTheme = ref.watch(themeSwitchProvider) == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12.w,
        title: Text("${widget.user.name}'s todos"),
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
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: CalendarWidget(
              initialDaySelected: _selectedDay,
              changeDay: (DateTime day) {
                setState(() {
                  _lastSelectedDay = _selectedDay;
                  _selectedDay = DateTime(day.year, day.month, day.day);
                  _wasListCompleted = true;
                });
              },
            ),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            gravity: 0.2,
            numberOfParticles: 15,
          ),
          Expanded(
            child: _todoList(),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New'),
        icon: const Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onPressed: () {
          showDialog(
            useSafeArea: false,
            context: context,
            builder: (BuildContext context) {
              return CreateTodo(
                selectedDay: _selectedDay,
              );
            },
          );
        },
      ),
    );
  }

  Widget _todoList() {
    final todos = ref.watch(todoListProvider);
    return switch (todos) {
      AsyncValue(:final error?) => Center(child: Text(error.toString())),
      AsyncValue(:final valueOrNull?) => _processMap(valueOrNull),
      _ => const CircularProgressIndicator.adaptive(),
    };
  }

  Widget _processMap(Map<DateTime, List<Todo>> map) {
    final List<Todo> list = map[_selectedDay] ?? [];
    var insertDuration = 0;
    var removeDuration = 0;
    final allDoneCheck = list.every((element) => element.isDone);
    if (!allDoneCheck && _wasListCompleted) {
      _wasListCompleted = false;
    }
    if (_lastSelectedDay.compareTo(_selectedDay) != 0) {
      _lastSelectedDay = _selectedDay;
    } else if (list.isNotEmpty) {
      insertDuration = 500;
      removeDuration = 250;
      if (allDoneCheck && !_wasListCompleted) {
        _confettiController.play();
        _wasListCompleted = true;
      }
    }
    return list.isEmpty
        ? const EmptyTile()
        : ImplicitlyAnimatedList<Todo>(
            removeDuration: Duration(milliseconds: removeDuration),
            insertDuration: Duration(milliseconds: insertDuration),
            items: list,
            areItemsTheSame: (a, b) => a.id == b.id,
            itemBuilder: (context, animation, item, index) {
              return SizeFadeTransition(
                sizeFraction: 0.7,
                curve: Curves.easeInOut,
                animation: animation,
                child: TodoTile(todo: item),
              );
            },
          );
  }
}
