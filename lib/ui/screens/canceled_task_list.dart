import 'package:flutter/material.dart';
import 'package:task_manager/Model/Task_Model.dart';
import 'package:task_manager/Network/network_caller.dart';
import 'package:task_manager/ui/utils/urls.dart';
import 'package:task_manager/widget/Center_circular_progress_bar.dart';
import '../../Model/Task_Status_Count_Model.dart';
import '../../widget/Snackbar_Messages.dart';
import '../../widget/Task_card.dart';
import '../../widget/Task_count_summary_card.dart';
import '../utils/DateFormat.dart';
import 'Show_Task_Details.dart';

class CanceledTaskList extends StatefulWidget {
  const CanceledTaskList({super.key});

  @override
  State<CanceledTaskList> createState() => _CanceledTaskListState();
}

class _CanceledTaskListState extends State<CanceledTaskList> {
  List<TaskModel> _canceledTaskList = [];
  bool _CancelledTaskisLoading = false;
  bool _taskCountSummaryLoading = false;
  List<TaskStatusCountModel> _taskCountSummaryList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCancelledTaskList();
      _getTaskCountSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Visibility(
              visible: _taskCountSummaryLoading == false,
              replacement: CenteredCircularProgressIndicator(),
              child: SizedBox(
                height: 100,
                child: ListView.separated(
                  itemCount: _taskCountSummaryList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return TaskCountSummaryCard(
                      title: _taskCountSummaryList[index].sId!,
                      count: _taskCountSummaryList[index].sum!,
                    );
                  },
                  separatorBuilder: (context, index) =>
                  const SizedBox(width: 4),
                ),
              ),
            ),
            Visibility(
              visible: _CancelledTaskisLoading == false,
              replacement: CenteredCircularProgressIndicator(),
              child: Expanded(
                child: ListView.builder(
                  itemCount: _canceledTaskList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ShowTaskDetails(
                              title: _canceledTaskList[index].title!,
                              description:
                              _canceledTaskList[index].description!,
                              createdDate: formatDate(
                                _canceledTaskList[index].createdDate!,
                              ),
                              status: _canceledTaskList[index].status!,
                            ),
                          ),
                        );
                      },
                      child: TaskCard(
                        taskType: TaskType.cancelled,
                        taskModel: _canceledTaskList[index],
                        onTaskStatusUpdated: () {
                          _getTaskCountSummary();
                          _getCancelledTaskList();
                        },
                        onDeleteTask: () {
                          _getTaskCountSummary();
                          _getCancelledTaskList();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCancelledTaskList() async {
    _CancelledTaskisLoading = true;
    if (mounted) {
      setState(() {});
    }

    NetworkResponse response = await networkCaller.getRequest(
      url: urls.CancelledTasksUrl,
    );

    if (response.isSuccess) {
      _CancelledTaskisLoading = true;
      final List<TaskModel> list = [];

      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _canceledTaskList = list;
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          'Failed to load cancelled tasks: ${response.errorMessage!}',
        );
      }
    }

    _CancelledTaskisLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getTaskCountSummary() async {
    _taskCountSummaryLoading = true;

    if (mounted) {
      setState(() {});
    }

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
    } else {
      if (mounted) {
        showSnackBarMessage(context, response.errorMessage!);
      }
    }

    _taskCountSummaryLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}