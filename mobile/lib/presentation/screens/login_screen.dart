import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../notifiers/auth_notifier.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    // If login successful, navigate to Home (listen to state change)
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.value != null) {
        context.go('/home');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (authState.isLoading)
                const CircularProgressIndicator()
              else ...[
                const Text('Welcome to Nomitomo'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(authNotifierProvider.notifier).login();
                  },
                  child: const Text('LINEでログイン'),
                ),
              ],
              if (authState.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'Error: ${authState.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
