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
  final (
    Rx<SearchServiceForKeyword> ,
    Rx<SearchServiceForCategories> )
   searchService = (
    SearchServiceForKeyword(keywords: '').obs,
    SearchServiceForCategories(keywords: '').obs
  );
  final TextEditingController textEditingController =
      Get.put(TextEditingController());

  Widget _buildTextField() {
    return TextField(
      controller: textEditingController,
      cursorColor: Theme.of(Get.context!).primaryColor,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Obx(() {
          if(keywords.value != ''){
            return IconButton(
          onPressed: () {
            textEditingController.clear();

            keywords.value = "";
            isSearched.value = false;
          },
          icon: const Icon(Icons.clear),
        );
          }else{
            return const SizedBox.shrink();
          }
        }),
        label: const Text(
          "search",
        ),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(Get.context!).primaryColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
      ),
      onSubmitted: (value) {
        if (value.trim().isNotEmpty) {
          searchService.$1.value = SearchServiceForKeyword(keywords: value); 
          searchService.$2.value= SearchServiceForCategories(keywords: '');
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
            keywords.value.trim().isNotEmpty
                ? "search:${keywords.value}"
                : "類型",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(20),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12).r,
          color: Theme.of(Get.context!).hoverColor,
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
