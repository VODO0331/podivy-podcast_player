// use GetX

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:get/get.dart';
import '../../../error_exception/cloud_storage_exception.dart';
import '../../../error_exception/information_storage_exception.dart';
import '../../user_id.dart';
import '../model/user_info.dart';
import 'dart:developer' as dev show log;

import 'constants.dart';

class InformationManagement {
  final _userId = userId;
  final CollectionReference<Map<String, dynamic>> _userTable =
      FirebaseFirestore.instance.collection("user");
  late final DocumentReference<Map<String, dynamic>> _userDocs;

  InformationManagement() {
    _userDocs = _userTable.doc(_userId);
    haveInfo();
  }

  Future<String> _imgCompress(Uint8List img) async {
    try {
      final imgData = await FlutterImageCompress.compressWithList(
        img,
        minHeight: 200,
        minWidth: 200,
        format: CompressFormat.png,
      );
      final result = base64Encode(imgData);
      return result;
    } on CompressError catch (e) {
      dev.log(e.message);
      throw ImageErrorException();
    } catch (e) {
      dev.log(e.toString());
      throw ImageErrorException();
    }
  }

  Future<void> haveInfo() async {
    final result =
        await _userTable.doc(_userId).get().then((value) => value.data());
    if (result == null || result.isEmpty) {
      await addInfo(userName: "Nobody");
    }
  }

  //僅在初始化使用
  Future<void> addInfo({required String userName}) async {
    ByteData data =
        await rootBundle.load("assets/images/user_pic/default_user.png");

    final imgData = await _imgCompress(data.buffer.asUint8List());

    await _userDocs.set({
      personalName: userName,
      personalImg: imgData,
    }).then((value) {
      dev.log("info added successfully!");
    }).catchError((error) => throw CloudNotCreateException());
  }

  //註銷用戶
  Future<void> deleteInfo() async {
    try {
      // await userInfo.delete();
      await _userTable
          .doc(_userId)
          .delete()
          .then((value) => dev.log("delete successfully"));
    } catch (_) {
      throw CloudDeleteException();
    }
  }

  Future<bool> updateInfo({ required String? userName,required Uint8List? userImg}) async {
    final Map<Object, Object?> updates = <Object, Object?>{};
    bool result = false;
    if (userName == null && userImg == null) return result;
    if (userName != null) {
      updates.addAll({personalName: userName});
      // _userInfo.value.userName.value = userName;
    }
    if (userImg != null) {
      final result = await _imgCompress(userImg);
      updates.addAll({personalImg: result});
      // _userInfo.value.userImg.value = result;
    }
    // update([_userInfo]);

    await _userDocs.update(updates).then((value) {
      dev.log("DocumentSnapshot successfully updated!");
      result = true;
    }).catchError((e) {
      dev.log(e.toString());
      throw CloudNotUpdateException();
    });
    return result;
  }

  Stream<UserInfo> readInfo() {
    try {
      return _userDocs.snapshots().map((event) => UserInfo.fromSnapshot(event));
    } catch (e) {
      dev.log(e.toString());
      throw CloudNotGetException();
    }
  }
}
