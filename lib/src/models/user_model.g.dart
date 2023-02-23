// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberModel _$$MemberModelFromJson(Map<String, dynamic> json) =>
    _$MemberModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String? ?? '',
      name: json['name'] as String?,
      birthday: json['birthday'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      role: $enumDecodeNullable(_$MemberRoleEnumMap, json['role']),
      thumbUrl: json['thumbUrl'] as String?,
      photoUrl: json['photoUrl'] as String?,
      description: json['description'] as String?,
      notificationTokens: (json['notificationTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      followerCount: json['followerCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      createdAt: const ServerTimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampNullableConverter()
          .fromJson(json['updatedAt'] as Timestamp?),
      deletedAt: const TimestampNullableConverter()
          .fromJson(json['deletedAt'] as Timestamp?),
    );

Map<String, dynamic> _$$MemberModelToJson(_$MemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'name': instance.name,
      'birthday': instance.birthday,
      'phoneNumber': instance.phoneNumber,
      'role': _$MemberRoleEnumMap[instance.role],
      'thumbUrl': instance.thumbUrl,
      'photoUrl': instance.photoUrl,
      'description': instance.description,
      'notificationTokens': instance.notificationTokens,
      'followerCount': instance.followerCount,
      'followingCount': instance.followingCount,
      'createdAt': const ServerTimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const TimestampNullableConverter().toJson(instance.updatedAt),
      'deletedAt':
          const TimestampNullableConverter().toJson(instance.deletedAt),
    };

const _$MemberRoleEnumMap = {
  MemberRole.owner: 'owner',
  MemberRole.admin: 'admin',
  MemberRole.member: 'member',
  MemberRole.none: 'none',
};
