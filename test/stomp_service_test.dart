import 'package:flutter_test/flutter_test.dart';
import 'package:jimkanman_delivery/services/websocket_service.dart';
import 'package:http/http.dart' as http;


void main() {
  late StompService stompService;

  setUp(() {
    stompService = StompService();
  });

  test('Test Connection', () async {
    final response = await http.get(Uri.parse('http://localhost:8080/health'));
    if (response.statusCode == 200) {
      print('Server accessible');
    } else {
      print('Server not accessible: ${response.statusCode}');
    }
  });

  test('Connect to STOMP server and send/receive messages', () async {
    // Step 1: STOMP 서버 연결
    stompService.connect(url: "ws://localhost:8080");

    // Wait for the connection to establish
    await Future.delayed(const Duration(seconds: 2));
    expect(stompService.stompClient.isActive, true);

    // Step 2: 메시지 구독
    final messages = <String>[];
    stompService.subscribe('/topic/delivery/3', (message) {
      messages.add(message.toString());// 메시지 내용 저장
      print(message);
    });

    // Step 3: 메시지 전송
    Map<String, dynamic> sendMessage = {
      'deliveryId': 3,
      'latitude': 10.1,
      'longitude' : 10.1,
    };
    stompService.send('/app/delivery/location', sendMessage);

    // Wait for the message to be received
    await Future.delayed(const Duration(seconds: 2));
    expect(messages, contains(sendMessage.toString()));

    // Step 4: 연결 해제
    stompService.disconnect();
    expect(stompService.stompClient.isActive, false);
  });
}