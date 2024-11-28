// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationDto _$ReservationDtoFromJson(Map<String, dynamic> json) =>
    ReservationDto(
      luggage: (json['luggage'] as List<dynamic>)
          .map((e) => LuggageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      destinationPostalCode: json['destinationPostalCode'] as String,
      destinationAddress: json['destinationAddress'] as String,
      startDateTime: json['startDateTime'] as String,
      endDateTime: json['endDateTime'] as String,
      deliveryArrivalDateTime: json['deliveryArrivalDateTime'] as String,
    );

Map<String, dynamic> _$ReservationDtoToJson(ReservationDto instance) =>
    <String, dynamic>{
      'luggage': instance.luggage,
      'destinationPostalCode': instance.destinationPostalCode,
      'destinationAddress': instance.destinationAddress,
      'startDateTime': instance.startDateTime,
      'endDateTime': instance.endDateTime,
      'deliveryArrivalDateTime': instance.deliveryArrivalDateTime,
    };

LuggageDto _$LuggageDtoFromJson(Map<String, dynamic> json) => LuggageDto(
      name: json['name'] as String,
      weight: (json['weight'] as num).toInt(),
    );

Map<String, dynamic> _$LuggageDtoToJson(LuggageDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'weight': instance.weight,
    };
