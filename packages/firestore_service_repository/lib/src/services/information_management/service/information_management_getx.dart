// use GetX

import 'dart:convert';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_service_repository/firestore_service_repository.dart';
// import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import '../../../../error_exception/cloud_storage_exception.dart';
import '../../../../error_exception/information_storage_exception.dart';
import 'dart:developer' as dev show log;
import 'constants.dart';

class InformationManagement {
  late final String _authEmail;
  late final String _loginMethod;
  late final DocumentReference<Map<String, dynamic>> _userDocs;

  InformationManagement(AuthService authService) {
    String userId = authService.currentUser!.id;
    _authEmail = authService.currentUser!.email;
    _loginMethod = authService.loginMethod;
    _userDocs = FirebaseFirestore.instance.collection("user").doc(userId);
    _haveInfo();
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

  Future<void> _haveInfo() async {
    final result = await _userDocs.get().then((value) => value.data());
    if (result == null || result.isEmpty) {
      await _initialization(userName: "Nobody");
    } else {
      //檢查firebaseAuth 與 firestore 的email是否相同
      if (result[personalEmail] != _authEmail) {
        await updateInfo(userName: null, userImg: null, newEmail: _authEmail);
      }
    }
  }

  Future<void> _initialization({required String userName}) async {
    ByteData data =
        await rootBundle.load("assets/images/user_pic/default_user.png");
    final imgData = await _imgCompress(data.buffer.asUint8List());

    await _userDocs.set({
      personalName: userName,
      personalImg: imgData,
      personalEmail: _authEmail,
      userLoginMethod: _loginMethod,
    }).then((value) {
      dev.log("info added successfully!");
    }).catchError((error) {
      dev.log("info added error!");
      throw CloudNotCreateException();
    });
  }

  //註銷用戶
  Future<bool> deleteInfo() async {
    final fsp = Get.find<FirestoreServiceProvider>();

    await fsp.follow.deleteUser();
    await fsp.interests.deleteUser();
    await fsp.list.deleteUser();

    await _userDocs.delete().then((value) {
      return true;
    });
    return false;
  }

  Future<bool> updateInfo(
      {required String? userName,
      required Uint8List? userImg,
      required String? newEmail}) async {
    final Map<Object, Object?> updates = <Object, Object?>{};
    bool result = false;
    if (userName == null && userImg == null && newEmail == null) return result;
    if (userName != null) {
      updates.addAll({personalName: userName});
    }
    if (userImg != null) {
      final result = await _imgCompress(userImg);
      updates.addAll({personalImg: result});
    }
    if (newEmail != null) {
      updates.addAll({personalEmail: newEmail});
    }

    await _userDocs.update(updates).then((value) {
      result = true;
    }).catchError((e) {
      if (e is InformationStorageException) {
        throw e;
      } else {
        dev.log(e.toString());
        throw CloudNotUpdateException();
      }
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

  Future<bool> checkEmail(String newEmail) async {
    
    await FirebaseFirestore.instance.collection("user").get().then((value) {
      for (DocumentSnapshot element in value.docs) {
        final data = element.data() as Map<String, dynamic>;
        if (newEmail == data[personalEmail]) {
          throw EmailAlreadyInUse();
        }
      }
    });

    return true;
  }
}
