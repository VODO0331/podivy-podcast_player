// use GetX

import 'dart:typed_data';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:information_management_service/src/error_exception/cloud_storage_exception.dart';
import 'package:information_management_service/src/models/user_info.dart';
import '../constants.dart';
import 'dart:developer' as dev show log;

class InformationManagementWithGet extends GetxController {
  final RxString userId = AuthService.firebase().currentUser!.id.obs;
  Rx<UserInfo?> get userData => userInfoResult;
  final Rx<CollectionReference<Map<String, dynamic>>> user =
      FirebaseFirestore.instance.collection("user").obs;

  late final Rx<DocumentReference<Map<String, dynamic>>> userInfo;
  late final Rx<UserInfo?> userInfoResult;
  late final Future initFuture;
  InformationManagementWithGet() {
    userInfo = user.value
        .doc(userId.value)
        .collection('information')
        .doc("personalInfo")
        .obs;
  }
  @override
  void onInit() async {
    super.onInit();
    initFuture = _init();
  }

  Future _init() async {
    await haveInfo();
    userInfoResult.value = await readInfo();
    update();
  }

  Future<void> haveInfo() async {
    final result =
        await user.value.doc(userId.value).get().then((value) => value.data());
    if (result == null || result.isEmpty) {
      XFile imgData = XFile('assets/images/userPic/default_user.png');
      await addInfo(userImg: imgData, userName: "Nobody");
    }
  }

  Future<Uint8List> imgCompress(XFile img) async {
    try {
      XFile? imgOO = XFile('assets/images/userPic/default_user.png');
      final imgData = await FlutterImageCompress.compressWithFile(
        imgOO.path,
        minHeight: 400,
        minWidth: 400,
        format: CompressFormat.png,
      );
      if (imgData != null) {
        return imgData;
      } else {
        throw ImageErrorException();
      }
    } on CompressError catch (e) {
      dev.log(e.message);
      throw ImageErrorException();
    }
  }

  Future<void> addInfo(
      {required String userName, required XFile userImg}) async {
    final imgData = await imgCompress(userImg);

    await userInfo.value
        .set({personalName: userName, personalImg: imgData}).then((value) {
      dev.log("info added successfully!");
      dev.log('right here');
      update([userInfoResult]);
    }).catchError((error) => throw CloudNotCreateException());
  }

  //註銷用戶
  Future<void> deleteInfo() async {
    try {
      await userInfo.value.delete();
      await user.value
          .doc(userId.value)
          .delete()
          .then((value) => update([userInfoResult]));
    } catch (_) {
      throw CloudDeleteException();
    }
  }

  Future<void> updateInfo({String? userName, XFile? userImg}) async {
    final Map<Object, Object?> updates = <Object, Object?>{}.obs;
    userName != null ? updates.addAll({personalName: userName}) : null;
    if (userImg != null) {
      final imgData = await imgCompress(userImg);
      updates.addAll({personalImg: imgData});
    }

    await userInfo.value.update(updates).then((value) {
      dev.log("DocumentSnapshot successfully updated!");
      update([userInfoResult]);
    }).catchError(throw CloudNotUpdateException());
  }

  Future<UserInfo> readInfo() async {
    return await userInfo.value
        .get()
        .then((value) => UserInfo.fromSnapshot(value))
        .catchError(throw CloudNotGetException());
  }

}
