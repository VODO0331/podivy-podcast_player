import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podivy/widget/turnTableAnimation.dart';
import 'package:podivy/widget/userAvatar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_scroll/text_scroll.dart';

class MyCarousel extends StatefulWidget {
  final List<TurnTable> items;

  MyCarousel({Key? key})
      : items = [
          TurnTable(
            isCentered: true,
            name: '百靈果',
            image:
                UserAvatar(imgPath: 'images/podcaster/BLG.jpg', radius: 40.r),
            latestList: [
              'overflowoverflowoverflowoverflowoverflowoverflow',
              'time2',
              'time3'
            ],
          ),
          TurnTable(
            isCentered: false,
            name: 'mike',
            image: Image.asset('images/userPic/people3.png'),
            latestList: ['time1', 'time2', 'time3'],
          ),
          TurnTable(
            isCentered: false,
            name: 'jane',
            image: Image.asset('images/userPic/people2.png'),
            latestList: ['time1', 'time2', 'time3'],
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
                    widget.items[i] = widget.items[i].updateIsCentered(false);
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
            color: const Color.fromARGB(255, 43, 49, 42),
            activeColor: const Color(0xFFABC4AA),
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
  final String name;
  final Widget image;
  final List latestList;
  final bool? isLiked;
  final bool? reminder;
  const TurnTable({
    Key? key,
    required this.isCentered,
    required this.name,
    required this.image,
    required this.latestList,
    this.isLiked,
    this.reminder,
  }) : super(key: key);

  @override
  State<TurnTable> createState() => _TurnTableState();

  TurnTable updateIsCentered(bool value) {
    
    return TurnTable(
      isCentered: value,
      name: name,
      image: image,
      latestList: latestList,
      reminder: reminder,
      isLiked: isLiked,
    );
  }
}

class _TurnTableState extends State<TurnTable> {
  bool? isLiked;
  bool? reminder;
  late bool isCentered;
  late UniqueKey _key;
  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked ?? false;
    reminder = widget.reminder ?? false;
    isCentered = widget.isCentered;
    _key = UniqueKey();
  }

  Widget buttonGroup(bool? isLiked, bool? reminder) {
    return Row(
      children: [
        Flexible(
          child: IconButton(
            onPressed: () {
              Share.share("分享此podcaster");
            },
            icon: const Icon(Icons.share),
          ),
        ),
        Flexible(
          child: IconButton(
            onPressed: () {
              setState(() {
                isLiked = !isLiked!;
              });
            },
            icon: Icon(
              isLiked == true ? Icons.favorite : Icons.favorite_border,
              color: isLiked == true ? Colors.red : null,
            ),
          ),
        ),
        Flexible(
          child: IconButton(
            onPressed: () {
              setState(() {
                reminder = !reminder!;
              });
            },
            icon: Icon(
              reminder == true
                  ? Icons.notifications_active
                  : Icons.notifications_active_outlined,
              color: reminder == true ? Colors.yellow : null,
            ),
          ),
        ),
      ],
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
        color: const Color.fromARGB(160, 73, 57, 34),
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
                    widget.name,
                    intervalSpaces: 5,
                    velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                    delayBefore: const Duration(seconds: 2),
                    pauseBetween: const Duration(seconds: 2),
                  ), //dcaster Name
                  SizedBox(
                    height: 5.h,
                  ),
                  //podcaster avatar
                  Expanded(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        TurntableAnimation(
                          key: _key,
                          isCentered: widget.isCentered,
                          child: CircleAvatar(
                            radius: 37,
                            child: widget.image,
                            
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
                  buttonGroup(isLiked, reminder),
                ],
              ),
            ),
          ),
          const VerticalDivider(
            thickness: 1,
            color: Color.fromARGB(255, 146, 114, 88),
          ),
          //podcaster 播放清單內容
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
   @override
  void didUpdateWidget(covariant TurnTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCentered) {
      _key = UniqueKey(); // 如果 isCentered 变为 true，更新 UniqueKey
    }
  }
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
