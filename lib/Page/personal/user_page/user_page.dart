import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:get/get.dart';
import 'package:podivy/Page/personal/user_page/build/build_user_avatar.dart';
import 'package:podivy/util/dialogs/reset_email_dialog.dart';

// import 'dart:developer' as dev show log;
class UserPage extends StatelessWidget {
  UserPage({Key? key}) : super(key: key);

  // final UserInfo userData = Get.arguments;
  final TextEditingController _nameEditingController =
      Get.put(TextEditingController());

  final fsp = Get.find<FirestoreServiceProvider>();
  final authService = Get.find<AuthService>();
  final RxBool _isEdit = false.obs;
  final RxString imgData = ''.obs;

  Widget _buildAppBar() {
    return Row(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    imgData.value = fsp.info.userData.img;
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
              child: BuildUserAvatar(
                imgData: imgData,
                fsp: fsp,
                isEdit: _isEdit,
              ),
            ),

            // 顯示用戶名稱
            Obx(() {
              _nameEditingController.text = fsp.info.userData.userName.value;
              return _isEdit.value
                  ? TextField(
                      controller: _nameEditingController,
                      decoration: InputDecoration(
                        labelText: "Name".tr,
                      ),
                    )
                  : ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(
                        "Name :   ${fsp.info.userData.userName}".tr,
                        style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                      ),
                    );
            }),
            const Divider(),
            // 顯示用戶Email
            Obx(() {
              return ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(
                    fsp.info.userData.email.value,
                    style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                  ),
                  trailing: authService.currentUser!.loginMethod == 'Firebase'
                      ? ElevatedButton(
                          child: const Icon(FontAwesomeIcons.pencil),
                          onPressed: () => showResetEmailDialog(),
                        )
                      : null);
            }),

            const Divider(),
            //修改動作
            Obx(() => _isEdit.value
                ? Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          _isEdit.value = false;
                          final List<dynamic> updates = [null, null];
                          if (_nameEditingController.text !=
                              fsp.info.userData.name) {
                            updates[0] = _nameEditingController.text;
                          }
                          if (fsp.info.userData.img != imgData.value) {
                            updates[1] = base64Decode(imgData.value);
                          }
                          fsp.info.updateInfo(
                            userName: updates[0],
                            userImg: updates[1],
                            newEmail: null,
                          );
                        },
                        child: Text("Done".tr),
                      ),
                      TextButton(
                        onPressed: () async {
                          _nameEditingController.text =
                              fsp.info.userData.userName.value;
                          imgData.value = fsp.info.userData.userImg.value;
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
