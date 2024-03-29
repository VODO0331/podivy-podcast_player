import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

void toastSuccess(String text) {
  BotToast.showCustomText(
      align: const AlignmentDirectional(0, -0.8),
      toastBuilder: (void Function() cancelFunc) {
        return Container(
            alignment: Alignment.center,
            height: 50.r,
            width: 220.r,
            decoration: BoxDecoration(
                color: Theme.of(Get.context!).colorScheme.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Theme.of(Get.context!).colorScheme.onBackground)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  FontAwesomeIcons.check,
                  color: Colors.lightGreen,
                ),
                Text(
                  text,
                  style: TextStyle(
                      color: Theme.of(Get.context!).colorScheme.onBackground),
                ),
              ],
            ));
      });
}


