import 'package:flutter/painting.dart';
import 'dart:math' as math;

abstract class RectUtils {
  static Rect scaledFaceBoundingBox(
      {required Rect faceRect, required Size widgetSize, double? scaleX, double? scaleY}) {
    return Rect.fromLTRB((widgetSize.width - faceRect.left.toDouble() * scaleX!), faceRect.top.toDouble() * scaleY!,
        widgetSize.width - faceRect.right.toDouble() * scaleX, faceRect.bottom.toDouble() * scaleY);
  }

  static bool isFaceBoundingBoxInsideTheViewFinder(
      {required Rect viewFinder,
      required Rect scaledFaceBoundingBox,
      double? radius,
      int acceptableDistanceThreshold = 24,
      int acceptableHeadTiltXThreshold = 120,
      int acceptableHeadTiltYThreshold = 120}) {
    final double circleCenterX = viewFinder.center.dx;
    final double circleCenterY = viewFinder.center.dy;
    final double rectLeft = scaledFaceBoundingBox.left;
    final double rectRight = scaledFaceBoundingBox.right;
    final double rectTop = scaledFaceBoundingBox.top;
    final double rectBottom = scaledFaceBoundingBox.bottom;
    final double _radius = radius ?? viewFinder.width * 0.35;
    final double deltaX = math.max(circleCenterX - rectRight, rectLeft - circleCenterX);
    final double deltaY = math.max(circleCenterY - rectBottom, rectTop - circleCenterY);
    final double distance = math.sqrt(deltaX * deltaX + deltaY * deltaY);
    final isInsideViewFinder = (_radius - distance).abs() <= acceptableDistanceThreshold &&
        distance <= _radius &&
        deltaX <= acceptableHeadTiltXThreshold &&
        deltaY.isNegative &&
        deltaY.abs() < acceptableHeadTiltYThreshold;
    return isInsideViewFinder;
  }
}
