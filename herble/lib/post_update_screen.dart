import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:herble/plant_page.dart';
import 'globals.dart' as globals;
import 'package:connectivity/connectivity.dart';

class PostUpdate extends StatefulWidget {
  final globals.Plant plant;
  final int days;
  final int volume;
  final Uint8List picture;
  PostUpdate({
    super.key,
    required this.plant,
    required this.days,
    required this.volume,
    required this.picture,
  });

  @override
  State<PostUpdate> createState() => _ConnectInternetState();
}

class _ConnectInternetState extends State<PostUpdate> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Column(
        children: [
          const Text("Reconect to the internet to finish"),
          isLoading
              ? const CircularProgressIndicator()
              : TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (await hasInternet()) {
                      await updatePlant(
                        widget.plant.plantName,
                        widget.plant.plantDescription,
                        widget.days,
                        widget.picture.toString(),
                        widget.volume,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PlantListScreen()),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text(
                                'The device must be connected to the internet'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'sorry'),
                                child: const Text('sorry'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: const Text("Continue")),
        ],
      ),
    );
  }

  Future<void> updatePlant(
      String name, String desc, int days, String pic, int volume) async {
    String url = 'https://herbledb.000webhostapp.com/update_plant.php';
    await http.post(Uri.parse(url), body: {
      'id': widget.plant.plantId.toString(),
      'plant_name': name,
      'plant_description': desc,
      'day_count': days.toString(),
      'picture': pic,
      'water_volume': volume.toString(),
    });
  }

  Future<bool> hasInternet() async {
    try {
      final response = await Future.any([
        http.get(
            Uri.parse("https://herbledb.000webhostapp.com/post_plant.php")),
        Future.delayed(const Duration(seconds: 3), () => null),
      ]);
      if (response == null) {
        throw Exception("Request timed out");
      }
      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {
      return false;
    }
    return false;
  }
}