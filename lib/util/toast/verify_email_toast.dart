


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

void toastVerify(){

  BotToast.showCustomText(
    align: const AlignmentDirectional(0, -0.8),toastBuilder:(cancelFunc) {
      return  Container(
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
                  Icons.email_outlined,
                  color: Theme.of(Get.context!).colorScheme.onPrimary,
                ),
                Text(
                  'Verification email sent'.tr,
                  style: TextStyle(
                      color: Theme.of(Get.context!).colorScheme.onPrimary),
                ),
              ],
            ));
    },);
}