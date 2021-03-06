import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

import '../database.dart';
import '../model.dart';
import '../notification.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeChanged>(_onHomeChanged);
    on<HomeInsert>(_onHomeInsert);
    on<HomeDeleted>(_onHomeDeleted);
  }

  late String _date;

  _onHomeChanged(HomeChanged event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    _date = DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(event.date));
    Database db = await DatabaseProvider().database;
    var data = await db.rawQuery("SELECT * FROM $todoTable WHERE DATE = ?", [_date]);
    List<TodoModel> todoList = List<TodoModel>.from(data.map((e) => TodoModel.fromJson(e)));
    emit(HomeLoaded(todoList));
  }

  _onHomeInsert(HomeInsert event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    Database db = await DatabaseProvider().database;
    var data = await db.transaction((txn) async {
      var data = await txn.insert(todoTable, event.todo.toJson());
      return data;
    });
    print(data);
    String formattedDate = '${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(event.todo.date))} ${event.todo.time}';
    DateTime notifDate = DateTime.parse(formattedDate);
    NotificationService notificationService = NotificationService();
    notificationService.scheduleNotifications(event.todo.subject, event.todo.desc, notifDate, event.todo.id);
    var data2 = await db.rawQuery("SELECT * FROM $todoTable WHERE DATE = ?", [_date]);
    List<TodoModel> todoList = List<TodoModel>.from(data2.map((e) => TodoModel.fromJson(e)));
    emit(HomeLoaded(todoList));
  }

  _onHomeDeleted(HomeDeleted event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    NotificationService notificationService = NotificationService();
    notificationService.cancelNotifications(event.todo.id);
    Database db = await DatabaseProvider().database;
    db.rawDelete('DELETE FROM $todoTable WHERE ID = ?', [event.todo.id]);
    var data2 = await db.rawQuery("SELECT * FROM $todoTable WHERE DATE = ?", [_date]);
    List<TodoModel> todoList = List<TodoModel>.from(data2.map((e) => TodoModel.fromJson(e)));
    emit(HomeLoaded(todoList));
  }
}
