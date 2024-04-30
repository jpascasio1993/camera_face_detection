import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_face_detection/builders/builders.dart';
import 'package:camera_face_detection/handlers/face_identifier.dart';
import 'package:camera_face_detection/models/detected_face.dart';
import 'package:camera_face_detection/state/camera_face_detection_viewfinder_state/camera_face_detection_viewfinder_state.dart';
import 'package:camera_face_detection/utils/rect_utils.dart';
import 'package:camera_face_detection/widget/widget_view.dart';
import 'package:contextual_logging/contextual_logging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraFaceDetectionViewFinder extends StatefulWidget {
  const CameraFaceDetectionViewFinder(
      {Key? key,
      this.resolutionPreset = ResolutionPreset.high,
      this.cameraLensDirection = CameraLensDirection.front,
      this.cameraFlashMode = FlashMode.auto,
      this.deviceOrientation = DeviceOrientation.portraitUp,
      this.autoCapture = true,
      required this.onFaceDetected,
      required this.onCapture,
      required this.viewFinderBuilder})
      : super(key: key);

  final ResolutionPreset resolutionPreset;
  final CameraLensDirection cameraLensDirection;
  final FlashMode cameraFlashMode;
  final DeviceOrientation deviceOrientation;
  final ValueChanged<DetectedFace?> onFaceDetected;
  final AsyncValueSetter<File?> onCapture;
  final bool autoCapture;
  final ViewFinderBuilder viewFinderBuilder;

  @override
  _CameraFaceDetectionViewFinderController createState() => _CameraFaceDetectionViewFinderController();
}

class _CameraFaceDetectionViewFinderController extends State<CameraFaceDetectionViewFinder>
    with WidgetsBindingObserver, TickerProviderStateMixin, ContextualLogger {
  CameraController? _controller;
  late final CameraFaceDetectionViewFinderState _cameraFaceDetectionViewFinderState;

  @override
  void initState() {
    super.initState();
    _cameraFaceDetectionViewFinderState = CameraFaceDetectionViewFinderState();
    _cameraFaceDetectionViewFinderState
      ..setFlashMode(widget.cameraFlashMode)
      ..setCurrentCameraLens(widget.cameraLensDirection)
      ..setDeviceOrientation(widget.deviceOrientation)
      ..setResolutionPreset(widget.resolutionPreset);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getAllAvailableCameraLens();
      await _initCamera();
    });
  }

  @override
  void dispose() {
    _cameraFaceDetectionViewFinderState.close();
    WidgetsBinding.instance.removeObserver(this);

    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      if (!cameraController.value.isStreamingImages) return;
      cameraController.stopImageStream();
    } else if (state == AppLifecycleState.resumed) {
      _startImageStream();
    }
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
      providers: [BlocProvider<CameraFaceDetectionViewFinderState>.value(value: _cameraFaceDetectionViewFinderState)],
      child: _CameraFaceDetectionViewFinderView(this));

  Future<void> _getAllAvailableCameraLens() async {
    try {
      final cameraLens = await availableCameras();
      _cameraFaceDetectionViewFinderState.setAllAvailableCameraLens(cameraLens);
    } catch (e) {
      log.e('_getAllAvailableCameraLens', error: e);
    }
  }

  Future<void> _initCamera() async {
    final cameraDescription = _cameraFaceDetectionViewFinderState.currentCameraDescription;
    final resolutionPreset = _cameraFaceDetectionViewFinderState.state.resolutionPreset;
    _controller = CameraController(cameraDescription, resolutionPreset,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888);

    await _initializeCameraController();
    await _changeFlashMode(_cameraFaceDetectionViewFinderState.state.flashMode);
    await _changeDeviceOrientation(_cameraFaceDetectionViewFinderState.state.deviceOrientation);
    await Future.delayed(const Duration(milliseconds: 1500));
    _startImageStream();
  }

  Future<void> _initializeCameraController() async {
    try {
      await _controller!.initialize();
      _cameraFaceDetectionViewFinderState.isInitialized(true);
    } catch (e) {
      log.e('_initializeCameraController', error: e);
    }
  }

  Future<void> _changeFlashMode(FlashMode flashMode) async {
    try {
      await _controller!.setFlashMode(flashMode);
      _cameraFaceDetectionViewFinderState.setFlashMode(flashMode);
    } catch (e) {
      log.e('_changeFlashMode', error: e);
    }
  }

  Future<void> _changeDeviceOrientation(DeviceOrientation deviceOrientation) async {
    try {
      await _controller!.lockCaptureOrientation(deviceOrientation);
      _cameraFaceDetectionViewFinderState.setDeviceOrientation(deviceOrientation);
    } catch (e) {
      log.e('_changeDeviceOrientation', error: e);
    }
  }

  void _startImageStream() {
    final CameraController? cameraController = _controller;
    if (cameraController != null && cameraController.value.isInitialized) {
      if(cameraController.value.isStreamingImages) return;
      if(cameraController.value.isRecordingVideo) return;
      cameraController.startImageStream(_processImage);
    }
  }

  void _processImage(CameraImage cameraImage) async {
    final CameraController? cameraController = _controller;
    final _alreadyCheckingImage = _cameraFaceDetectionViewFinderState.state.alreadyCheckingImage;

    if (!_alreadyCheckingImage && mounted) {
      _cameraFaceDetectionViewFinderState.isCheckingImage(true);
      try {
        await FaceIdentifier.scanImage(cameraImage: cameraImage, camera: cameraController!.description)
            .then((result) async {
          _cameraFaceDetectionViewFinderState.setDetectedFace(result);

          if (result != null) {
            try {
              if (result.wellPositioned) {
                widget.onFaceDetected(result);
                if (widget.autoCapture) {
                  _onTakePictureButtonPressed();
                }
              }
            } catch (e) {
              log.e('_processImage', error: e);
            }
          }
        });
        if (mounted) {
          _cameraFaceDetectionViewFinderState.isCheckingImage(false);
        }
      } catch (ex, stack) {
        log.e('_processImage', error: ex, stackTrace: stack);
      }
    }
  }

  Future<void> _onTakePictureButtonPressed() async {
    final CameraController? cameraController = _controller;
    try {
      await cameraController!.stopImageStream().whenComplete(() async {
        await Future.delayed(const Duration(milliseconds: 500));
        final file = await takePicture();
        if (file != null) {
          await widget.onCapture(File(file.path));
        }

        await Future.delayed(const Duration(seconds: 2));

        if (mounted && cameraController.value.isInitialized) {
          _startImageStream();
        }
      });
    } catch (e, s) {
      log.e('_onTakePictureButtonPressed', error: e, stackTrace: s);
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      log.e('Error: select a camera first.');
      if (!mounted) return null;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error: select a camera first'),
        backgroundColor: Colors.redAccent,
      ));
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.redAccent,
      ));
      return null;
    }
  }

  Widget _cameraDisplayWidget(bool isInitialized) {
    final CameraController? cameraController = _controller;
    if (cameraController != null && isInitialized) {
      return Transform.scale(
        scale: 1.0,
        child: AspectRatio(
          aspectRatio: 1 / cameraController.value.previewSize!.aspectRatio,
          child: CameraPreview(cameraController),
        ),
      );
    }
    return const SizedBox.expand();
  }
}

