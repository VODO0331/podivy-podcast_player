import 'package:flutter/material.dart';

class MyBackGround extends StatelessWidget {
  final Widget myWiget;

  const MyBackGround({super.key, required this.myWiget});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 237, 186, 145),
              Color(0xFF2C271D),
            ],
            stops: [
              0.1,
              1
            ]),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset("images/background/backGroundVine.png"),
          ),
          myWiget
        ],
      ),
    );
  }
}
