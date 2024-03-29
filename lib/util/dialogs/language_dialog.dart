import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internationalization_repository/internationalization.dart';

typedef LanguageCallback = void Function(String language);

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
              onTap: () {
                translationService.changeLanguage('zh', 'TW');
                // languageCallback("intl language".tr);
              },
            ),
            ListTile(
                title: const Text("English"),
                onTap: () {
                  translationService.changeLanguage('en', 'US');
                  // languageCallback("intl language".tr);
                }),
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
