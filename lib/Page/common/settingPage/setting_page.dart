import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

import '../../../util/language_dialog.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});
  final RxBool isDarkTheme = true.obs;
  final RxString language = "中文".obs;
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    storage.writeIfNull('darkMode', true);
    isDarkTheme.value = storage.read('darkMode');
    return Scaffold(
      appBar: AppBar(
        title: const Icon(Icons.settings),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              SizedBox(
                height: 200.h,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              borderRadius: BorderRadius.circular(30)),
                          child: Obx(
                            () => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isDarkTheme.value
                                      ? Icons.dark_mode_outlined
                                      : Icons.light_mode_outlined,
                                  size: 50.r,
                                ),
                                Text(
                                  "theme".tr,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    letterSpacing: 10,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.r,
                                ),
                                Switch(
                                  value: isDarkTheme.value,
                                  onChanged: (value) {
                                    Get.changeThemeMode(Get.isDarkMode
                                        ? ThemeMode.light
                                        : ThemeMode.dark);
                                    isDarkTheme.value = !isDarkTheme.value;
                                    storage.write('darkMode', value);
                                  },
                                )
                              ],
                            ),
                          )),
                    ),
                    const Expanded(flex: 1, child: SizedBox.shrink()),
                    Expanded(
                      flex: 6,
                      child: Container(
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              borderRadius: BorderRadius.circular(30)),
                          child: Obx(
                            () => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.language,
                                  size: 50.r,
                                ),
                                Text(
                                  "language",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    letterSpacing: 2,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.r,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      await languageDialog();
                                    },
                                    child: Text(
                                      language.value,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                    ))
                              ],
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
