import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:information_management_service/src/constants.dart';

class UserInfo {
  final String userName;
  final Uint8List userImg;

  UserInfo({
    required this.userName,
    required this.userImg,
  });

  UserInfo.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> docs)
      : userName = docs.data()![personalName] as String,
        userImg = Uint8List.fromList((docs.data()![personalImg] as List).cast<int>());
}
