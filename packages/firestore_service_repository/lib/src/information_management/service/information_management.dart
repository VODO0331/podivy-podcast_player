// import 'package:authentication_repository/authentication_repository.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:information_management_service/src/constants.dart';

// import 'dart:developer' as dev show log;

// import '../../personal_information_management.dart';
// import '../error_exception/cloud_storage_exception.dart';

// class InformationManagement {
//   get userId => AuthService.firebase().currentUser!.id;
//   final CollectionReference<Map<String, dynamic>> _userTable =
//       FirebaseFirestore.instance.collection("user");
//   late final DocumentReference<Map<String, dynamic>> _userInfo;

//   static final InformationManagement _shard =
//       InformationManagement._shardInstance();
//   InformationManagement._shardInstance() {
//     _userInfo = _userTable.doc(userId);
//   }
//   factory InformationManagement() => _shard;

//   Future<Uint8List> _imgCompress(Uint8List img) async {
//     try {
//       final imgData = await FlutterImageCompress.compressWithList(
//         img,
//         minHeight: 200,
//         minWidth: 200,
//         format: CompressFormat.png,
//       );
//       return imgData;
//     } on CompressError catch (e) {
//       dev.log(e.message);
//       throw ImageErrorException();
//     } catch (e) {
//       dev.log(e.toString());
//       throw ImageErrorException();
//     }
//   }

//   Future<void> haveInfo() async {
//     final result =
//         await _userTable.doc(userId).get().then((value) => value.data());
//     if (result == null || result.isEmpty) {
//       await addInfo(userName: "Nobody");
//     }
//   }

//   //僅在初始化使用
//   Future<void> addInfo({required String userName}) async {
//     ByteData data =
//         await rootBundle.load("assets/images/user_pic/default_user.png");
//     final imgData = await _imgCompress(data.buffer.asUint8List());

//     await _userInfo.set({
//       personalName: userName,
//       personalImg: imgData,
//     }).then((value) {
//       dev.log("info added successfully!");
//     }).catchError((error) => throw CloudNotCreateException());
//   }

//   //註銷用戶
//   Future<void> deleteInfo() async {
//     try {
//       // await userInfo.delete();
//       await _userTable
//           .doc(userId)
//           .delete()
//           .then((value) => dev.log("delete successfully"));
//     } catch (_) {
//       throw CloudDeleteException();
//     }
//   }

//   Future<void> updateInfo({String? userName, Uint8List? userImg}) async {
//     final Map<Object, Object?> updates = <Object, Object?>{};

//     if (userName != null) {
//       updates.addAll({personalName: userName});
//     }
//     if (userImg != null) {
//       final result = await _imgCompress(userImg);
//       updates.addAll({personalImg: result});
//     }

//     await _userInfo.update(updates).then((value) {
//       dev.log("DocumentSnapshot successfully updated!");
//     }).catchError((e){
//       dev.log(e.toString());
//       throw CloudNotUpdateException();
//     });
//   }

//   Stream<UserInfo> readInfo() {
//     try {
//       final result =
//           _userInfo.snapshots().map((event) => UserInfo.fromSnapshot(event));
//       return result;
//     } catch (e) {
//       dev.log(e.toString());
//       throw CloudNotGetException();
//     }
//   }
// }
