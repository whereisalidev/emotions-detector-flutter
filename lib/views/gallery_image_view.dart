import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class GalleryImageView extends StatefulWidget {
  const GalleryImageView({super.key});

  @override
  State<GalleryImageView> createState() => _GalleryImageViewState();
}

class _GalleryImageViewState extends State<GalleryImageView> {
  late ImagePicker picker;
  dynamic faceDetector;
  File? img;
  dynamic image;
  late List<Face> faces;
  String result = '';
  int resultcount = 0;

  @override
  void initState() {
    super.initState();
    picker = ImagePicker();
    final options = FaceDetectorOptions(
      enableClassification: true,
      enableContours: true,
      enableLandmarks: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.fast,
    );
    faceDetector = FaceDetector(options: options);
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool firstTime = false;
  imgFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      img = File(image.path);
      Timer(const Duration(seconds: 2), () {

      });
      doFaceDetection();
    }
    
    firstTime = true;
  }

  doFaceDetection() async {
    InputImage inputImage = InputImage.fromFile(img!);
    faces = await faceDetector.processImage(inputImage);
    result = '';

    for (Face f in faces) {
      if(f.smilingProbability! < 0.02){
        result += 'Sad-';
        print('Labelllllllllllllllllllllllllllll = ${f.smilingProbability}');
      }
      else if(f.smilingProbability! >= 0.02 && f.smilingProbability! < 0.15){
        result += 'Neutral-';
        print('Labelllllllllllllllllllllllllllll = ${f.smilingProbability}');
      }
      else if(f.smilingProbability! >= 0.15 && f.smilingProbability! < 0.2){
        result += 'Serious-';
        print('Labelllllllllllllllllllllllllllll = ${f.smilingProbability}');
      }
      else if(f.smilingProbability! >= 0.2 && f.smilingProbability! < 0.8){
        result += 'Smiling-';
        print('Labelllllllllllllllllllllllllllll = ${f.smilingProbability}');
      }
      else if (f.smilingProbability! >= 0.8) {
        result += 'Happy-';
        print('Labelllllllllllllllllllllllllllll = ${f.smilingProbability}');
      }
      else {
        result += "can't detect!";
        print('Labelllllllllllllllllllllllllllll = ${f.smilingProbability}');
      }
      resultcount++;

    }
    setState(() {
      img;
      result;
      resultcount;
    });
    drawRectangelAroundFaces();
  }

  drawRectangelAroundFaces() async {
    List<int> bytes = await img!.readAsBytes();
    image = await decodeImageFromList(Uint8List.fromList(bytes));
    setState(() {
      image;
      result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            children: [
              InkWell(
                onTap: ()=> Navigator.pop(context),
                  child: const Icon(Icons.arrow_back)
              ),
              const SizedBox(width: 20,),
              const Text('Choose Image'),
            ],
          ),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              Stack(
                children: [
                  Container(
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: imgFromGallery,
                        child: Container(
                          width: 335,
                          height: 450,
                          margin: const EdgeInsets.only(top: 30),
                          child: image == null ?
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 340,
                            height: 330,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 100,
                                ),
                                Text('Open gallery')
                              ],
                            ),
                          ) :
                          Center(
                            child: FittedBox(
                              child: SizedBox(
                                width: image.width.toDouble(),
                                height: image.height.toDouble(),
                                child: CustomPaint(
                                  painter: FacePainter(
                                    faceList: faces,
                                    imageFile: image,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.9,
                margin: const EdgeInsets.only(top: 30),
                decoration: result.isEmpty && firstTime == true?
                BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8)
                ) :
                const BoxDecoration(),
                child: Center(
                  child: Text(
                    result.isEmpty && firstTime == true? 'No face Detected' :
                    result,
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  List<Face> faceList;
  dynamic imageFile;
  FacePainter({required this.faceList, required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    //For drawing the Rectangle in Faces
    Paint p = Paint();
    p.color = Colors.green;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 10;
    for (Face face in faceList) {
      canvas.drawRect(face.boundingBox, p);
    }

    //For Drawing the point in face contours like eye, mouth etc...
    Paint p2 = Paint();
    p2.color = Colors.green;
    p2.style = PaintingStyle.stroke;
    p2.strokeWidth = 6;
    for (Face face in faceList) {
      Map<FaceContourType, FaceContour?> con = face.contours;
      List<Offset> offsetPoints = <Offset>[];
      con.forEach((key, value) {
        if (value != null) {
          List<Point<int>>? points = value.points;
          for (Point p in points) {
            Offset offset = Offset(p.x.toDouble(), p.y.toDouble());
            offsetPoints.add(offset);
          }
          canvas.drawPoints(PointMode.points, offsetPoints, p2);
        }
      });

      //For Drawing the Rectangle on the left ear.
      Paint p3 = Paint();
      p3.color = Colors.yellow;
      p3.style = PaintingStyle.stroke;
      p3.strokeWidth = 6;
      final FaceLandmark leftEar = face.landmarks[FaceLandmarkType.leftEar]!;
      final Point<int> leftEarPos = leftEar.position;
      canvas.drawRect(
          Rect.fromLTWH(
              leftEarPos.x.toDouble() - 5, leftEarPos.y.toDouble() - 5, 30, 30),
          p3);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}