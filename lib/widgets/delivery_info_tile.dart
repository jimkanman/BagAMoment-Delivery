import 'package:flutter/material.dart';
import 'package:jimkanman_delivery/config/AppColors.dart';
import 'package:jimkanman_delivery/models/delivery_response.dart';
import 'package:jimkanman_delivery/models/luggage_dto.dart';
import 'package:jimkanman_delivery/services/location_service.dart';
import 'package:jimkanman_delivery/widgets/rectangle_elevated_button.dart';

class DeliveryInfoTile extends StatelessWidget {
  final DeliveryReservationDto deliveryReservation;
  final String? distanceKm;
  final void Function(DeliveryReservationDto) onPressed;

  const DeliveryInfoTile({
    super.key,
    required this.deliveryReservation,
    required this.distanceKm,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0, // 그림자 높이
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // 둥근 모서리
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // 카드 내부 패딩
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 출발지 정보
            Row(
              children: [
                const Text("출발지", style: TextStyle(fontSize: 16), textAlign: TextAlign.left,),
                const SizedBox(width: 16.0),
                Expanded(child: Text(deliveryReservation.storageAddress ?? '보관소 주소', textAlign: TextAlign.right, overflow: TextOverflow.ellipsis,))
              ],
            ),
            const SizedBox(height: 4,),

            // 목적지 정보
            Row(
              children: [
                const Text("도착지", style: TextStyle(fontSize: 16), textAlign: TextAlign.left,),
                const SizedBox(width: 16.0),
                Expanded(child: Text(deliveryReservation.destinationAddress ?? '보관소 주소', textAlign: TextAlign.right, overflow: TextOverflow.ellipsis,))
              ],
            ),
            const SizedBox(height: 8.0),

            // 거리 정보, 짐 정보, 수락 버튼
            Row(
              children: [
                Text('(${distanceKm ?? 0.0} km)'),
                
                const Spacer(), // 나머지 위젯 오른쪽에 배치
                luggageInfoText(),
                const SizedBox(width: 8,),
                RectangularElevatedButton(
                  borderRadius: 4,
                  onPressed: () => onPressed(deliveryReservation),
                  backgroundColor: AppColors.primaryDark,
                  child: const Text(
                    'Apply',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget luggageInfoText() {
    int bagCount = 0, carrierCount = 0, miscellaneousItemCount = 0;
    deliveryReservation.luggage
    ?.forEach((luggage) {
      switch(luggage.type.toLowerCase()){
        case 'bag':
          bagCount++;
          break;
        case 'carrier':
          carrierCount++;
          break;
        case 'miscellaneous_item':
          miscellaneousItemCount++;
          break;
      }
    });

    String ret = '';
    if(bagCount > 0) ret += '배낭 $bagCount개 ';
    if(carrierCount > 0) ret += '캐리어 $carrierCount개 ';
    if(miscellaneousItemCount > 0) ret += '기타 $miscellaneousItemCount개';

    return Text(ret);
  }
}
