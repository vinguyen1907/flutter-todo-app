import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/pages/add_task_page.dart';
import 'package:todo_app/services/get_data_by_id.dart';
import 'package:todo_app/services/local_notification.dart';
import 'package:todo_app/ui/app_colors.dart';
import 'package:todo_app/ui/app_styles.dart';
import 'package:todo_app/widgets/button.dart';

class HomePage extends StatefulWidget {
  final DateTime? selectedDate;

  HomePage({Key? key, this.selectedDate}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final LocalNotificationService service;
  late DateTime _selectedDate;

  List<String> docIDs = [];
  List<ToDos> todos = [];

  Future getDocIDs() async {
    docIDs = [];
    await FirebaseFirestore.instance
        .collection("ToDo")
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              docIDs.add(element.id);
            }));
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
    // print(_selectedDate);
    service = LocalNotificationService();
    service.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: FutureBuilder(
                    future: getDocIDs(),
                    builder: (context, snapshot) {
                      bool isLoading = false;
                      void setIsLoading() {
                        isLoading = true;
                      }

                      return ListView.builder(
                          // shrinkWrap: true,
                          itemCount: docIDs.length,
                          itemBuilder: (context, index) {
                            return GetDataById(
                                documentId: docIDs[index],
                                date: _selectedDate,
                                setIsLoading: setIsLoading,
                                isLoading: isLoading);
                          });
                    }),
              ),
            ),
          ],
        ));
  }

  _addDateBar() {
    return Container(
        margin: const EdgeInsets.only(top: 20, left: 20),
        child: DatePicker(DateTime.now(),
            height: 100,
            width: 80,
            initialSelectedDate: _selectedDate,
            selectionColor: AppColors.primaryColor,
            selectedTextColor: Colors.white,
            dateTextStyle: subHeadingStyle.copyWith(
              fontSize: 20,
            ), onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        }));
  }

  _appBar() {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      leading: InkWell(
        onTap: () async {
          await service.showNotification(
            id: 1,
            title: 'Notification',
            body: 'This is a notification',
          );
        },
        child: const Icon(
          Icons.nightlight_round,
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

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(DateFormat.yMMMMd().format(DateTime.now()),
              style: subHeadingStyle),
          Text("Today", style: headingStyle),
        ]),
        MyButton(
            label: "+ Add task",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddTaskPage();
              }));
            }),
      ]),
    );
  }
}
