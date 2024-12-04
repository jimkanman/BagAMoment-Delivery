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

DeliveryReservationDto _$DeliveryReservationDtoFromJson(
        Map<String, dynamic> json) =>
    DeliveryReservationDto(
      id: (json['id'] as num).toInt(),
      deliveryId: (json['deliveryId'] as num).toInt(),
      storageId: (json['storageId'] as num).toInt(),
      deliveryArrivalDateTime: json['deliveryArrivalDateTime'] as String?,
      luggage: (json['luggage'] as List<dynamic>?)
          ?.map((e) => LuggageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      storageAddress: json['storageAddress'] as String?,
      storagePostalCode: json['storagePostalCode'] as String?,
      storageLatitude: (json['storageLatitude'] as num?)?.toDouble(),
      storageLongitude: (json['storageLongitude'] as num?)?.toDouble(),
      destinationAddress: json['destinationAddress'] as String?,
      destinationPostalCode: json['destinationPostalCode'] as String?,
      destinationLatitude: (json['destinationLatitude'] as num?)?.toDouble(),
      destinationLongitude: (json['destinationLongitude'] as num?)?.toDouble(),
      status: json['status'] as String,
      distance: (json['distance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DeliveryReservationDtoToJson(
        DeliveryReservationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deliveryId': instance.deliveryId,
      'storageId': instance.storageId,
      'deliveryArrivalDateTime': instance.deliveryArrivalDateTime,
      'luggage': instance.luggage,
      'storageAddress': instance.storageAddress,
      'storagePostalCode': instance.storagePostalCode,
      'storageLatitude': instance.storageLatitude,
      'storageLongitude': instance.storageLongitude,
      'destinationAddress': instance.destinationAddress,
      'destinationPostalCode': instance.destinationPostalCode,
      'destinationLatitude': instance.destinationLatitude,
      'destinationLongitude': instance.destinationLongitude,
      'distance': instance.distance,
      'status': instance.status,
    };
