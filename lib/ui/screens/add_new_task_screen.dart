import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/add_new_task_controller.dart';
import '../widget/center_circular_progress_bar.dart';
import '../widget/screen_background.dart';
import '../widget/td_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  static const String name = '/add-new-task';

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNewTaskController>(
      builder: (controller) {
        return Scaffold(
          appBar: TDAppBar(),
          body: SingleChildScrollView(
            child: ScreenBackground(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Add New Task',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.titleTEController,
                        textInputAction: TextInputAction.next,
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your title';
                          }
                          return null;
                        },
                        decoration: InputDecoration(hintText: 'Title'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.descriptionTEController,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        maxLines: 5,
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your description';
                          }
                          return null;
                        },
                        decoration: InputDecoration(hintText: 'Description'),
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: controller.isLoading == false,
                        replacement: CenteredCircularProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.addNewTask(context);
                            }
                          },
                          child: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}