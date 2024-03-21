import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TranslationService extends Translations {
  static final TranslationService _singleton = TranslationService._internal();
  factory TranslationService() => _singleton;

  TranslationService._internal();

  @override
  Map<String, Map<String, String>> get keys => {
        'zh_TW': {
          'PageError': "搜尋不到此頁面!",

          //auth
          'logIn': "登入",
          'register': "註冊",
          'enter the Email': '輸入電子郵件',
          'enter the Password': '輸入密碼',
          'enter the password again': '再次輸入密碼',
          'forget the password?': '忘記密碼?',
          'Already have an account? Log in here': '已有帳號? 在這登入',
          'If you forget your password, enter the email': '如果你忘記密碼，請輸入電子郵件',
          'Please verify the email': '請驗證電子郵件',
          'reset Password': '重設密碼',
          'send verification': '傳送驗證',
          //search Page
          'loading': "加載中...",
          "dataError": "數據出現錯誤!",
          'dataNotFind': '搜尋不到資料',
          'category': '類別',
          //podcast Page
          'share': '分享',
          'follow': '追隨',
          'newest': '最新',
          'oldest': '最舊',
          'No Content': '無內容',
          //setting Page
          'theme': '主題',
          //media Page
          'History': "歷史紀錄",
          'Tag List': '標籤清單',
          'delete': "刪除",
          //List Page
          'Add time (new > old)': "新增時間(新>舊)",
          'Add time (old > new)': "新增時間(舊>新)",
          'Release time (old > new)': '發布時間(舊>新)',
          'Release time (new > old)': '發布時間(新>舊)',
          'New list name': '新播放清單名稱',
          'list Name': '清單名稱',
          'Please enter the new name': '請輸入新的名稱',

          //add list dialog
          'Add To List': '添加清單',
          'Add': "添加",

          //drawer
          'setting': '設定',
          'logOut': '登出',

          'Name': '名稱',
          'Edit': '編輯',
          'Count': '數量',
          'Cancel': '取消',
          'Done': '完成',
          'back': '返回',
        },
        'de_DE': {
          'PageError': "Page Not Find!",
          //auth
          'logIn': "login",
          'register': "register",
          'enter the Email': 'Please Enter the Email',
          'enter the Password': 'Please Enter the Password',
          'enter the password again': 'Enter the password again',
          'forget the password?': 'forget the password?',
          'Already have an account? Log in here':
              'Already have an account? Log in here',
          'If you forget your password, enter the email':
              'If you forget your password, enter the email',
          'reset Password': 'Reset Password',
          'Please verify the email': 'Please verify the email',
          'send verification': 'Send verification',
          //search Page
          'loading': "Loading...",
          "dataError": "Data Error!",
          'dataNotFind': 'Data Not Find',
          'category': 'Category',
          //podcast Page
          'share': 'Share',
          'follow': 'Follow',
          'No Content': 'No Content',
          'newest': 'Newest',
          'oldest': 'Oldest',
          //setting Page
          'theme': 'Theme',
          //media Page
          'History': "History",
          'Tag List': 'Tag List',
          'delete': 'Delete',
          //List Page
          'Add time (new > old)': "Add time (new > old)",
          'Add time (old > new)': "Add time (old > new)",
          'Release time (old > new)': 'Release time (old > new)',
          'Release time (new > old)': 'Release time (new > old)',
          'list Name': 'List Name',
          'New list name': 'New list name',
          'Please enter the new name': 'Please enter the new list name',

          //add list dialog
          'Add To List': 'Add To List',
          'Add': "Add",
          //drawer
          'logOut': 'LogOut',
          'setting': 'setting',

          'Name': 'Name',
          'Edit': 'Edit',
          'Count': 'count',
          'Cancel': 'Cancel',
          'Done': 'Done',
          'back': 'Back',
        }
      };
  updateTransition(Locale local) {
    Get.updateLocale(local);
  }
}
