import 'package:flutter/material.dart';
import 'package:interests_management_service/interests.management.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:get/get.dart';

import '../../../../theme/custom_theme.dart';
import 'build_podcast_gridView.dart';

class ExploreContent extends StatelessWidget {
  ExploreContent({Key? key}) : super(key: key);
  final RxString selectedType = ''.obs;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CategoryButton(
            selected: (category) {
              selectedType.value = category;
            },
          ),
          Expanded(
            child: Obx(() {
              return BuildGridView(
                category: selectedType.value,
              );
            }),
          ),
        ],
      ),
    );
  }
}

typedef SelectCallBack = void Function(String category);

class CategoryButton extends StatelessWidget {
  final SelectCallBack selected;
  CategoryButton({super.key, required this.selected});
  final InterestsManagement _interestsManagement =
      Get.put(InterestsManagement());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _interestsManagement.interestsCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              final interests = snapshot.data;
              if (interests!.isNotEmpty) {
                selected(interests.first.category); // 在此處調用回調函數，傳遞第一筆資料
              }
              return SizedBox(
                height: 55.r,
                width: ScreenUtil().screenWidth,
                child: ListView.builder(
                  padding: const EdgeInsets.all(9).r,
                  scrollDirection: Axis.horizontal,
                  itemCount: interests.length,
                  itemBuilder: (context, index) {
                    final interest = interests.elementAt(index);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4).r,
                      child: TextButton(
                        style: textButtonForRecommend,
                        child: Text(
                          interest.category,
                          style:
                              TextStyle(fontSize: 12.sp, color: Colors.black),
                        ),
                        onPressed: () => selected(interest.category),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Text("Loading...");
            }
          } else {
            return Text("Connection state: ${snapshot.connectionState}");
          }
        });
  }
}
