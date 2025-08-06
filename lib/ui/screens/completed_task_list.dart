import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/screens/show_task_details.dart';
import 'package:task_manager/ui/utils/urls.dart';

import '../../controller/completed_task_list_controller.dart';
import '../../controller/task_count_summary_controller.dart';
import '../utils/date_format.dart';
import '../widget/center_circular_progress_bar.dart';
import '../widget/task_card.dart';
import '../widget/task_count_summary_card.dart';

class CompletedTaskList extends StatefulWidget {
  const CompletedTaskList({super.key});

  @override
  State<CompletedTaskList> createState() => _CompletedTaskListState();
}

class _CompletedTaskListState extends State<CompletedTaskList> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<TaskCountSummaryController>().getTaskCountSummary();
      Get.find<CompletedTaskListController>().CompletedTaskList();
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
            GetBuilder<TaskCountSummaryController>(
              builder: (controller) {
                return Visibility(
                  visible: controller.isLoading == false,
                  replacement: CenteredCircularProgressIndicator(),
                  child: SizedBox(
                    height: 100,
                    child: ListView.separated(
                      itemCount: controller.taskCountSummaryList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return TaskCountSummaryCard(
                          title: controller.taskCountSummaryList[index].sId!,
                          count: controller.taskCountSummaryList[index].sum!,
                        );
                      },
                      separatorBuilder: (context, index) =>
                      const SizedBox(width: 4),
                    ),
                  ),
                );
              },
            ),
            GetBuilder<CompletedTaskListController>(
              builder: (controller) {
                return Visibility(
                  visible: controller.isLoading == false,
                  replacement: CenteredCircularProgressIndicator(),
                  child: Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 70),
                      itemCount: controller.completedTaskList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ShowTaskDetails(
                                  title: controller
                                      .completedTaskList[index]
                                      .title!,
                                  description: controller
                                      .completedTaskList[index]
                                      .description!,
                                  createdDate: formatDate(
                                    controller
                                        .completedTaskList[index]
                                        .createdDate!,
                                  ),
                                  status: controller
                                      .completedTaskList[index]
                                      .status!,
                                ),
                              ),
                            );
                          },
                          child: TaskCard(
                            taskType: TaskType.completed,
                            taskModel: controller.completedTaskList[index],
                            onTaskStatusUpdated: () {
                              Get.find<TaskCountSummaryController>()
                                  .getTaskCountSummary();
                              Get.find<CompletedTaskListController>()
                                  .CompletedTaskList();
                            },
                            onDeleteTask: () {
                              Get.find<TaskCountSummaryController>()
                                  .getTaskCountSummary();
                              Get.find<CompletedTaskListController>()
                                  .CompletedTaskList();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}