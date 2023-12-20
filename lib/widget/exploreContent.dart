import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:podivy/util/recommendButton.dart';
import 'dart:developer' as dev show log;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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

              return buildGridView(selectedType, imgError);
            }),
          ),
        ],
      ),
    );
  }

  Widget buildGridView(RxString type, RxBool imgError) {
    // 根據 selectedType 選擇顯示的資料

    return Query(
        options: QueryOptions(
          document: gql(getPodcasts),
          variables: {
            'languageFilter': 'zh',
            'first': 4,
            'sortBy': 'FOLLOWER_COUNT',
            'sortdirection': 'DESCENDING',
            'categoriesFilter': [type.value],
          },
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            dev.log(result.exception.toString());
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const SizedBox(
              height: 50,
              width: 50,
              child: Center(child: CircularProgressIndicator(),),
            );
          }

          List? getPodcasts = result.data?['podcasts']?['data'];
          if (getPodcasts == null) {
            return const Text('No repositories');
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
              final Map podcaster = getPodcasts[index];
              return GestureDetector(
                onTap: () {
                  dev.log("進入${podcaster['title']}的頁面");
                  Get.toNamed('/podcaster', arguments: podcaster['id']);
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
                        FutureBuilder(
                          future: loadImage(podcaster['imageUrl']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Image.asset(
                                  'images/podcaster/defaultPodcaster.jpg',
                                  fit: BoxFit.fill,
                                );
                              } else {
                                return Image.network(podcaster['imageUrl']);
                              }
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            color: const Color(0x7C191B18),
                            child: Text(
                              podcaster['title'],
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
        });
  }

  Future<Image> loadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      return Image.memory(response.bodyBytes);
    } else {
      throw Exception('Failed to load image');
    }
  }
}

String getPodcasts = """
  query GetPodcasts(
     \$languageFilter: String,
     \$first : Int, 
     \$categoriesFilter :[String],
     \$sortBy: PodcastSortType!,
     \$sortdirection: SortDirection,
  ){
    podcasts(
      filters: {
        language: \$languageFilter,
        categories: \$categoriesFilter
      },
      first: \$first, 
      sort: {sortBy: \$sortBy, direction: \$sortdirection},
    ){
      data {
        id
        title
        imageUrl

      }
    }
  }
""";
