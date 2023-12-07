import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final myList = [
      'podcast1',
      'podcast2',
      'podcast3',
      'podcast2',
      'podcast3',
      'podcast2',
      'podcast3',
      'podcast2',
      'podcast3',
      'podcast2',
      'podcast3',
      'podcast2',
      'podcast3',
      'podcast2',
      'podcast3'
    ];
    final listLength = myList.length.toString();
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 20, 0, 10),
              child: Row(
                children: [
                  Icon(
                    Icons.bookmark_border_outlined,
                    size: 80,
                    shadows: [Shadow()],
                  ),
                  Text(
                    '標籤清單',
                    style: TextStyle(fontSize: 29),
                  )
                ],
              ),
            ),
            Text('$listLength 部'),
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text(myList[index]),
                          leading:
                              Image.asset('images/userPic/people4Rect.png'),
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
