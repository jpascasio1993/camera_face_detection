import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_face_detection/models/detected_face.dart';
import 'package:camera_face_detection/state/camera_face_detection_viewfinder_state/camera_face_detection_viewfinder_state_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraFaceDetectionViewFinderState extends Cubit<CameraFaceDetectionViewFinderStateState> {
  CameraFaceDetectionViewFinderState(): super(const CameraFaceDetectionViewFinderStateState());


  CameraDescription get currentCameraDescription => state.availableCameraLens.firstWhere((element) => element.lensDirection == state.currentCameraLens);

  void setAllAvailableCameraLens(List<CameraDescription> cameraLens) {
    emit(state.copyWith(availableCameraLens: cameraLens));
  }

  void setCurrentCameraLens(CameraLensDirection cameraLens) {
    emit(state.copyWith(currentCameraLens: cameraLens));
  }

  void setFlashMode(FlashMode flashMode){
    emit(state.copyWith(flashMode: flashMode));
  }

  void setDeviceOrientation(DeviceOrientation deviceOrientation) {
    emit(state.copyWith(deviceOrientation: deviceOrientation));
  }

  void setResolutionPreset(ResolutionPreset resolutionPreset) {
    emit(state.copyWith(resolutionPreset: resolutionPreset));
  }

  void setDetectedFace(DetectedFace? detectedFace) {
    emit(state.copyWith(detectedFace: detectedFace));
  }

  void setCapturedPhoto(File? file) {
    emit(state.copyWith(capturedPhoto: file));
  }

  void isCheckingImage(bool value) {
    emit(state.copyWith(alreadyCheckingImage: value));
  }

  void isInitialized(bool value) {
    emit(state.copyWith(initialized: value));
  }
}