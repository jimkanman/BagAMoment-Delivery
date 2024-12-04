import 'dart:convert';

import 'package:jimkanman_delivery/config/config.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';


class StompService {
  late StompClient stompClient;
  String BASE_URL = WEBSOCKET_URL;

  void connect({String? url}) {
    if(url != null) BASE_URL = url;
    stompClient = StompClient(
      config: StompConfig(
        url: "$BASE_URL/connection",
        onConnect: onConnect,
        beforeConnect: () async {
          print("StompService: waiting connection..");
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
        print('StompService: received ${frame.body}');
        if (frame.body != null) {
          // final message = Map<String, dynamic>.from(frame.body as Map);
          final message = jsonDecode(frame.body!);
          onMessage(message);
        }
      },
    );
  }

  void send(String destination, Map<String, dynamic> message) {
    print("StompClient: sending $message");
    stompClient.send(
      destination: destination,
      body: jsonEncode(message),
    );
  }

  void disconnect() {
    stompClient.deactivate();
  }
}