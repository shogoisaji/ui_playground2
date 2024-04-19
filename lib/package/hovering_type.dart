import 'dart:math';

import 'package:flutter/material.dart';

enum HoveringType { normal, hovering1, hovering2, hovering3 }

class HoveringActions {
  final HoveringType type;

  HoveringActions(this.type);

  Animation getAnimation(AnimationController animationController) {
    switch (type) {
      case HoveringType.normal:
        return CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

      case HoveringType.hovering1:
        return CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
      case HoveringType.hovering2:
        return CurvedAnimation(parent: animationController, curve: Curves.easeIn);
      case HoveringType.hovering3:
        return CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    }
  }

  Matrix4 getTransform(double controllerValue, double bounceHeight, double width) {
    switch (type) {
      case HoveringType.normal:
        return Matrix4.identity()..translate(0, -controllerValue * bounceHeight, 0.0);
      case HoveringType.hovering1:
        final hoveringTween = TweenSequence<double>([
          // 1回目の上昇と下降
          TweenSequenceItem(
            tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 1.0,
          ),
          TweenSequenceItem(
            tween: Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 1.0,
          ),
          TweenSequenceItem(
            tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 1.0,
          ),
          TweenSequenceItem(
            tween: Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 1.0,
          ),
        ]);
        final spinTween = TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(begin: 0.0, end: 0.0),
            weight: 1.0,
          ),
          TweenSequenceItem(
            tween: Tween(begin: 0.0, end: pi * 2).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 1.7,
          ),
          TweenSequenceItem(
            tween: Tween(begin: 0, end: 0),
            weight: 1.0,
          ),
        ]);
        return Matrix4.identity()
          ..translate(width / 2, 0.0, 0.0)
          ..rotateY(spinTween.transform(controllerValue))
          ..translate(-width / 2, 0.0, 0.0);
      case HoveringType.hovering2:
        return Matrix4.translationValues(0, bounceHeight, 0);
      case HoveringType.hovering3:
        return Matrix4.translationValues(bounceHeight, 0, 0);
    }
  }
}
