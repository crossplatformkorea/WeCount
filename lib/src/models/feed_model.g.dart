// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FeedModel _$$_FeedModelFromJson(Map<String, dynamic> json) => _$_FeedModel(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      visibility: json['visibility'] as bool? ?? true,
      currency:
          $enumDecodeNullable(_$CommunityCurrencyEnumMap, json['currency']) ??
              CommunityCurrency.usd,
      placeName: json['placeName'] as String?,
      picture: (json['picture'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      type:
          $enumDecodeNullable(_$FeedTypeEnumMap, json['type']) ?? FeedType.none,
      likeCount: json['likeCount'] as int? ?? 0,
      dislikeCount: json['dislikeCount'] as int? ?? 0,
      replyCount: json['replyCount'] as int? ?? 0,
      writerRef: const DocumentRefConverter()
          .fromJson(json['writerRef'] as DocumentReference<Object?>),
      communityRef: const DocumentRefConverter()
          .fromJson(json['communityRef'] as DocumentReference<Object?>),
      createdAt: const ServerTimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampNullableConverter()
          .fromJson(json['updatedAt'] as Timestamp?),
      deletedAt: const TimestampNullableConverter()
          .fromJson(json['deletedAt'] as Timestamp?),
    );

Map<String, dynamic> _$$_FeedModelToJson(_$_FeedModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'amount': instance.amount,
      'visibility': instance.visibility,
      'currency': _$CommunityCurrencyEnumMap[instance.currency]!,
      'placeName': instance.placeName,
      'picture': instance.picture,
      'type': _$FeedTypeEnumMap[instance.type]!,
      'likeCount': instance.likeCount,
      'dislikeCount': instance.dislikeCount,
      'replyCount': instance.replyCount,
      'writerRef': const DocumentRefConverter().toJson(instance.writerRef),
      'communityRef':
          const DocumentRefConverter().toJson(instance.communityRef),
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

const _$FeedTypeEnumMap = {
  FeedType.none: 'none',
  FeedType.income: 'income',
  FeedType.consume: 'consume',
};
