import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/Add_new_task_screen.dart';
import 'package:task_manager/ui/screens/EmailVarification.dart';
import 'package:task_manager/ui/screens/main_navbar_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/screens/spalash_screen.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';

import '../ui/screens/EmailPinVarification.dart';
import '../ui/screens/SetPassword.dart';
import '../ui/screens/Sign_in_screen.dart';
import '../ui/screens/new_task_list.dart';

class TaskManager extends StatefulWidget {
  const TaskManager({super.key});

  @override
  State<TaskManager> createState() => _TaskManagerState();
  static GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

}

class _TaskManagerState extends State<TaskManager> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: TaskManager.navigator,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),

        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: Size.fromWidth(double.maxFinite),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.green),
        ),
      ),

      initialRoute: '/',
      routes: {
        SpalashScreen.name: (context) => SpalashScreen(),
        SignInScreen.name: (context) => SignInScreen(),
        SignUpScreen.name: (context) => SignUpScreen(),
        Emailvarification.name: (context) => Emailvarification(),
        Emailpinvarification.name: (context) => Emailpinvarification(),
        Setpassword.name: (context) => Setpassword(),
        MainNavbarScreen.name: (context) => MainNavbarScreen(),
        UpdateProfileScreen.name: (context) => UpdateProfileScreen(),
        NewTaskList.name: (context) => NewTaskList(),
        AddNewTaskScreen.name: (context) => AddNewTaskScreen(),
      },
    );
  }
}