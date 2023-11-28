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
          appBar(),
          const Divider(
            thickness: 2,
            color: Color.fromARGB(123, 255, 255, 255),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(8),
            width: 360.w,
            height: 180.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(160, 73, 57, 34),
              border: Border.all(color: Colors.white70),
            ),
            child: Flex(direction: Axis.horizontal, children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text('podcaster'),
                    SizedBox(
                      height: 4.h,
                    ),
                    CircleAvatar(
                      radius: 55,
                      backgroundImage:
                          AssetImage('images/turnTable/record.png'),
                      child: CircleAvatar(
                        radius: 40,
                        child: Image.asset(
                          'images/drawer/people2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const VerticalDivider(
                thickness: 1,
                color: Color.fromARGB(255, 237, 186, 145),
              ),
              Expanded(
                  flex: 6,
                  child: Container(
                      width: 200.w,
                      height: 165.h,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(96, 76, 74, 74),
                          border: Border.all(color: Colors.white60),
                          borderRadius: BorderRadius.circular(10)),
                      child: ListView(
                        children: const [
                          Text('tile1'),
                          Divider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                          Text('tile2'),
                          Divider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                          Text('tile3'),
                          Divider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                        ],
                      )))
            ]),
          ),
        ],
      ),
    );
  }
}

Widget appBar() {
  return Flex(
    direction: Axis.horizontal,
    children: [
      Expanded(
        flex: 2,
        child: GestureDetector(
          onTap: () {
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
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ElevatedButton.icon(
            style: ButtonStyle(
              alignment: Alignment.centerLeft,
              backgroundColor: MaterialStateProperty.all(Colors.black45),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            label: const Text(""),
            onPressed: () {
              dev.log('sarch');
            },
          ),
        ),
      )
    ],
  );
}
