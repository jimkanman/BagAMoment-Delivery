import 'package:jimkanman_delivery/models/luggage_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation_dto.g.dart';

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

