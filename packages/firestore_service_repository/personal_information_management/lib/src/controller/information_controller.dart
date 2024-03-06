import 'package:get/get.dart';
import 'package:information_management_service/information_management_service.dart';

class InformationController extends GetxController {
  final Rx<UserInfo> _userInfo = UserInfo.forDefault().obs;
  UserInfo get userData => _userInfo.value;

  @override
  void onReady() {
    super.onReady();
    _userInfo.bindStream(InformationManagement().readInfo());
  }
}
