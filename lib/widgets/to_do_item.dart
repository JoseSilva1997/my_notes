import 'package:flutter/material.dart';

class ToDoWidget extends StatelessWidget {
  final String title;
  final bool isDone;
  final ValueChanged<bool?>? onChanged;

  const ToDoWidget({
    super.key,
    required this.title,
    this.isDone = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: isDone,
        onChanged: onChanged,
      ),
      title: Text(
        title,
        style: TextStyle(
          decoration: isDone ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }
}