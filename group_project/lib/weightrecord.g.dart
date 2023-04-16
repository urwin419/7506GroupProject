// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weightrecord.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeightRecord _$WeightRecordFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'date', 'weight'],
  );
  return WeightRecord(
    json['id'] as String,
    json['date'] as String,
    json['weight'] as String,
  );
}

Map<String, dynamic> _$WeightRecordToJson(WeightRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'weight': instance.weight,
    };
