import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podivy/international/intl.dart';

Future languageDialog() async {
  final TranslationService translationService = Get.put(TranslationService());
  return await showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.language),
            SizedBox(
              width: 10,
            ),
            Text('language'),
          ],
        ),
        content: Column(
          children: [
            ListTile(
              title: const Text("中文"),
              onTap: () =>
                  translationService.updateTransition(const Locale('zh', 'TW')),
            ),
            ListTile(
              title: const Text("English"),
              onTap: () =>
                  translationService.updateTransition(const Locale('en', 'US')),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      );
    },
  );
}
