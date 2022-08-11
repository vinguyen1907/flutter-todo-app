import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/widgets/task_card.dart';

class GetDataById extends StatelessWidget {
  final String documentId;
  final DateTime date;
  final bool isLoading;
  final Function setIsLoading;

  GetDataById({
    Key? key,
    required this.documentId,
    required this.date,
    required this.setIsLoading,
    required this.isLoading,
  }) : super(key: key);

  bool isThisDate = false;

  @override
  Widget build(BuildContext context) {
    CollectionReference todos = FirebaseFirestore.instance.collection('ToDo');

    return FutureBuilder<DocumentSnapshot>(
        future: todos.doc(documentId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            isThisDate = DateFormat.yMd().format(data["date"].toDate()) ==
                DateFormat.yMd().format(date);
            if (data['title'] != "" && isThisDate) {
              return TaskCard(
                id: documentId,
                title: data['title'],
                note: data["note"],
                startTime: data['startTime'].toDate(),
                endTime: data['endTime'].toDate(),
                colorString: data['color'],
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting &&
              isLoading == false) {
            setIsLoading();
            return const Center(child: CircularProgressIndicator());
          }
          return Container();
        });
  }
}
