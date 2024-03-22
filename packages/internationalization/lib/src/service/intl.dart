import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../language/intl_en_us.dart';
import '../language/intl_zh_tw.dart';

class TranslationService extends Translations {
  final storage = GetStorage();
  final RxString _currentLanguage = 'en'.obs;
  final RxString _currentLocation = 'US'.obs;
  String get currentLanguage => _currentLanguage.value;
  String get currentLocation => _currentLocation.value;
  static final TranslationService _singleton = TranslationService._();

  factory TranslationService() => _singleton;
  TranslationService._() {
    storage.writeIfNull('language', 'en');
    storage.writeIfNull('location', 'US');
    _currentLanguage.value = storage.read('language') ?? 'en';
    _currentLocation.value = storage.read('location') ?? 'US';
  }

  Future<void> changeLanguage(String languageCode, String location) async {
    _currentLanguage.value = languageCode;
    _currentLocation.value = location;
    await Get.updateLocale(Locale(languageCode));

    await storage
        .write('language', languageCode)
        .then((value) =>
            printInfo(info: 'success store $languageCode in to language'))
        .catchError((_) => printInfo(info: 'store error'));
    await storage
        .write('location', location)
        .then((value) =>
            printInfo(info: 'success store $location in to location'))
        .catchError((_) => printInfo(info: 'store error'));
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'zh_TW': zh_Tw,
        'en_US': en_Us,
      };
  updateTransition(Locale local) {
    Get.updateLocale(local);
  }
}
