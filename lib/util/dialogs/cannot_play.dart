import 'package:flutter/material.dart';


import './generic_dialog.dart';

Future<void> showPlayErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'ERROR，播放錯誤',
    content: text,
    optionBuilder: () => {
      'OK': null,
    },
  );
}