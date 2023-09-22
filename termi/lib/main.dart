import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:termi/camera_preview.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('The user did not grant the camera permission!');
            break;
          default:
            print('Something went wrong with the camera!');
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // a body with a camera preview and a button to take a picture
        body: Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _controller.value.isInitialized
              ? CameraPreview(_controller)
              : const Center(child: CircularProgressIndicator()),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () async {
                    if (!_controller.value.isInitialized) {
                      return null;
                    }

                    if (_controller.value.isTakingPicture) {
                      return null;
                    }

                    try {
                      await _controller.setFlashMode(FlashMode.auto);

                      XFile picture = await _controller.takePicture();

                      //send picture to camera_preview
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PicturePreview(
                            picture: picture,
                          ),
                        ),
                      );
                    } on CameraException catch (e) {
                      print(e);
                      return null;
                    }
                  },
                  icon: const Icon(Icons.camera),
                ),
              ],
            ),
          ),
        ),
      ],
    )

        /*body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: _controller.value.isInitialized
          ? CameraPreview(_controller)
          : const Center(child: CircularProgressIndicator()),
    ) */
        );
  }
}
