// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleDeliveryDto _$SimpleDeliveryDtoFromJson(Map<String, dynamic> json) =>
    SimpleDeliveryDto(
      deliveryId: (json['deliveryId'] as num).toInt(),
      deliveryReservationId: (json['deliveryReservationId'] as num).toInt(),
      storageReservationId: (json['storageReservationId'] as num).toInt(),
      arrivalTime: json['arrivalTime'] as String?,
      status: json['status'] as String,
    );

Map<String, dynamic> _$SimpleDeliveryDtoToJson(SimpleDeliveryDto instance) =>
    <String, dynamic>{
      'deliveryId': instance.deliveryId,
      'deliveryReservationId': instance.deliveryReservationId,
      'storageReservationId': instance.storageReservationId,
      'status': instance.status,
      'arrivalTime': instance.arrivalTime,
    };

DeliveryDto _$DeliveryDtoFromJson(Map<String, dynamic> json) => DeliveryDto(
      id: (json['id'] as num).toInt(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      arrivalTime: json['arrivalTime'] as String?,
      status: json['status'] as String,
    );

Map<String, dynamic> _$DeliveryDtoToJson(DeliveryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'arrivalTime': instance.arrivalTime,
      'status': instance.status,
    };
