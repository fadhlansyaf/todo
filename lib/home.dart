import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:todo/bloc/home_bloc.dart';
import 'package:todo/item_list.dart';
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

  final sc = ScrollController();
  Widget _panel() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        controller: sc,
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return TodoItemList(todoData: todoList[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home'),
      // ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoaded) {
            setState(() {
              todoList = state.todoList;
            });
          }
        },
        child: Stack(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.orange.shade100, Colors.orange.shade300],
              )),
            ),
            Column(
              children: [
                SizedBox(
                  height: 56,
                ),
                Container(
                  height: 430,
                  child: SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.single,
                    headerStyle: const DateRangePickerHeaderStyle(
                        backgroundColor: Color(0xFF7fcd91),
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 25,
                          letterSpacing: 5,
                          color: Color(0xFFff5eaea),
                        )),
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      dayFormat: 'EEE',
                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                        backgroundColor: Colors.deepOrange.shade400,
                        textStyle: TextStyle(fontSize: 14, letterSpacing: 5, ),
                      ),
                      viewHeaderHeight: 50
                    ),
                  ),
                ),
                //_panel()
                Expanded(
                  child: ListView.builder(
                    controller: sc,
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      return TodoItemList(todoData: todoList[index]);
                    },
                  ),
                ),
              ],
            ),
          ],
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
                                      Text(
                                        timeOfDay != null
                                            ? timeOfDay!.format(context)
                                            : TimeOfDay.now().format(context),
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.refresh),
                                        onPressed: () async {
                                          timeOfDay = await showTimePicker(
                                              context: context,
                                              initialTime: timeOfDay!);
                                          setModalState(() {});
                                        },
                                      )
                                    ],
                                  )
                                ],
                              )),
                          ButtonBar(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    DateTime currDate =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            date);
                                    DateTime submitDate = DateTime(
                                        currDate.year,
                                        currDate.month,
                                        currDate.day,
                                        timeOfDay!.hour,
                                        timeOfDay!.minute);
                                    context.read<HomeBloc>().add(HomeInsert(
                                        TodoModel(
                                            subject: subController.text,
                                            desc: descController.text,
                                            date: submitDate
                                                .millisecondsSinceEpoch,
                                            time: timeOfDay!.format(context))));
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
