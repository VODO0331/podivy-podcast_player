import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// import 'dart:developer' as dev show log;
class UserPage extends StatelessWidget {
  UserPage({Key? key}) : super(key: key);

  // final UserInfo userData = Get.arguments;
  final TextEditingController _textEditingController =
      Get.put(TextEditingController());
  final ImagePicker _imagePicker = Get.put(ImagePicker());
  final InformationController userController = Get.find();
  final InformationManagement informationManagement =
      Get.put(InformationManagement());
  final RxBool _isEdit = false.obs;
  final Rx<String> imgData = ''.obs;
  Future<Uint8List?> selectImage() async {
    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      final Uint8List newImg =
          (Uint8List.fromList(await File(image.path).readAsBytes()));
      if (base64Encode(newImg) != userController.userData.img) {
        return newImg;
      }
    }
    return null;
  }

  Widget _buildAppBar() {
    return Container(
      color: Theme.of(Get.context!).colorScheme.secondaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            iconSize: 35.r,
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_rounded),
          ),
          PopupMenuButton(
            color: Theme.of(Get.context!).colorScheme.primary,
            icon: Icon(
              Icons.more_vert_sharp,
              size: 35.r,
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: true,
                  child: Text('Edit'.tr),
                )
              ];
            },
            onSelected: (value) {
              _isEdit.value = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEditBt() {
    return Obx(() {
      return _isEdit.value
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

  Widget _buildUserAvatar() {
    return Container(
      height: 200.h,
      width: 300.w,
      decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 15, offset: Offset(0, 5))
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

  @override
  Widget build(BuildContext context) {
    // 獲取用戶email
    final userEmail = AuthService.firebase().currentUser!.email;
    imgData.value = userController.userData.img;
    return Scaffold(
      key: UniqueKey(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const Divider(
              color: Colors.white12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15).r,
              child: _buildUserAvatar(),
            ),

            // 顯示用戶名稱的ListTile
            Obx(() {
              _textEditingController.text =
                  userController.userData.userName.value;
              return _isEdit.value
                  ? TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        labelText: "Name".tr,
                      ),
                    )
                  : ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(
                        "Name :   ${userController.userData.userName}".tr,
                        style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                      ),
                    );
            }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(
                userEmail,
                style: TextStyle(fontSize: ScreenUtil().setSp(15)),
              ),
            ),
            const Divider(),
            Obx(() => _isEdit.value
                ? Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          _isEdit.value = false;
                          final List<dynamic> updates = [null, null];
                          if (_textEditingController.text !=
                              userController.userData.name) {
                            updates[0] = _textEditingController.text;
                          }
                          if (userController.userData.img != imgData.value) {
                            updates[1] = base64Decode(imgData.value);
                          }
                          informationManagement.updateInfo(
                            userName: updates[0],
                            userImg: updates[1],
                          );
                        },
                        child: Text("Done".tr),
                      ),
                      TextButton(
                        onPressed: () async {
                          _textEditingController.text =
                              userController.userData.userName.value;
                          imgData.value = userController.userData.userImg.value;
                          _isEdit.value = false;
                        },
                        child: Text("Cancel".tr),
                      )
                    ],
                  )
                : const SizedBox.shrink()),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  'assets/images/background/user.png',
                  width: 230.r,
                  height: 250.r,
                  cacheHeight: 525.r.toInt(),
                  cacheWidth: 500.r.toInt(),
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
