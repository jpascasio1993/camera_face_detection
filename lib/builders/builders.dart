import 'package:camera_face_detection/models/detected_face.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

typedef ViewFinderBuilder = Widget Function(BuildContext context, DetectedFace? detectedFace, Size? imageSize, Rect? scaledFaceBoundingBox, AsyncCallback takePhoto);