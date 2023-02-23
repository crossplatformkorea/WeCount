// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return MemberModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get birthday => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  MemberRole? get role => throw _privateConstructorUsedError;
  String? get thumbUrl => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String>? get notificationTokens => throw _privateConstructorUsedError;
  int get followerCount => throw _privateConstructorUsedError;
  int get followingCount => throw _privateConstructorUsedError;
  @ServerTimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampNullableConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @TimestampNullableConverter()
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String id,
      String email,
      String displayName,
      String? name,
      String? birthday,
      String? phoneNumber,
      MemberRole? role,
      String? thumbUrl,
      String? photoUrl,
      String? description,
      List<String>? notificationTokens,
      int followerCount,
      int followingCount,
      @ServerTimestampConverter() DateTime createdAt,
      @TimestampNullableConverter() DateTime? updatedAt,
      @TimestampNullableConverter() DateTime? deletedAt});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = null,
    Object? name = freezed,
    Object? birthday = freezed,
    Object? phoneNumber = freezed,
    Object? role = freezed,
    Object? thumbUrl = freezed,
    Object? photoUrl = freezed,
    Object? description = freezed,
    Object? notificationTokens = freezed,
    Object? followerCount = null,
    Object? followingCount = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      birthday: freezed == birthday
          ? _value.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as MemberRole?,
      thumbUrl: freezed == thumbUrl
          ? _value.thumbUrl
          : thumbUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      notificationTokens: freezed == notificationTokens
          ? _value.notificationTokens
          : notificationTokens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      followerCount: null == followerCount
          ? _value.followerCount
          : followerCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _value.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemberModelCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$MemberModelCopyWith(
          _$MemberModel value, $Res Function(_$MemberModel) then) =
      __$$MemberModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String displayName,
      String? name,
      String? birthday,
      String? phoneNumber,
      MemberRole? role,
      String? thumbUrl,
      String? photoUrl,
      String? description,
      List<String>? notificationTokens,
      int followerCount,
      int followingCount,
      @ServerTimestampConverter() DateTime createdAt,
      @TimestampNullableConverter() DateTime? updatedAt,
      @TimestampNullableConverter() DateTime? deletedAt});
}

/// @nodoc
class __$$MemberModelCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$MemberModel>
    implements _$$MemberModelCopyWith<$Res> {
  __$$MemberModelCopyWithImpl(
      _$MemberModel _value, $Res Function(_$MemberModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = null,
    Object? name = freezed,
    Object? birthday = freezed,
    Object? phoneNumber = freezed,
    Object? role = freezed,
    Object? thumbUrl = freezed,
    Object? photoUrl = freezed,
    Object? description = freezed,
    Object? notificationTokens = freezed,
    Object? followerCount = null,
    Object? followingCount = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_$MemberModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      birthday: freezed == birthday
          ? _value.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as MemberRole?,
      thumbUrl: freezed == thumbUrl
          ? _value.thumbUrl
          : thumbUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      notificationTokens: freezed == notificationTokens
          ? _value._notificationTokens
          : notificationTokens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      followerCount: null == followerCount
          ? _value.followerCount
          : followerCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _value.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberModel extends MemberModel {
  const _$MemberModel(
      {required this.id,
      required this.email,
      this.displayName = '',
      this.name,
      this.birthday,
      this.phoneNumber,
      this.role,
      this.thumbUrl,
      this.photoUrl,
      this.description,
      final List<String>? notificationTokens,
      this.followerCount = 0,
      this.followingCount = 0,
      @ServerTimestampConverter() required this.createdAt,
      @TimestampNullableConverter() this.updatedAt,
      @TimestampNullableConverter() this.deletedAt})
      : _notificationTokens = notificationTokens,
        super._();

  factory _$MemberModel.fromJson(Map<String, dynamic> json) =>
      _$$MemberModelFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  @JsonKey()
  final String displayName;
  @override
  final String? name;
  @override
  final String? birthday;
  @override
  final String? phoneNumber;
  @override
  final MemberRole? role;
  @override
  final String? thumbUrl;
  @override
  final String? photoUrl;
  @override
  final String? description;
  final List<String>? _notificationTokens;
  @override
  List<String>? get notificationTokens {
    final value = _notificationTokens;
    if (value == null) return null;
    if (_notificationTokens is EqualUnmodifiableListView)
      return _notificationTokens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final int followerCount;
  @override
  @JsonKey()
  final int followingCount;
  @override
  @ServerTimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampNullableConverter()
  final DateTime? updatedAt;
  @override
  @TimestampNullableConverter()
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, displayName: $displayName, name: $name, birthday: $birthday, phoneNumber: $phoneNumber, role: $role, thumbUrl: $thumbUrl, photoUrl: $photoUrl, description: $description, notificationTokens: $notificationTokens, followerCount: $followerCount, followingCount: $followingCount, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.birthday, birthday) ||
                other.birthday == birthday) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.thumbUrl, thumbUrl) ||
                other.thumbUrl == thumbUrl) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._notificationTokens, _notificationTokens) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      displayName,
      name,
      birthday,
      phoneNumber,
      role,
      thumbUrl,
      photoUrl,
      description,
      const DeepCollectionEquality().hash(_notificationTokens),
      followerCount,
      followingCount,
      createdAt,
      updatedAt,
      deletedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberModelCopyWith<_$MemberModel> get copyWith =>
      __$$MemberModelCopyWithImpl<_$MemberModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberModelToJson(
      this,
    );
  }
}

abstract class MemberModel extends UserModel {
  const factory MemberModel(
      {required final String id,
      required final String email,
      final String displayName,
      final String? name,
      final String? birthday,
      final String? phoneNumber,
      final MemberRole? role,
      final String? thumbUrl,
      final String? photoUrl,
      final String? description,
      final List<String>? notificationTokens,
      final int followerCount,
      final int followingCount,
      @ServerTimestampConverter() required final DateTime createdAt,
      @TimestampNullableConverter() final DateTime? updatedAt,
      @TimestampNullableConverter() final DateTime? deletedAt}) = _$MemberModel;
  const MemberModel._() : super._();

  factory MemberModel.fromJson(Map<String, dynamic> json) =
      _$MemberModel.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get displayName;
  @override
  String? get name;
  @override
  String? get birthday;
  @override
  String? get phoneNumber;
  @override
  MemberRole? get role;
  @override
  String? get thumbUrl;
  @override
  String? get photoUrl;
  @override
  String? get description;
  @override
  List<String>? get notificationTokens;
  @override
  int get followerCount;
  @override
  int get followingCount;
  @override
  @ServerTimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampNullableConverter()
  DateTime? get updatedAt;
  @override
  @TimestampNullableConverter()
  DateTime? get deletedAt;
  @override
  @JsonKey(ignore: true)
  _$$MemberModelCopyWith<_$MemberModel> get copyWith =>
      throw _privateConstructorUsedError;
}
