import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

class LoginBackGround extends StatelessWidget {
  final Widget child;
  const LoginBackGround({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,////当键盘弹出时，Scaffold 不会调整底部的 body 区域
      body: Stack(
        alignment: AlignmentDirectional.center,
        fit:StackFit.expand,
        children: [
          Image.asset(
            "assets/images/background/loginBackGround.png",
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15).w,
            child: child,
          ),
        ],
      ),
    );
  }
}
