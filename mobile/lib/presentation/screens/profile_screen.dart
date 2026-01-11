import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../notifiers/auth_notifier.dart';
import '../../data/repositories/auth_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('マイページ')),
      body: user == null 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
                const SizedBox(height: 16),
                Text(user.displayName, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(user.bio ?? '自己紹介を設定していません'),
                const Divider(height: 40),
                SwitchListTile(
                  title: const Text('「飲み募集中」にする'),
                  subtitle: const Text('ONにすると他のユーザーから見つけられるようになります'),
                  value: user.isRecruiting,
                  onChanged: (value) async {
                    final updatedUser = await ref.read(authRepositoryProvider).updateStatus(value);
                    ref.read(authNotifierProvider.notifier).updateLocalUser(updatedUser);
                  },
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    ref.read(authNotifierProvider.notifier).logout();
                    context.go('/login');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('ログアウト'),
                ),
              ],
            ),
          ),
    );
  }
}
