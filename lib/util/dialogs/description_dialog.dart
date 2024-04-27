import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import './generic_dialog.dart';

Future<void> showDescriptionDialog(
    BuildContext context, String htmlDescription) {
  var document = parse(htmlDescription);

  return showGenericDialog(
      context: context,
      title: 'Description'.tr,
      content: document.body!.text,
      optionBuilder: () => {'Close'.tr: null});
}
