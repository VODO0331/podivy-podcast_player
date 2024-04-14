import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

class BuildDrawerBackground extends StatelessWidget {
  const BuildDrawerBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: _buildVineImage("assets/images/drawer/vine1.png"),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: _buildVineImage("assets/images/drawer/vine2.png"),
        ),
      ],
    );
  }

  Widget _buildVineImage(String imagePath) {
    return Image.asset(
      imagePath,
      width: 200.r,
      height: 190.r,
      cacheHeight: 250.r.toInt(),
      cacheWidth: 240.r.toInt(),
      fit: BoxFit.cover,
      color: Theme.of(Get.context!).colorScheme.onBackground.withOpacity(0.7),
    );
  }
}
