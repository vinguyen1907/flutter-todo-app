class ToDos {
  String id;
  String title;
  String? note;
  DateTime startTime;
  DateTime endTime;
  String colorString;
  int remind;
  int repeat;

  ToDos({
    required this.id,
    required this.title,
    this.note,
    required this.colorString,
    required this.startTime,
    required this.endTime,
    required this.remind,
    required this.repeat,
  });
}
