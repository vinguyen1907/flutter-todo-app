import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/pages/home_page.dart';
import 'package:todo_app/ui/app_colors.dart';
import 'package:todo_app/widgets/button.dart';

import '../ui/app_styles.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  // Date time
  static DateTime _selectedDate = DateTime.now();

  static DateTime _startTime = _selectedDate;
  // static String _startTimeString =
  // DateFormat.jm().format(_startTime).toString();
  DateTime _endTime = _startTime.add(const Duration(hours: 1));
  // String _endTimeString = DateFormat.jm().format(_endTime).toString();
  // !!Note: Only static class members can be used in initializers.

  // Remind
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20, 25, 30];
  int _selectedRepeat = 0;
  List<int> repeatList = [0, 1, 7, 15, 30, 60, 180, 365];

  String convertDaysToString(int _selectedRepeat) {
    if (_selectedRepeat == 0) {
      return 'Never';
    } else if (_selectedRepeat == 1) {
      return 'Every day';
    } else if (_selectedRepeat == 7) {
      return 'Every week';
    } else if (_selectedRepeat == 15) {
      return 'Every 2 weeks';
    } else if (_selectedRepeat == 30) {
      return 'Every month';
    } else if (_selectedRepeat == 60) {
      return 'Every 2 months';
    } else if (_selectedRepeat == 180) {
      return 'Every 6 months';
    } else if (_selectedRepeat == 365) {
      return 'Every year';
    } else {
      return 'Never';
    }
  }

  // Color collector
  List<Color> colorPalette = [
    AppColors.primaryColor,
    AppColors.pinkColor,
    AppColors.yellowColor,
  ];
  int _selectedColor = 0;

  // Text controller
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: _appBar(context),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            height: size.height - 56,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              InputField(
                  title: "Title",
                  hint: "Enter tilte here.",
                  controller: _titleController),
              InputField(
                  title: "Note",
                  hint: "Enter note here.",
                  controller: _noteController),
              InputField(
                  title: "Date",
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    onPressed: () {
                      _getDateFromUser();
                    },
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                  )),
              Row(children: [
                Expanded(
                  child: InputField(
                      title: "Start time",
                      hint: DateFormat.jm().format(_startTime).toString(),
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: const Icon(Icons.access_time_outlined),
                        color: Colors.grey,
                      )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InputField(
                      title: "End time",
                      hint: DateFormat.jm().format(_endTime).toString(),
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: const Icon(Icons.access_time_outlined),
                        color: Colors.grey,
                      )),
                ),
              ]),
              InputField(
                  title: "Remind",
                  hint: '$_selectedRemind minutes before',
                  widget: DropdownButton<String>(
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    items:
                        remindList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: '$value',
                        child: Text('$value minutes before'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRemind = int.parse(value!);
                      });
                    },
                  )),
              InputField(
                  title: "Repeat",
                  hint: convertDaysToString(_selectedRepeat),
                  widget: DropdownButton<String>(
                    underline: Container(),
                    icon: const Icon(Icons.repeat_rounded),
                    items:
                        repeatList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: '$value',
                        child: Text(convertDaysToString(value)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRepeat = int.parse(value!);
                      });
                    },
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    colorSelector(),
                    MyButton(
                        label: "Create task",
                        onTap: () {
                          // validateAndSubmit();
                          FirebaseFirestore.instance.collection("ToDo").add({
                            "title": _titleController.text,
                            "note": _noteController.text,
                            "date": _selectedDate,
                            "startTime": _startTime,
                            "endTime": _endTime,
                            "remind": _selectedRemind,
                            "repeat": _selectedRepeat,
                            "color": _selectedColor == 0
                                ? "primaryColor"
                                : _selectedColor == 1
                                    ? "pinkColor"
                                    : "yellowColor",
                          });

                          _selectedDate = DateTime.now();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage())).then((_) {
                            setState(() {});
                          });
                        })
                  ],
                ),
              )
            ]),
          ),
        ));
  }

  validateAndSubmit() {
    if (_titleController.text.isNotEmpty) {
      Navigator.pop(context);
    } else if (_titleController.text.isEmpty) {
      final snackBar = SnackBar(
        content: const Text('You must enter the title!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  colorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: titleStyle),
        Wrap(
            children: List<Widget>.generate(
          3,
          (int index) {
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(top: 6, right: 8),
                decoration: BoxDecoration(
                  color: colorPalette[index],
                  borderRadius: BorderRadius.circular(100),
                ),
                child: index == _selectedColor
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            );
          },
        ))
      ],
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
          _selectedDate = DateTime.now();
        },
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 20,
        ),
      ),
      centerTitle: true,
      title: const Text('Home Page'),
      actions: [
        CircleAvatar(
            radius: 15,
            child: ClipOval(
                child: Image.asset("assets/images/profile_image.jpg"))),
        const SizedBox(width: 15)
      ],
    );
  }

  _getDateFromUser() {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              height: 190,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 180,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        minimumYear: 2000,
                        onDateTimeChanged: (val) {
                          setState(() {
                            _selectedDate = val;
                            _startTime = _selectedDate;
                            _endTime = _startTime.add(const Duration(hours: 1));
                          });
                        }),
                  ),
                ],
              ),
            ));
  }

  _getTimeFromUser({required bool isStartTime}) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              height: 190,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 180,
                    child: CupertinoDatePicker(
                        // use24hFormat: true,
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: isStartTime ? _startTime : _endTime,
                        minimumYear: 2000,
                        onDateTimeChanged: (val) {
                          if (isStartTime == true) {
                            setState(() {
                              // set start time again
                              _startTime = val;
                              // update _startTimeString to re-render to screen
                              // _startTimeString =
                              //     DateFormat("hh:mm a").format(val).toString();
                              // update _endTime to get value
                              _endTime =
                                  _startTime.add(const Duration(hours: 1));
                              // update _endTimeString to re-render to screen
                              // _endTimeString = DateFormat("hh:mm a")
                              //     .format(_endTime)
                              //     .toString();
                            });
                          } else {
                            setState(() {
                              _endTime = val;
                              // _endTimeString =
                              //     DateFormat("hh:mm a").format(val).toString();
                            });
                          }
                        }),
                  ),
                ],
              ),
            ));
  }
}
