import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'build_category_bt.dart';
import 'build_podcast_grid.dart';

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
              Future.microtask(() => selectedType.value = category);
              
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
