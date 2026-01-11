import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/dio_provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/chat_room.dart';
import '../../domain/entities/chat_message.dart';

part 'chat_repository.g.dart';

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository(
    ref.watch(dioProvider),
    ref.watch(authRepositoryProvider),
  );
}

class ChatRepository {
  final Dio _dio;
  final AuthRepository _authRepo;

  ChatRepository(this._dio, this._authRepo);

  Future<ChatRoom> createRoom(String targetUserId) async {
    final token = await _authRepo.getToken();
    final response = await _dio.post(
      '/chats/',
      data: {'target_user_id': targetUserId},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return ChatRoom.fromJson(response.data);
  }

  Future<List<ChatMessage>> getMessages(String roomId) async {
    final token = await _authRepo.getToken();
    final response = await _dio.get(
      '/chats/$roomId/messages',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final List<dynamic> list = response.data;
    return list.map((json) => ChatMessage.fromJson(json)).toList();
  }

  Future<ChatMessage> sendMessage(String roomId, String content) async {
    final token = await _authRepo.getToken();
    final response = await _dio.post(
      '/chats/$roomId/messages',
      data: {'content': content},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return ChatMessage.fromJson(response.data);
  }
}
