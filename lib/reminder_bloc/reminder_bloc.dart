import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../database.dart';
import '../model.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderBloc() : super(ReminderInitial()) {
    on<LoadReminder>(_onLoadReminder);
  }

  _onLoadReminder(LoadReminder event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    String date = DateFormat('yyyy-MM-dd').format(event.selectedDate);
    String now = DateFormat('yyyy-MM-dd').format(event.now);
    Database db = await DatabaseProvider().database;
    var data = await db.rawQuery("SELECT * FROM $todoTable WHERE DATE BETWEEN ? AND ?", [now, date]);
    List<TodoModel> todoList = List<TodoModel>.from(data.map((e) => TodoModel.fromJson(e)));
    emit(ReminderLoaded(todoList));
  }
}
