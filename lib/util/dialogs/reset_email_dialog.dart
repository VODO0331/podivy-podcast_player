import 'package:authentication_repository/authentication_repository.dart';
import 'package:firestore_service_repository/error_exception/information_storage_exception.dart';
import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/Page/login/auth_middleware.dart';
import 'package:podivy/util/dialogs/error_dialog.dart';
import 'package:podivy/util/toast/waring.toast.dart';

Future<void> showResetEmailDialog() => showDialog(
      context: Get.context!,
      builder: (context) {
        final TextEditingController email =
            Get.put(tag: 'email', TextEditingController());
        final infoCtr = Get.find<InformationController>();
        return AlertDialog(
          title: Text('Change email'.tr),
          content: SizedBox(
            width: 400.w,
            height: 280.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                    'When you change your email, you will be logged out so you can log in with your new email.'
                        .tr),
                Text(
                  'Please note: If you do not receive verification, please use your original email address'
                      .tr,
                  style: TextStyle(color: Colors.red[400]),
                ),
                TextField(
                  controller: email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'enter the new Email'.tr,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                  email.text = '';
                },
                child: Text('Cancel'.tr)),
            TextButton(
                onPressed: () async {
                  try {
                    if (email.text ==
                        AuthService.firebase().provider.currentUser!.email) {
                      toastWaning('Please do not use the same email'.tr);
                      Get.back();
                      return;
                    }
                    if (await infoCtr.checkEmail(email.text)) {
                      await AuthService.firebase()
                          .emailReset(newEmail: email.text);

                      Get.back();
                      await showResetEmailTipDialog(email.text);
                    }
                    Get.back();
                    email.text = '';
                  } catch (e) {
                    if (e is NewEmailInvalid) {
                      await showErrorDialog(
                        Get.context!,
                        'Invalid email'.tr,
                      );
                    } else if (e is UserNotFindAuthException) {
                      await showErrorDialog(
                        Get.context!,
                        'This user does not exist'.tr,
                      );
                    } else if (e is EmailAlreadyInUse) {
                      await showErrorDialog(
                        Get.context!,
                        'This email has been registered'.tr,
                      );
                    } else if (e is RequiresRecentLoginException) {
                      await showErrorDialog(
                        Get.context!,
                        'Please login again and try again.'.tr,
                      );
                    } else {
                      await showErrorDialog(
                        Get.context!,
                        'Other wrong'.tr,
                      );
                    }
                  }
                },
                child: Text('change'.tr)),
          ],
        );
      },
    );

Future<void> showResetEmailTipDialog(String newEmail) => showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('send verification'.tr),
        content: Text(
            'The verification has been sent to the new email address. The email address will be changed after verification...'
                .tr),
        actions: [
          TextButton(
            child: const Text('ok'),
            onPressed: () async {
              await Get.deleteAll();
              context.mounted
                  ? context.read<AuthBloc>().add(const AuthEventLogOut("Firebase"))
                  : null;
              Get.offAll(() => const AuthMiddleWare());
            },
          )
        ],
      ),
    );
