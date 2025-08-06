import 'package:get/get.dart';
import '../model/task_model.dart';
import '../network/network_caller.dart';
import '../ui/utils/urls.dart';

class CompletedTaskListController extends GetxController {
  bool _isLoading = false;
  List<TaskModel> _completedTaskList = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;

  List<TaskModel> get completedTaskList => _completedTaskList;

  String? get errorMessage => _errorMessage;

  Future<bool> CompletedTaskList() async {
    bool isSuccess = false;
    _isLoading = true;
    update();

    NetworkResponse response = await networkCaller.getRequest(
      url: urls.CompletedTasksUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _completedTaskList = list;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage!;
    }

    _isLoading = false;
    update();
    return isSuccess;
  }
}