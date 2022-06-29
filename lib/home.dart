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
      // child: ListView(
      //   controller: sc,
      //   children: <Widget>[
      //     SizedBox(
      //       height: 12.0,
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[
      //         Container(
      //           width: 30,
      //           height: 5,
      //           decoration: BoxDecoration(
      //               color: Colors.grey[300],
      //               borderRadius: BorderRadius.all(Radius.circular(12.0))),
      //         ),
      //       ],
      //     ),
      //     SizedBox(
      //       height: 18.0,
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[
      //         Text(
      //           DateFormat('EEEE, dd MMMM yyyy').format(date),
      //           style: TextStyle(
      //             fontWeight: FontWeight.normal,
      //             fontSize: 24.0,
      //           ),
      //         ),
      //       ],
      //     ),
      //     SizedBox(
      //       height: 36.0,
      //     ),
      //     SizedBox(
      //       height: 36.0,
      //     ),
      //     Container(
      //       padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           Text("Images",
      //               style: TextStyle(
      //                 fontWeight: FontWeight.w600,
      //               )),
      //           SizedBox(
      //             height: 12.0,
      //           ),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: <Widget>[],
      //           ),
      //         ],
      //       ),
      //     ),
      //     SizedBox(
      //       height: 36.0,
      //     ),
      //     Container(
      //       padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           Text("About",
      //               style: TextStyle(
      //                 fontWeight: FontWeight.w600,
      //               )),
      //           SizedBox(
      //             height: 12.0,
      //           ),
      //           Text(
      //             """Pittsburgh is a city in the state of Pennsylvania in the United States, and is the county seat of Allegheny County. A population of about 302,407 (2018) residents live within the city limits, making it the 66th-largest city in the U.S. The metropolitan population of 2,324,743 is the largest in both the Ohio Valley and Appalachia, the second-largest in Pennsylvania (behind Philadelphia), and the 27th-largest in the U.S.\n\nPittsburgh is located in the southwest of the state, at the confluence of the Allegheny, Monongahela, and Ohio rivers. Pittsburgh is known both as "the Steel City" for its more than 300 steel-related businesses and as the "City of Bridges" for its 446 bridges. The city features 30 skyscrapers, two inclined railways, a pre-revolutionary fortification and the Point State Park at the confluence of the rivers. The city developed as a vital link of the Atlantic coast and Midwest, as the mineral-rich Allegheny Mountains made the area coveted by the French and British empires, Virginians, Whiskey Rebels, and Civil War raiders.\n\nAside from steel, Pittsburgh has led in manufacturing of aluminum, glass, shipbuilding, petroleum, foods, sports, transportation, computing, autos, and electronics. For part of the 20th century, Pittsburgh was behind only New York City and Chicago in corporate headquarters employment; it had the most U.S. stockholders per capita. Deindustrialization in the 1970s and 80s laid off area blue-collar workers as steel and other heavy industries declined, and thousands of downtown white-collar workers also lost jobs when several Pittsburgh-based companies moved out. The population dropped from a peak of 675,000 in 1950 to 370,000 in 1990. However, this rich industrial history left the area with renowned museums, medical centers, parks, research centers, and a diverse cultural district.\n\nAfter the deindustrialization of the mid-20th century, Pittsburgh has transformed into a hub for the health care, education, and technology industries. Pittsburgh is a leader in the health care sector as the home to large medical providers such as University of Pittsburgh Medical Center (UPMC). The area is home to 68 colleges and universities, including research and development leaders Carnegie Mellon University and the University of Pittsburgh. Google, Apple Inc., Bosch, Facebook, Uber, Nokia, Autodesk, Amazon, Microsoft and IBM are among 1,600 technology firms generating \$20.7 billion in annual Pittsburgh payrolls. The area has served as the long-time federal agency headquarters for cyber defense, software engineering, robotics, energy research and the nuclear navy. The nation's eighth-largest bank, eight Fortune 500 companies, and six of the top 300 U.S. law firms make their global headquarters in the area, while RAND Corporation (RAND), BNY Mellon, Nova, FedEx, Bayer, and the National Institute for Occupational Safety and Health (NIOSH) have regional bases that helped Pittsburgh become the sixth-best area for U.S. job growth.
      //             """,
      //             softWrap: true,
      //           ),
      //         ],
      //       ),
      //     ),
      //     SizedBox(
      //       height: 24,
      //     ),
      //   ],
      // ),
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
                                ],
                              )),
                          ButtonBar(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    context.read<HomeBloc>().add(HomeInsert(
                                        TodoModel(subject: subController.text,
                                            desc: descController.text, date: date)));
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
