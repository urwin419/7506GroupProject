// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weightrecord.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeightRecord _$WeightRecordFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['token', 'date', 'weight'],
  );
  return WeightRecord(
    json['token'] as String,
    json['date'] as String,
    json['weight'] as String,
  );
}

Map<String, dynamic> _$WeightRecordToJson(WeightRecord instance) =>
    <String, dynamic>{
      'token': instance.token,
      'date': instance.date,
      'weight': instance.weight,
    };
