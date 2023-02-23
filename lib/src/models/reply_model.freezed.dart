// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reply_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ReplyModel _$ReplyModelFromJson(Map<String, dynamic> json) {
  return _ReplyModel.fromJson(json);
}

/// @nodoc
mixin _$ReplyModel {
  /// Reply ID
  String get id => throw _privateConstructorUsedError;

  /// Reply
  String get reply => throw _privateConstructorUsedError;

  /// Like count
  int get likeCount => throw _privateConstructorUsedError;

  /// Dislike count
  int get dislikeCount => throw _privateConstructorUsedError;

  /// replies count
  int get replyCount => throw _privateConstructorUsedError;

  /// Dates
  @ServerTimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @ServerTimestampConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @ServerTimestampConverter()
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Replier
  @DocumentRefConverter()
  DocumentReference<Object?> get writerRef =>
      throw _privateConstructorUsedError;

  /// Reply to feed
  @DocumentRefConverter()
  DocumentReference<Object?>? get feedRef => throw _privateConstructorUsedError;

  /// Replying to reply
  @DocumentRefConverter()
  DocumentReference<Object?>? get replyRef =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReplyModelCopyWith<ReplyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReplyModelCopyWith<$Res> {
  factory $ReplyModelCopyWith(
          ReplyModel value, $Res Function(ReplyModel) then) =
      _$ReplyModelCopyWithImpl<$Res, ReplyModel>;
  @useResult
  $Res call(
      {String id,
      String reply,
      int likeCount,
      int dislikeCount,
      int replyCount,
      @ServerTimestampConverter() DateTime createdAt,
      @ServerTimestampConverter() DateTime? updatedAt,
      @ServerTimestampConverter() DateTime? deletedAt,
      @DocumentRefConverter() DocumentReference<Object?> writerRef,
      @DocumentRefConverter() DocumentReference<Object?>? feedRef,
      @DocumentRefConverter() DocumentReference<Object?>? replyRef});
}

/// @nodoc
class _$ReplyModelCopyWithImpl<$Res, $Val extends ReplyModel>
    implements $ReplyModelCopyWith<$Res> {
  _$ReplyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reply = null,
    Object? likeCount = null,
    Object? dislikeCount = null,
    Object? replyCount = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? writerRef = null,
    Object? feedRef = freezed,
    Object? replyRef = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reply: null == reply
          ? _value.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as String,
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
      writerRef: null == writerRef
          ? _value.writerRef
          : writerRef // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>,
      feedRef: freezed == feedRef
          ? _value.feedRef
          : feedRef // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>?,
      replyRef: freezed == replyRef
          ? _value.replyRef
          : replyRef // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ReplyModelCopyWith<$Res>
    implements $ReplyModelCopyWith<$Res> {
  factory _$$_ReplyModelCopyWith(
          _$_ReplyModel value, $Res Function(_$_ReplyModel) then) =
      __$$_ReplyModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String reply,
      int likeCount,
      int dislikeCount,
      int replyCount,
      @ServerTimestampConverter() DateTime createdAt,
      @ServerTimestampConverter() DateTime? updatedAt,
      @ServerTimestampConverter() DateTime? deletedAt,
      @DocumentRefConverter() DocumentReference<Object?> writerRef,
      @DocumentRefConverter() DocumentReference<Object?>? feedRef,
      @DocumentRefConverter() DocumentReference<Object?>? replyRef});
}

