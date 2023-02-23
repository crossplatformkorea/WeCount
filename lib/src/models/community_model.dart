import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/converter.dart';
import '../utils/firestore_config.dart';
import 'user_model.dart';

part 'community_model.freezed.dart';
part 'community_model.g.dart';

enum CommunityCurrency {
  krw,
  usd,
}

@freezed
class CommunityModel with _$CommunityModel {
  const CommunityModel._();

  const factory CommunityModel({
    required String id,
    required String title,
    @ColorConverter() required Color color,
    @Default(true) bool visibility,
    @Default(CommunityCurrency.usd) CommunityCurrency currency,
    String? description,
    String? thumbUrl,
    String? photoUrl,
    @Default([]) List<MemberModel> members,
    @Default(0) int starCount,
    @Default(0.0) double totalIncome,
    @Default(0.0) double totalConsume,
    @DocumentRefConverter() DocumentReference? ownerRef,
    @ServerTimestampConverter() required DateTime createdAt,
    @TimestampNullableConverter() DateTime? updatedAt,
    @TimestampNullableConverter() DateTime? deletedAt,
  }) = _CommunityModel;

  factory CommunityModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityModelFromJson(json);

  DocumentReference get ref => FirestoreConfig.communityColRef.doc(id);

  bool get isOwner => FirebaseAuth.instance.currentUser == null
      ? false
      : ownerRef ==
          FirestoreConfig.userColRef
              .doc(FirebaseAuth.instance.currentUser!.uid);
}
