import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camera_face_detection/camera_face_detection_method_channel.dart';

void main() {
  MethodChannelCameraFaceDetection platform = MethodChannelCameraFaceDetection();
  const MethodChannel channel = MethodChannel('camera_face_detection');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
