import 'package:json_annotation/json_annotation.dart';

part 'delivery_request.g.dart';

@JsonSerializable()
class ReservationDto {
  final List<LuggageDto> luggage;
  final String destinationPostalCode;
  final String destinationAddress;
  final String startDateTime;
  final String endDateTime;
  final String deliveryArrivalDateTime;

  ReservationDto({
    required this.luggage,
    required this.destinationPostalCode,
    required this.destinationAddress,
    required this.startDateTime,
    required this.endDateTime,
    required this.deliveryArrivalDateTime,
  });

  factory ReservationDto.fromJson(Map<String, dynamic> json) => _$ReservationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationDtoToJson(this);
}

@JsonSerializable()
class LuggageDto {
  final String name;
  final int weight;

  LuggageDto({required this.name, required this.weight});

  factory LuggageDto.fromJson(Map<String, dynamic> json) => _$LuggageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LuggageDtoToJson(this);
}
