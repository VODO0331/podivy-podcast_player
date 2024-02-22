import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;
import 'package:get/get.dart';
import 'package:list_management_service/personal_list_management.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/widget/background.dart';

class MediaPage extends StatelessWidget {
  const MediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ListManagement listManagement = Get.put(ListManagement());
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
                const Divider(
                  thickness: 1,
                  color: Colors.white24,
                ),
                SizedBox(
                  height: 180.h,
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    elevation: 30,
                    shadowColor: Colors.grey,
                    color: const Color(0xFFABC4AA),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide.none, // 取消边框
                            ),
                            onPressed: () {
                              Get.toNamed('/ListPage',
                                  parameters: {'listTitle': '標籤清單'},
                                  arguments: ['play1', 'play2']);
                            },
                            icon: Icon(
                              Icons.bookmark_border_outlined,
                              size: 30.sp,
                              color: Colors.black,
                            ),
                            label: Text(
                              '標籤清單',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20.sp,
                                  letterSpacing: 10),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30).r,
                            child: const Divider(
                              thickness: 1,
                              color: Colors.white24,
                            ),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide.none, // 取消边框
                            ),
                            onPressed: () {},
                            icon: Icon(
                              Icons.history_rounded,
                              size: 30.sp,
                              color: Colors.black,
                            ),
                            label: Text(
                              '歷史紀錄',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  letterSpacing: 10),
                            ),
                          )
                        ]),
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.white24,
                ),
                OutlinedButton(
                  onPressed: () {
                    dev.log('添加清單');
                    Get.toNamed('/test');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide.none, // 取消边框
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_box_outlined,
                        size: 30.sp,
                        color: Colors.white,
                      ), // 图标
                      const SizedBox(width: 40), // 图标和文本之间的间距
                      Text(
                        '添加清單',
                        style: TextStyle(color: Colors.white, fontSize: 20.sp),
                      ), // 文本
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
