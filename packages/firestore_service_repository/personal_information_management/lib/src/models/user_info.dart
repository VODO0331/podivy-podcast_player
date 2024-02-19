
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:information_management_service/src/constants.dart';

class UserInfo {
  final RxString userName;
  final Rx<Uint8List?> userImg;

  UserInfo({
    required this.userName,
    required this.userImg,
  });
   String  get name => userName.value;
   Uint8List?  get img => userImg.value;
  UserInfo.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> docs)
      : userName = (docs.data()![personalName]as String ).obs  ,
        userImg =
            (Uint8List.fromList((docs.data()![personalImg] as List).cast<int>())).obs;

  factory UserInfo.forDefault() =>
      UserInfo(userName: ''.obs, userImg: null.obs);
}
