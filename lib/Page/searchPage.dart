import 'package:flutter/material.dart';
import 'package:podivy/widget/recommendButton.dart';

class SerchPage extends StatefulWidget {
  const SerchPage({super.key});

  @override
  State<SerchPage> createState() => _SerchPageState();
}

class _SerchPageState extends State<SerchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color.fromARGB(196, 5, 8, 5),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(20, 90, 20, 20),
            child: Column(children: [
              TextField(
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
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "類型",
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),
              Divider(),
              Wrap(
                spacing: 10,
                runSpacing: 5,
                children: [
                  RecommendButton(text: '123'),
                  RecommendButton(text: '237923478'),
                  RecommendButton(text: '123'),
                  RecommendButton(text: '123123rwe'),
                  RecommendButton(text: 'test123231123'),
                  RecommendButton(text: '123'),
                ],
              )
            ]),
          ),
        ),
      );
    
  }
}
