import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

void toastGeneric({
  required String text,
  required Color textColor,
  required IconData icon,
  required Color iconColor,
  required Color background,
  required Color border,
}) {
  BotToast.showCustomText(
      align: const AlignmentDirectional(0, -0.8),
      toastBuilder: (void Function() cancelFunc) {
        return Container(
            alignment: Alignment.center,
            height: 50.r,
            width: 240.r,
            decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: border)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(icon, color: iconColor),
                Text(
                  text,
                  style: TextStyle(color: textColor),
                ),
              ],
            ));
      });
}
