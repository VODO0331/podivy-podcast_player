import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Cancel'.tr,
    content: 'Are you sure you want to cancel follow?'.tr,
    optionBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
