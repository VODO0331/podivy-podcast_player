import 'package:flutter/material.dart';

import './generic_dialog.dart';

Future<void> showCanNotShareDialog(
  BuildContext context,
) {
  return showGenericDialog(
    context: context,
    title: '分享錯誤',
    content: '不能分享',
    optoinBuilder: () => {
      'OK': null,
    },
  );
}
