import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

void toastUnfollow() {
  BotToast.showCustomText(
      align: const AlignmentDirectional(0, -0.8),
      toastBuilder: (void Function() cancelFunc) {
        return Container(
            alignment: Alignment.center,
            height: 50.r,
            width: 220.r,
            decoration: BoxDecoration(
                color: Theme.of(Get.context!).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Theme.of(Get.context!).colorScheme.background)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.cancel_outlined,
                  color: Theme.of(Get.context!).colorScheme.onPrimary,
                ),
                Text(
                  'Unfollowed'.tr,
                  style: TextStyle(
                      color: Theme.of(Get.context!).colorScheme.onPrimary),
                ),
              ],
            ));
      });
}