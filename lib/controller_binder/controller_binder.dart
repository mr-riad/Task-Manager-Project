import 'package:get/get.dart';

import '../controller/add_new_task_controller.dart';
import '../controller/cancelled_task_list_controller.dart';
import '../controller/completed_task_list_controller.dart';
import '../controller/email_pin_varification_controller.dart';
import '../controller/email_varification_controller.dart';
import '../controller/new_task_list_controller.dart';
import '../controller/progress_task_list_controller.dart';
import '../controller/set_password_controller.dart';
import '../controller/sign_in_controller.dart';
import '../controller/sign_up_controller.dart';
import '../controller/task_count_summary_controller.dart';
import '../controller/update_profile_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(EmailVerificationController());
    Get.put(EmailPinVerificationController());
    Get.put(SetPasswordController());
    Get.put(SignUpController());
    Get.put(AddNewTaskController());
    Get.put(TaskCountSummaryController());
    Get.put(NewTaskListController());
    Get.put(ProgressTaskListController());
    Get.put(CancelledTaskListController());
    Get.put(CompletedTaskListController());
    Get.put(UpdateProfileController());
  }
}