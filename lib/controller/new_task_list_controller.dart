import 'package:get/get.dart';
import '../model/task_model.dart';
import '../network/network_caller.dart';
import '../ui/utils/urls.dart';

class NewTaskListController extends GetxController {
  bool _isLoading = false;
  List<TaskModel> _newTaskList = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;

  List<TaskModel> get newTaskList => _newTaskList;

  String? get errorMessage => _errorMessage;

  Future<bool> getNewTaskList() async {
    bool isSuccess = false;
    _isLoading = true;
    update();

    NetworkResponse response = await networkCaller.getRequest(
      url: urls.GetNewTasksUrl,
    );
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _newTaskList = list;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage!;
    }

    _isLoading = false;
    update();
    return isSuccess;
  }
}