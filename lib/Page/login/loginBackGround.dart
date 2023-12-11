import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginBackGround extends StatelessWidget {
  final Widget child;
  const LoginBackGround({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,////当键盘弹出时，Scaffold 不会调整底部的 body 区域
      body: Stack(
        children: [
          Image.asset(
            "images/background/loginBackGround.png",
            
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15).w,
            child: child,
          )
        ],
      ),
    );
  }
}
