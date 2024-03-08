import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:search_service/search_service_repository.dart';

import '../build/build_search_result.dart';
// import 'dart:developer' as dev show log;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? keywords;
  late SearchService searchService;
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    searchService = SearchServiceForKeyword(keywords: keywords);
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    searchService;
  }

  Widget _buildTextField() {
    return TextField(
      controller: textEditingController,
      cursorColor: const Color(0xFFABC4AA),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: () {
            textEditingController.clear();
            setState(() {
              keywords = " ";
            });
          },
          icon: const Icon(Icons.clear),
        ),
        label: const Text(
          "search",
          style: TextStyle(color: Color.fromARGB(255, 110, 127, 109)),
        ),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFABC4AA)),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      onSubmitted: (value) {
        setState(() {
          searchService = SearchServiceForKeyword(keywords: value);
          keywords = value;
        });
      },
    );
  }

  Widget _buildSearchLabel() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "search:${keywords ?? "類型"}",
        style: TextStyle(
          fontSize: ScreenUtil().setSp(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        color: const Color.fromARGB(196, 5, 8, 5),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
          child: Column(
            children: [
              _buildTextField(),
              const SizedBox(height: 15),
              _buildSearchLabel(),
              const Divider(endIndent: 170, color: Color(0xFFABC4AA)),
              Expanded(child: SearchResult(
                keywords: keywords,
                searchService: searchService,
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
