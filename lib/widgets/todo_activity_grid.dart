import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/providers/todo_list.dart';

class TodoActivityGrid extends StatefulWidget {
  const TodoActivityGrid({Key? key}) : super(key: key);

  @override
  _TodoActivityGridState createState() => _TodoActivityGridState();
}

class _TodoActivityGridState extends State<TodoActivityGrid> {
  int selectedYear = DateTime.now().year;
  final List<String> monthNames = const [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  Color getBackgroundColor(int count) {
    if (count > 20) {
      return Colors.yellow[700]!;
    } else if (count > 1) {
      return Colors.orange[200]!;
    } else {
      return Colors.grey[300]!;
    }
  }

  Color getTextColor(int count) {
    if (count > 20) {
      return Colors.yellowAccent;
    } else if (count > 1) {
      return Colors.orange[800]!;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 8),
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
                  final count = monthlyCounts[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: getBackgroundColor(count),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      monthNames[index],
                      style: TextStyle(
                        color: getTextColor(count),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }),
      ],
    );
  }
}
