// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'luggage_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LuggageDto _$LuggageDtoFromJson(Map<String, dynamic> json) => LuggageDto(
      type: json['type'] as String,
      weight: (json['weight'] as num).toInt(),
    );

Map<String, dynamic> _$LuggageDtoToJson(LuggageDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'weight': instance.weight,
    };
