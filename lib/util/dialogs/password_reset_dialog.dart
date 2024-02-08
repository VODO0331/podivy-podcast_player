import 'package:flutter/material.dart';
import 'package:podivy/util/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: '密碼重製',
      content: '郵件已發送，請確認',
      optionBuilder: ()=>{
        'OK': null
      });
}
