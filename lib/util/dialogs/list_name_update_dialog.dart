import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podivy/util/toast/success_toast.dart';

Future<void> updateListNameDialog(UserList list) async {
  await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        TextEditingController textEditingController = Get.put(
            TextEditingController(text: list.listTitle),
            tag: 'listNameUpdate:${list.docId}');
        return AlertDialog(
          title: Text('New list name'.tr),
          content: TextField(
            controller: textEditingController,
            decoration:
                InputDecoration(hintText: 'Please enter the new name'.tr),
            
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 取消
                Get.delete<TextEditingController>(tag: 'listNameUpdate:${list.docId}'); 
              },
              child: Text('Cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () async {
                final fsp = Get.find<FirestoreServiceProvider>();
                if (await fsp.list
                    .updateList(list, textEditingController.text)) {
                  toastSuccess('updated'.tr);
                }
                
                Get.back();
                Get.delete<TextEditingController>(tag: 'listNameUpdate:${list.docId}'); 
              },
              child: const Text('Ok'),
            ),
          ],
        );
      });
  if (Get.isRegistered<TextEditingController>(
      tag: 'listNameUpdate:${list.docId}')) {
    Get.delete<TextEditingController>(tag: 'listNameUpdate:${list.docId}');
  }
}
