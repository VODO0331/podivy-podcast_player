import 'dart:typed_data';

import 'package:get/get.dart';
import '../model/user_info.dart';
import '../service/information_management_getx.dart';

class InformationController extends GetxController {
  final Rx<UserInfo> _userInfo = UserInfo.forDefault().obs;
  late final InformationManagement informationManagement ;
  UserInfo get userData => _userInfo.value;
  InformationController(String userId){
    informationManagement = InformationManagement(userId);
  }
  haveInfo() => informationManagement.haveInfo();

  addInfo({required String userName}) =>
      informationManagement.addInfo(userName: userName);

  deleteInfo() => informationManagement.deleteInfo();

  updateInfo(
          {required String? userName,
          required Uint8List? userImg,
          required String? newEmail}) =>
      informationManagement
          .updateInfo(userName: userName, userImg: userImg, newEmail: newEmail);

  checkEmail(String newEmail) => informationManagement.checkEmail(newEmail);
  @override
  void onReady() {
    super.onReady();
    _userInfo.bindStream(informationManagement.readInfo());
  }
  
}
