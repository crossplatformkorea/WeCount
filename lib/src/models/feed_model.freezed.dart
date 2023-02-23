// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FeedModel _$FeedModelFromJson(Map<String, dynamic> json) {
  return _FeedModel.fromJson(json);
}

/// @nodoc
mixin _$FeedModel {
  String get id => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  bool get visibility => throw _privateConstructorUsedError;
  CommunityCurrency get currency => throw _privateConstructorUsedError;
  String? get placeName => throw _privateConstructorUsedError;
  List<String> get picture => throw _privateConstructorUsedError;
  FeedType get type => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  int get dislikeCount => throw _privateConstructorUsedError;
  int get replyCount => throw _privateConstructorUsedError;
  @DocumentRefConverter()
  DocumentReference<Object?> get writerRef =>
      throw _privateConstructorUsedError;
  @DocumentRefConverter()
  DocumentReference<Object?> get communityRef =>
      throw _privateConstructorUsedError;
  @ServerTimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampNullableConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @TimestampNullableConverter()
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedModelCopyWith<FeedModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedModelCopyWith<$Res> {
  factory $FeedModelCopyWith(FeedModel value, $Res Function(FeedModel) then) =
      _$FeedModelCopyWithImpl<$Res, FeedModel>;
  @useResult
  $Res call(
      {String id,
      String description,
      double amount,
      bool visibility,
      CommunityCurrency currency,
      String? placeName,
      List<String> picture,
      FeedType type,
      int likeCount,
      int dislikeCount,
      int replyCount,
      @DocumentRefConverter() DocumentReference<Object?> writerRef,
      @DocumentRefConverter() DocumentReference<Object?> communityRef,
      @ServerTimestampConverter() DateTime createdAt,
      @TimestampNullableConverter() DateTime? updatedAt,
      @TimestampNullableConverter() DateTime? deletedAt});
}

/// @nodoc
class _$FeedModelCopyWithImpl<$Res, $Val extends FeedModel>
    implements $FeedModelCopyWith<$Res> {
  _$FeedModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? amount = null,
    Object? visibility = null,
    Object? currency = null,
    Object? placeName = freezed,
    Object? picture = null,
    Object? type = null,
    Object? likeCount = null,
    Object? dislikeCount = null,
    Object? replyCount = null,
    Object? writerRef = null,
    Object? communityRef = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as bool,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as CommunityCurrency,
      placeName: freezed == placeName
          ? _value.placeName
          : placeName // ignore: cast_nullable_to_non_nullable
              as String?,
      picture: null == picture
          ? _value.picture
          : picture // ignore: cast_nullable_to_non_nullable
              as List<String>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FeedType,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      dislikeCount: null == dislikeCount
          ? _value.dislikeCount
          : dislikeCount // ignore: cast_nullable_to_non_nullable
              as int,
      replyCount: null == replyCount
          ? _value.replyCount
          : replyCount // ignore: cast_nullable_to_non_nullable
              as int,
      writerRef: null == writerRef
          ? _value.writerRef
          : writerRef // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>,
      communityRef: null == communityRef
          ? _value.communityRef
          : communityRef // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>,
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
abstract class _$$_FeedModelCopyWith<$Res> implements $FeedModelCopyWith<$Res> {
  factory _$$_FeedModelCopyWith(
          _$_FeedModel value, $Res Function(_$_FeedModel) then) =
      __$$_FeedModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String description,
      double amount,
      bool visibility,
      CommunityCurrency currency,
      String? placeName,
      List<String> picture,
      FeedType type,
      int likeCount,
      int dislikeCount,
      int replyCount,
      @DocumentRefConverter() DocumentReference<Object?> writerRef,
      @DocumentRefConverter() DocumentReference<Object?> communityRef,
      @ServerTimestampConverter() DateTime createdAt,
      @TimestampNullableConverter() DateTime? updatedAt,
      @TimestampNullableConverter() DateTime? deletedAt});
}

