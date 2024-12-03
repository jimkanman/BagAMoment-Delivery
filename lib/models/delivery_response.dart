import 'package:jimkanman_delivery/models/reservation_dto.dart';
import 'package:jimkanman_delivery/models/luggage_dto.dart';
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

@JsonSerializable()
class DeliveryReservationDto {
  final int id;
  final int deliveryId;

  @JsonKey(defaultValue: null)
  final String? deliveryArrivalDateTime;
  @JsonKey(defaultValue: null)
  final List<LuggageDto>? luggage;

  @JsonKey(defaultValue: null)
  final String? storageAddress;
  @JsonKey(defaultValue: null)
  final String? storagePostalCode;
  @JsonKey(defaultValue: null)
  final String? destinationAddress;
  @JsonKey(defaultValue: null)
  final String? destinationPostalCode;
  @JsonKey(defaultValue: null)
  final double? destinationLatitude;
  @JsonKey(defaultValue: null)
  final double? destinationLongitude;
  @JsonKey(defaultValue: null)
  final double? distance;

  final String status;

  DeliveryReservationDto({
    required this.id,
    required this.deliveryId,
    required this.deliveryArrivalDateTime,
    required this.luggage,
    required this.storageAddress,
    required this.storagePostalCode,
    required this.destinationAddress,
    required this.destinationPostalCode,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.status,
    required this.distance
});

  factory DeliveryReservationDto.fromJson(Map<String, dynamic> json) => _$DeliveryReservationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryReservationDtoToJson(this);
}