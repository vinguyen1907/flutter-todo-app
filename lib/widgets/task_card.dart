import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/pages/update_task_page.dart';
import 'package:todo_app/ui/app_colors.dart';

import '../pages/home_page.dart';

class TaskCard extends StatefulWidget {
  final String id;
  final String title;
  final String? note;
  String? colorString = 'primaryColor';
  final DateTime startTime;
  final DateTime endTime;

  TaskCard({
    Key? key,
    required this.id,
    required this.title,
    this.note,
    this.colorString,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    final Color color = widget.colorString == 'primaryColor'
        ? AppColors.primaryColor
        : widget.colorString == 'yellowColor'
            ? AppColors.yellowColor
            : AppColors.pinkColor;

    return InkWell(
      onTap: () {
        showModalBottomSheet(
            // backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              // topLeft: Radius.circular(20),
              // topRight: Radius.circular(20),
            ),
            context: context,
            builder: (BuildContext context) {
              return _bottomSheet(context, widget.startTime);
            });
      },
      child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding:
              const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 10),
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: color,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.access_alarms_outlined,
                      color: Colors.white, size: 18),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                      "${DateFormat.jm().format(widget.startTime).toString()} - ${DateFormat.jm().format(widget.endTime).toString()} AM",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      )),
                ]),
                const SizedBox(height: 6),
                widget.note == null || widget.note == ""
                    ? const Text("Don't have note.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontStyle: FontStyle.italic))
                    : Text(widget.note!,
                        style: const TextStyle(
                          color: Colors.white,
                        )),
              ],
            ),
            Row(children: [
              Container(
                height: 80,
                width: 1,
                color: Colors.white,
                margin: const EdgeInsets.only(right: 5),
              ),
              const RotatedBox(
                  quarterTurns: -1,
                  child: Text("TODO",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        letterSpacing: 1,
                      ))),
            ])
          ])),
    );
  }

  _bottomSheet(BuildContext context, DateTime startTime) {
    return Container(
        // height: 250,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              height: 5,
              width: 70,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(30),
              )),
          _bottomSheetColorButton(
            title: "Delete",
            color: AppColors.pinkColor,
            context: context,
            onTap: () {
              FirebaseFirestore.instance
                  .collection("ToDo")
                  .doc(widget.id)
                  .delete();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => HomePage(
                            selectedDate: startTime,
                          ))).then((_) {
                setState(() {});
              });
            },
          ),
          _bottomSheetColorButton(
            title: "Edit",
            color: AppColors.primaryColor,
            context: context,
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => UpdateTaskPage()));
            },
          ),
          _bottomSheetBorderButton(
              title: "Cancel",
              context: context,
              onTap: () {
                Navigator.pop(context);
              }),
        ]));
  }

  _bottomSheetColorButton(
      {required String title,
      required Color color,
      required Function onTap,
      required BuildContext context}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )),
        ),
      ),
    );
  }

  _bottomSheetBorderButton(
      {required String title,
      required Function onTap,
      required BuildContext context}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )),
        ),
      ),
    );
  }
}
