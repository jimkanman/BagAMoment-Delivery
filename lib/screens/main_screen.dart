import 'package:flutter/material.dart';
import 'package:jimkanman_delivery/config/AppColors.dart';
import 'package:jimkanman_delivery/config/config.dart';
import 'package:jimkanman_delivery/services/location_service.dart';
import 'package:jimkanman_delivery/utils/shared_prefs_util.dart';
import 'package:jimkanman_delivery/widgets/delivery_info_tile.dart';
import '../models/delivery_response.dart';
import '../services/api_service.dart';
import '../widgets/rectangle_elevated_button.dart';
import './delivery_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ApiService apiService = ApiService(baseUrl: BASE_URL);
  final LocationService locationService = LocationService();
  late Future<List<DeliveryReservationDto>> deliveryRequests;
  int? savedDeliveryId; // 저장된 배송 ID 추적

  @override
  void initState() {
    super.initState();
    // checkDeliveryScreenRoute();
    deliveryRequests = fetchDeliveryRequests();
  }

  /// DeliveryId 로드 후 DeliveryScreen으로 라우팅
  void checkDeliveryScreenRoute() async {
    savedDeliveryId = await SharedPrefsUtil.getDeliveryId();
    var savedDeliveryReservationId = await SharedPrefsUtil.get(SharedPrefsUtil.deliveryReservationIdKey);
    if (savedDeliveryId != null) {
      final deliveryReservation = await apiService.get(
        'delivery/reservation/$savedDeliveryReservationId',
            // (data) => DeliveryDto.fromJson(data),
          (data) => DeliveryReservationDto.fromJson(data),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeliveryScreen(deliveryReservation: deliveryReservation), // 복원된 배송화면으로 이동
        ),
      );
    }
  }

  Future<List<DeliveryReservationDto>> fetchDeliveryRequests() async {
    return await apiService.get<List<DeliveryReservationDto>>(
      'delivery',
      (data){
          print(data);
          // return (data as List).map((e) => DeliveryDto.fromJson(e)).toList();
          return (data as List).map((elem) => DeliveryReservationDto.fromJson(elem)).toList();
      },
    );
  }

  /// 배송 정보 새로 가져온 후 화면 재구성
  Future<void> refreshDeliveryRequests() async {
    await fetchDeliveryRequests(); // 새 데이터 가져옴
    setState(() {
      deliveryRequests = fetchDeliveryRequests();
    });
  }

  void applyForDelivery(DeliveryReservationDto deliveryReservation) async {
    try {
      SharedPrefsUtil.saveDeliveryId(deliveryReservation.deliveryId);
      SharedPrefsUtil.save(SharedPrefsUtil.deliveryReservationIdKey, deliveryReservation.id);
      SharedPrefsUtil.save(SharedPrefsUtil.storageReservationIdKey, deliveryReservation.storageId);

      // final delivery = await apiService.get(
      //   'delivery/$deliveryId',
      //     (data) => DeliveryDto.fromJson(data),
      // );

      Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (context) => DeliveryScreen(deliveryReservation: delivery),
          builder: (context) => DeliveryScreen(deliveryReservation: deliveryReservation),
        ),
      );
    } catch (e) {
      print('Error applying for delivery: $e');
    }
  }

  void showDeliveryDetails(DeliveryReservationDto deliveryReservation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Text('배송 수락', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          content: Column(
            mainAxisSize: MainAxisSize.min, // 팝업 크기 자동 조정
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('출발지: ${deliveryReservation.destinationAddress}'),
              Text('목적지: ${deliveryReservation.destinationAddress}'),
              const SizedBox(height: 4,),
              Text('(약 ${locationService.convertMToKM(deliveryReservation.distance, 1)} km)'),
              // 필요시 추가 세부 정보
              const SizedBox(height: 8,),
              const Text('해당 배송을 신청합니다.')
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
                // applyForDelivery(deliveryReservation.deliveryId); // 배송 신청 실행
                applyForDelivery(deliveryReservation); // 배송 신청
              },
              child: const Text('확인'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // 팝업 닫기
              child: const Text('취소'),
            ),
          ],
          actionsPadding: const EdgeInsets.all(8),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Center(
            child: Text('짐깐만 배송',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
      ),
      body: RefreshIndicator(
        onRefresh: refreshDeliveryRequests,
        child: FutureBuilder<List<DeliveryReservationDto>>(
          future: deliveryRequests,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              /* 로딩 중 */
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              /* API 에러 발생 */
              return Center(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30,),
                    const Text('서버 연결 중 에러가 발생했습니다!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    const SizedBox(height: 45),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  ],
                )
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              /* 배송 존재 X */
              return const Center(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30,),
                    Text('아직 배송 요청이 없습니다!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ],
                )
              );
            } else {
              /* 정상 케이스 */
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final deliveryReservation = snapshot.data![index];
                  print(deliveryReservation.distance);
                  print(locationService.convertMToKM(deliveryReservation.distance, 1));
                  return DeliveryInfoTile(
                      deliveryReservation: deliveryReservation,
                      distanceKm: locationService.convertMToKM(deliveryReservation.distance, 1)?.toString(),
                      onPressed: showDeliveryDetails);
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: refreshDeliveryRequests,
        child: const Icon(Icons.refresh),
        //backgroundColor: Colors.lightGreen,
      ),
    );
  }
}
