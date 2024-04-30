import 'package:flutter/painting.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'detected_face.freezed.dart';

@freezed
class DetectedFace with _$DetectedFace {
  const factory DetectedFace({Face? face, @Default(false) bool wellPositioned, Rect? scaledBoundingBox}) = _DetectedFace;
}
