import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecommendButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const RecommendButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal: 3).w,
      child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFABC4AA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), 
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(color: Colors.black54),
          )),
    );
  }
}
