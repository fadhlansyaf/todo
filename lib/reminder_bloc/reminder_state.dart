part of 'reminder_bloc.dart';

abstract class ReminderState extends Equatable {
  const ReminderState();
}

class ReminderInitial extends ReminderState {
  @override
  List<Object> get props => [];
}

class ReminderLoading extends ReminderState {
  @override
  List<Object> get props => [];
}

class ReminderLoaded extends ReminderState {
  final List<TodoModel> todoList;

  const ReminderLoaded(this.todoList);

  @override
  List<Object> get props => [];
}
