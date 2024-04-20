import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../service/constants.dart';

class UserInfo {
  final RxString userName;
  final RxString userImg;
  final RxString loginMethod;
  final RxString email;
  UserInfo( {
    required this.userName,
    required this.userImg,
    required this.loginMethod,
    required this.email,
  });
  String get name => userName.value;
  String get img => userImg.value;
  UserInfo.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> docs)
      : userName = (docs.data()![personalName] as String).obs,
        userImg = (docs.data()![personalImg] as String).obs,
        loginMethod = (docs.data()![userLoginMethod] as String).obs,
        email = (docs.data()![personalEmail] as String).obs;

  factory UserInfo.forDefault() => UserInfo(userName: ''.obs, userImg: ''.obs,loginMethod: ''.obs, email: ''.obs);
}
