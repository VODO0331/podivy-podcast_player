import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podivy/util/toast/success_toast.dart';

Future<void> updateListNameDialog(UserList list) async {
   await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        TextEditingController textEditingController =
            Get.put(TextEditingController());
        return AlertDialog(
          title: Text('New list name'.tr),
          content: TextField(
            controller: textEditingController,
            decoration:
                InputDecoration(hintText: 'Please enter the new name'.tr),
            onChanged: (value) {
              textEditingController.text = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 取消
              },
              child: Text('Cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () async {
                final ListManagement listManagement = Get.find();
                if (await listManagement.updateList(
                    list, textEditingController.text)) {
                  toastSuccess('updated'.tr);
                }
                textEditingController.clear();
                Get.back();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      });
}