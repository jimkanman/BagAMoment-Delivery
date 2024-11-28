import 'package:json_annotation/json_annotation.dart';

part 'delivery_response.g.dart';

@JsonSerializable()
class SimpleDeliveryDto {
  final int deliveryId;
  final int deliveryReservationId;
  final int storageReservationId;
  final String status;

  @JsonKey(defaultValue: null)
  final String? arrivalTime;

  SimpleDeliveryDto({
    required this.deliveryId,
    required this.deliveryReservationId,
    required this.storageReservationId,
    required this.arrivalTime,
    required this.status,
  });

  factory SimpleDeliveryDto.fromJson(Map<String, dynamic> json) => _$SimpleDeliveryDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SimpleDeliveryDtoToJson(this);
}

@JsonSerializable()
class DeliveryDto {
  final int id;

  @JsonKey(defaultValue: null)
  final double? latitude;

  @JsonKey(defaultValue: null)
  final double? longitude;

  @JsonKey(defaultValue: null)
  final String? arrivalTime;

  final String status;

  DeliveryDto({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.arrivalTime,
    required this.status,
  });

  factory DeliveryDto.fromJson(Map<String, dynamic> json) => _$DeliveryDtoFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryDtoToJson(this);
}
