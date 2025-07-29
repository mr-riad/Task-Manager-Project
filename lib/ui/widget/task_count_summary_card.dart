import 'package:flutter/material.dart';

import '../Model/Task_Status_Count_Model.dart';
import '../Network/network_caller.dart';
import '../ui/utils/urls.dart';
import 'Snackbar_Messages.dart';

class TaskCountSummaryCard extends StatelessWidget {
  const TaskCountSummaryCard({
    super.key,
    required this.title,
    required this.count,
  });

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('$count', style: Theme.of(context).textTheme.titleLarge),
            Text(title, maxLines: 1),
          ],
        ),
      ),
    );
  }
}