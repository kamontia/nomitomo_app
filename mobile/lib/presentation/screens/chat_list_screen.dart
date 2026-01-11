import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      app_bar: AppBar(title: const Text('チャット')),
      body: const Center(
        child: Text('チャット履歴はここに表示されます\n(機能開発中)'),
      ),
    );
  }
}
