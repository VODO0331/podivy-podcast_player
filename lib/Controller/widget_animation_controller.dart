

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final Rxn<AnimationController> _animationController =
      Rxn<AnimationController>();
  AnimationController? get animationController => _animationController.value;

  final Rxn<Animation<double?>> _opacityAnimation = Rxn<Animation<double?>>();
  Animation<double?>? get opacityAnimation => _opacityAnimation.value;

  final Rxn<Animation<double>> _heightAnimation = Rxn<Animation<double>>();
  Animation<double>? get heightAnimation => _heightAnimation.value;

  final Rxn<Animation<double>> _avatarSizeAnimation = Rxn<Animation<double>>();
  Animation<double>? get avatarSizeAnimation => _avatarSizeAnimation.value;

  final Rxn<Animation<double>> _rotateAnimation = Rxn<Animation<double>>();
  Animation<double>? get rotateAnimation => _rotateAnimation.value;
  @override
  void onInit() {
    super.onInit();
    const duration = Duration(milliseconds: 600);

    _animationController.value = AnimationController(
      vsync: this,
      duration: duration,
    );

    _opacityAnimation.value = (Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.linear))
        .animate(_animationController.value!)
      ..addListener(() {
        update();
      }));

    _heightAnimation.value = (Tween<double>(begin: 220, end: 500)
        .chain(CurveTween(curve: Curves.ease))
        .animate(_animationController.value!)
      ..addListener(() {
        update();
      }));

    _avatarSizeAnimation.value = (Tween<double>(begin: 55, end: 0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_animationController.value!)
      ..addListener(() {
        update();
      }));

    _rotateAnimation.value = (Tween<double>(begin: 0, end: pi)
        .chain(CurveTween(curve: Curves.bounceOut))
        .animate(_animationController.value!)
      ..addListener(() {
        update();
      }));
    _animationController.value?.stop();
  }

  void changeAnimation() {
    if (_animationController.value?.status == AnimationStatus.completed) {
      _animationController.value?.reverse();
    } else {
      _animationController.value?.forward();
    }
  }

  @override
  void onClose() {
    _animationController.value?.dispose();
    super.onClose();
  }
}