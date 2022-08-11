import 'package:flutter/material.dart';
import 'package:todo_app/ui/app_colors.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function onTap;

  const MyButton({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        width: 130,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label,
            style: const TextStyle(
              color: Colors.white,
            )),
      ),
    );
  }
}
