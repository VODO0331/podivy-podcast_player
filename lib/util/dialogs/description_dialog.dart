import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:my_audio_player/my_audio_player.dart';
import './generic_dialog.dart';

Future<void> showDescriptionDialog(
    BuildContext context, MediaItem mediaItem) {
  var document = parse(mediaItem.displayDescription!);
  return showGenericDialog(
      context: context,
      title: 'Description'.tr,
      content: "${mediaItem.extras!['airDate']}  \n ${document.body!.text}",
      optionBuilder: () => {'Close'.tr: null});
}
