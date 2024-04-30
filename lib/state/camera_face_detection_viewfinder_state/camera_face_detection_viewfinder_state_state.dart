import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_face_detection/models/detected_face.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'camera_face_detection_viewfinder_state_state.freezed.dart';

@freezed
class CameraFaceDetectionViewFinderStateState with _$CameraFaceDetectionViewFinderStateState {
  const factory CameraFaceDetectionViewFinderStateState(
          {DetectedFace? detectedFace,
          @Default(false) bool initialized,
          @Default(false) bool alreadyCheckingImage,
          @Default([]) List<CameraDescription> availableCameraLens,
          @Default(FlashMode.auto) FlashMode flashMode,
          @Default(CameraLensDirection.front) CameraLensDirection currentCameraLens,
          @Default(DeviceOrientation.portraitUp) DeviceOrientation deviceOrientation,
          @Default(ResolutionPreset.high) ResolutionPreset resolutionPreset,
          File? capturedPhoto}) =
      _CameraFaceDetectionViewFinderStateState;
}
