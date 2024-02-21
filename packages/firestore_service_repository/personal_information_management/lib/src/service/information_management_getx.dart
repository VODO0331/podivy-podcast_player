// use GetX

import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:get/get.dart';
import 'package:information_management_service/src/error_exception/cloud_storage_exception.dart';
import 'package:information_management_service/src/models/user_info.dart';
import '../constants.dart';
import 'dart:developer' as dev show log;

class InformationManagement {
  get userId => AuthService.firebase().currentUser!.id;
  final CollectionReference<Map<String, dynamic>> _userTable =
      FirebaseFirestore.instance.collection("user");
  late final DocumentReference<Map<String, dynamic>> _userDocs;

  InformationManagement() {
    _userDocs = _userTable.doc(userId);
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
        await _userTable.doc(userId).get().then((value) => value.data());
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
          .doc(userId)
          .delete()
          .then((value) => dev.log("delete successfully"));
    } catch (_) {
      throw CloudDeleteException();
    }
  }

  Future<void> updateInfo({String? userName, Uint8List? userImg}) async {
    final Map<Object, Object?> updates = <Object, Object?>{};
    if (userName == null && userImg == null) return;
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
    }).catchError((e) {
      dev.log(e.toString());
      throw CloudNotUpdateException();
    });
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
