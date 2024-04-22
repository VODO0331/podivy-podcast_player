import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podivy/util/toast/generic_toast.dart';

void toastWaning(String text) =>toastGeneric(
      text: text,
      textColor: Theme.of(Get.context!).colorScheme.onErrorContainer,
      icon: Icons.warning_rounded,
      iconColor: Theme.of(Get.context!).colorScheme.onErrorContainer,
      background: Theme.of(Get.context!).colorScheme.errorContainer,
      border: Theme.of(Get.context!).colorScheme.background);
