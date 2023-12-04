import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAvatar extends StatelessWidget {
  final Widget user;
  final double radius;
  const UserAvatar({
    super.key,
    required this.user,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: radius.h,
      child: CircleAvatar(
        radius: (radius - 1).h,
        child: user,
      ),
    );
  }
}
