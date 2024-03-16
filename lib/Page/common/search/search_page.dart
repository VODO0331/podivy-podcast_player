import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:search_service/search_service_repository.dart';

import 'build/build_search_result.dart';
// import 'dart:developer' as dev show log;

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);
  final RxString keywords = "".obs;
  final RxBool isSearched = false.obs;
  final Rx<SearchService> searchService =
      Get.put(SearchServiceForKeyword(keywords: "").obs);
  final TextEditingController textEditingController =
      Get.put(TextEditingController());

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

            keywords.value = "";
            isSearched.value = false;
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
        if (value.trim().isNotEmpty) {
          searchService.value = SearchServiceForKeyword(keywords: value);
          keywords.value = value;
          isSearched.value = true;
        } else {
          Get.snackbar(
            '提示',
            "請輸入",
            duration: const Duration(seconds: 1),
          );
        }
      },
    );
  }

  Widget _buildSearchLabel() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Obx(() => Text(
            "search:${keywords.value.trim().isNotEmpty ? keywords.value : "類型"}",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(20),
            ),
          )),
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
              Expanded(
                child: SearchResult(
                  isSearched: isSearched,
                  searchService: searchService,
                  onSearched: (keyword) {
                    keywords.value = keyword;
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
