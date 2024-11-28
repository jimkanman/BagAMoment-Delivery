import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<T> get<T>(String endpoint, T Function(dynamic) fromJson) async {
    print("ApiService: GET to '$baseUrl/$endpoint");
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    String body = utf8.decode(response.bodyBytes);
    print("ApiService: GET /$endpoint received ${body}");
    if (response.statusCode == 200) {
      return fromJson(jsonDecode(body)['data']);
    } else {
      throw Exception('Failed to load data: ${body}');
    }
  }

  Future<T> post<T>(String endpoint, Map<String, dynamic> requestBody, T Function(dynamic) fromJson) async {
    print("ApiService: POST to /$endpoint with body=$requestBody");
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    String decodedBody = utf8.decode(response.bodyBytes);
    print("ApiService: POST /$endpoint received $decodedBody");
    if (response.statusCode == 200) {
      return fromJson(jsonDecode(decodedBody)['data']);
    } else {
      throw Exception('Failed to post data: $decodedBody');
    }
  }
}
