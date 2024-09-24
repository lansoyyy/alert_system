import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EvacuationTab extends StatefulWidget {
  const EvacuationTab({super.key});

  @override
  State<EvacuationTab> createState() => _EvacuationTabState();
}

class _EvacuationTabState extends State<EvacuationTab> {
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
          return GoogleMap(
            markers: {
              Marker(
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
          );
        });
  }
}
