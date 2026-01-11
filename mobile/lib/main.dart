import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/main_navigation_screen.dart';
import 'presentation/screens/chat_room_screen.dart';
import 'presentation/screens/user_detail_screen.dart';
import 'presentation/screens/landing_screen.dart';

import 'package:flutter_line_sdk/flutter_line_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Replace with real Channel ID
  await LineSDK.instance.setup('YOUR_LINE_CHANNEL_ID').then((_) {
    print('LineSDK Prepared');
  });
  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  initialLocation: '/landing',
  routes: [
    GoRoute(
      path: '/landing',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/user-detail/:userId',
      builder: (context, state) => UserDetailScreen(userId: state.pathParameters['userId']!),
    ),
    GoRoute(
      path: '/chat-room/:roomId',
      builder: (context, state) {
        final roomId = state.pathParameters['roomId']!;
        final name = state.uri.queryParameters['name'] ?? 'チャット';
        return ChatRoomScreen(roomId: roomId, roomPartnerName: name);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nomitomo',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1613),
        primaryColor: const Color(0xFFF2994A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF2994A),
          brightness: Brightness.dark,
          surface: const Color(0xFF2A2420),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1613),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1613),
          selectedItemColor: Color(0xFFF2994A),
          unselectedItemColor: Colors.grey,
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
