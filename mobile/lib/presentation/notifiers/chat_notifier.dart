import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../domain/entities/chat_message.dart';
import '../../data/repositories/chat_repository.dart';
import '../notifiers/auth_notifier.dart';

part 'chat_notifier.g.dart';

@riverpod
class ChatNotifier extends _$ChatNotifier {
  WebSocketChannel? _channel;

  @override
  FutureOr<List<ChatMessage>> build(String roomId) async {
    final user = ref.watch(authNotifierProvider).value;
    if (user != null) {
      _connectWebSocket(user.id);
    }
    
    ref.onDispose(() {
      _channel?.sink.close();
    });

    return await _fetchMessages();
  }

  Future<List<ChatMessage>> _fetchMessages() async {
    final repo = ref.read(chatRepositoryProvider);
    return await repo.getMessages(roomId);
  }

  void _connectWebSocket(String userId) {
    // For local dev, use 10.0.2.2 (Android) or 127.0.0.1 (iOS/Desktop)
    // Here we'd ideally get this from a config provider
    const wsUrl = 'ws://10.0.2.2:8000/chats/ws'; 
    _channel = WebSocketChannel.connect(Uri.parse('$wsUrl/$userId'));

    _channel!.stream.listen((data) {
      final json = jsonDecode(data);
      final message = ChatMessage.fromJson(json);
      
      // Update state if message belongs to this room
      if (message.roomId == roomId) {
        if (state.hasValue) {
          state = AsyncValue.data([...state.value!, message]);
        }
      }
    });
  }

  Future<void> sendMessage(String content) async {
    final repo = ref.read(chatRepositoryProvider);
    // Continue using HTTP POST for sending as planned (REST approach for mutations)
    await repo.sendMessage(roomId, content);
  }
}
