import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:information_management_service/src/constants.dart';

class UserInfo {
  final RxString userName;
  final RxString userImg;

  UserInfo({
    required this.userName,
    required this.userImg,
  });
  String get name => userName.value;
  String get img => userImg.value;
  UserInfo.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> docs)
      : userName = (docs.data()![personalName] as String).obs,
        userImg = (docs.data()![personalImg] as String).obs;

  factory UserInfo.forDefault() => UserInfo(userName: ''.obs, userImg: ''.obs);
}
