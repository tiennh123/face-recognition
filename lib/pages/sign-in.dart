// A screen that allows users to take a picture using a given camera.
import 'dart:async';
import 'dart:io';
import 'package:face_net_authentication/pages/models/face.model.dart';
import 'package:face_net_authentication/pages/models/user.model.dart';
import 'package:face_net_authentication/pages/profile.dart';
import 'package:face_net_authentication/pages/widgets/FacePainter.dart';
import 'package:face_net_authentication/pages/widgets/camera_header.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/couch_base_service.dart';
import 'package:face_net_authentication/services/facenet.service.dart';
import 'package:face_net_authentication/services/ml_vision_service.dart';
import 'package:camera/camera.dart';
import 'package:face_net_authentication/utils/constant.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:logger/logger.dart' as log;

class SignIn extends StatefulWidget {
  final CameraDescription cameraDescription;

  const SignIn({
    Key key,
    @required this.cameraDescription,
  }) : super(key: key);

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  /// Service injection
  CameraService _cameraService = CameraService();
  MLVisionService _mlVisionService = MLVisionService();
  FaceNetService _faceNetService = FaceNetService();

  Future _initializeControllerFuture;

  bool cameraInitializated = false;
  bool _detectingFaces = false;
  bool pictureTaked = false;

  // switchs when the user press the camera
  bool _saving = false;
  int _currentStep = StepLiveness.stepHeadLeft;
  bool isShot = false;

  User predictedUser;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String imagePath;
  Size imageSize;
  Face faceDetected;

  FaceModel _faceModel;

  @override
  void initState() {
    super.initState();

    /// starts the camera & start framing faces
    _start();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraService.dispose();
    super.dispose();
  }

  /// starts the camera & start framing faces
  _start() async {
    _initializeControllerFuture =
        _cameraService.startService(widget.cameraDescription);
    await _initializeControllerFuture;

    setState(() {
      cameraInitializated = true;
    });

    _faceNetService.deviceInfoListener((FaceModel faceModel) {
      setState(() {
        _faceModel = faceModel;   
      });   
    });

    _frameFaces();
  }

  /// draws rectangles when detects faces
  _frameFaces() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        // if its currently busy, avoids overprocessing
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          List<Face> faces = await _mlVisionService.getFacesFromImage(image);

          if (faces != null) {
            if (faces.length > 0) {
              // preprocessing the image
              setState(() {
                faceDetected = faces[0];
              });

              Map<String, dynamic> dataFace = {
                "boundingBox": {
                  "top": faceDetected.boundingBox.top,
                  "right": faceDetected.boundingBox.right,
                  "bottom": faceDetected.boundingBox.bottom,
                  "left": faceDetected.boundingBox.left,
                  "width": faceDetected.boundingBox.width,
                  "height": faceDetected.boundingBox.height
                },
                "headEulerAngleY": faceDetected.headEulerAngleY,
                "headEulerAngleZ": faceDetected.headEulerAngleZ,
                "leftEyeOpenProbability": faceDetected.leftEyeOpenProbability,
                "rightEyeOpenProbability": faceDetected.rightEyeOpenProbability,
                "smilingProbability": faceDetected.smilingProbability,
              };
              log.Logger().v({'[SignIn] frameFaces': dataFace});

              if (_saving) {
                _saving = false;
                _faceNetService.setCurrentPrediction(image, faceDetected);
              }
            } else {
              setState(() {
                faceDetected = null;
              });
            }
          }

          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }

      if (faceDetected != null && _currentStep != StepLiveness.stepTakePicture) {
        if (_currentStep == StepLiveness.stepHeadLeft && faceDetected.headEulerAngleY > 30) {
          _updateValidStep(StepLiveness.stepHeadRight);
        }
        if (_currentStep == StepLiveness.stepHeadRight && faceDetected.headEulerAngleY < -30) {
          _updateValidStep(StepLiveness.stepBlink);
        }
        if (_currentStep == StepLiveness.stepBlink && (faceDetected.leftEyeOpenProbability < 0.4 || faceDetected.rightEyeOpenProbability < 0.4)) {
          _updateValidStep(StepLiveness.stepSmile);
        }
        if (_currentStep == StepLiveness.stepSmile && faceDetected.smilingProbability > 0.4 && !isShot) {
          setState(() {
            isShot = true;
          });
          await onShot();
        }
      }
    });
  }

  String _predictUser() {
    // String userAndPass = _faceNetService.predict();
    String userAndPass = _faceNetService.predictCouchbase(_faceModel);
    return userAndPass ?? null;
  }

  /// handles the button pressed event
  Future<void> onShot() async {
    if (faceDetected == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('No face detected!'),
          );
        },
      );
    } else {
      _saving = true;

      await Future.delayed(Duration(milliseconds: 500));
      if(_cameraService.cameraController != null && _cameraService.cameraController.value.isStreamingImages) {
        await _cameraService.cameraController.stopImageStream();
      }
      await Future.delayed(Duration(milliseconds: 500));
      XFile file = await _cameraService.takePicture();

      setState(() {
        pictureTaked = true;
        imagePath = file.path;
      });

      var userAndPass = _predictUser();
      if (userAndPass != null) {
        this.predictedUser = User.fromDB(userAndPass);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Profile(
                    this.predictedUser.user,
                    imagePath: _cameraService.imagePath,
                  )));
      } else {
        PersistentBottomSheetController bottomSheetController = scaffoldKey.currentState.showBottomSheet((context) => signSheet(context));
        bottomSheetController.closed.whenComplete(() => _reload());
      }
    }
  }

  _reload() {
    setState(() {
      cameraInitializated = false;
      pictureTaked = false;
      isShot = false;
      _currentStep = StepLiveness.stepHeadLeft;
    });
    this._start();
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  _updateValidStep(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (pictureTaked) {
                    return Container(
                      width: width,
                      height: height,
                      child: Transform(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.file(File(imagePath)),
                          ),
                          transform: Matrix4.rotationY(mirror)),
                    );
                  } else {
                    return Transform.scale(
                      scale: 1.0,
                      child: AspectRatio(
                        aspectRatio: MediaQuery.of(context).size.aspectRatio,
                        child: OverflowBox(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Container(
                              width: width,
                              height: width *
                                  _cameraService
                                      .cameraController.value.aspectRatio,
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  CameraPreview(
                                      _cameraService.cameraController),
                                  CustomPaint(
                                    painter: FacePainter(
                                        face: faceDetected,
                                        imageSize: imageSize),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          CameraHeader(
            "LOGIN",
            _currentStep,
            onBackPressed: _onBackPressed,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  signSheet(context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          predictedUser == null
              ? Container(
                      child: Text(
                      'User not found 😞',
                      style: TextStyle(fontSize: 20),
                    ))
                  : Container(),
        ],
      ),
    );
  }
}
