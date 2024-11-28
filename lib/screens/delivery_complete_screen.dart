import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/delivery_response.dart';

class CompleteDeliveryScreen extends StatelessWidget {
  final DeliveryDto delivery;

  CompleteDeliveryScreen({required this.delivery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delivery Completed')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(delivery.latitude!, delivery.longitude!),
              zoom: 14.0,
            ),
            markers: {
              Marker(markerId: MarkerId('current'), position: LatLng(delivery.latitude!, delivery.longitude!)),
              Marker(markerId: MarkerId('destination'), position: LatLng(delivery.latitude!, delivery.longitude!)),
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
              child: Text('Back to Main'),
            ),
          ),
        ],
      ),
    );
  }
}
