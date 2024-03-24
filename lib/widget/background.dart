import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

class MyBackGround extends StatelessWidget {
  final Widget child;
  const MyBackGround({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      // padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              // const Color(0xFFE1CFAF)
              Theme.of(context)
                  .colorScheme
                  .onBackground
                  .blend(const Color(0xFFDE8F07), 30),
            ],
            stops: const [
              0.2,
              1,
            ]),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/background/test.png',
              fit: BoxFit.cover,
              cacheHeight: 500.r.toInt(),
              cacheWidth: 400.r.toInt(),
            ),
          ),
          child
        ],
      ),
    );
  }
}
