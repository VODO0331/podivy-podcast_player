import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podivy/model/Podcaster.dart';
import 'package:podivy/model/Search.dart';
import 'package:podivy/service/search/searchService.dart';
import 'package:podivy/util/recommendButton.dart';
import 'package:get/get.dart';
import 'package:podivy/widget/loadImage.dart';

// ignore: must_be_immutable
class ExploreContent extends StatelessWidget {
  ExploreContent({Key? key}) : super(key: key);

  RxString selectedType = 'News'.obs;
  RxBool imgError = true.obs;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 8).h,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                RecommendButton(
                  text: '時事',
                  onPressed: () {
                    selectedType.value = 'News';
                  },
                ),
                RecommendButton(
                  text: '喜劇',
                  onPressed: () {
                    selectedType.value = 'Comedy';
                  },
                ),
                RecommendButton(
                  text: '社會',
                  onPressed: () {
                    selectedType.value = 'Society';
                  },
                ),
                RecommendButton(
                  text: '文化',
                  onPressed: () {
                    selectedType.value = 'Culture';
                  },
                ),
                RecommendButton(
                  text: '電影',
                  onPressed: () {
                    selectedType.value = 'Film';
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              return buildGridView(selectedType);
            }),
          ),
        ],
      ),
    );
  }

  Widget buildGridView(RxString type) {
    // 根據 selectedType 選擇顯示的資料
    SearchServiceForExploreContent exploreContent =
        SearchServiceForExploreContent(
      keywords: type.value,
    );
    return FutureBuilder(
      future: getSearchData(exploreContent),
      builder: (context, snapshot) {

        
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            
            return Text('snapshot Error:${snapshot.error}');
          }
          final Map? data = snapshot.data;
          List<Podcaster>? getPodcasts = data?['podcastList'];
          if (data == null || getPodcasts == null) {
            return Center(
              child: Text(
                '接收資料錯誤',
                style: TextStyle(fontSize: ScreenUtil().setSp(14)),
              ),
            );
          }
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 50, right: 50, bottom: 50).h,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 12.0,
            ),
            itemCount: getPodcasts.length,
            itemBuilder: (BuildContext context, int index) {
              final Podcaster podcaster = getPodcasts[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed('/podcaster', arguments: podcaster.id);
                },
                child: Container(
                    key: UniqueKey(),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(2, 5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        LoadImageWidget(
                          imageUrl: podcaster.imageUrl,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            color: const Color(0x7C191B18),
                            child: Text(
                              podcaster.title!,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(16)),
                            ),
                          ),
                        ),
                      ],
                    )),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
 
