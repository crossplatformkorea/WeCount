// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CommunityModel _$CommunityModelFromJson(Map<String, dynamic> json) {
  return _CommunityModel.fromJson(json);
}

/// @nodoc
mixin _$CommunityModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @ColorConverter()
  Color get color => throw _privateConstructorUsedError;
  bool get visibility => throw _privateConstructorUsedError;
  CommunityCurrency get currency => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get thumbUrl => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  List<MemberModel> get members => throw _privateConstructorUsedError;
  int get starCount => throw _privateConstructorUsedError;
  double get totalIncome => throw _privateConstructorUsedError;
  double get totalConsume => throw _privateConstructorUsedError;
  @DocumentRefConverter()
  DocumentReference<Object?>? get ownerRef =>
      throw _privateConstructorUsedError;
  @ServerTimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampNullableConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @TimestampNullableConverter()
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommunityModelCopyWith<CommunityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityModelCopyWith<$Res> {
  factory $CommunityModelCopyWith(
          CommunityModel value, $Res Function(CommunityModel) then) =
      _$CommunityModelCopyWithImpl<$Res, CommunityModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      @ColorConverter() Color color,
      bool visibility,
      CommunityCurrency currency,
      String? description,
      String? thumbUrl,
      String? photoUrl,
      List<MemberModel> members,
      int starCount,
      double totalIncome,
      double totalConsume,
      @DocumentRefConverter() DocumentReference<Object?>? ownerRef,
      @ServerTimestampConverter() DateTime createdAt,
      @TimestampNullableConverter() DateTime? updatedAt,
      @TimestampNullableConverter() DateTime? deletedAt});
}

/// @nodoc
class _$CommunityModelCopyWithImpl<$Res, $Val extends CommunityModel>
    implements $CommunityModelCopyWith<$Res> {
  _$CommunityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? color = null,
    Object? visibility = null,
    Object? currency = null,
    Object? description = freezed,
    Object? thumbUrl = freezed,
    Object? photoUrl = freezed,
    Object? members = null,
    Object? starCount = null,
    Object? totalIncome = null,
    Object? totalConsume = null,
    Object? ownerRef = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as bool,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as CommunityCurrency,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbUrl: freezed == thumbUrl
          ? _value.thumbUrl
          : thumbUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<MemberModel>,
      starCount: null == starCount
          ? _value.starCount
          : starCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalConsume: null == totalConsume
          ? _value.totalConsume
          : totalConsume // ignore: cast_nullable_to_non_nullable
              as double,
      ownerRef: freezed == ownerRef
          ? _value.ownerRef
          : ownerRef // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>?,
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
abstract class _$$_CommunityModelCopyWith<$Res>
    implements $CommunityModelCopyWith<$Res> {
  factory _$$_CommunityModelCopyWith(
          _$_CommunityModel value, $Res Function(_$_CommunityModel) then) =
      __$$_CommunityModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      @ColorConverter() Color color,
      bool visibility,
      CommunityCurrency currency,
      String? description,
      String? thumbUrl,
      String? photoUrl,
      List<MemberModel> members,
      int starCount,
      double totalIncome,
      double totalConsume,
      @DocumentRefConverter() DocumentReference<Object?>? ownerRef,
      @ServerTimestampConverter() DateTime createdAt,
      @TimestampNullableConverter() DateTime? updatedAt,
      @TimestampNullableConverter() DateTime? deletedAt});
}

