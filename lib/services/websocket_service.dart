import 'package:jimkanman_delivery/config/config.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';


class StompService {
  late StompClient stompClient;

  void connect(String url) {
    stompClient = StompClient(
      config: StompConfig(
        url: websocketUrl,
        onConnect: onConnect,
        beforeConnect: () async {
          print("StompService: wating connection..");
          await Future.delayed(const Duration(microseconds: 250));
          print("connecting...");
        },
        onWebSocketError: (dynamic error) => print(error.toString())
      )
    );

    stompClient.activate();
  }

  void onConnect(StompFrame frame) {
    print('Connected to STOMP WebSocket');
  }

  void subscribe(String topic, Function(Map<String, dynamic>) onMessage) {
    stompClient.subscribe(
      destination: topic,
      callback: (StompFrame frame) {
        if (frame.body != null) {
          final message = Map<String, dynamic>.from(frame.body as Map);
          onMessage(message);
        }
      },
    );
  }

  void send(String destination, Map<String, dynamic> message) {
    stompClient.send(
      destination: destination,
      body: message.toString(),
    );
  }

  void disconnect() {
    stompClient.deactivate();
  }
}

/*
*
* final StompService stompService = StompService();

// 연결
stompService.connect('http://your-server.com/connection');

// 메시지 구독
stompService.subscribe('/topic/delivery/location', (message) {
  print('Received message: $message');
});

// 메시지 전송
stompService.send('/app/delivery/location', {
  'deliveryId': 123,
  'latitude': 37.5665,
  'longitude': 126.9780,
});

// 연결 해제
stompService.disconnect();
* */