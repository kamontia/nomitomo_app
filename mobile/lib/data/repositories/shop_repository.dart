import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/shop_post.dart';

part 'shop_repository.g.dart';

@riverpod
ShopRepository shopRepository(ShopRepositoryRef ref) {
  return ShopRepository(
    ref.watch(dioProvider),
    ref.watch(authRepositoryProvider),
  );
}

class ShopRepository {
  final Dio _dio;
  final AuthRepository _authRepo;

  ShopRepository(this._dio, this._authRepo);

  Future<List<ShopPost>> getShopPosts() async {
    final token = await _authRepo.getToken();
    final response = await _dio.get(
      '/shops/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final List<dynamic> list = response.data;
    return list.map((json) => ShopPost.fromJson(json)).toList();
  }

  Future<ShopPost> createPost(String shopName, String? comment) async {
    final token = await _authRepo.getToken();
    final response = await _dio.post(
      '/shops/posts',
      data: {'shop_name': shopName, 'comment': comment},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return ShopPost.fromJson(response.data);
  }
}
