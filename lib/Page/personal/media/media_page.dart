import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/Page/personal/media/build/build_listView.dart';
import 'package:podivy/widget/background.dart';

class MediaPage extends StatelessWidget {
   final ListManagement listManagement;
  const MediaPage({super.key, required this.listManagement});

  @override
  Widget build(BuildContext context) {
    return MyBackGround(
      child: Scaffold(
        backgroundColor:
            Theme.of(context).colorScheme.background.withOpacity(0.5),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(
                top: 30,
                left: 10,
                right: 10,
              ).r,
              child: Column(
                children: [
                  Text(
                    'Media',
                    style: GoogleFonts.borel(
                      fontSize: 40.sp,
                      color: Get.theme.primaryColor,
                    ),
                  ),
                  _divider(),
                  _defaultOption(),
                  _divider(),
                  Expanded(
                    child: StreamBuilder(
                      stream: listManagement.readAllList(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              final allList = snapshot.data;

                              return MyListView(
                                lists: allList!,
                                onDelete: (list) async {
                                  await listManagement.deleteList(list);
                                },
                                onTap: (list) {
                                  Get.toNamed('/listPage', arguments: {
                                    "list": list,
                                    "icon": Icons.list,
                                  });
                                },
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          default:
                            return const SizedBox.shrink();
                        }
                      },
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}

Widget _defaultOption() {
  Color onP = Get.isDarkMode
      ? Theme.of(Get.context!).colorScheme.onPrimary
      : Theme.of(Get.context!).colorScheme.onPrimaryContainer;

  Color bk = Get.isDarkMode
      ? Theme.of(Get.context!).colorScheme.primary
      : Theme.of(Get.context!).colorScheme.primaryContainer;
  return SizedBox(
    height: 180.h,
    child: Card(
      margin: const EdgeInsets.all(10),
      elevation: 30,
      shadowColor: Colors.grey,
      color: bk,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide.none, // 取消边框
              ),
              onPressed: () {
                Get.toNamed('/listPage', arguments: {
                  "list": UserList(docId: "TagList", listTitle: "TagList"),
                  "icon": Icons.bookmark_border_outlined,
                });
              },
              icon: Icon(
                Icons.bookmark_border_outlined,
                size: 30.sp,
                color: onP,
              ),
              label: Text(
                'Tag List'.tr,
                style:
                    TextStyle(color: onP, fontSize: 20.sp, letterSpacing: 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30).r,
              child: Divider(
                thickness: 1,
                color: ThemeData().dividerColor,
              ),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide.none, // 取消边框
              ),
              onPressed: () {
                Get.toNamed('/listPage', arguments: {
                  "list": UserList(docId: "History", listTitle: "History"),
                  "icon": Icons.history,
                });
              },
              icon: Icon(
                Icons.history_rounded,
                size: 30.sp,
                color: onP,
              ),
              label: Text(
                'History'.tr,
                style:
                    TextStyle(color: onP, fontSize: 20.sp, letterSpacing: 10),
              ),
            )
          ]),
    ),
  );
}

Widget _divider() {
  return const Divider(
    thickness: 1,
    color: Colors.white24,
  );
}
