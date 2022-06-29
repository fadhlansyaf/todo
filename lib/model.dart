class TodoModel {
  String subject;
  String desc;
  int date;

  TodoModel({required this.subject, required this.desc, required this.date});

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
      date: json['DATE'], desc: json['DESC'], subject: json['SUBJECT']);

  Map<String, dynamic> toJson() => {
        "SUBJECT": subject,
        "DESC": desc,
        "DATE": date,
      };
}
