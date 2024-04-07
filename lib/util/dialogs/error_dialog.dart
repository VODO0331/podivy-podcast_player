import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'Error'.tr,
    content: text,
    optionBuilder: () => {
      'OK': null,
    },
  );
}
