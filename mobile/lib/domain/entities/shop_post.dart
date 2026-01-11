import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_post.freezed.dart';
part 'shop_post.g.dart';

@freezed
class ShopPost with _$ShopPost {
  const factory ShopPost({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'shop_name') required String shopName,
    String? comment,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ShopPost;

  factory ShopPost.fromJson(Map<String, dynamic> json) => _$ShopPostFromJson(json);
}
