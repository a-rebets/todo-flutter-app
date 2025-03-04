import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/notifications.dart';
import 'package:todo_app/providers/todo_list.dart';

class CreateTodo extends ConsumerStatefulWidget {
  final DateTime? selectedDay;
  final bool isEdit;
  final Todo? todo;
  const CreateTodo(
      {super.key, this.selectedDay, this.isEdit = false, this.todo});

  @override
  ConsumerState<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends ConsumerState<CreateTodo> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late bool remindMe;

  @override
  void initState() {
    remindMe = widget.isEdit ? widget.todo!.isReminder : false;
    title = widget.isEdit ? widget.todo!.title : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(200),
        surfaceTintColor: Colors.transparent,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: TextFormField(
                        initialValue: title,
                        expands: true,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.lora(
                            fontSize: 40.sp, fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Create a task...',
                          hintStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(100),
                          ),
                        ),
                        autocorrect: false,
                        onChanged: (value) {
                          title = value;
                        },
                        validator: (value) {
                          if (value != null && value.length <= 4) {
                            return "Task title is too short.";
                          }
                          return null;
                        },
                      ))),
              SwitchListTile(
                value: remindMe,
                contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                onChanged: (bool newValue) {
                  setState(() {
                    remindMe = newValue;
                  });
                },
                title: const Text('Remind me'),
              ),
              Gap(50.h),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Gap(16.w),
                    FilledButton(
                      onPressed: _handleSave,
                      child: const Text('Done'),
                    ),
                    Gap(30.w),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ]),
              Gap(70.h),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final crudTodo = ref.read(todoListProvider.notifier);
      final notificationService = ref.read(notificationServiceProvider);

      if (widget.isEdit) {
        final todo = widget.todo!
          ..title = title
          ..isReminder = remindMe;
        crudTodo.updateTaskItemToServer(todo);

        if (remindMe) {
          notificationService.showTaskNotification(todo);
        }
      } else {
        final todo = Todo(
            todoDate: widget.selectedDay!.toUtc(),
            createdAt: DateTime.now().toUtc(),
            title: title,
            isReminder: remindMe,
            isDone: false);
        crudTodo.putTaskItemsToServer(todo);

        if (remindMe) {
          notificationService.showTaskNotification(todo);
        }
      }
      Navigator.pop(context);
    }
  }
}
