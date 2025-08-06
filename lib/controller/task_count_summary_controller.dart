import 'package:get/get.dart';
import '../model/task_status_count_model.dart';
import '../network/network_caller.dart';
import '../ui/utils/urls.dart';

class TaskCountSummaryController extends GetxController {
  bool _isLoading = false;
  String? _errorMessage;
  List<TaskStatusCountModel> _taskCountSummaryList = [];

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  List<TaskStatusCountModel> get taskCountSummaryList => _taskCountSummaryList;

  Future<bool> getTaskCountSummary() async {
    bool isSuccess = false;
    _isLoading = true;
    update();
    NetworkResponse response = await networkCaller.getRequest(
      url: urls.GetAllTasksUrl,
    );

    if (response.isSuccess) {
      List<TaskStatusCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskStatusCountModel.fromJson(jsonData));
      }
      list.sort((a, b) => b.sum!.compareTo(a.sum!));
      _taskCountSummaryList = list;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage!;
    }

    _isLoading = false;
    update();
    return isSuccess;
  }
}