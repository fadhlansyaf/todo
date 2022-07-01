import 'package:flutter/material.dart';
import 'package:todo/model.dart';

class TodoItemList extends StatelessWidget {
  const TodoItemList({Key? key, required this.todoData}) : super(key: key);
  final TodoModel todoData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          todoData.subject,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(todoData.desc),
        const SizedBox(
          height: 20,
        ),
        Text(todoData.time),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
