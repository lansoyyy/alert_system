import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addNotif(name, desc, image) async {
  final docUser = FirebaseFirestore.instance.collection('Notifs').doc();

  final json = {
    'name': name,
    'desc': desc,
    'image': image,
    'id': docUser.id,
    'dateTime': DateTime.now(),
  };

  await docUser.set(json);
}
