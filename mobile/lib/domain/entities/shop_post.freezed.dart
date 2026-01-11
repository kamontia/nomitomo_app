// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShopPost _$ShopPostFromJson(Map<String, dynamic> json) {
  return _ShopPost.fromJson(json);
}

/// @nodoc
mixin _$ShopPost {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shop_name')
  String get shopName => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ShopPost to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShopPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShopPostCopyWith<ShopPost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopPostCopyWith<$Res> {
  factory $ShopPostCopyWith(ShopPost value, $Res Function(ShopPost) then) =
      _$ShopPostCopyWithImpl<$Res, ShopPost>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'shop_name') String shopName,
    String? comment,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$ShopPostCopyWithImpl<$Res, $Val extends ShopPost>
    implements $ShopPostCopyWith<$Res> {
  _$ShopPostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShopPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? shopName = null,
    Object? comment = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            shopName: null == shopName
                ? _value.shopName
                : shopName // ignore: cast_nullable_to_non_nullable
                      as String,
            comment: freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShopPostImplCopyWith<$Res>
    implements $ShopPostCopyWith<$Res> {
  factory _$$ShopPostImplCopyWith(
    _$ShopPostImpl value,
    $Res Function(_$ShopPostImpl) then,
  ) = __$$ShopPostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'shop_name') String shopName,
    String? comment,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$ShopPostImplCopyWithImpl<$Res>
    extends _$ShopPostCopyWithImpl<$Res, _$ShopPostImpl>
    implements _$$ShopPostImplCopyWith<$Res> {
  __$$ShopPostImplCopyWithImpl(
    _$ShopPostImpl _value,
    $Res Function(_$ShopPostImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShopPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? shopName = null,
    Object? comment = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$ShopPostImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        shopName: null == shopName
            ? _value.shopName
            : shopName // ignore: cast_nullable_to_non_nullable
                  as String,
        comment: freezed == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShopPostImpl implements _ShopPost {
  const _$ShopPostImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'shop_name') required this.shopName,
    this.comment,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$ShopPostImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShopPostImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'shop_name')
  final String shopName;
  @override
  final String? comment;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'ShopPost(id: $id, userId: $userId, shopName: $shopName, comment: $comment, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopPostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.shopName, shopName) ||
                other.shopName == shopName) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, shopName, comment, createdAt);

  /// Create a copy of ShopPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopPostImplCopyWith<_$ShopPostImpl> get copyWith =>
      __$$ShopPostImplCopyWithImpl<_$ShopPostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShopPostImplToJson(this);
  }
}

abstract class _ShopPost implements ShopPost {
  const factory _ShopPost({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'shop_name') required final String shopName,
    final String? comment,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$ShopPostImpl;

  factory _ShopPost.fromJson(Map<String, dynamic> json) =
      _$ShopPostImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'shop_name')
  String get shopName;
  @override
  String? get comment;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of ShopPost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShopPostImplCopyWith<_$ShopPostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
