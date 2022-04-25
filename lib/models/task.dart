class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startDate;
  String? endDate;
  int? color;
  int? remind;
  String? repeat;

  Task(
      {this.id,
      this.title,
      this.note,
      this.isCompleted,
      this.date,
      this.startDate,
      this.endDate,
      this.color,
      this.remind,
      this.repeat});
  Task.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    startDate = json['startTime'];
    endDate = json['endTime'];
    color = json['color'];
    remind = json['remaid'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['note'] = note;
    data['isCompleted'] = isCompleted;
    data['date'] = date;
    data['startTime'] = startDate;
    data['endTime'] = endDate;
    data['color'] = color;
    data['remaid'] = remind;
    data['repeat'] = repeat;
    return data;
  }
}
