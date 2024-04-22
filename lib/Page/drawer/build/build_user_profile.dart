import 'dart:convert';

import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

class BuildUserProfile extends StatelessWidget {
  BuildUserProfile({super.key});
  final fsp = Get.find<FirestoreServiceProvider>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 90.h),
        GestureDetector(
          onTap: () => Get.toNamed('/user'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              final UserInfo data = fsp.info.userData;

              if (data.img != '') {
                return CircleAvatar(
                  backgroundImage: MemoryImage(base64Decode(data.img)),
                  minRadius: 35.r,
                  maxRadius: 40.r,
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
            width: 200.r,
            child: Obx(() {
              // if (fsp.userData != null) {/
              return Text(
                fsp.info.userData.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              );
              // } else {
              //   return const Text("loading...");
              // }
            })),
        SizedBox(height: 12.h),
        Container(
          height: 0.6.h,
          width: 200.w,
          decoration: const BoxDecoration(
            color: Colors.grey,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 1,
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
