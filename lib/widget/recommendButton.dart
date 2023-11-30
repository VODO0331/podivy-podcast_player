import 'package:flutter/material.dart';

class RecommendButton extends StatelessWidget {
  final String text;
  final void Function()? onPress;
  const RecommendButton({super.key, required this.text, this.onPress});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Color(0xFFABC4AA))),
        onPressed: onPress,
        child: Text(
          text,
          style: const TextStyle(color: Colors.black54),
        ));
  }
}
