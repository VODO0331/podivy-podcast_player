import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podivy/util/recommendButton.dart';

class SerchPage extends StatefulWidget {
  const SerchPage({super.key});

  @override
  State<SerchPage> createState() => _SerchPageState();
}

class _SerchPageState extends State<SerchPage> {
  late bool searched;
  String? keywords;

  @override
  void initState() {
    super.initState();
    searched = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(196, 5, 8, 5),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 90, 20, 20).r,
          child: Column(children: [
            const TextField(
              cursorColor: Color(0xFFABC4AA),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                ),
                suffixIcon: Icon(Icons.clear),
                // IconButton(onPressed:(){}, icon: Icon(Icons.clear)),
                label: Text(
                  "search",
                  style: TextStyle(color: Color.fromARGB(255, 110, 127, 109)),
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFABC4AA)),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                keywords ?? "類型",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(25),
                ),
              ),
            ),
            const Divider(),
            searchContent(keywords)
          ]),
        ),
      ),
    );
  }

  Widget searchContent(String? keyword) {
    print(
        'SearchContent method called. Searched: $searched, Keywords: $keywords');

    return searched
        ? Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10).h,
                      child: ListTile(
                        title: const Text(
                          'title1',
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
          )
        : Wrap(
            spacing: 10,
            runSpacing: 5,
            children: [
              RecommendButton(
                text: '123',
                onPressed: () {
                  setState(() {
                    searched = true;
                    keywords = '123';
                    
                  });
                },
              ),
              RecommendButton(text: '237923478'),
              RecommendButton(text: '123'),
              RecommendButton(text: '123123rwe'),
              RecommendButton(text: 'test123231123'),
              RecommendButton(text: '123'),
            ],
          );
  }
}
