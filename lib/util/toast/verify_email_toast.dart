import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podivy/util/toast/generic_toast.dart';

void toastVerify() => toastGeneric(
      text: 'Verification email sent'.tr,
      textColor: Theme.of(Get.context!).colorScheme.onPrimary,
      icon: Icons.email_outlined,
      iconColor: Theme.of(Get.context!).colorScheme.onPrimary,
      background: Theme.of(Get.context!).colorScheme.primary,
      border:  Theme.of(Get.context!).colorScheme.background);