/// @nodoc
class __$$_CommunityModelCopyWithImpl<$Res>
    extends _$CommunityModelCopyWithImpl<$Res, _$_CommunityModel>
    implements _$$_CommunityModelCopyWith<$Res> {
  __$$_CommunityModelCopyWithImpl(
      _$_CommunityModel _value, $Res Function(_$_CommunityModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? color = null,
    Object? visibility = null,
    Object? currency = null,
    Object? description = freezed,
    Object? thumbUrl = freezed,
    Object? photoUrl = freezed,
    Object? members = null,
    Object? starCount = null,
    Object? totalIncome = null,
    Object? totalConsume = null,
    Object? ownerRef = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_$_CommunityModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as bool,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as CommunityCurrency,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbUrl: freezed == thumbUrl
          ? _value.thumbUrl
          : thumbUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<MemberModel>,
      starCount: null == starCount
          ? _value.starCount
          : starCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalConsume: null == totalConsume
          ? _value.totalConsume
          : totalConsume // ignore: cast_nullable_to_non_nullable
              as double,
      ownerRef: freezed == ownerRef
          ? _value.ownerRef
          : ownerRef // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>?,
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
class _$_CommunityModel extends _CommunityModel {
  const _$_CommunityModel(
      {required this.id,
      required this.title,
      @ColorConverter() required this.color,
      this.visibility = true,
      this.currency = CommunityCurrency.usd,
      this.description,
      this.thumbUrl,
      this.photoUrl,
      final List<MemberModel> members = const [],
      this.starCount = 0,
      this.totalIncome = 0.0,
      this.totalConsume = 0.0,
      @DocumentRefConverter() this.ownerRef,
      @ServerTimestampConverter() required this.createdAt,
      @TimestampNullableConverter() this.updatedAt,
      @TimestampNullableConverter() this.deletedAt})
      : _members = members,
        super._();

  factory _$_CommunityModel.fromJson(Map<String, dynamic> json) =>
      _$$_CommunityModelFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @ColorConverter()
  final Color color;
  @override
  @JsonKey()
  final bool visibility;
  @override
  @JsonKey()
  final CommunityCurrency currency;
  @override
  final String? description;
  @override
  final String? thumbUrl;
  @override
  final String? photoUrl;
  final List<MemberModel> _members;
  @override
  @JsonKey()
  List<MemberModel> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  @JsonKey()
  final int starCount;
  @override
  @JsonKey()
  final double totalIncome;
  @override
  @JsonKey()
  final double totalConsume;
  @override
  @DocumentRefConverter()
  final DocumentReference<Object?>? ownerRef;
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
    return 'CommunityModel(id: $id, title: $title, color: $color, visibility: $visibility, currency: $currency, description: $description, thumbUrl: $thumbUrl, photoUrl: $photoUrl, members: $members, starCount: $starCount, totalIncome: $totalIncome, totalConsume: $totalConsume, ownerRef: $ownerRef, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CommunityModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.thumbUrl, thumbUrl) ||
                other.thumbUrl == thumbUrl) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.starCount, starCount) ||
                other.starCount == starCount) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalConsume, totalConsume) ||
                other.totalConsume == totalConsume) &&
            (identical(other.ownerRef, ownerRef) ||
                other.ownerRef == ownerRef) &&
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
      title,
      color,
      visibility,
      currency,
      description,
      thumbUrl,
      photoUrl,
      const DeepCollectionEquality().hash(_members),
      starCount,
      totalIncome,
      totalConsume,
      ownerRef,
      createdAt,
      updatedAt,
      deletedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CommunityModelCopyWith<_$_CommunityModel> get copyWith =>
      __$$_CommunityModelCopyWithImpl<_$_CommunityModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CommunityModelToJson(
      this,
    );
  }
}

abstract class _CommunityModel extends CommunityModel {
  const factory _CommunityModel(
          {required final String id,
          required final String title,
          @ColorConverter() required final Color color,
          final bool visibility,
          final CommunityCurrency currency,
          final String? description,
          final String? thumbUrl,
          final String? photoUrl,
          final List<MemberModel> members,
          final int starCount,
          final double totalIncome,
          final double totalConsume,
          @DocumentRefConverter() final DocumentReference<Object?>? ownerRef,
          @ServerTimestampConverter() required final DateTime createdAt,
          @TimestampNullableConverter() final DateTime? updatedAt,
          @TimestampNullableConverter() final DateTime? deletedAt}) =
      _$_CommunityModel;
  const _CommunityModel._() : super._();

  factory _CommunityModel.fromJson(Map<String, dynamic> json) =
      _$_CommunityModel.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  @ColorConverter()
  Color get color;
  @override
  bool get visibility;
  @override
  CommunityCurrency get currency;
  @override
  String? get description;
  @override
  String? get thumbUrl;
  @override
  String? get photoUrl;
  @override
  List<MemberModel> get members;
  @override
  int get starCount;
  @override
  double get totalIncome;
  @override
  double get totalConsume;
  @override
  @DocumentRefConverter()
  DocumentReference<Object?>? get ownerRef;
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
  _$$_CommunityModelCopyWith<_$_CommunityModel> get copyWith =>
      throw _privateConstructorUsedError;
}
