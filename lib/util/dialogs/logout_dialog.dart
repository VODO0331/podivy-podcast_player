import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './generic_dialog.dart';

Future<bool> showLogOutDialog(
  BuildContext context,
) {
  return showGenericDialog(
    context: context,
    title: 'Log Out',
    content: 'Are you sure you want to log out?'.tr,
    optionBuilder: () => {        
      'Cancel'.tr: false,
      'logOut'.tr: true,
    },
  ).then(
    (value) => value ?? false,
  );
}
