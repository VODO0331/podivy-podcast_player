import 'package:get/get.dart';
import 'package:internationalization_repository/internationalization.dart';
import 'package:translator/translator.dart';

Future<String> translation(String text) async {
  final translator = GoogleTranslator();
  final language = Get.locale?.languageCode;
  if (language == null || TranslationService().currentLanguage == 'en')return text;
    
  final String target =
      '${TranslationService().currentLanguage}-${TranslationService().currentLocation.toLowerCase()}';

  return await translator
      .translate(text, to: target)
      .then((value) => value.text);
}
