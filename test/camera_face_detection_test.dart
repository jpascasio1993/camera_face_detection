import 'package:flutter_test/flutter_test.dart';
import 'package:camera_face_detection/camera_face_detection.dart';
import 'package:camera_face_detection/camera_face_detection_platform_interface.dart';
import 'package:camera_face_detection/camera_face_detection_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCameraFaceDetectionPlatform
    with MockPlatformInterfaceMixin
    implements CameraFaceDetectionPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CameraFaceDetectionPlatform initialPlatform = CameraFaceDetectionPlatform.instance;

  test('$MethodChannelCameraFaceDetection is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCameraFaceDetection>());
  });

  test('getPlatformVersion', () async {
    CameraFaceDetection cameraFaceDetectionPlugin = CameraFaceDetection();
    MockCameraFaceDetectionPlatform fakePlatform = MockCameraFaceDetectionPlatform();
    CameraFaceDetectionPlatform.instance = fakePlatform;

    expect(await cameraFaceDetectionPlugin.getPlatformVersion(), '42');
  });
}
