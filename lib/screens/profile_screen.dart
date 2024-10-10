import 'package:alert_system/utils/colors.dart';
import 'package:alert_system/utils/const.dart';
import 'package:alert_system/widgets/text_widget.dart';
import 'package:alert_system/widgets/textfield_widget.dart';
import 'package:alert_system/widgets/toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import '../widgets/button_widget.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final number = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: primary,
        centerTitle: true,
        title: TextWidget(
          text: 'Profile',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('Loading'));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            dynamic data = snapshot.data;

            name.text = data['name'].toString();

            number.text = data['number'];
            email.text = data['email'];
            password.text = '*******';
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          uploadPicture('gallery');
                        },
                        child: CircleAvatar(
                          minRadius: 75,
                          maxRadius: 75,
                          backgroundImage: NetworkImage(data['profile']),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldWidget(
                      hasValidator: false,
                      hint: 'Enter fullname',
                      borderColor: Colors.grey,
                      label: 'Fullname',
                      controller: name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a email';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                      inputType: TextInputType.number,
                      hasValidator: false,
                      hint: 'Enter contact number',
                      borderColor: Colors.grey,
                      label: 'Contact Number',
                      controller: number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a email';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                      enabled: false,
                      hasValidator: false,
                      hint: 'Enter email',
                      borderColor: Colors.grey,
                      label: 'Email',
                      controller: email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a email';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        TextFieldWidget(
                          enabled: false,
                          hasValidator: false,
                          hint: 'Enter password',
                          showEye: true,
                          borderColor: Colors.grey,
                          label: 'Password',
                          isObscure: true,
                          controller: password,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ButtonWidget(
                        label: 'Update',
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(userId)
                              .update({
                            'number': number.text,
                            'name': name.text,
                          });

                          showToast('Profile updated!');
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }),
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

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update({
          'profile': imageURL,
        });

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