/// @nodoc
class __$$_FeedModelCopyWithImpl<$Res>
    extends _$FeedModelCopyWithImpl<$Res, _$_FeedModel>
    implements _$$_FeedModelCopyWith<$Res> {
  __$$_FeedModelCopyWithImpl(
      _$_FeedModel _value, $Res Function(_$_FeedModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? amount = null,
    Object? visibility = null,
    Object? currency = null,
    Object? placeName = freezed,
    Object? picture = null,
    Object? type = null,
    Object? likeCount = null,
    Object? dislikeCount = null,
    Object? replyCount = null,
    Object? writerRef = null,
    Object? communityRef = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_$_FeedModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as bool,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as CommunityCurrency,
      placeName: freezed == placeName
          ? _value.placeName
          : placeName // ignore: cast_nullable_to_non_nullable
              as String?,
      picture: null == picture
          ? _value._picture
          : picture // ignore: cast_nullable_to_non_nullable
              as List<String>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FeedType,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      dislikeCount: null == dislikeCount
          ? _value.dislikeCount
          : dislikeCount // ignore: cast_nullable_to_non_nullable
              as int,
      replyCount: null == replyCount
          ? _value.replyCount
          : replyCount // ignore: cast_nullable_to_non_nullable
              as int,
      writerRef: null == writerRef
          ? _value.writerRef
          : writerRef // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>,
      communityRef: null == communityRef
          ? _value.communityRef
          : communityRef // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>,
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
class _$_FeedModel extends _FeedModel {
  const _$_FeedModel(
      {required this.id,
      required this.description,
      this.amount = 0.0,
      this.visibility = true,
      this.currency = CommunityCurrency.usd,
      this.placeName,
      final List<String> picture = const [],
      this.type = FeedType.none,
      this.likeCount = 0,
      this.dislikeCount = 0,
      this.replyCount = 0,
      @DocumentRefConverter() required this.writerRef,
      @DocumentRefConverter() required this.communityRef,
      @ServerTimestampConverter() required this.createdAt,
      @TimestampNullableConverter() this.updatedAt,
      @TimestampNullableConverter() this.deletedAt})
      : _picture = picture,
        super._();

  factory _$_FeedModel.fromJson(Map<String, dynamic> json) =>
      _$$_FeedModelFromJson(json);

  @override
  final String id;
  @override
  final String description;
  @override
  @JsonKey()
  final double amount;
  @override
  @JsonKey()
  final bool visibility;
  @override
  @JsonKey()
  final CommunityCurrency currency;
  @override
  final String? placeName;
  final List<String> _picture;
  @override
  @JsonKey()
  List<String> get picture {
    if (_picture is EqualUnmodifiableListView) return _picture;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_picture);
  }

  @override
  @JsonKey()
  final FeedType type;
  @override
  @JsonKey()
  final int likeCount;
  @override
  @JsonKey()
  final int dislikeCount;
  @override
  @JsonKey()
  final int replyCount;
  @override
  @DocumentRefConverter()
  final DocumentReference<Object?> writerRef;
  @override
  @DocumentRefConverter()
  final DocumentReference<Object?> communityRef;
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
    return 'FeedModel(id: $id, description: $description, amount: $amount, visibility: $visibility, currency: $currency, placeName: $placeName, picture: $picture, type: $type, likeCount: $likeCount, dislikeCount: $dislikeCount, replyCount: $replyCount, writerRef: $writerRef, communityRef: $communityRef, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FeedModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.placeName, placeName) ||
                other.placeName == placeName) &&
            const DeepCollectionEquality().equals(other._picture, _picture) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.dislikeCount, dislikeCount) ||
                other.dislikeCount == dislikeCount) &&
            (identical(other.replyCount, replyCount) ||
                other.replyCount == replyCount) &&
            (identical(other.writerRef, writerRef) ||
                other.writerRef == writerRef) &&
            (identical(other.communityRef, communityRef) ||
                other.communityRef == communityRef) &&
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
      description,
      amount,
      visibility,
      currency,
      placeName,
      const DeepCollectionEquality().hash(_picture),
      type,
      likeCount,
      dislikeCount,
      replyCount,
      writerRef,
      communityRef,
      createdAt,
      updatedAt,
      deletedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FeedModelCopyWith<_$_FeedModel> get copyWith =>
      __$$_FeedModelCopyWithImpl<_$_FeedModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FeedModelToJson(
      this,
    );
  }
}

abstract class _FeedModel extends FeedModel {
  const factory _FeedModel(
      {required final String id,
      required final String description,
      final double amount,
      final bool visibility,
      final CommunityCurrency currency,
      final String? placeName,
      final List<String> picture,
      final FeedType type,
      final int likeCount,
      final int dislikeCount,
      final int replyCount,
      @DocumentRefConverter()
          required final DocumentReference<Object?> writerRef,
      @DocumentRefConverter()
          required final DocumentReference<Object?> communityRef,
      @ServerTimestampConverter()
          required final DateTime createdAt,
      @TimestampNullableConverter()
          final DateTime? updatedAt,
      @TimestampNullableConverter()
          final DateTime? deletedAt}) = _$_FeedModel;
  const _FeedModel._() : super._();

  factory _FeedModel.fromJson(Map<String, dynamic> json) =
      _$_FeedModel.fromJson;

  @override
  String get id;
  @override
  String get description;
  @override
  double get amount;
  @override
  bool get visibility;
  @override
  CommunityCurrency get currency;
  @override
  String? get placeName;
  @override
  List<String> get picture;
  @override
  FeedType get type;
  @override
  int get likeCount;
  @override
  int get dislikeCount;
  @override
  int get replyCount;
  @override
  @DocumentRefConverter()
  DocumentReference<Object?> get writerRef;
  @override
  @DocumentRefConverter()
  DocumentReference<Object?> get communityRef;
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
  _$$_FeedModelCopyWith<_$_FeedModel> get copyWith =>
      throw _privateConstructorUsedError;
}
