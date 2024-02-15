import 'package:flutter/material.dart';

import './generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: '取消提醒',
    content: '確定取消追蹤?',
    optionBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
