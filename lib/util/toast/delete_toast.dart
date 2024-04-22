
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

void toastDelete(String text) {
  BotToast.showCustomText(
      align: const AlignmentDirectional(0, -0.8),
      toastBuilder: (void Function() cancelFunc) {
        return Container(
            alignment: Alignment.center,
            height: 40.r,
            width: 150.r,
            decoration: BoxDecoration(
                color: Theme.of(Get.context!).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Theme.of(Get.context!).colorScheme.background)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_forever,
                  color: Theme.of(Get.context!).colorScheme.onErrorContainer,
                ),
                Text(
                  text,
                  style: TextStyle(
                      color:
                          Theme.of(Get.context!).colorScheme.onErrorContainer),
                ),
              ],
            ));
      });
}


