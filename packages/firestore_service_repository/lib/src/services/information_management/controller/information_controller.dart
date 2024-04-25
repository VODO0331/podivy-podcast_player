import 'dart:typed_data';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:get/get.dart';
import '../model/user_info.dart';
import '../service/information_management_getx.dart';

class InformationController extends GetxController {
  final Rx<UserInfo> _userInfo = UserInfo.forDefault().obs;
  late final InformationManagement _informationManagement;
  UserInfo get userData => _userInfo.value;
  InformationController(AuthService authService) {
    _informationManagement = InformationManagement(authService);
  }

  deleteInfo() => _informationManagement.deleteInfo();

  updateInfo(
          {required String? userName,
          required Uint8List? userImg,
          required String? newEmail}) =>
      _informationManagement.updateInfo(
          userName: userName, userImg: userImg, newEmail: newEmail);

  checkEmail(String newEmail) => _informationManagement.checkEmail(newEmail);

  @override
  void onReady() {
    super.onReady();
    _userInfo.bindStream(_informationManagement.readInfo());
  }
}
