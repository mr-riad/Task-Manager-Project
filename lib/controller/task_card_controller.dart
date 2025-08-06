import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../model/task_model.dart';
import '../network/network_caller.dart';
import '../ui/utils/urls.dart';
import '../ui/widget/snackbar_messages.dart';

class TaskCardController extends GetxController {
  final TaskModel taskModel;

  TaskCardController({required this.taskModel});

  bool _updateTaskStatusInProgress = false;
  bool _deleteTaskInProgress = false;
  String? _errorMessage;

  bool get updateTaskStatusInProgress => _updateTaskStatusInProgress;

  bool get deleteTaskInProgress => _deleteTaskInProgress;

  String? get errorMessage => _errorMessage;

  Future<void> updateTaskStatus(
      String status,
      BuildContext context,
      VoidCallback onTaskStatusUpdated,
      ) async {
    _updateTaskStatusInProgress = true;
    update();

    NetworkResponse response = await networkCaller.getRequest(
      url: urls.UpdateTaskStatusUrl(taskModel.id!, status),
    );

    if (response.isSuccess) {
      _updateTaskStatusInProgress = false;
      showSnackBarMessage(context, 'Task status updated');
      _errorMessage = null;
      Get.back();
      onTaskStatusUpdated();
      update();
    } else {
      _updateTaskStatusInProgress = false;
      update();
      showSnackBarMessage(
        context,
        'Failed to update task status: ${response.errorMessage!}',
      );
      _errorMessage = response.errorMessage!;
      update();
    }

    _updateTaskStatusInProgress = false;
    update();
  }

  Future<void> deleteTask(
      VoidCallback onDeleteTask,
      BuildContext context,
      ) async {
    _deleteTaskInProgress = true;
    update();

    NetworkResponse response = await networkCaller.getRequest(
      url: urls.DeleteTaskUrl(taskModel.id),
    );

    if (response.isSuccess && response.body?['status'] == 'success') {
      _deleteTaskInProgress = false;
      _errorMessage = null;
      onDeleteTask();
      update();
      showSnackBarMessage(context, 'Task deleted');
    } else {
      _deleteTaskInProgress = false;
      _errorMessage = response.errorMessage ?? 'Failed to delete task';
      update();
      showSnackBarMessage(context, "Failed to delete task");
    }

    _deleteTaskInProgress = false;
    update();
  }
}