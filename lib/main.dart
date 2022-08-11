import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/pages/home_page.dart';
import 'package:todo_app/pages/login_page.dart';
import 'package:todo_app/pages/onboarding_page.dart';
import 'package:todo_app/ui/app_colors.dart';
import 'package:todo_app/widgets/task_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.leanBack); // hide status bar on Android devices
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "ToDo App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        darkTheme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.darkGreyColor,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        themeMode: ThemeMode.light,
        home: OnBoardingPage());
  }
}
