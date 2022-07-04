import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
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
  double cardHeight = 0;

  final subController = TextEditingController();
  final descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    DatabaseProvider().database;
    context.read<HomeBloc>().add(HomeChanged(date));
  }

  _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is DateTime) {
      setState(() {
        cardHeight = 0;
        date = args.value.millisecondsSinceEpoch;
        context.read<HomeBloc>().add(HomeChanged(date));
      });
    }
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void showAddSelection() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose Action',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                SizedBox(
                  child: GridView(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    padding: EdgeInsets.all(8),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: GridTile(
                          footer: const GridTileBar(
                            backgroundColor: Colors.black54,
                            title: Text(
                              'Reminder',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Add a reminder"),
                          ),
                          child: InkResponse(
                              enableFeedback: true,
                              onTap: () {
                                Navigator.pop(context);
                                chooseTodoTime();
                              },
                              child: Container(
                                child: Icon(Icons.timer),
                                color: Colors.grey,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: GridTile(
                          footer: const GridTileBar(
                            backgroundColor: Colors.black54,
                            title: Text(
                              'Soon',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Coming Soon"),
                          ),
                          child: InkResponse(
                              enableFeedback: true,
                              onTap: () {},
                              child: Container(
                                child: Icon(Icons.refresh),
                                color: Colors.grey,
                              )),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void chooseTodoTime() {
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
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              controller: subController,
                              decoration:
                                  const InputDecoration(labelText: 'Subject'),
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
                                  DateTime.fromMillisecondsSinceEpoch(date);
                              DateTime submitDate = DateTime(
                                  currDate.year,
                                  currDate.month,
                                  currDate.day,
                                  timeOfDay!.hour,
                                  timeOfDay!.minute);
                              context.read<HomeBloc>().add(HomeInsert(TodoModel(
                                  subject: subController.text,
                                  desc: descController.text,
                                  date: submitDate.millisecondsSinceEpoch,
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
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> selectedWidget = [
      Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.orange.shade100, Colors.orange.shade300],
            )),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(10),
                  child: SfDateRangePicker(
                    initialSelectedDate: DateTime.fromMillisecondsSinceEpoch(date),
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
                      ),
                    ),
                    monthViewSettings: DateRangePickerMonthViewSettings(
                        dayFormat: 'EEE',
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          backgroundColor: Colors.deepOrange.shade400,
                          textStyle: const TextStyle(
                            fontSize: 14,
                            letterSpacing: 5,
                          ),
                        ),
                        viewHeaderHeight: 50),
                  ),
                ),
                //_panel()
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: SizedBox(
                      height: cardHeight <
                              MediaQuery.of(context).size.height * 0.37
                          ? MediaQuery.of(context).size.height * 0.37
                          : cardHeight,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: todoList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return TodoItemList(todoData: todoList[index]);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const Center(child: Text('Coming Soon'),)
    ];
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home'),
      // ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoaded) {
            setState(() {
              todoList = state.todoList;
              for (var _ in todoList) {
                cardHeight += 107;
              }
            });
          }
        },
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeLoaded) {
              setState(() {
                todoList = state.todoList;
                for (var _ in todoList) {
                  cardHeight += MediaQuery.of(context).size.height * 0.001;
                }
              });
            }
          },
          child: selectedWidget.elementAt(_selectedIndex),
        )

      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.refresh), label: 'Item1'),
            BottomNavigationBarItem(icon: Icon(Icons.refresh), label: 'Item2'),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddSelection();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
