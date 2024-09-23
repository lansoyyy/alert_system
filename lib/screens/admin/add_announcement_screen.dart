import 'package:alert_system/services/add_announcement.dart';
import 'package:alert_system/utils/colors.dart';
import 'package:alert_system/widgets/button_widget.dart';
import 'package:alert_system/widgets/text_widget.dart';
import 'package:alert_system/widgets/toast_widget.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class AddAnnouncementScreen extends StatefulWidget {
  const AddAnnouncementScreen({super.key});

  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final name = TextEditingController();

  final desc = TextEditingController();

  final cooktime = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: primary,
        title: TextWidget(
          text: 'Announcement',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40.0),
              imageURL == ''
                  ? const Center(
                      child: Icon(
                        Icons.image,
                        size: 120.0,
                        color: Colors.grey,
                      ),
                    )
                  : SizedBox(
                      width: 300,
                      height: 300,
                      child: Image.network(imageURL),
                    ),
              const SizedBox(height: 20.0),
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Announcement Title',
                  labelStyle: TextStyle(color: Colors.orange),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: desc,
                decoration: const InputDecoration(
                  labelText: 'Announcement Description',
                ),
              ),
              const SizedBox(height: 30.0),
              ButtonWidget(
                radius: 5,
                label: 'Select Image',
                onPressed: () {
                  uploadPicture('gallery');
                },
              ),
              const SizedBox(height: 20.0),
              imageURL != ''
                  ? ButtonWidget(
                      radius: 5,
                      label: 'Save Announcement',
                      onPressed: () {
                        addAnnouncement(name.text, desc.text, imageURL);
                        Navigator.pop(context);
                        showToast('Announcement added succesfully!');
                      },
                    )
                  : const SizedBox(),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  late String fileName = '';

  late File imageFile;

  late String imageURL = '';

  Future<void> uploadPicture(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;
    try {
      pickedImage = (await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920))!;

      fileName = path.basename(pickedImage.path);
      imageFile = File(pickedImage.path);

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: AlertDialog(
                title: Row(
              children: [
                CircularProgressIndicator(
                  color: Colors.black,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Loading . . .',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QRegular'),
                ),
              ],
            )),
          ),
        );

        await firebase_storage.FirebaseStorage.instance
            .ref('Pictures/$fileName')
            .putFile(imageFile);
        imageURL = await firebase_storage.FirebaseStorage.instance
            .ref('Pictures/$fileName')
            .getDownloadURL();

        setState(() {});

        Navigator.of(context).pop();
        showToast('Image uploaded!');
      } on firebase_storage.FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }
}
