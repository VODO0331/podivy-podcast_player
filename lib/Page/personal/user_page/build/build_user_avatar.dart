import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

class BuildUserAvatar extends StatelessWidget {
  final RxString imgData;
  final FirestoreServiceProvider fsp;
  final RxBool isEdit;
  BuildUserAvatar(
      {super.key,
      required this.imgData,
      required this.fsp,
      required this.isEdit});
  final ImagePicker _imagePicker = Get.put(ImagePicker());

  @override
  Widget build(BuildContext context) {
    final Color userAvatar = Get.isDarkMode
        ? Theme.of(Get.context!).colorScheme.primary
        : Theme.of(Get.context!).colorScheme.primaryContainer;
    return Container(
      height: 200.h,
      width: 300.w,
      decoration: BoxDecoration(
          color: userAvatar,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(4, 4))
          ]),
      child: GestureDetector(
        onTap: () {},
        child: Stack(
          alignment: Alignment.center,
          children: [
            Obx(() {
              if (imgData.value != "") {
                return CircleAvatar(
                  backgroundImage: MemoryImage(base64Decode(imgData.value)),
                  radius: 68.r,
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
            _buildEditBt(),
          ],
        ),
      ),
    );
  }

  Widget _buildEditBt() {
    return Obx(() {
      return isEdit.value
          ? Positioned(
              bottom: 0,
              right: 0,
              child: OutlinedButton(
                onPressed: () async {
                  final Uint8List? result = await selectImage();

                  if (result != null) {
                    imgData.value = base64Encode(result);
                  }
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: const CircleBorder()),
                child: Icon(
                  Icons.add_to_photos_outlined,
                  size: 20.r,
                ),
              ),
            )
          : const SizedBox.shrink();
    });
  }

  Future<Uint8List?> selectImage() async {
    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      final Uint8List newImg =
          (Uint8List.fromList(await File(image.path).readAsBytes()));
      if (base64Encode(newImg) != fsp.info.userData.img) {
        return newImg;
      }
    }
    return null;
  }
}
