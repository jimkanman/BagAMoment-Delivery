import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jimkanman_delivery/config/config.dart';
import 'package:jimkanman_delivery/services/websocket_service.dart';
import '../models/delivery_response.dart';
import '../services/location_service.dart';

class DeliveryScreen extends StatefulWidget {
  final DeliveryDto delivery;

  DeliveryScreen({required this.delivery});

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final StompService stompService = StompService();
  final LocationService locationService = LocationService();
  late GoogleMapController mapController;

  bool deliveryStarted = false;
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    connectToStomp();
  }

  void connectToStomp() {
    stompService.connect(websocketUrl);
  }

  void startDelivery() async {
    setState(() {
      deliveryStarted = true;
    });

    // 채널 구독
    stompService.subscribe('/topic/delivery/${widget.delivery.id}', (message) {
      print('Received: $message');
    });

    // 위치 갱신 및 서버 전송
    while (deliveryStarted) {
      try {
        final position = await locationService.getCurrentPosition();
        setState(() {
          currentLocation = LatLng(position.latitude, position.longitude);
        });
        stompService.send('/app/delivery/location', {
          'deliveryId': widget.delivery.id,
          'latitude': position.latitude,
          'longitude': position.longitude,
        });
      } catch (e) {
        print('Error sending location: $e');
      }
      await Future.delayed(Duration(seconds: 5));
    }
  }

  void completeDelivery() {
    setState(() {
      deliveryStarted = false;
    });
    Navigator.pushReplacementNamed(context, '/delivery-complete', arguments: widget.delivery);
  }

  @override
  void dispose() {
    stompService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delivery #${widget.delivery.id}')),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => mapController = controller,
            initialCameraPosition: CameraPosition(
              target: currentLocation ?? LatLng(widget.delivery.latitude!, widget.delivery.longitude!),
              zoom: 14.0,
            ),
            markers: {
              if (currentLocation != null)
                Marker(markerId: MarkerId('current'), position: currentLocation!),
              Marker(markerId: MarkerId('destination'), position: LatLng(widget.delivery.latitude!, widget.delivery.longitude!)),
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel Delivery'),
                ),
                ElevatedButton(
                  onPressed: deliveryStarted ? completeDelivery : startDelivery,
                  child: Text(deliveryStarted ? 'Complete Delivery' : 'Start Delivery'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
