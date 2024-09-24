import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdminEvacuationTab extends StatefulWidget {
  const AdminEvacuationTab({super.key});

  @override
  State<AdminEvacuationTab> createState() => _AdminEvacuationTabState();
}

class _AdminEvacuationTabState extends State<AdminEvacuationTab> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Map')
            .doc('evac')
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

          print(data['lat']);
          return SizedBox(
            width: 500,
            height: 500,
            child: GoogleMap(
              onTap: (argument) {
                print('123');
              },
              markers: {
                Marker(
                  draggable: true,
                  onDragEnd: (value) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text(
                                'Location Confirmation',
                                style: TextStyle(
                                    fontFamily: 'QBold',
                                    fontWeight: FontWeight.bold),
                              ),
                              content: const Text(
                                'Are you sure you want to mark this location as evacuation center?',
                                style: TextStyle(fontFamily: 'QRegular'),
                              ),
                              actions: <Widget>[
                                MaterialButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text(
                                    'Close',
                                    style: TextStyle(
                                        fontFamily: 'QRegular',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('Map')
                                        .doc('evac')
                                        .update({
                                      'lat': value.latitude,
                                      'long': value.longitude,
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Continue',
                                    style: TextStyle(
                                        fontFamily: 'QRegular',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ));
                  },
                  infoWindow: const InfoWindow(title: 'Evacuation Center'),
                  position: LatLng(data['lat'], data['long']),
                  markerId: const MarkerId('Marker'),
                ),
              },
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(data['lat'], data['long']),
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          );
        });
  }
}
