import 'package:flutter/material.dart';
import 'package:flutter_demo/models/account.dart';
import 'package:flutter_demo/models/task.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../controller/PhongBanListController.dart';
import '../../helpers/utils.dart';

class TaskView extends StatefulWidget {
  final Task task;
  const TaskView({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var actionButtontext = '';
  var canAcceptTask = false;
  var canSubmitTask = false;
  var canStartTask = false;
  @override
  void initState() {
    super.initState();
    switch (widget.task.status) {
      case 0:
        canStartTask = true;
        actionButtontext = "Huỷ Task";
        //Chưa nhận
        break;
      case 1:
        canSubmitTask = true;
        canAcceptTask = true;
        //Đã nhận
        break;
      case 2:
        //Đã huỷ
        break;
      case 3:
        actionButtontext = "Reject Task";
        canSubmitTask = true;
        canAcceptTask = true;
        //Đang chờ
        break;
      case 4:
        canSubmitTask = true;
        canAcceptTask = true;
        //Từ chối - reject
        break;
      case 5:
        canAcceptTask = false;
        canSubmitTask = false;
        canStartTask = false;
        //Đã xong
        break;
    }
    setState(() {
      canAcceptTask;
      canSubmitTask;
      canStartTask;
      actionButtontext;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 140, 231, 227),
      margin: const EdgeInsets.only(bottom: 2.0, top: 2.0),
      elevation: 0,
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tên: ${widget.task.ten}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 3,
            ),
            const SizedBox(
              height: 6.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: const Color.fromARGB(255, 117, 117, 117)),
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Người giao: ${widget.task.owner}',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: const Color.fromARGB(255, 117, 117, 117)),
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Người được giao: ${widget.task.assign}',
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {},
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Color.fromARGB(255, 118, 248, 12),
                            ),
                            child: Center(
                              child: Text(
                                'Xem',
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (canSubmitTask &&
                        widget.task.assign_id == Utils.getAccount().id)
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {},
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Color.fromARGB(255, 26, 115, 232),
                              ),
                              child: Center(
                                child: Text(
                                  'Submit',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (canStartTask &&
                        widget.task.assign_id == Utils.getAccount().id)
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            showTopSnackBar(
                              Overlay.of(context)!,
                              CustomSnackBar.info(
                                message: await Utils.startTask(widget.task),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Color.fromARGB(255, 26, 115, 232),
                              ),
                              child: Center(
                                child: Text(
                                  'Start',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (Utils.getAccount().role != 'user' &&
                        actionButtontext != '')
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            showTopSnackBar(
                              Overlay.of(context)!,
                              CustomSnackBar.info(
                                message: await Utils.rejectTask(widget.task),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Color.fromARGB(255, 26, 115, 232),
                              ),
                              child: Center(
                                child: Text(
                                  actionButtontext,
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (Utils.getAccount().role != 'user' && canAcceptTask)
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            showTopSnackBar(
                              Overlay.of(context)!,
                              CustomSnackBar.info(
                                message: await Utils.acceptTask(widget.task),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Color.fromARGB(255, 26, 115, 232),
                              ),
                              child: Center(
                                child: Text(
                                  'Accept',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                // ${canSubmitTask && row.assign_id == window.accountId ? Submit}
                //             ${canStartTask && row.assign_id == window.accountId ? Start}
                //             ${window.accountRole != "user" && actionButtontext != "" ? `${actionButtontext}}
                //             ${window.accountRole != "user" && canAcceptTask ? `<button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#acceptTask" data-task="">Accept Task</button>` : ''}
              ],
            ),
            const SizedBox(
              height: 6.0,
            ),
            const SizedBox(height: 6.0),
          ],
        ),
        onTap: () async {},
      ),
    );
  }
}
