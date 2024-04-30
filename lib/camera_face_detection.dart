

export 'package:camera_face_detection/models/detected_face.dart';
export 'package:camera_face_detection/widget/camera_face_detection_viewfinder.dart';
export 'package:camera_face_detection/utils/rect_utils.dart';

// class CameraFaceDetection with ContextualLogger {
//
//   static List<CameraDescription> _cameras = [];
//
//   @override
//   String get logContext => runtimeType.toString();
//
//   static Future<void> initialize() async {
//     /// Fetch the available cameras before initializing the app.
//     try {
//       _cameras = await availableCameras();
//     } on CameraException catch (e) {
//       debugPrint('[CameraFaceDetection] Error: $e');
//     }
//   }
//
//   static List<CameraDescription> get cameras {
//     return _cameras;
//   }
// }

