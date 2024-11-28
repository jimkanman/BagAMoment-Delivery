import 'package:json_annotation/json_annotation.dart';


class SuccessResponse<T> {
  final bool isSuccess;
  final int code;
  final String message;
  final T data;

  SuccessResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.data,
  });

  factory SuccessResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return SuccessResponse<T>(
      isSuccess: json['isSuccess'] as bool,
      code: json['code'] as int,
      message: json['message'] as String,
      data: fromJsonT(json['data']),
    );
  }
}
