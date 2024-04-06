import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

void toastWaning(String text) {
  BotToast.showCustomText(
      align: const AlignmentDirectional(0, -0.8),
      toastBuilder: (cancelFunc) => Container(
          alignment: Alignment.center,
          height: 40.r,
          // width: 120.r,
          decoration: BoxDecoration(
              color: Theme.of(Get.context!).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Theme.of(Get.context!).colorScheme.background)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_rounded,
                color: Theme.of(Get.context!).colorScheme.onPrimaryContainer,
              ),
              Text(
                text,
                style: TextStyle(
                    color: Theme.of(Get.context!).colorScheme.onPrimaryContainer),
              ),
            ],
          )));
}