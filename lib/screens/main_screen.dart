import 'package:flutter/material.dart';
import 'package:jimkanman_delivery/config/config.dart';
import 'package:jimkanman_delivery/utils/shared_prefs_util.dart';
import '../models/delivery_response.dart';
import '../services/api_service.dart';
import './delivery_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ApiService apiService = ApiService(baseUrl: baseUrl);
  late Future<List<DeliveryDto>> deliveryRequests;
  int? savedDeliveryId; // 저장된 배송 ID 추적

  @override
  void initState() {
    super.initState();
    loadSavedDeliveryId();
    deliveryRequests = fetchDeliveryRequests();
  }

  /// DeliveryId 로드 후 DeliveryScreen으로 라우팅
  void loadSavedDeliveryId() async {
    savedDeliveryId = await SharedPrefsUtil.getDeliveryId();
    if (savedDeliveryId != null) {
      final delivery = await apiService.get(
        'delivery/$savedDeliveryId',
            (data) => DeliveryDto.fromJson(data),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeliveryScreen(delivery: delivery), // 복원된 배송화면으로 이동
        ),
      );
    }
  }

  Future<List<DeliveryDto>> fetchDeliveryRequests() async {
    return await apiService.get<List<DeliveryDto>>(
      'delivery',
      (data){
          print(data);
          return (data as List).map((e) => DeliveryDto.fromJson(e)).toList();
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

  void applyForDelivery(int deliveryId) async {
    try {
      final response = await apiService.post(
        'delivery/assign/$deliveryId',
        {},
            (data) => SimpleDeliveryDto.fromJson(data),
      );
      SharedPrefsUtil.saveDeliveryId(response.deliveryId);
      SharedPrefsUtil.save(SharedPrefsUtil.deliveryReservationIdKey, response.deliveryReservationId);
      SharedPrefsUtil.save(SharedPrefsUtil.storageReservationIdKey, response.storageReservationId);

      final delivery = await apiService.get(
        'delivery/$deliveryId',
          (data) => DeliveryDto.fromJson(data),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeliveryScreen(delivery: delivery),
        ),
      );
    } catch (e) {
      print('Error applying for delivery: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Screen')),
      body: RefreshIndicator(
        onRefresh: refreshDeliveryRequests,
        child: FutureBuilder<List<DeliveryDto>>(
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
                  ElevatedButton(onPressed: refreshDeliveryRequests, child: Text("새로고침"),)
                ],
              ));
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
                  final delivery = snapshot.data![index];
                  return ListTile(
                    title: Text('Delivery #${delivery.id}'),
                    subtitle: /*Text('Destination: ${delivery.destinationAddress}'),*/ Text("Destination: TO_BE_DEVELOPED"),
                    trailing: ElevatedButton(
                      onPressed: () => applyForDelivery(delivery.id),
                      child: Text('Apply'),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: refreshDeliveryRequests,
        child: Icon(Icons.refresh),
        //backgroundColor: Colors.lightGreen,
      ),
    );
  }
}
