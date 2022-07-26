part of 'reminder_bloc.dart';

abstract class ReminderEvent extends Equatable {
  const ReminderEvent();
}

class LoadReminder extends ReminderEvent{
  final DateTime selectedDate;
  final DateTime now;

  const LoadReminder(this.selectedDate, this.now);

  @override
  List<Object> get props => [selectedDate, now];
}