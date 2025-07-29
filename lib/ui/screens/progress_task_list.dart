import 'package:flutter/material.dart';
import 'package:task_manager/Model/Task_Status_Count_Model.dart';
import 'package:task_manager/Network/network_caller.dart';
import '../../Model/Task_Model.dart';
import '../utils/date_format.dart';
import '../utils/urls.dart';
import '../widget/Center_circular_progress_bar.dart';
import '../widget/Snackbar_Messages.dart';
import '../widget/task_card.dart';
import '../widget/task_count_summary_card.dart';
import 'show_task_details.dart';

class ProgressTaskList extends StatefulWidget {
  const ProgressTaskList({super.key});

  @override
  State<ProgressTaskList> createState() => _ProgressTaskListState();
}

class _ProgressTaskListState extends State<ProgressTaskList> {
  bool _ProgressTaskisLoading = false;
  List<TaskModel> _progressTaskList = [];
  bool _taskCountSummaryLoading = false;
  List<TaskStatusCountModel> _taskCountSummaryList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getProgressTaskList();
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
              visible: _ProgressTaskisLoading == false,
              replacement: CenteredCircularProgressIndicator(),
              child: Expanded(
                child: ListView.builder(
                  itemCount: _progressTaskList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ShowTaskDetails(
                              title: _progressTaskList[index].title!,
                              description:
                              _progressTaskList[index].description!,
                              createdDate: formatDate(
                                _progressTaskList[index].createdDate!,
                              ),
                              status: _progressTaskList[index].status!,
                            ),
                          ),
                        );
                      },
                      child: TaskCard(
                        taskType: TaskType.progress,
                        taskModel: _progressTaskList[index],
                        onTaskStatusUpdated: () {
                          _getTaskCountSummary();
                          _getProgressTaskList();
                        },
                        onDeleteTask: () {
                          _getTaskCountSummary();
                          _getProgressTaskList();
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

  Future<void> _getProgressTaskList() async {
    _ProgressTaskisLoading = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await networkCaller.getRequest(
      url: urls.ProgressTasksUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];

      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _progressTaskList = list;
    } else {
      if (mounted) {
        showSnackBarMessage(context, response.errorMessage!);
      }
    }
    _ProgressTaskisLoading = false;
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