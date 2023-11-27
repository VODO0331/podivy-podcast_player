import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer' as dev show log;
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: (){
                    dev.log('open user page');
                  },
                  child: Stack(alignment: Alignment.centerLeft, children: [
                    SvgPicture.asset(
                      "images/homePage/userBackground.svg",
                      height: 40.h,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 17.h,
                        child: CircleAvatar(
                          radius: 16.h,
                          child: Image.asset("images/drawer/people1.png"),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
              Expanded(
                flex: 7,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                      iconColor: MaterialStateProperty.all(Colors.white),
                      alignment: Alignment.centerLeft,
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black45),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), 
                        ),
                      ),
                      ),
                  icon:const Icon(Icons.search),
                  label:const Text(""),
                  onPressed: () { dev.log('sarch');},
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
