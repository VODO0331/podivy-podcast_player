import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCarousel extends StatefulWidget {
  final List<Widget> items;

  MyCarousel({Key? key})
      : items = [
          TurnTable(
            isCentered: false,
            name: 'josh',
            image: Image.asset('images/drawer/people2.png'),
            latestList: ['time1', 'time2', 'time3'],
          ),
          TurnTable(
            isCentered: false,
            name: 'mike',
            image: Image.asset('images/drawer/people2.png'),
            latestList: ['time1', 'time2', 'time3'],
          ),
          TurnTable(
            isCentered: false,
            name: 'jane',
            image: Image.asset('images/drawer/people2.png'),
            latestList: ['time1', 'time2', 'time3'],
          ),
        ],
        super(key: key);

  @override
  State<MyCarousel> createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarousel> {
  late final bool isCentered;
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
                print(index);
                currentIndex = index.toDouble();
                isCentered = isElementCentered(index);
                for (int itemsIndex = 0;
                    itemsIndex < widget.items.length;
                    itemsIndex++) {
                  if (itemsIndex == index) {
                    widget.items[itemsIndex] =
                        changeCentered(itemsIndex, widget.items, isCentered);
                  } else {
                    widget.items[itemsIndex] =
                        changeCentered(itemsIndex, widget.items, isCentered);
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

  bool isElementCentered(int currentIndex) {
    return currentIndex == (widget.items.length ~/ 2);
  }

  Widget changeCentered(int index, List items, bool isCenter) {
    var itemsWidget = items[index];
    print(isCenter);
    if (isCentered) {
      return itemsWidget.updateIsCentered(true);
    }
    return itemsWidget.updateIsCentered(false);
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

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked ?? false;
    reminder = widget.reminder ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final mixH = widget.isCentered ? 30.h : 5.h;
    final mixW = widget.isCentered ? 30.w : 5.w;
    print('${widget.name} :${widget.isCentered}');
    return Container(
      padding: const EdgeInsets.all(8),
      width: 360.w,
      height: 200.h,
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
                  Text(widget.name),
                  SizedBox(
                    height: 5.h,
                  ),
                  //podcaster
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundImage:
                            const AssetImage('images/turnTable/record.png'),
                        child: CircleAvatar(
                          radius: 40,
                          child: widget.image,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          'images/turnTable/record2.png',
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                          constraints:
                              BoxConstraints(maxHeight: mixH, maxWidth: mixW),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isLiked = !isLiked!;
                            });
                          },
                          icon: Icon(
                            isLiked == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isLiked == true ? Colors.red : null,
                          ),
                          constraints:
                              BoxConstraints(maxHeight: mixH, maxWidth: mixW),
                        ),
                      ),
                      Expanded(
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
                          constraints:
                              BoxConstraints(maxHeight: mixH, maxWidth: mixW),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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

Widget podcastLatestContent(List latestList) {
  return ListView.builder(
    padding: EdgeInsets.zero,
    itemCount: 3,
    itemBuilder: (BuildContext context, int index) {
      return Column(
        children: [
          ListTile(title: Text(latestList[index])),
          if (index < 2)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ),
        ],
      );
    },
  );
}
