import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/util/toast/generic_toast.dart';

void toastSuccess(String text) =>toastGeneric(
      text: text,
      textColor: Theme.of(Get.context!).colorScheme.onBackground,
      icon: FontAwesomeIcons.check,
      iconColor: Colors.lightGreen,
      background: Theme.of(Get.context!).colorScheme.background,
      border: Theme.of(Get.context!).colorScheme.onBackground);


