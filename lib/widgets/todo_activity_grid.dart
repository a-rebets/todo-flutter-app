import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/providers/todo_list.dart';

class TodoActivityGrid extends StatefulWidget {
  const TodoActivityGrid({super.key});

  @override
  State<TodoActivityGrid> createState() => TodoActivityGridState();
}

class TodoActivityGridState extends State<TodoActivityGrid> {
  int selectedYear = DateTime.now().year;
  final List<String> monthNames = const [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Column(
        children: [
          // Header row with year and chevron buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    selectedYear--;
                  });
                },
              ),
              Text(
                selectedYear.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    selectedYear++;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          Consumer(builder: (context, ref, child) {
            final todosAsync = ref.watch(todoListProvider);
            return todosAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
              data: (todosMap) {
                List<int> monthlyCounts = List.filled(12, 0);
                todosMap.forEach((date, todos) {
                  if (date.year == selectedYear) {
                    for (var todo in todos) {
                      if (todo.isDone) {
                        monthlyCounts[date.month - 1] += 1;
                      }
                    }
                  }
                });
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 12,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return TodoActivityGridCell(
                      month: monthNames[index],
                      count: monthlyCounts[index],
                    );
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

class TodoActivityGridCell extends StatefulWidget {
  final String month;
  final int count;

  const TodoActivityGridCell({super.key, required this.month, required this.count});

  @override
  TodoActivityGridCellState createState() => TodoActivityGridCellState();
}

class TodoActivityGridCellState extends State<TodoActivityGridCell> {
  bool isPressed = false;

  Color getBackgroundColor() {
    int count = widget.count;
    if (count >= 15) {
      // Max state: Gold background
      return const Color(0xFFFFD700);
    } else if (count >= 1) {
      // Mid state: Light orange background
      return Colors.orange[200]!;
    } else {
      // Min state: Transparent fill (cell shows border)
      return Colors.transparent;
    }
  }

  Color getTextColor() {
    int count = widget.count;
    if (count >= 15) {
      // Max state: Dark gold text
      return const Color(0xFFB8860B);
    } else if (count >= 1) {
      // Mid state: Dark orange text
      return Colors.orange[800]!;
    } else {
      // Min state: Light grey text
      return Colors.grey;
    }
  }

  BoxDecoration getDecoration() {
    if (widget.count == 0) {
      return BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey[300]!, width: 2),
        borderRadius: BorderRadius.circular(16),
      );
    } else {
      return BoxDecoration(
        color: getBackgroundColor(),
        borderRadius: BorderRadius.circular(16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: Container(
        decoration: getDecoration(),
        alignment: Alignment.center,
        child: Text(
          isPressed ? (widget.count == 0 ? '😢' : widget.count.toString()) : widget.month,
          style: TextStyle(
            color: getTextColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
