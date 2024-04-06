import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/util/dialogs/language_dialog.dart';

class ThemeSetting extends StatelessWidget {
  ThemeSetting({super.key});
  final RxBool isDarkTheme = true.obs;
  final RxString language = "intl language".obs;
  final storage = GetStorage();
  @override
  Widget build(BuildContext context) {
    storage.writeIfNull('darkMode', true);
    isDarkTheme.value = storage.read('darkMode');
    return Flex(
      direction: Axis.horizontal,
      children: [
        //Theme button
        Expanded(
          flex: 6,
          child: Container(
            height: 100.r,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Obx(() => Center(
                  child: ListTile(
                    leading: Icon(
                      isDarkTheme.value
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      size: 30.r,
                    ),
                    title: Text(
                      "theme".tr,
                      style: TextStyle(
                        fontSize: 20.sp,
                        // letterSpacing: 3,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    subtitle:
                        Text(Get.isDarkMode ? 'dark mode'.tr : 'light mode'.tr),
                    subtitleTextStyle: const TextStyle(color: Colors.grey),
                    onTap: () {
                      Get.changeThemeMode(
                          Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                      isDarkTheme.value = !isDarkTheme.value;
                      storage.write('darkMode', isDarkTheme.value);
                    },
                  ),
                )),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox.shrink()),
        //language button
        Expanded(
          flex: 6,
          child: Container(
              height: 100.r,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.language,
                    size: 30.r,
                  ),
                  title: Text(
                    "Language",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14.sp,
                      
                      // letterSpacing: 3,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  subtitle: Text("intl_language".tr),
                  onTap: () async {
                    await languageDialog();
                  },
                ),
              )),
        )
      ],
    );
  }
}
