import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podivy/util/toast/generic_toast.dart';

void toastUnfollow() =>toastGeneric(
      text: 'Unfollowed'.tr,
      textColor: Theme.of(Get.context!).colorScheme.onPrimary,
      icon: Icons.cancel_outlined,
      iconColor: Theme.of(Get.context!).colorScheme.onPrimary,
      background: Theme.of(Get.context!).colorScheme.primary,
      border: Theme.of(Get.context!).colorScheme.background);
