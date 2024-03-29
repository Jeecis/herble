import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:herble/add_plant.dart';
import 'globals.dart' as globals;
import 'package:herble/camera.dart';
import 'package:herble/update_plant_basics.dart';
import 'package:image_picker/image_picker.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }
  runApp(const PicturePage(
    pic: null,
    cum: 0,
  ));
}

class PicturePage extends StatefulWidget {
  final Uint8List? pic;
  final int cum;

  const PicturePage({Key? key, required this.pic, required this.cum})
      : super(key: key);

  @override
  State<PicturePage> createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  late Uint8List pic;

  @override
  void initState() {
    super.initState();
    loadImageFromAssets('assets/default_plant-1.jpg').then((value) {
      setState(() {
        pic = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change picture"),
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            if (widget.cum == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPlantPage(pic: pic)),
              );
            } else if (widget.cum == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdatePlantBasics(
                          pic: widget.pic!,
                          plant: globals.currentPlant,
                        )),
              );
            }
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: PicForm(pic: widget.pic, cum: widget.cum),
    );
  }

  Future<Uint8List> loadImageFromAssets(String url) async {
    final byteData = await rootBundle.load(url);
    return byteData.buffer.asUint8List();
  }
}

class PicForm extends StatefulWidget {
  final Uint8List? pic;
  final int cum;

  const PicForm({Key? key, required this.pic, required this.cum})
      : super(key: key);

  @override
  State<PicForm> createState() => _PicFormState();
}

class _PicFormState extends State<PicForm> {
  late Uint8List? currentPicture;
  int? picId;

  @override
  void initState() {
    super.initState();
    if (widget.pic != null) {
      currentPicture = widget.pic!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 3,
            ),
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: currentPicture == null
                  ? const FittedBox(
                      fit: BoxFit.cover,
                      child: Image(
                        image: AssetImage('assets/default_plant-1.jpg'),
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    )
                  : FittedBox(
                      fit: BoxFit.cover,
                      child: Image.memory(
                        currentPicture!,
                        width: 150,
                        height: 150,
                      ),
                    )),
        ),
        Column(
          children: [
            const Text("Choose from default pictures"),
            Row(children: [
              GestureDetector(
                onTap: () async {
                  Uint8List newPicture =
                      await loadImageFromAssets('assets/default_plant0.jpg');
                  setState(() {
                    currentPicture = newPicture;
                  });
                  picId = 0;
                },
                child: Image.asset(
                  'assets/default_plant0.jpg',
                  width: 100,
                  height: 100,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Uint8List newPicture =
                      await loadImageFromAssets('assets/default_plant1.jpg');
                  setState(() {
                    currentPicture = newPicture;
                  });
                  picId = 1;
                },
                child: Image.asset(
                  'assets/default_plant1.jpg',
                  width: 100,
                  height: 100,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Uint8List newPicture =
                      await loadImageFromAssets('assets/default_plant2.jpg');
                  setState(() {
                    currentPicture = newPicture;
                  });
                  picId = 2;
                },
                child: Image.asset(
                  'assets/default_plant2.jpg',
                  width: 100,
                  height: 100,
                ),
              ),
            ]),
            Row(children: [
              GestureDetector(
                onTap: () async {
                  Uint8List newPicture =
                      await loadImageFromAssets('assets/default_plant3.jpg');
                  setState(() {
                    currentPicture = newPicture;
                  });
                  picId = 3;
                },
                child: Image.asset(
                  'assets/default_plant3.jpg',
                  width: 100,
                  height: 100,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Uint8List newPicture =
                      await loadImageFromAssets('assets/default_plant4.jpg');
                  setState(() {
                    currentPicture = newPicture;
                  });
                  picId = 4;
                },
                child: Image.asset(
                  'assets/default_plant4.jpg',
                  width: 100,
                  height: 100,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Uint8List newPicture =
                      await loadImageFromAssets('assets/default_plant5.jpg');
                  setState(() {
                    currentPicture = newPicture;
                  });
                  picId = 5;
                },
                child: Image.asset(
                  'assets/default_plant5.jpg',
                  width: 100,
                  height: 100,
                ),
              ),
            ]),
          ],
        ),
        TextButton(
            onPressed: _useGalery, child: const Text("Choose from gallery")),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CameraScreen(cum: widget.cum)),
            );
            picId = null;
          },
          child: const Text("Open camera"),
        ),
        TextButton(
          onPressed: () {
            if (widget.cum == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddPlantPage(
                          pic: currentPicture!,
                          picId: picId,
                        )),
              );
            } else if (widget.cum == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdatePlantBasics(
                          pic: currentPicture!,
                          plant: globals.currentPlant,
                          picId: picId,
                        )),
              );
            }
          },
          child: const Text("Save image"),
        ),
      ],
    );
  }

  Future<Uint8List> loadImageFromAssets(String url) async {
    final byteData = await rootBundle.load(url);
    return byteData.buffer.asUint8List();
  }

  Future<void> _useGalery() async {
    var imagePicker = ImagePicker();
    picId = null;
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    Uint8List bytes = await image!.readAsBytes();
    setState(() {
      currentPicture = bytes;
    });
  }
}
