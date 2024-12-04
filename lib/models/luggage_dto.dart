import 'package:json_annotation/json_annotation.dart';

part 'luggage_dto.g.dart';

@JsonSerializable()
class LuggageDto {
  final String type;
  @JsonKey(defaultValue: null)
  final int? width;
  @JsonKey(defaultValue: null)
  final int? depth;
  @JsonKey(defaultValue: null)
  final int? height;

  LuggageDto({
    required this.type,
    required this.width,
    required this.depth,
    required this.height
  });

  factory LuggageDto.fromJson(Map<String, dynamic> json) => _$LuggageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LuggageDtoToJson(this);
}
