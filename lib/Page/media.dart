import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:developer' as dev show log;

class MediaPage extends StatelessWidget {
  const MediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Container(
      color: Colors.black87,
      height: height,
      width: width,
      child: Padding(
          padding: const EdgeInsets.only(
            top: 100,
            left: 10,
            right: 10,
          ),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Media',
                    style: TextStyle(
                      fontSize: 40.sp,
                      color: const Color(0xFFABC4AA),
                    ),
                  )),
              const Divider(
                thickness: 1,
                color: Colors.white24,
              ),
              OutlinedButton(
                  onPressed: () {
                    dev.log('標籤清單');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide.none, // 取消边框
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.bookmark_border_outlined,
                        size: 30.sp,
                        color: Colors.white,
                      ), // 图标
                      const SizedBox(width: 40), // 图标和文本之间的间距
                      Text(
                        '標籤清單',
                        style: TextStyle(color: Colors.white, fontSize: 20.sp),
                      ), // 文本
                    ],
                  )
                  ),
                  const Divider(
                thickness: 1,
                color: Colors.white24,
              ),
              OutlinedButton(
                  onPressed: () {
                    dev.log('歷史紀錄');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide.none, // 取消边框
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 30.sp,
                        color: Colors.white,
                      ), // 图标
                      const SizedBox(width: 40), // 图标和文本之间的间距
                      Text(
                        '歷史紀錄',
                        style: TextStyle(color: Colors.white, fontSize: 20.sp),
                      ), // 文本
                    ],
                  )
                  ),
                  const Divider(
                thickness: 1,
                color: Colors.white24,
              ),
              OutlinedButton(
                  onPressed: () {
                    dev.log('添加清單');
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
                  )
                  ),
            ],
          )),
    );
  }
}
