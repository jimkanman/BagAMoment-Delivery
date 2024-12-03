import 'package:json_annotation/json_annotation.dart';

part 'luggage_dto.g.dart';

@JsonSerializable()
class LuggageDto {
  final String type;
  @JsonKey(defaultValue: null)
  final int weight;

  LuggageDto({required this.type, required this.weight});

  factory LuggageDto.fromJson(Map<String, dynamic> json) => _$LuggageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LuggageDtoToJson(this);
}
