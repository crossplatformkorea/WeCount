// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CommunityModel _$$_CommunityModelFromJson(Map<String, dynamic> json) =>
    _$_CommunityModel(
      id: json['id'] as String,
      title: json['title'] as String,
      color: const ColorConverter().fromJson(json['color'] as int),
      visibility: json['visibility'] as bool? ?? true,
      currency:
          $enumDecodeNullable(_$CommunityCurrencyEnumMap, json['currency']) ??
              CommunityCurrency.usd,
      description: json['description'] as String?,
      thumbUrl: json['thumbUrl'] as String?,
      photoUrl: json['photoUrl'] as String?,
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => MemberModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      starCount: json['starCount'] as int? ?? 0,
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0.0,
      totalConsume: (json['totalConsume'] as num?)?.toDouble() ?? 0.0,
      ownerRef: _$JsonConverterFromJson<DocumentReference<Object?>,
              DocumentReference<Object?>>(
          json['ownerRef'], const DocumentRefConverter().fromJson),
      createdAt: const ServerTimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampNullableConverter()
          .fromJson(json['updatedAt'] as Timestamp?),
      deletedAt: const TimestampNullableConverter()
          .fromJson(json['deletedAt'] as Timestamp?),
    );

Map<String, dynamic> _$$_CommunityModelToJson(_$_CommunityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'color': const ColorConverter().toJson(instance.color),
      'visibility': instance.visibility,
      'currency': _$CommunityCurrencyEnumMap[instance.currency]!,
      'description': instance.description,
      'thumbUrl': instance.thumbUrl,
      'photoUrl': instance.photoUrl,
      'members': instance.members,
      'starCount': instance.starCount,
      'totalIncome': instance.totalIncome,
      'totalConsume': instance.totalConsume,
      'ownerRef': _$JsonConverterToJson<DocumentReference<Object?>,
              DocumentReference<Object?>>(
          instance.ownerRef, const DocumentRefConverter().toJson),
      'createdAt': const ServerTimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const TimestampNullableConverter().toJson(instance.updatedAt),
      'deletedAt':
          const TimestampNullableConverter().toJson(instance.deletedAt),
    };

const _$CommunityCurrencyEnumMap = {
  CommunityCurrency.krw: 'krw',
  CommunityCurrency.usd: 'usd',
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
