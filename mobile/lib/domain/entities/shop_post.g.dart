// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShopPostImpl _$$ShopPostImplFromJson(Map<String, dynamic> json) =>
    _$ShopPostImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      shopName: json['shop_name'] as String,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ShopPostImplToJson(_$ShopPostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'shop_name': instance.shopName,
      'comment': instance.comment,
      'created_at': instance.createdAt.toIso8601String(),
    };
