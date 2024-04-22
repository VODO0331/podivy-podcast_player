import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';

import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/util/translator.dart';

typedef SelectCallBack = void Function(String category);

class CategoryButton extends StatelessWidget {
  final FirestoreServiceProvider fsp;
  final SelectCallBack selected;
  const CategoryButton(
      {super.key, required this.selected, required this.fsp});
  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: fsp.interests.interestsCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              final interests = snapshot.data;
              if (interests!.isNotEmpty) {
                selected(interests.first.category); // 在此處調用回調函數，傳遞第一筆資料
              }
              return SizedBox(
                height: 55.r,
                width: ScreenUtil().screenWidth,
                child: ListView.builder(
                  padding: const EdgeInsets.all(9).r,
                  scrollDirection: Axis.horizontal,
                  itemCount: interests.length,
                  itemBuilder: (context, index) {
                    final interest = interests.elementAt(index);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8).r,
                      child: ElevatedButton(
                        child: FutureBuilder(
                          future: translation(interest.category),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              return Text(snapshot.data as String);
                            } else {
                              return const Text('Translation Error');
                            }
                          },
                        ),
                        onPressed: () => selected(interest.category),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Text("Loading...");
            }
          } else {
            return Text("Connection state: ${snapshot.connectionState}");
          }
        });
  }
}
