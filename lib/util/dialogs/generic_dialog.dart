import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(Get.context!).dialogBackgroundColor,
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTile) {
          final value = options[optionTile];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Get.back(result: value);
              } else {
                Get.back();
              }
            },
            child: Text(
              optionTile,
              style:  TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }).toList(),
      );
    },
  );
}
