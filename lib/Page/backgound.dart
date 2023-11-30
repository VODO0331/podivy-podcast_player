import 'package:flutter/material.dart';

class MyBackGround extends StatelessWidget {
  final Widget child;

  const MyBackGround({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7B7060),
              Color(0xFF2C271D),
            ],
            stops: [
              0.4,
              1
            ]),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset("images/background/backGroundVine.png"),
          ),
          child
        ],
      ),
    );
  }
}
