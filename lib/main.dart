import 'package:flutter/material.dart';
import 'package:jimkanman_delivery/config/AppColors.dart';
import 'package:jimkanman_delivery/models/delivery_response.dart';
import 'package:jimkanman_delivery/models/luggage_dto.dart';
import 'package:jimkanman_delivery/screens/delivery_screen.dart';
import 'package:jimkanman_delivery/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryDark,
          secondary: AppColors.primary,
        ),
        useMaterial3: true,
        fontFamily: "Pretendard",
      ),
      // home: MainScreen(),
      home: DeliveryScreen(deliveryReservation: DeliveryReservationDto(
          id: 1,
          deliveryId: 1,
          storageId: 1,
          deliveryArrivalDateTime: "2024-12-31T16:30:00",
          luggage: [LuggageDto(type: "BAG", height: 30, width: 30, depth: 30)],
          storageAddress: "서울특별시 보관소 주소 어쩌구",
          storagePostalCode: "12345",
          storageLatitude: 37,
          storageLongitude: 125,
          destinationAddress: "서울특별시 목적지 어쩌구 몇층 몇호",
          destinationPostalCode: "54321",
          destinationLatitude: 37.5,
          destinationLongitude: 127,
          status: "pending",
          distance: 1300),),
    );
  }
}
