import 'package:flutter/material.dart';
import 'package:todo_app/ui/app_colors.dart';

class Themes {
  static final light = ThemeData(
      // primaryColor: AppColors.primaryColor,
      // primaryColor is removed
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryColor,
      ));

  static final dark = ThemeData(
      // primaryColor: Colors.yellow,
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkGreyColor,
      ));
}
