import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/converter.dart';
import '../utils/firestore_config.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum MemberRole {
  owner,
  admin,
  member,
  none,
}

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String email,
    @Default('') String displayName,
    String? name,
    String? birthday,
    String? phoneNumber,
    MemberRole? role,
    String? thumbUrl,
    String? photoUrl,
    String? description,
    List<String>? notificationTokens,
    @Default(0) int followerCount,
    @Default(0) int followingCount,
    @ServerTimestampConverter() required DateTime createdAt,
    @TimestampNullableConverter() DateTime? updatedAt,
    @TimestampNullableConverter() DateTime? deletedAt,
  }) = MemberModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  DocumentReference get ref => FirestoreConfig.userColRef.doc(id);
}
