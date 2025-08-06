import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/new_task_list.dart';
import 'package:task_manager/ui/screens/progress_task_list.dart';
import '../utils/urls.dart';
import '../widget/td_app_bar.dart';
import 'add_new_task_screen.dart';
import 'canceled_task_list.dart';
import 'completed_task_list.dart';

class MainNavbarScreen extends StatefulWidget {
  const MainNavbarScreen({super.key});

  static const String name = '/main-nav-bar-holder';

  @override
  State<MainNavbarScreen> createState() => _MainNavbarScreenState();
}

class _MainNavbarScreenState extends State<MainNavbarScreen> {
  final List<Widget> _screens = [
    NewTaskList(),
    ProgressTaskList(),
    CompletedTaskList(),
    CanceledTaskList(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDAppBar(),
      body: _screens[_selectedIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.new_label_outlined),
            label: 'New',
          ),
          NavigationDestination(
            icon: Icon(Icons.arrow_circle_right_outlined),
            label: 'Progress',
          ),
          NavigationDestination(icon: Icon(Icons.done), label: 'Completed'),
          NavigationDestination(icon: Icon(Icons.close), label: 'Cancelled'),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTaskButton,
        child: Icon(Icons.add),
      ),
    );
  }

  void _onTapAddNewTaskButton() {
    Navigator.pushNamed(context, AddNewTaskScreen.name).then((value) {
      if (value == true) {
        setState(() {});
      }
    });
  }
}