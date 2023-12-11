

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podivy/service/auth/podcaster/podcasterData.dart';
import 'package:podivy/util/recommendButton.dart';
import 'dart:developer'as dev ;


class ExploreContent extends StatefulWidget {
  const ExploreContent({Key? key}) : super(key: key);

  @override
  _ExploreContentState createState() => _ExploreContentState();
}

class _ExploreContentState extends State<ExploreContent> {
  String selectedType = 'type1'; // 預設選擇 'type1'

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
                  text: 'type1',
                  onPressed: () {
                    updateSelectedType('type1');
                  },
                ),
                RecommendButton(
                  text: 'type2',
                  onPressed: () {
                    updateSelectedType('type2');
                  },
                ),
                RecommendButton(
                  text: 'type3',
                  onPressed: () {
                    updateSelectedType('type3');
                  },
                ),
                RecommendButton(
                  text: 'type4',
                  onPressed: () {
                    updateSelectedType('type4');
                  },
                ),
                RecommendButton(
                  text: 'type5',
                  onPressed: () {
                    updateSelectedType('type5');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: buildGridView(),
          ),
        ],
      ),
    );
  }

  void updateSelectedType(String type) {
    setState(() {
      selectedType = type;
    });
  }

  Widget buildGridView() {
    // 根據 selectedType 選擇顯示的資料
    List<PodcasterData> podcasterList = getPodcastersByType(selectedType);

    return GridView.builder(
      physics:const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 50).h,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
      ),
      itemCount: podcasterList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildPodcasterCard(podcasterList[index]);
      },
    );
  }

  Widget buildPodcasterCard(PodcasterData podcaster) {
    return GestureDetector(
      onTap: () {
        dev.log("進入${podcaster.name}的頁面");
        Get.toNamed('/podcaster',arguments: podcaster);
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(podcaster.imagePath),
            fit: BoxFit.cover,
          ),
          boxShadow: const[
             BoxShadow(
              color: Colors.black54,
              offset: Offset(2, 5),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            color: const Color(0xDBA08E75),
            child: Text(
              podcaster.name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: ScreenUtil().setSp(16)),
            ),
          ),
        ),
      ),
    );
  }

  List<PodcasterData> getPodcastersByType(String type) {
    // 根據不同的 type 返回對應的資料
    // 這裡的 PodcasterData 是一個自定義的類，代表每位主持人的資料
    // 你需要根據實際情況修改
    
    switch(type){
      case 'type1':
        return [
        PodcasterData(name: '百靈果', imagePath: 'images/podcaster/BLG.jpg'),
        PodcasterData(name: '志祺七七', imagePath: 'images/podcaster/77.png'),
        PodcasterData(name: '台灣通勤第一品牌', imagePath: 'images/podcaster/TT.jpg'),
        PodcasterData(name: '呱吉', imagePath: 'images/podcaster/GG.jpeg'),
        ];
      case 'type2':
        return [
        PodcasterData.defaultPodcaster(),
        PodcasterData.defaultPodcaster(),
        PodcasterData.defaultPodcaster(),
        PodcasterData.defaultPodcaster(),
      ];
      default:
        return [
        PodcasterData.defaultPodcaster(),
        PodcasterData.defaultPodcaster(),
        PodcasterData.defaultPodcaster(),
        PodcasterData.defaultPodcaster(),
      ];
    }
  }
}

