import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:podivy/widget/exploreContent.dart';
import 'package:podivy/widget/userAvatar.dart';
import 'package:podivy/widget/carousel.dart';

import 'dart:developer' as dev show log;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100).h,
      child: Column(
        children: [
          appBar(),
          const Divider(
            thickness: 2,
            color: Color.fromARGB(123, 255, 255, 255),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10).h,
            child: MyCarousel(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30).w,
            child: const Divider(
              thickness: 0.5,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const ExploreContent(),
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
            Get.toNamed('/user');
          },
          child: Stack(alignment: Alignment.centerLeft, children: [
            SvgPicture.asset(
              "images/homePage/userBackground.svg",
              height: 40.h,
            ),
            const Align(
              alignment: Alignment.center,
              child: UserAvatar(
                imgPath: "images/userPic/people1.png",
                radius: 17,
              ),
            )
          ]),
        ),
      ),
      Expanded(
        flex: 7,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0).w,
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
            onPressed: () async {
              Get.toNamed('/search');
              // await getAccessToken();
            },
          ),
        ),
      )
    ],
  );
}

// Future<void> getAccessToken() async {
//   // final Uri url = Uri.parse('https://account.spotify.com/api/token');
//   // Map<String, String> requestBody = {
//   //   'grant_type': 'client_credentials',
//   //   'client_id': '791d85b9f3c748919f240057b3b89d39',
//   //   'client_secret': '7ab17acd278d44008200e9d29ff82fba'
//   // };
//   // Map<String, String> header = {
//   //   'Content-type': "application/x-www-form-urlencoded"
//   // };
//   // var credentials = SpotifyApiCredentials('791d85b9f3c748919f240057b3b89d39','7ab17acd278d44008200e9d29ff82fba');
//   // var spotify = SpotifyApi(credentials);
//   // credentials = await spotify.getCredentials();
//   // dev.log('Client Id: ${credentials.clientId}');
//   // dev.log('Access Token: ${credentials.accessToken}');
//   // dev.log('Credentials Expired: ${credentials.isExpired}');

  
//   // await spotify.shows
//   //     .get('5Vv32KtHB3peVZ8TeacUty')
//   //     .then((podcast) => dev.log(podcast.uri.toString()))
//   //     .onError(
//   //         (error, stackTrace) => dev.log((error as SpotifyException).message.toString()));

//   // final response = await http.post(url, headers: {
//   //   'Content-type': "application/x-www-form-urlencoded"
//   // }, body: {
//   //   'grant_type': 'client_credentials',
//   //   'client_id': '791d85b9f3c748919f240057b3b89d39',
//   //   'client_secret': '7ab17acd278d44008200e9d29ff82fba'
//   // });
//   // dev.log('Response body: ${response.body}');

//   // return json.decode(response.body);
// }
