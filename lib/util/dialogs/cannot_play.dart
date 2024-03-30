import 'package:flutter/material.dart';
import 'package:get/get.dart';


import './generic_dialog.dart';

Future<void> showPlayErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'player error'.tr,
    content: text,
    optionBuilder: () => {
      'OK': null,
    },
  );
}