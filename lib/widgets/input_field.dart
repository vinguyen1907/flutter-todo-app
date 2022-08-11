import 'package:flutter/material.dart';
import 'package:todo_app/ui/app_styles.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final Widget? widget;
  final TextEditingController? controller;

  const InputField({
    Key? key,
    required this.title,
    required this.hint,
    this.widget,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              title,
              style: titleStyle,
            ),
            FractionallySizedBox(
              // widthFactor: 0.9,
              child: Container(
                  margin: const EdgeInsets.only(top: 7),
                  height: size.height / 17,
                  width: size.width * 0.9,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      )),
                  alignment: Alignment.center,
                  child: Row(children: [
                    Expanded(
                        child: TextFormField(
                      readOnly: widget == null ? false : true,
                      autofocus: false,
                      cursorColor: Colors.grey[700],
                      cursorHeight: 20,
                      controller: controller,
                      style: subTitleStyle,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: subTitleStyle,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    )),
                    widget ?? Container(child: widget),
                  ])),
            )
          ])
        ]));
  }
}