class _CameraFaceDetectionViewFinderView
    extends WidgetView<CameraFaceDetectionViewFinder, _CameraFaceDetectionViewFinderController> {
  const _CameraFaceDetectionViewFinderView(_CameraFaceDetectionViewFinderController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final CameraController? cameraController = state._controller;
    final isInitialized = context.select<CameraFaceDetectionViewFinderState, bool>((value) => value.state.initialized);
    return Stack(
      alignment: Alignment.center,
      children: [
        if (cameraController != null && isInitialized) ...[
          Transform.scale(
            scale: 1.0,
            child: AspectRatio(
              aspectRatio: size.aspectRatio,
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: SizedBox(
                    width: size.width,
                    height: size.width * cameraController.value.aspectRatio,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Builder(builder: (context) {
                          final isInitialized = context
                              .select<CameraFaceDetectionViewFinderState, bool>((value) => value.state.initialized);
                          return state._cameraDisplayWidget(isInitialized);
                        }),
                        SizedBox(
                          width: cameraController.value.previewSize!.width,
                          height: cameraController.value.previewSize!.height,
                          child: LayoutBuilder(builder: (context, constraints) {
                            return Builder(builder: (context) {
                              final detectedFace = context.select<CameraFaceDetectionViewFinderState, DetectedFace?>(
                                  (value) => value.state.detectedFace);
                              final imageSize = Size(
                                state._controller!.value.previewSize!.height,
                                state._controller!.value.previewSize!.width,
                              );

                              final scaleX = constraints.maxWidth / imageSize.width;
                              final scaleY = constraints.maxHeight / imageSize.height;

                              final scaledFaceBoundingBox = detectedFace != null && detectedFace.face != null
                                  ? RectUtils.scaledFaceBoundingBox(
                                      faceRect: detectedFace.face!.boundingBox,
                                      widgetSize: constraints.biggest,
                                      scaleX: scaleX,
                                      scaleY: scaleY)
                                  : null;

                              return widget.viewFinderBuilder(context, detectedFace, imageSize, scaledFaceBoundingBox,
                                  state._onTakePictureButtonPressed);
                            });
                          }),
                        ),
                        // if (_detectedFace != null) ...[
                        //   SizedBox(
                        //       width: cameraController.value.previewSize!.width,
                        //       height: cameraController.value.previewSize!.height,
                        //       child: widget.indicatorBuilder?.call(
                        //           context,
                        //           _detectedFace,
                        //           Size(
                        //             _controller!.value.previewSize!.height,
                        //             _controller!.value.previewSize!.width,
                        //           )) ??
                        //           CustomPaint(
                        //             painter: FacePainter(
                        //                 face: _detectedFace!.face,
                        //                 indicatorShape: widget.indicatorShape,
                        //                 indicatorAssetImage: widget.indicatorAssetImage,
                        //                 imageSize: Size(
                        //                   _controller!.value.previewSize!.height,
                        //                   _controller!.value.previewSize!.width,
                        //                 )),
                        //           ))
                        // ]
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ] else
          widget.viewFinderBuilder(context, null, size, null, state._onTakePictureButtonPressed)
        // widget.indicatorBuilder != null
        //     ? widget.indicatorBuilder!(context, _detectedFace, size)
        //     : Column(children: [
        //   const Text('No Camera Detected',
        //       style: TextStyle(
        //         fontSize: 18.0,
        //         fontWeight: FontWeight.w500,
        //       )),
        //   CustomPaint(
        //     size: size,
        //     painter: HolePainter(),
        //   )
        // ]),
      ],
    );
  }
}
