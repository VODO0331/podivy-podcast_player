import 'dart:typed_data';

import 'package:get/get.dart';
import '../model/user_info.dart';
import '../service/information_management_getx.dart';

class InformationController extends GetxController {
  final Rx<UserInfo> _userInfo = UserInfo.forDefault().obs;
  UserInfo get userData => _userInfo.value;
  haveInfo() => InformationManagement().haveInfo();
  addInfo({required String userName}) =>
      InformationManagement().addInfo(userName: userName);
  deleteInfo() => InformationManagement().deleteInfo();
  updateInfo({required String? userName, required Uint8List? userImg}) =>
      InformationManagement().updateInfo(userName: userName, userImg: userImg);
  @override
  void onReady() {
    super.onReady();
    _userInfo.bindStream(InformationManagement().readInfo());
  }
}
