import 'package:flutter/material.dart';
import './generic_dialog.dart';

Future<bool> showLogOutDialog(
  BuildContext context,
) {
  return showGenericDialog(
    context: context,
    title: 'Log Out',
    content: '確定要登出嗎',
    optoinBuilder: () => {
      'Cancel': false,
      'Log Out': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
