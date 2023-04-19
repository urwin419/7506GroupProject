import 'package:json_annotation/json_annotation.dart';

part 'exerecord.g.dart';

@JsonSerializable()
class ExeRecord {
  ExeRecord(this.id, this.date, this.time, this.type, this.content);

  @JsonKey(required: true)
  String id;
  @JsonKey(required: true)
  String date;
  @JsonKey(required: true)
  String time;
  @JsonKey(required: true)
  String type;
  @JsonKey(required: true)
  String content;

  factory ExeRecord.fromJson(Map<String, dynamic> json) =>
      _$ExeRecordFromJson(json);

  Map<String, dynamic> toJson() => _$ExeRecordToJson(this);
}
