import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:list_management_service/personal_list_management.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:nil/nil.dart';
import 'package:podivy/Page/personal/media/build/build_listView.dart';
import 'package:podivy/widget/background.dart';

class MediaPage extends StatelessWidget {
  const MediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ListManagement listManagement = Get.find();
    return MyBackGround(
      bkColor: const Color.fromRGBO(255, 255, 255, 1),
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Padding(
            padding: const EdgeInsets.only(
              top: 100,
              left: 10,
              right: 10,
            ).r,
            child: Column(
              children: [
                Text(
                  'Media',
                  style: GoogleFonts.borel(
                    fontSize: 40.sp,
                    color: const Color(0xFFABC4AA),
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
                                Get.toNamed('/ListPage', arguments: {
                                  "list": list,
                                  "icon": Icons.list,
                                });
                              },
                            );
                          } else {
                            return nil;
                          }
                        default:
                          return nil;
                      }
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }
}

Widget _defaultOption() {
  return SizedBox(
    height: 180.h,
    child: Card(
      margin: const EdgeInsets.all(10),
      elevation: 30,
      shadowColor: Colors.grey,
      color: const Color(0xFFABC4AA),
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
                Get.toNamed('/ListPage', arguments: {
                  "list": UserList(listTitle: "TagList"),
                  "icon": Icons.bookmark_border_outlined,
                });
              },
              icon: Icon(
                Icons.bookmark_border_outlined,
                size: 30.sp,
                color: Colors.black,
              ),
              label: Text(
                '標籤清單',
                style: TextStyle(
                    color: Colors.black87, fontSize: 20.sp, letterSpacing: 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30).r,
              child: const Divider(
                thickness: 1,
                color: Colors.white24,
              ),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide.none, // 取消边框
              ),
              onPressed: () {
                Get.toNamed('/ListPage', arguments: {
                  "list": UserList(listTitle: "History"),
                  "icon": Icons.history,
                });
              },
              icon: Icon(
                Icons.history_rounded,
                size: 30.sp,
                color: Colors.black,
              ),
              label: Text(
                '歷史紀錄',
                style: TextStyle(
                    color: Colors.black, fontSize: 20.sp, letterSpacing: 10),
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
