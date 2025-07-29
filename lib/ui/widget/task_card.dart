import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/urls.dart';
import '../Model/Task_Model.dart';
import '../Network/network_caller.dart';
import '../ui/utils/DateFormat.dart';
import 'Center_circular_progress_bar.dart';
import 'Snackbar_Messages.dart';

enum TaskType { tNew, progress, completed, cancelled }

class TaskCard extends StatefulWidget {
  final TaskType taskType;
  final TaskModel taskModel;
  final VoidCallback onTaskStatusUpdated;
  final VoidCallback onDeleteTask;

  const TaskCard({
    super.key,
    required this.taskType,
    required this.taskModel,
    required this.onTaskStatusUpdated,
    required this.onDeleteTask,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _updateTaskStatusInProgress = false;
  bool _DeleteTaskisLoading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              widget.taskModel.description!,
              style: TextStyle(color: Colors.black54),
            ),
            //Text(widget.taskModel.createdDate!),
            Text(formatDate(widget.taskModel.createdDate!)),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(
                    _getTaskTypeName(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  backgroundColor: _getTaskChipColor(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Spacer(),
                Visibility(
                  visible: _updateTaskStatusInProgress == false,
                  replacement: CenteredCircularProgressIndicator(),
                  child: IconButton(
                    onPressed: () => _showEditTaskStatusDialog(),
                    icon: Icon(Icons.edit,
                      color: Colors.green,
                    ),
                  ),
                ),
                Visibility(
                  visible: _DeleteTaskisLoading == false,
                  replacement: CenteredCircularProgressIndicator(),
                  child: IconButton(
                    onPressed: () => _deleteTask(),
                    icon: Icon(Icons.delete,
                        color: Colors.red),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTaskChipColor() {
    switch (widget.taskType) {
      case TaskType.tNew:
        return Colors.blue;
      case TaskType.progress:
        return Colors.purple;
      case TaskType.completed:
        return Colors.green;
      case TaskType.cancelled:
        return Colors.red;
      case null:
      // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  String _getTaskTypeName() {
    switch (widget.taskType) {
      case TaskType.tNew:
        return 'New';
      case TaskType.progress:
        return 'Progress';
      case TaskType.completed:
        return 'Completed';
      case TaskType.cancelled:
        return 'Cancelled';
      case null:
      // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  void _showEditTaskStatusDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Task Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('New'),
                trailing: _getTaskStatusTrailing(TaskType.tNew),
                onTap: () {
                  if (widget.taskType == TaskType.tNew) {
                    return;
                  }
                  _updateTaskStatus('New');
                },
              ),
              ListTile(
                title: Text('Progress'),
                trailing: _getTaskStatusTrailing(TaskType.progress),
                onTap: () {
                  if (widget.taskType == TaskType.progress) {
                    return;
                  }
                  _updateTaskStatus('Progress');
                },
              ),
              ListTile(
                title: Text('Completed'),
                trailing: _getTaskStatusTrailing(TaskType.completed),
                onTap: () {
                  if (widget.taskType == TaskType.completed) {
                    return;
                  }
                  _updateTaskStatus('Completed');
                },
              ),
              ListTile(
                title: Text('Cancelled'),
                trailing: _getTaskStatusTrailing(TaskType.cancelled),
                onTap: () {
                  if (widget.taskType == TaskType.cancelled) {
                    return;
                  }
                  _updateTaskStatus('Cancelled');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget? _getTaskStatusTrailing(TaskType type) {
    return widget.taskType == type ? Icon(Icons.check) : null;
  }

  Future<void> _updateTaskStatus(String status) async {
    Navigator.pop(context);
    _updateTaskStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }

    NetworkResponse response = await networkCaller.getRequest(
      url: urls.UpdateTaskStatusUrl(widget.taskModel.id!, status),
    );

    _updateTaskStatusInProgress = false;

    if (response.isSuccess) {
      if (mounted) {
        setState(() {
          widget.onTaskStatusUpdated();
        });
      }
    } else {
      _updateTaskStatusInProgress = false;
      if (mounted) {
        showSnackBarMessage(
          context,
          'Failed to update task status: ${response.errorMessage!}',
        );
      }
    }
  }

  Future<void> _deleteTask() async {
    _DeleteTaskisLoading = true;
    if (mounted) {
      setState(() {});
    }

    NetworkResponse response = await networkCaller.getRequest(
      url: urls.DeleteTaskUrl(widget.taskModel.id),
    );

    if (response.isSuccess) {
      String getStatus = response.body!['status'] ?? '';

      if (getStatus == 'success') {
        _DeleteTaskisLoading = false;
        if (mounted) {
          widget.onDeleteTask();
          setState(() {});
          showSnackBarMessage(context, "Task deleted successfully");
        }
      } else {
        if (mounted) {
          _DeleteTaskisLoading = false;
          showSnackBarMessage(context, "Failed to delete task");
        }
      }
    } else {
      if (mounted) {
        _DeleteTaskisLoading = false;
        showSnackBarMessage(context, response.errorMessage!);
      }
    }

    _DeleteTaskisLoading = false;
    if (mounted) {
      setState(() {});
    }
  }
}