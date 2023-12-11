import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAvatar extends StatelessWidget {
  final String imgPath;
  final double radius;
  final double? boraderthinness;
  final Color? color;
  const UserAvatar({
    super.key,
    required this.imgPath,
    required this.radius,
    this.color, 
    this.boraderthinness
  });
  
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color?? Colors.white,
      radius: boraderthinness ?? radius+1.h,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(imgPath),
      ),
    );
  }
}
