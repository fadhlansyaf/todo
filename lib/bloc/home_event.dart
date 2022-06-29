part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeChanged extends HomeEvent{
  final int date;

  const HomeChanged(this.date);

  @override
  List<Object> get props => [date];
}

class HomeInsert extends HomeEvent{
  final TodoModel todo;

  const HomeInsert(this.todo);

  @override
  List<Object> get props => [todo];
}