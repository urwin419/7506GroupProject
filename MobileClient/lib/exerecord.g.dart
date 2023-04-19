// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exerecord.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExeRecord _$ExeRecordFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'date', 'time', 'type', 'content'],
  );
  return ExeRecord(
    json['id'] as String,
    json['date'] as String,
    json['time'] as String,
    json['type'] as String,
    json['content'] as String,
  );
}

Map<String, dynamic> _$ExeRecordToJson(ExeRecord instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'time': instance.time,
      'type': instance.type,
      'content': instance.content,
    };
