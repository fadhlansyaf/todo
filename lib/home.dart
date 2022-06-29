import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:todo/bloc/home_bloc.dart';
import 'package:todo/model.dart';

import 'database.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int date = DateTime.now().millisecondsSinceEpoch;
  List<TodoModel> todoList = [];

  final subController = TextEditingController();
  final descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    DatabaseProvider().database;
  }

  _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is DateTime) {
      setState(() {
        date = args.value.millisecondsSinceEpoch;
        context.read<HomeBloc>().add(HomeChanged(date));
      });
    }
  }

  Widget createTodoList(int index) {
    if (index == -1) {
      return Column(
        children: [
          const SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius:
                        const BorderRadius.all(Radius.circular(12.0))),
              ),
            ],
          ),
          const SizedBox(
            height: 18.0,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Text(
            todoList[index].subject,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(todoList[index].desc),
          const SizedBox(
            height: 20,
          ),
          Text(todoList[index].time),
          const SizedBox(
            height: 20,
          )
        ],
      );
    }
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        controller: sc,
        itemCount: todoList.length + 1,
        itemBuilder: (context, index) {
          return createTodoList(index - 1);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if(state is HomeLoaded){
            setState((){
              todoList = state.todoList;
            });
          }
        },
        child: SlidingUpPanel(
          minHeight: 350,
          maxHeight: MediaQuery.of(context).size.height - 90,
          panelBuilder: (sc) => _panel(sc),
          // panel: Padding(
          //   padding: const EdgeInsets.all(8),
          //   child: Column(
          //     children: [
          //       Text(DateFormat('EEEE, dd MMMM yyyy').format(date)),
          //     ],
          //   ),
          // ),
          body: ListView(
            children: [
              Container(
                height: 450,
                child: SfDateRangePicker(
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.single,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TimeOfDay? timeOfDay = TimeOfDay.now();
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setModalState) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                          10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const Text(
                                    'Add Todo List',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextFormField(
                                    controller: subController,
                                    decoration: const InputDecoration(
                                        labelText: 'Subject'),
                                  ),
                                  TextFormField(
                                    controller: descController,
                                    decoration: const InputDecoration(
                                        labelText: 'Description'),
                                  ),
                                  Row(
                                    children: [
                                      Text(timeOfDay!.format(context), style: const TextStyle(fontSize: 18),),
                                      IconButton(icon: Icon(Icons.refresh), onPressed: () async {
                                        timeOfDay = await showTimePicker(context: context, initialTime: timeOfDay!);
                                        setModalState((){});
                                      },)
                                    ],
                                  )
                                ],
                              )),
                          ButtonBar(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    DateTime currDate = DateTime.fromMillisecondsSinceEpoch(date);
                                    DateTime submitDate = DateTime(currDate.year, currDate.month, currDate.day, timeOfDay!.hour, timeOfDay!.minute);
                                    context.read<HomeBloc>().add(HomeInsert(
                                        TodoModel(subject: subController.text,
                                            desc: descController.text, date: submitDate.millisecondsSinceEpoch, time: timeOfDay!.format(context))));
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Submit'))
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
