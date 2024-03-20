import 'package:get/get_navigation/src/root/internacionalization.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          'PageError': "搜尋不到此頁面!",
          'logIn': "登入",
          'register': "註冊",
          'loading': "加載中...",
          "dataError": "數據出現錯誤",
          'hello': '你好 世界',
        },
        'de_DE': {
          'PageError': "Page not find!",
          'logIn': "login",
          'register': "register",
          'loading': "loading...",
          "dataError": "Data Error",
          'hello': 'Hallo Welt',
        }
      };
}
