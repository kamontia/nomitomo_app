import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/dio_provider.dart';
import '../../domain/entities/user.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref.watch(dioProvider));
}

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<User> login(String accessToken) async {
    final response = await _dio.post(
      '/auth/login',
      data: {
        'line_access_token': accessToken,
      },
    );

    final data = response.data;
    final token = data['access_token'];
    
    // Save token
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);

    return User(
      id: data['user_id'],
      displayName: data['display_name'],
    );
  }

  Future<User> updateStatus(bool isRecruiting) async {
    final token = await getToken();
    final response = await _dio.post(
      '/users/me/status',
      data: {'is_recruiting': isRecruiting},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return User.fromJson(response.data);
  }

  Future<List<User>> getRecruitingUsers() async {
    final token = await getToken();
    final response = await _dio.get(
      '/users/recruiting',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final List<dynamic> list = response.data;
    return list.map((json) => User.fromJson(json)).toList();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
