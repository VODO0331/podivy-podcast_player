import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podivy/service/auth/podcaster/podcasterData.dart';
import 'package:podivy/widget/turnTableAnimation.dart';
import 'package:podivy/widget/userAvatar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:get/get.dart';

class MyCarousel extends StatefulWidget {
  final List<TurnTable> items;

  MyCarousel({Key? key})
      : items = [
          TurnTable(
            isCentered: true,
            isLiked: false.obs,
            reminder: false.obs,
                // UserAvatar(imgPath: 'images/podcaster/BLG.jpg', radius: 40.r),
            latestList: [
              'overflowoverflowoverflowoverflowoverflowoverflow',
              'time2',
              'time3'
            ],
            podcaster: PodcasterData(name: '志祺七七', imagePath: 'images/podcaster/77.png'),
          ),
          TurnTable(
            isLiked: false.obs,
            reminder: false.obs,
            isCentered: false,
            latestList: ['time1', 'time2', 'time3'],
            podcaster: PodcasterData(
              name: '百靈果',
              imagePath: 'images/podcaster/BLG.jpg',
            ),
          ),
          TurnTable(
            isLiked: false.obs,
            reminder: false.obs,
            isCentered: false,
            latestList: ['time1', 'time2', 'time3'],
            podcaster: PodcasterData(
              name: '百靈果',
              imagePath: 'images/podcaster/BLG.jpg',
            ),
          ),
        ],
        super(key: key);

  @override
  State<MyCarousel> createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarousel> {
  late CarouselController controller;
  double currentIndex = 0;

  @override
  void initState() {
    controller = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: controller,
          items: widget.items,
          options: CarouselOptions(
            height: 200.0,
            enlargeCenterPage: true, // 居中的 Slide 放大
            enableInfiniteScroll: false,
            autoPlay: false, // 自动播放
            aspectRatio: 20 / 9, // 设置宽高比
            viewportFraction: 0.9, // 可见部分的宽度占整个 Carousel 的比例
            onPageChanged: (index, reason) {
              // 更新 isCentered 的值
              setState(() {
                currentIndex = index.toDouble();
                for (int i = 0; i < widget.items.length; i++) {
                  if (i == index) {
                    widget.items[i] = widget.items[i].updateIsCentered(true);
                  } else {
                    if (widget.items[i].isCentered == true) {
                      widget.items[i] = widget.items[i].updateIsCentered(false);
                    }
                  }
                }
              });

              // 更新 TurnTable 中的 isCentered
            },
          ),
        ),
        DotsIndicator(
          dotsCount: widget.items.length,
          position: currentIndex.round().toDouble(),
          decorator: DotsDecorator(
            color: const Color(0xFF2B312A),
            activeColor: const Color(0xFFF0FDF0),
            size: const Size.square(12.0),
            activeSize: const Size(24.0, 12.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ],
    );
  }
}

class TurnTable extends StatefulWidget {
  final bool isCentered;
  final PodcasterData podcaster;
  
  final List latestList;
  final RxBool isLiked;
  final RxBool reminder;

  TurnTable({
    Key? key,
    required this.isCentered,
    required this.latestList,
    required this.isLiked,
    required this.reminder,
    required this.podcaster,
  }) : super(key: key);

  TurnTable updateIsCentered(bool value) {
    return TurnTable(
      isCentered: value,
      latestList: latestList,
      reminder: reminder,
      isLiked: isLiked,
      podcaster: podcaster,
    );
  }

  @override
  State<TurnTable> createState() => _TurnTableState();
}

class _TurnTableState extends State<TurnTable> {
  late RxBool isLiked;
  late RxBool reminder;
  late bool isCentered;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    reminder = widget.reminder;
    isCentered = widget.isCentered;
  }

  Widget buttonGroup(RxBool isLiked, RxBool reminder, String name) {
    return Row(
      children: [
        Flexible(
          child: IconButton(
            onPressed: () {
              Share.share('分享$name');
            },
            icon: const Icon(Icons.share),
          ),
        ),
        Flexible(
            child: IconButton(onPressed: () {
          isLiked.toggle();
        }, icon: Obx(() {
          return Icon(
            isLiked.value ? Icons.favorite : Icons.favorite_border,
            color: isLiked.value ? Colors.red : null,
          );
        }))),
        Flexible(
          child: IconButton(onPressed: () {
            reminder.toggle();
          }, icon: Obx(() {
            return Icon(
              reminder.value
                  ? Icons.notifications_active
                  : Icons.notifications_active_outlined,
              color: reminder.value ? Colors.yellow : null,
            );
          })),
        ),
      ],
    );
  }

  Widget podcastLatestContent(List latestList) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            ListTile(
              title: TextScroll(
                latestList[index],
                intervalSpaces: 12,
                velocity: const Velocity(pixelsPerSecond: Offset(90, 0)),
                delayBefore: const Duration(seconds: 3),
                pauseBetween: const Duration(seconds: 5),
              ),
            ),
            if (index < 2)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0).w,
                child: const Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5).r,
      width: 360.w,
      height: 210.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0x9F22261F),
        border: Border.all(color: Colors.white70),
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 3,
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextScroll(
                    widget.podcaster.name,
                    intervalSpaces: 5,
                    velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                    delayBefore: const Duration(seconds: 2),
                    pauseBetween: const Duration(seconds: 2),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/podcaster',
                                arguments: widget.podcaster);
                          },
                          child: TurntableAnimation(
                            isCentered: widget.isCentered,
                            child: CircleAvatar(
                              radius: 37,
                              child: UserAvatar(imgPath: widget.podcaster.imagePath, radius: 40.r, isNetwork: false,),
                             
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            'images/turnTable/record2.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                  buttonGroup(isLiked, reminder, widget.podcaster.name)
                ],
              ),
            ),
          ),
          const VerticalDivider(
            thickness: 1,
            color: Color.fromARGB(255, 129, 145, 122),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: 200.w,
              height: 165.h,
              decoration: BoxDecoration(
                color: const Color.fromARGB(96, 76, 74, 74),
                border: Border.all(color: Colors.white60),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(16.0),
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: podcastLatestContent(widget.latestList),
            ),
          ),
        ],
      ),
    );
  }
}
