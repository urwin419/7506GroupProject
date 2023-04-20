// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mealrecord.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealRecord _$MealRecordFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'date', 'time', 'meal'],
  );
  return MealRecord(
    json['id'] as String,
    json['date'] as String,
    json['time'] as String,
    json['meal'] as String,
  );
}

Map<String, dynamic> _$MealRecordToJson(MealRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'time': instance.time,
      'meal': instance.meal,
    };
