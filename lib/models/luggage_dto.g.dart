// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'luggage_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LuggageDto _$LuggageDtoFromJson(Map<String, dynamic> json) => LuggageDto(
      type: json['type'] as String,
      width: (json['width'] as num?)?.toInt(),
      depth: (json['depth'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LuggageDtoToJson(LuggageDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'width': instance.width,
      'depth': instance.depth,
      'height': instance.height,
    };
