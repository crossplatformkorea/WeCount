// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ReplyModel _$$_ReplyModelFromJson(Map<String, dynamic> json) =>
    _$_ReplyModel(
      id: json['id'] as String,
      reply: json['reply'] as String,
      likeCount: json['likeCount'] as int? ?? 0,
      dislikeCount: json['dislikeCount'] as int? ?? 0,
      replyCount: json['replyCount'] as int? ?? 0,
      createdAt: const ServerTimestampConverter().fromJson(json['createdAt']),
      updatedAt: const ServerTimestampConverter().fromJson(json['updatedAt']),
      deletedAt: const ServerTimestampConverter().fromJson(json['deletedAt']),
      writerRef: const DocumentRefConverter()
          .fromJson(json['writerRef'] as DocumentReference<Object?>),
      feedRef: _$JsonConverterFromJson<DocumentReference<Object?>,
              DocumentReference<Object?>>(
          json['feedRef'], const DocumentRefConverter().fromJson),
      replyRef: _$JsonConverterFromJson<DocumentReference<Object?>,
              DocumentReference<Object?>>(
          json['replyRef'], const DocumentRefConverter().fromJson),
    );

Map<String, dynamic> _$$_ReplyModelToJson(_$_ReplyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reply': instance.reply,
      'likeCount': instance.likeCount,
      'dislikeCount': instance.dislikeCount,
      'replyCount': instance.replyCount,
      'createdAt': const ServerTimestampConverter().toJson(instance.createdAt),
      'updatedAt': _$JsonConverterToJson<Object?, DateTime>(
          instance.updatedAt, const ServerTimestampConverter().toJson),
      'deletedAt': _$JsonConverterToJson<Object?, DateTime>(
          instance.deletedAt, const ServerTimestampConverter().toJson),
      'writerRef': const DocumentRefConverter().toJson(instance.writerRef),
      'feedRef': _$JsonConverterToJson<DocumentReference<Object?>,
              DocumentReference<Object?>>(
          instance.feedRef, const DocumentRefConverter().toJson),
      'replyRef': _$JsonConverterToJson<DocumentReference<Object?>,
              DocumentReference<Object?>>(
          instance.replyRef, const DocumentRefConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
