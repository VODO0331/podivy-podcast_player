import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:information_management_service/personal_information_management.dart';
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

  @override
  Widget build(BuildContext context) {
    // 獲取用戶email
    final userEmail = AuthService.firebase().currentUser!.email;
    final Rx<String> imgData = userController.userData.img.obs;
    return Scaffold(
      key: UniqueKey(),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(221, 15, 20, 15),
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/background/userPageBackGround.jpg',
                width: double.infinity,
                height: 350.h,
                fit: BoxFit.cover,
                cacheHeight: 120,
                cacheWidth: 120,
                color: Colors.white12,
                colorBlendMode: BlendMode.lighten,
              ).asGlass(),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 60, 12, 0),
                child: Column(
                  children: [
                    Row(
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
                          color: Colors.black87,
                          icon: Icon(
                            Icons.more_vert_sharp,
                            size: 35.r,
                          ),
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem(
                                value: true,
                                child: Text('編輯'),
                              )
                            ];
                          },
                          onSelected: (value) {
                            _isEdit.value = value;
                          },
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.white12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20).r,
                      child: GestureDetector(
                        onTap: () {},
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Obx(() {
                              if (imgData.value != "") {
                                return CircleAvatar(
                                  backgroundImage:
                                      MemoryImage(base64Decode(imgData.value)),
                                  radius: 68.r,
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            }),
                            Obx(() {
                              return _isEdit.value
                                  ? Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: OutlinedButton(
                                        onPressed: () async {
                                          final Uint8List? result =
                                              await selectImage();

                                          if (result != null) {
                                            imgData.value =
                                                base64Encode(result);
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
                                  : const SizedBox();
                            })
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                // 顯示用戶名稱的ListTile
                Obx(() {
                  _textEditingController.text =
                      userController.userData.userName.value;
                  return _isEdit.value
                      ? TextField(
                          controller: _textEditingController,
                          decoration: const InputDecoration(
                            labelText: "名稱",
                          ),
                        )
                      : ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(
                            "名稱 :   ${userController.userData.userName}",
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
                              if (userController.userData.img !=
                                  imgData.value) {
                                updates[1] = base64Decode(imgData.value);
                              }
                              informationManagement.updateInfo(
                                userName: updates[0],
                                userImg: updates[1],
                              );
                            },
                            child: const Text("完成"),
                          ),
                          TextButton(
                            onPressed: () async {
                              _textEditingController.text =
                                  userController.userData.userName.value;
                              imgData.value =
                                  userController.userData.userImg.value;
                              _isEdit.value = false;
                            },
                            child: const Text("取消"),
                          )
                        ],
                      )
                    : const SizedBox())
              ],
            ),
          )
        ],
      ),
    );
  }
}
