import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/widgets/item_list.dart';

import '../model.dart';

class ReminderItemList extends StatelessWidget {
  const ReminderItemList({Key? key, required this.todoList}) : super(key: key);
  final List<TodoModel> todoList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            DateFormat('EEEE, dd MMMM yyyy')
                .format(DateTime.fromMillisecondsSinceEpoch(todoList[0].date)),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: todoList.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                TodoItemList(todoData: todoList[index]),
          ),
        )
      ],
    );
  }
}
