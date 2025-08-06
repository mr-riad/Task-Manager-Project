import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../network/network_caller.dart';
import '../ui/screens/main_navbar_screen.dart';
import '../ui/utils/urls.dart';
import '../ui/widget/snackbar_messages.dart';

class AddNewTaskController extends GetxController {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
  TextEditingController();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  TextEditingController get titleTEController => _titleTEController;

  TextEditingController get descriptionTEController => _descriptionTEController;

  Future<void> addNewTask(BuildContext context) async {
    _isLoading = true;
    update();

    Map<String, String> requestbody = {
      'title': _titleTEController.text.trim(),
      'description': _descriptionTEController.text.trim(),
      'status': 'New',
    };

    NetworkResponse response = await networkCaller.postRequest(
      url: urls.AddNewTaskUrl,
      body: requestbody,
    );

    _isLoading = false;
    update();
    if (response.isSuccess) {
      _titleTEController.clear();
      _descriptionTEController.clear();

      showSnackBarMessage(context, 'Task added successfully');
      Navigator.pushReplacementNamed(context, MainNavbarScreen.name);
    } else {
      showSnackBarMessage(
        context,
        'Failed to add task: ${response.errorMessage!}',
      );
    }
  }

  @override
  void onClose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.onClose();
  }
}