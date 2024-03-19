import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future languageDialog() async {
  return await showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.language),
            SizedBox(width: 10,),
            Text('language'),
          ],
        ),
        content: Column(
          children: [
            ListTile(
              title: const Text("中文"),
              onTap: () {},
            ),
            ListTile(
              title: const Text("English"),
              onTap: () {},
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('取消'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      );
    },
  );
}