/// @nodoc
class __$$_ReplyModelCopyWithImpl<$Res>
    extends _$ReplyModelCopyWithImpl<$Res, _$_ReplyModel>
    implements _$$_ReplyModelCopyWith<$Res> {
  __$$_ReplyModelCopyWithImpl(
      _$_ReplyModel _value, $Res Function(_$_ReplyModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reply = null,
    Object? likeCount = null,
    Object? dislikeCount = null,
    Object? replyCount = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? writerRef = null,
    Object? feedRef = freezed,
    Object? replyRef = freezed,
  }) {
    return _then(_$_ReplyModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reply: null == reply
          ? _value.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as String,
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
      writerRef: null == writerRef
          ? _value.writerRef
          : writerRef // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>,
      feedRef: freezed == feedRef
          ? _value.feedRef
          : feedRef // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>?,
      replyRef: freezed == replyRef
          ? _value.replyRef
          : replyRef // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ReplyModel extends _ReplyModel {
  const _$_ReplyModel(
      {required this.id,
      required this.reply,
      this.likeCount = 0,
      this.dislikeCount = 0,
      this.replyCount = 0,
      @ServerTimestampConverter() required this.createdAt,
      @ServerTimestampConverter() this.updatedAt,
      @ServerTimestampConverter() this.deletedAt,
      @DocumentRefConverter() required this.writerRef,
      @DocumentRefConverter() this.feedRef,
      @DocumentRefConverter() this.replyRef})
      : super._();

  factory _$_ReplyModel.fromJson(Map<String, dynamic> json) =>
      _$$_ReplyModelFromJson(json);

  /// Reply ID
  @override
  final String id;

  /// Reply
  @override
  final String reply;

  /// Like count
  @override
  @JsonKey()
  final int likeCount;

  /// Dislike count
  @override
  @JsonKey()
  final int dislikeCount;

  /// replies count
  @override
  @JsonKey()
  final int replyCount;

  /// Dates
  @override
  @ServerTimestampConverter()
  final DateTime createdAt;
  @override
  @ServerTimestampConverter()
  final DateTime? updatedAt;
  @override
  @ServerTimestampConverter()
  final DateTime? deletedAt;

  /// Replier
  @override
  @DocumentRefConverter()
  final DocumentReference<Object?> writerRef;

  /// Reply to feed
  @override
  @DocumentRefConverter()
  final DocumentReference<Object?>? feedRef;

  /// Replying to reply
  @override
  @DocumentRefConverter()
  final DocumentReference<Object?>? replyRef;

  @override
  String toString() {
    return 'ReplyModel(id: $id, reply: $reply, likeCount: $likeCount, dislikeCount: $dislikeCount, replyCount: $replyCount, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, writerRef: $writerRef, feedRef: $feedRef, replyRef: $replyRef)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ReplyModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reply, reply) || other.reply == reply) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.dislikeCount, dislikeCount) ||
                other.dislikeCount == dislikeCount) &&
            (identical(other.replyCount, replyCount) ||
                other.replyCount == replyCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.writerRef, writerRef) ||
                other.writerRef == writerRef) &&
            (identical(other.feedRef, feedRef) || other.feedRef == feedRef) &&
            (identical(other.replyRef, replyRef) ||
                other.replyRef == replyRef));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      reply,
      likeCount,
      dislikeCount,
      replyCount,
      createdAt,
      updatedAt,
      deletedAt,
      writerRef,
      feedRef,
      replyRef);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ReplyModelCopyWith<_$_ReplyModel> get copyWith =>
      __$$_ReplyModelCopyWithImpl<_$_ReplyModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ReplyModelToJson(
      this,
    );
  }
}

abstract class _ReplyModel extends ReplyModel {
  const factory _ReplyModel(
      {required final String id,
      required final String reply,
      final int likeCount,
      final int dislikeCount,
      final int replyCount,
      @ServerTimestampConverter()
          required final DateTime createdAt,
      @ServerTimestampConverter()
          final DateTime? updatedAt,
      @ServerTimestampConverter()
          final DateTime? deletedAt,
      @DocumentRefConverter()
          required final DocumentReference<Object?> writerRef,
      @DocumentRefConverter()
          final DocumentReference<Object?>? feedRef,
      @DocumentRefConverter()
          final DocumentReference<Object?>? replyRef}) = _$_ReplyModel;
  const _ReplyModel._() : super._();

  factory _ReplyModel.fromJson(Map<String, dynamic> json) =
      _$_ReplyModel.fromJson;

  @override

  /// Reply ID
  String get id;
  @override

  /// Reply
  String get reply;
  @override

  /// Like count
  int get likeCount;
  @override

  /// Dislike count
  int get dislikeCount;
  @override

  /// replies count
  int get replyCount;
  @override

  /// Dates
  @ServerTimestampConverter()
  DateTime get createdAt;
  @override
  @ServerTimestampConverter()
  DateTime? get updatedAt;
  @override
  @ServerTimestampConverter()
  DateTime? get deletedAt;
  @override

  /// Replier
  @DocumentRefConverter()
  DocumentReference<Object?> get writerRef;
  @override

  /// Reply to feed
  @DocumentRefConverter()
  DocumentReference<Object?>? get feedRef;
  @override

  /// Replying to reply
  @DocumentRefConverter()
  DocumentReference<Object?>? get replyRef;
  @override
  @JsonKey(ignore: true)
  _$$_ReplyModelCopyWith<_$_ReplyModel> get copyWith =>
      throw _privateConstructorUsedError;
}
