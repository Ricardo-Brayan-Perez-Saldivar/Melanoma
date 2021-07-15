import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_demo/main.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraImage cameraImage;
  late CameraController cameraController;

  bool isworking = false;
  String result = '';

  initCamera() {
    cameraController = CameraController(camera[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) {
          if (!isworking) {
            isworking = true;
            cameraImage = imageFromStream;
            runModelOnFrame();
          }
        });
      });
    });
  }

  runModelOnFrame() async {
    if (cameraImage != null) {
      var recognitions = await Tflite.runModelOnFrame(
          bytesList: cameraImage.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage.height,
          imageWidth: cameraImage.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 1,
          threshold: 0.1,
          asynch: true);
      result = "";
      recognitions?.forEach((response) {
        result += response["label"] + "\n";
      });
      setState(() {});
      isworking = false;
    }
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
  }

  @override
  void initState() {
    //TODO implement setState
    super.initState();
    initCamera();
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: result.isEmpty
                ? Text('Enfoque el melanoma')
                : Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Text(
                      result,
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
            centerTitle: true,
          ),
          body: Container(
              child: (!cameraController.value.isInitialized)
                  ? Container()
                  : Align(
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: cameraController.value.aspectRatio,
                        child: CameraPreview(cameraController),
                      ),
                    )),
          backgroundColor: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
