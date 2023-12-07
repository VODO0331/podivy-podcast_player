import 'package:flutter/material.dart';

import './generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context){
    return showGenericDialog(
      context: context, 
      title: '刪除提醒', 
      content: '確定要刪除此筆記嗎?', 
      optoinBuilder: () => {
        'Cancel': false,
        'Ok': true,
      },).then((value) => value ?? false);
}