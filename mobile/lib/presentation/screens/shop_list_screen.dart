import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/shop_repository.dart';
import '../../domain/entities/shop_post.dart';

final shopPostsProvider = FutureProvider<List<ShopPost>>((ref) async {
  return await ref.watch(shopRepositoryProvider).getShopPosts();
});

class ShopListScreen extends ConsumerWidget {
  const ShopListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(shopPostsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('おすすめのお店')),
      body: postsAsync.when(
        data: (posts) => posts.isEmpty
          ? const Center(child: Text('まだおすすめのお店はありません\n(投稿から24時間後に表示されます)'))
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(post.shopName),
                    subtitle: Text(post.comment ?? ''),
                    trailing: const Icon(Icons.star, color: Colors.orange),
                  ),
                );
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('エラー: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPostDialog(context, ref);
        },
        child: const Icon(Icons.add_comment),
      ),
    );
  }

  void _showPostDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('お店を投稿する'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: '店名')),
            TextField(controller: commentController, decoration: const InputDecoration(labelText: 'コメント')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await ref.read(shopRepositoryProvider).createPost(
                  nameController.text,
                  commentController.text,
                );
                ref.invalidate(shopPostsProvider);
                if (context.mounted) Navigator.pop(context);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('投稿しました！反映まで24時間お待ちください')),
                  );
                }
              }
            },
            child: const Text('投稿'),
          ),
        ],
      ),
    );
  }
}
