import 'package:flutter/material.dart';

class MyBackGround extends StatelessWidget {
  final Widget child;
  final Color? bkColor;
  const MyBackGround({super.key, required this.child, this.bkColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFA99B86),
              Color(0xFF7B7060),
              Color(0xFF2C271D),
            ],
            stops: [
              0.4,
              0.6,
              1
            ]),
      ),
      child: Stack(
        children: [
          
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset('images/background/test.png',fit: BoxFit.cover,),
            ),
          
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset("images/background/backGroundVine.png",
                color: bkColor),
          ),
          child
        ],
      ),
    );
  }
}
