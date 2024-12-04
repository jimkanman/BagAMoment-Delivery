import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jimkanman_delivery/config/AppColors.dart';
import 'package:jimkanman_delivery/config/config.dart';
import 'package:jimkanman_delivery/services/api_service.dart';
import 'package:jimkanman_delivery/services/websocket_service.dart';
import 'package:jimkanman_delivery/widgets/rectangle_elevated_button.dart';
import '../models/delivery_response.dart';
import '../services/location_service.dart';

class DeliveryScreen extends StatefulWidget {
  final DeliveryReservationDto deliveryReservation;

  const DeliveryScreen({required this.deliveryReservation});

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final StompService stompService = StompService();
  final ApiService apiService = ApiService();
  final LocationService locationService = LocationService();
  late GoogleMapController mapController;
  late Future<LatLng> _futureCurrentLocation;
  String destinationTime = "";
  DateTime? parsedDateTime;


  BitmapDescriptor? currentMarkerIcon;
  BitmapDescriptor? storageMarkerIcon;
  BitmapDescriptor? destinationMarkerIcon;

  bool deliveryStarted = false;
  final LatLng _defaultPosition = LatLng(
      37.5047267237807, 126.953833907628); // 중앙대 위치
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    connectToStomp(); // 웹소켓 handshake
    try {
      parsedDateTime =
          DateTime.parse(widget.deliveryReservation.deliveryArrivalDateTime!);
      destinationTime = DateFormat('HH:mm').format( // 도착 시간 파싱
          parsedDateTime!
      );
    } catch (e) {}
    ;
    _futureCurrentLocation = initializeLocation(); // 현재 위치 + 카메라 갱신
    _loadCustomMarkers();
  }

  Future<LatLng> initializeLocation() async {
    try {
      // 현재 위치 가져오기
      final position = await locationService.getCurrentPosition();
      currentLocation = LatLng(position.latitude, position.longitude);
      print("initializeLocation: fetched location ${position.latitude}, ${position.longitude}");
      return currentLocation!;
      // 카메라 위치 갱신
      if (widget.deliveryReservation.destinationLatitude != null && widget.deliveryReservation.destinationLongitude != null) {
        moveCameraTo(LatLng(widget.deliveryReservation.destinationLatitude!, widget.deliveryReservation.destinationLongitude!));
      }
    } catch (e) {
      print(e);
      return _defaultPosition;
    }
  }

  /// 마커 이미지 로드
  Future<void> _loadCustomMarkers() async {
    storageMarkerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/box_icon.png',
    );

    destinationMarkerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/box_icon_red.png',
    );

    setState(() {});
  }

  void moveCameraTo(LatLng position) {
    if (mapController != null) {
      mapController.animateCamera(
          CameraUpdate.newLatLng(position)
      );
    }
  }

  void connectToStomp() {
    stompService.connect();
  }

  void startDelivery() async {
    setState(() {
      deliveryStarted = true;
    });

    // 채널 구독
    stompService.subscribe('/topic/delivery/${widget.deliveryReservation.id}', (message) {
      print('Received: $message');
    });

    // 카메라를 currentLocation으로 이동 // 추가된 코드
    if (currentLocation != null) {
      moveCameraTo(currentLocation!); // 카메라를 현재 위치로 이동
    }

    // 5초마다 반복
    while (deliveryStarted) {
      try {
        final position = await locationService.getCurrentPosition();
        // 위치 갱신
        setState(() {
          currentLocation = LatLng(position.latitude, position.longitude);
          moveCameraTo(currentLocation!);
        });

        // 서버 전송
        stompService.send('/app/delivery/location', {
          'deliveryId': widget.deliveryReservation.id,
          'latitude': position.latitude,
          'longitude': position.longitude,
        });
      } catch (e) {
        print('Error sending location: $e');
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  void completeDelivery() {
    setState(() {
      deliveryStarted = false;
    });
    // Navigator.pushReplacementNamed(context, '/delivery-complete', arguments: widget.delivery);
    // TODO API 요청
    stompService.disconnect();

    Navigator.pop(context);
  }

  void cancelDelivery() {
    // TODO
    setState(() {
      deliveryStarted = false;
    });
    Navigator.pop(context);
  }

  /// 팝업 창을 띄워 Action 확인
  Future<void> confirmAction({
    required String title,
    required Widget content,
    required VoidCallback onConfirm,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: content,
          // 테두리 둥글게 처리
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          actionsPadding: const EdgeInsets.all(8.0),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      onConfirm();
    }
  }

  @override
  void dispose() {
    stompService.disconnect();
    super.dispose();
  }

  Widget TimeLeftInText({TextStyle? style}) {
    var minutes = parsedDateTime!.difference(DateTime.now()).inMinutes;
    String time = '';
    int day = 0;
    int hours = 0;
    while (minutes > 1440) {
      day++;
      minutes -= 1440;
    }
    while (minutes > 60) {
     hours++;
     minutes -= 60;
    }
    if(day > 0) time += "$day 일 ";
    if(minutes > 0) time += "$hours 시간 ";
    time += "$minutes 분";

    return Text(
      '($time 남음)',
      style: style,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16,),
            Expanded(
              child: FutureBuilder<LatLng>(
                future: _futureCurrentLocation,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error fetching location: ${snapshot.error}"),);
                  } else if (snapshot.hasData) {
                    return GoogleMap(
                      onMapCreated: (controller) => mapController = controller,
                      initialCameraPosition: CameraPosition(
                        target: currentLocation ?? _defaultPosition,
                        zoom: 14.0,
                      ),
                      markers: {
                        if (currentLocation != null)
                          Marker(
                            markerId: const MarkerId('current_location'),
                            position: currentLocation!,
                            icon: currentMarkerIcon ?? BitmapDescriptor
                                .defaultMarker, // Use custom marker
                          ),
                        if(widget.deliveryReservation.storageLatitude != null &&
                            widget.deliveryReservation.storageLongitude != null)
                          Marker(
                            markerId: const MarkerId('storage_location'),
                            position: LatLng(
                                widget.deliveryReservation.storageLatitude!,
                                widget.deliveryReservation.storageLongitude!),
                            icon: storageMarkerIcon ?? BitmapDescriptor
                                .defaultMarker, // Use custom marker
                          ),
                        if(widget.deliveryReservation.destinationLatitude !=
                            null && widget.deliveryReservation
                            .destinationLongitude != null)
                          Marker(
                            markerId: const MarkerId('destination_location'),
                            position: LatLng(
                                widget.deliveryReservation.destinationLatitude!,
                                widget.deliveryReservation
                                    .destinationLongitude!),
                            icon: destinationMarkerIcon ?? BitmapDescriptor
                                .defaultMarker, // Use custom marker
                          ),
                      },
                    );
                  } else {
                    return const Center(child: Text("Failed to load map"),);
                  }
                }
              ),
            ),

            const SizedBox(height: 16,),

            // 하단 위젯 (배송 정보, 수락 및 취소 버튼 등)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Column(
                children: [
                  Center(
                    child: !deliveryStarted
                        ? const Text("픽업 대기 중", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),)
                        : const Text("배송 중", style: TextStyle(fontSize: 24,  fontWeight: FontWeight.w300)),
                  ),
                  const SizedBox(height: 16,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("출발지 ", style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
                      Expanded(
                        child: Text(widget.deliveryReservation.storageAddress ?? '출발지 주소',
                          style: TextStyle(fontSize:  deliveryStarted ? 12 : 14),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("배송지 ", style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
                      Expanded(
                        child: Text(widget.deliveryReservation.destinationAddress ?? '배송지 주소',
                          style: TextStyle(fontSize:  deliveryStarted ? 14 : 12,),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Text(" (총 ${locationService.convertMToKM(widget.deliveryReservation.distance, 1)} km)", style: const TextStyle(fontSize: 8),)
                    ],
                  ),
                  const SizedBox(height: 4.0,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("도착시간 ", style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
                      Expanded(child: Text(destinationTime, textAlign: TextAlign.right,)),
                      const SizedBox(width: 4,),
                      TimeLeftInText(style: const TextStyle(fontSize: 8)),
                    ],
                  ),

                  const SizedBox(height: 16,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RectangularElevatedButton(
                          backgroundColor: AppColors.primaryDark,
                          borderRadius: 5,
                          onPressed: () => confirmAction(
                            title: deliveryStarted ? '배송 완료' : '배송 시작',
                            content: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 50,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(deliveryStarted ? '배송을 완료할까요?' : '배송을 시작할까요?')
                                ],
                              ),
                            ),
                            onConfirm: deliveryStarted ? completeDelivery : startDelivery
                          ),
                          child: Text(deliveryStarted ? '배송 완료' : '배송 시작', style: const TextStyle(fontSize: 13, color: AppColors.textLight),),
                        ),
                      ),

                      const SizedBox(width: 8.0),

                      Expanded(
                        child: RectangularElevatedButton(
                          borderRadius: 5,
                          backgroundColor: AppColors.secondaryLight,
                          textColor: AppColors.textDark,
                          onPressed: () => confirmAction(
                            title: '배송 취소',
                            content: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 50,
                              child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8,),
                                    Text("배송을 취소할까요?")
                                  ],
                                ),
                            ),
                            onConfirm: cancelDelivery
                          ),
                          child: const Text('배송 취소', style: TextStyle(fontSize: 13),),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

