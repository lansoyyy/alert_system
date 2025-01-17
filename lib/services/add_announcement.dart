import 'package:alert_system/services/add_notif.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addAnnouncement(name, desc, image) async {
  final docUser = FirebaseFirestore.instance.collection('Announcement').doc();

  final json = {
    'name': name,
    'desc': desc,
    'image': image,
    'id': docUser.id,
    'dateTime': DateTime.now(),
  };

  addNotif(name, desc, image);

  await docUser.set(json);
}
