import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podivy/widget/drawer.dart';
import 'package:get/get.dart';
class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params = Get.parameters;
    final String listTitle = params['listTitle'];
    final List myList = Get.arguments as List;

    return Scaffold(
      drawer: const MyDrawer(),
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 50, 12, 10).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 35.r,
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                  ),
                ),
                IconButton(
                  iconSize: 30.r,
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert_sharp),
                ),
              ],
            ),
            const Divider(
              color: Colors.white10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 20, 0, 10).r,
              child: Row(
                children: [
                  const Icon(
                    Icons.bookmark_border_outlined,
                    size: 80,
                    shadows: [Shadow()],
                  ),
                  Text(
                    listTitle,
                    style: const TextStyle(fontSize: 29),
                  )
                ],
              ),
            ),
            Text('${myList.length} 部'),
            const Divider(
              thickness: 1,
            ),
            IconButton(
                onPressed: () {
                  print('sort');
                },
                icon: const Icon(Icons.sort_sharp)),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: myList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10).h,
                        child: ListTile(
                          title: Text(
                            myList[index],
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: Image.asset('images/podcaster/77.png'),
                          trailing: const Icon(Icons.more_vert),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
