import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<User?> build() async {
    final repo = ref.read(authRepositoryProvider);
    final token = await repo.getToken();
    if (token != null) {
      // For MVP, we'd ideally verify this token with our backend
      // But for now we just try to get the cached user info if possible
      // (Simplified: return null to force login if no user data cached)
      return null; 
    }
    return null;
  }

  Future<void> login() async {
    state = const AsyncValue.loading();
    try {
      final loginResult = await LineSDK.instance.login();
      final accessToken = loginResult.accessToken.value;
      
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.login(accessToken);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void updateLocalUser(User user) {
    state = AsyncValue.data(user);
  }

  void logout() async {
    await LineSDK.instance.logout();
    state = const AsyncValue.data(null);
  }
}
