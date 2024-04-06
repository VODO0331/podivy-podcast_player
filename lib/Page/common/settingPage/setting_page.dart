import 'package:authentication_repository/authentication_repository.dart';
import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/Page/common/settingPage/build/theme_setting.dart';
import 'package:podivy/Page/login/auth_middleware.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.offAndToNamed('/');
            },
            icon: const Icon(Icons.arrow_back_ios_rounded)),
        title: const Icon(Icons.settings),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Column(
            children: [
              SizedBox(height: 100.h, child: ThemeSetting()),
              Divider(
                color: ThemeData().dividerColor,
              ),
              ListTile(
                iconColor: Colors.red,
                textColor: Colors.red,
                leading: const Icon(Icons.delete_forever),
                title: Text('Delete User'.tr),
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Delete User'.tr),
                        content: Text(
                            'Are you sure you want to delete your account?'.tr),
                        actions: [
                          TextButton(
                              onPressed: () => Get.back(),
                              child: Text('Cancel'.tr)),
                          TextButton(
                              onPressed: () async {
                                //  Get.back();
                                final infoCtr = Get.put(InformationController()); 
                                infoCtr.deleteInfo();
                               await Get.deleteAll();
                                context.mounted
                                    ? context
                                        .read<AuthBloc>()
                                        .add(const AuthEventLogOut())
                                    : null;
                                Get.offAll(() => const AuthMiddleWare());

                                await AuthService.firebase().deleteUser();
                              },
                              child: Text(
                                'delete'.tr,
                                style: const TextStyle(color: Colors.red),
                              ))
                        ],
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
