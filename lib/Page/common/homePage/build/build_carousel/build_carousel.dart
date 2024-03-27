import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

import 'package:get/get.dart';

import 'carousel_content.dart';


class BuildCarousel extends StatelessWidget {
  final FollowedManagement followedStorageService;
  const BuildCarousel({super.key, required this.followedStorageService});
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: followedStorageService.homePageViewFollowed(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            final data = snapshot.data;
            if (data == null || data.isEmpty) {
              return const NullCarouselContent();
            } else {
              return MyCarousel(
                item: data,
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class MyCarousel extends StatelessWidget {
  final Iterable<Followed> item;
  MyCarousel({
    Key? key,
    required this.item,
  }) : super(key: key);
  final CarouselController controller = Get.put(CarouselController());
  final Rx<double> currentIndex = 0.0.obs;

  final RxBool isFollowed = false.obs;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: controller,
          items: listCarouselItem(item),
          options: CarouselOptions(
            height: 190.0.r,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            autoPlay: false,
            aspectRatio: 20 / 9,
            viewportFraction: 0.9,
            onScrolled: (value) {
              currentIndex.value = value!;
            },
          ),
        ),
        Obx(
          () => DotsIndicator(
            dotsCount: item.length,
            position: currentIndex.value,
            decorator: _buildDotsDecorator(),
          ),
        )
      ],
    );
  }

  // void _handlePageChanged(int index, CarouselPageChangedReason reason) {
  DotsDecorator _buildDotsDecorator() {
    return DotsDecorator(
      color: Theme.of(Get.context!).colorScheme.primaryContainer,
      activeColor: Theme.of(Get.context!).colorScheme.onPrimaryContainer,
      size: const Size.square(12.0),
      activeSize: const Size(24.0, 12.0),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}

List<Widget> listCarouselItem(Iterable<Followed> data) {
  final List<Widget> list = [];
  for (int i = 0; i < data.length; i++) {
    list.add(CarouselContent(
      followed: data.elementAt(i),
    ));
  }
  return list;
}


