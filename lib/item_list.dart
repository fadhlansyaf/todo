import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/model.dart';

import 'bloc/home_bloc.dart';

class TodoItemList extends StatelessWidget {
  const TodoItemList({Key? key, required this.todoData}) : super(key: key);
  final TodoModel todoData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
              ],
            ),
          ),
          Text(todoData.time),
          const SizedBox(width: 5),
          IconButton(onPressed: (){
            context.read<HomeBloc>().add(HomeDeleted(todoData));
          }, icon: const Icon(Icons.remove_circle))
        ],
      ),
    );
  }
}
