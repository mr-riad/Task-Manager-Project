import 'package:get/get.dart';
import '../model/task_model.dart';
import '../network/network_caller.dart';
import '../ui/utils/urls.dart';

class CancelledTaskListController extends GetxController {
  bool _isLoading = false;
  List<TaskModel> _cancelledTaskList = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;

  List<TaskModel> get cancelledTaskList => _cancelledTaskList;

  String? get errorMessage => _errorMessage;

  Future<bool> getCancelledTaskList() async {
    bool isSuccess = false;
    _isLoading = true;
    update();

    NetworkResponse response = await networkCaller.getRequest(
      url: urls.CancelledTasksUrl,
    );

    if (response.isSuccess) {
      _isLoading = true;
      final List<TaskModel> list = [];

      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _cancelledTaskList = list;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage!;
    }

    _isLoading = false;
    update();

    return isSuccess;
  }
}