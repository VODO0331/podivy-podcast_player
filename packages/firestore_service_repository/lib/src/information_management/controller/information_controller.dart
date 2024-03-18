import 'package:get/get.dart';
import '../model/user_info.dart';
import '../service/information_management_getx.dart';
class InformationController extends GetxController {
  final Rx<UserInfo> _userInfo = UserInfo.forDefault().obs;
  UserInfo get userData => _userInfo.value;

  @override
  void onReady() {
    super.onReady();
    _userInfo.bindStream(InformationManagement().readInfo());
  }
}
