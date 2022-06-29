import 'package:intl/intl.dart';

class TodoModel {
  String subject;
  String desc;
  int date;
  String time;

  TodoModel(
      {required this.subject,
      required this.desc,
      required this.date,
      required this.time});

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
      date: DateTime.parse(json['DATE']).millisecondsSinceEpoch,
      desc: json['DESC'],
      subject: json['SUBJECT'],
      time: json['TIME']);

  Map<String, dynamic> toJson() => {
        "SUBJECT": subject,
        "DESC": desc,
        "DATE": DateFormat('yyyy-MM-dd')
            .format(DateTime.fromMillisecondsSinceEpoch(date)),
        "TIME": time
      };
}
