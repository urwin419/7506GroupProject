import 'package:json_annotation/json_annotation.dart';

part 'mealrecord.g.dart';

@JsonSerializable()
class MealRecord {
  MealRecord(this.id, this.date, this.time, this.meal);
  
  @JsonKey(required: true)
  String id;
  @JsonKey(required: true)
  String date;
  @JsonKey(required: true)
  String time;
  @JsonKey(required: true)
  String meal;

  factory MealRecord.fromJson(Map<String, dynamic> json) =>
      _$MealRecordFromJson(json);

  Map<String, dynamic> toJson() => _$MealRecordToJson(this);
}
