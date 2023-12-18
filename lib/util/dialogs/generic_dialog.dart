import 'package:flutter/material.dart';
import 'package:get/get.dart';
typedef DialogOptoinBuilder<T> = Map<String, T?> Function();
Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptoinBuilder optoinBuilder,
}) {
  final options = optoinBuilder();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Color.fromARGB(230, 49, 49, 49),
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
              style: const TextStyle(
                color: Color(0xFFABC4AA),
              ),
            ),
          );
        }).toList(),
      );
    },
  );
}
