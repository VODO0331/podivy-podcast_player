import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import './generic_dialog.dart';

Future<void> showDescriptionDialog(
    BuildContext context, String htmlDescription) {
  var document = parse(htmlDescription);

  return showGenericDialog(
      context: context,
      title: '介紹',
      content: document.body!.text,
      optoinBuilder: () => {'關閉': null});
}
