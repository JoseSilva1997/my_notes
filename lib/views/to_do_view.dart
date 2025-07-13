import 'package:flutter/material.dart';
import 'package:my_notes/widgets/to_do_item.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final List<Map<String, dynamic>> _todos = [];

  void _addToDo() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New To-Do'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter to-do item'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        _todos.add({'title': result.trim(), 'isDone': false});
      });
    }
  }

  void _deleteToDo(ToDoWidget todo) async {
    // No controller is needed for a simple confirmation dialog.
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (result != null && result) {
      setState(() {
        _todos.removeWhere((element) => element['title'] == todo.title);
      });
    }
  }

  void _toggleDone(int index, bool? value) {
    setState(() {
      _todos[index]['isDone'] = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _todos.length,
        itemBuilder: (context, index) {
            final todo = _todos[index];
            return Row(
            children: [
              Expanded(
              child: ToDoWidget(
                title: todo['title'],
                isDone: todo['isDone'],
                onChanged: (value) => _toggleDone(index, value),
              ),
              ),
              IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteToDo(
                ToDoWidget(
                title: todo['title'],
                isDone: todo['isDone'],
                onChanged: (value) {},
                ),
              ),
              ),
            ],
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addToDo,
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}