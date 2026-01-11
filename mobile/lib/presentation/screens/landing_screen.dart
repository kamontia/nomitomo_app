import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Stack(
              children: [
                Container(
                  height: 500,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1543007630-9710e4a00a20?q=80&w=800'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 500,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        const Color(0xFF1A1613),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_bar, color: Color(0xFFF2994A)),
                            const SizedBox(width: 8),
                            const Text('Drinking Buddy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const Spacer(),
                            TextButton(
                              onPressed: () => context.go('/login'),
                              child: const Text('Login', style: TextStyle(color: Colors.white70)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 100),
                        const Text(
                          'Tonight’s Toast\nStarts Here.',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Connect, meet, and cheers with\ndrinking buddies nearby.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.go('/login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF2994A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Get Started Free', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // How to Use Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                children: [
                  const Text('How to Use', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(width: 40, height: 3, color: const Color(0xFFF2994A)),
                  const SizedBox(height: 48),
                  const StepItem(
                    step: 'STEP 1',
                    title: 'LINEでかんたん登録',
                    description: 'Easy sign-up via your existing LINE account.',
                    icon: Icons.chat_bubble,
                  ),
                  const StepLine(),
                  const StepItem(
                    step: 'STEP 2',
                    title: '近くの飲み友を探す',
                    description: 'Use GPS to find buddies wanting to grab a drink nearby.',
                    icon: Icons.location_on,
                  ),
                  const StepLine(),
                  const StepItem(
                    step: 'STEP 3',
                    title: 'メッセージを送って乾杯！',
                    description: 'Match, send a message, and enjoy your night!',
                    icon: Icons.local_bar,
                  ),
                ],
              ),
            ),

            // Why Choose Us
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: const Color(0xFF2A2420),
              child: Column(
                children: [
                  const Text('Why Choose Us', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 32),
                  const FeatureCard(
                    icon: Icons.verified_user,
                    title: 'Safe & Secure',
                    description: 'Verified integration with LINE ensures real profiles and safety.',
                  ),
                  const SizedBox(height: 16),
                  const FeatureCard(
                    icon: Icons.bolt,
                    title: 'Instant Matching',
                    description: 'Smart GPS-based logic connects you with people nearby.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),
            const Text('Ready to Drink?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StoreButton(icon: Icons.apple, label: 'App Store'),
                const SizedBox(width: 12),
                StoreButton(icon: Icons.android, label: 'Google Play'),
              ],
            ),
            const SizedBox(height: 64),
            const Text('© 2024 Drinking Buddy. All rights reserved.', style: TextStyle(color: Colors.white24, fontSize: 12)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class StepItem extends StatelessWidget {
  final String step;
  final String title;
  final String description;
  final IconData icon;

  const StepItem({super.key, required this.step, required this.title, required this.description, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(color: Color(0xFF2A2420), shape: BoxShape.circle),
          child: Icon(icon, color: const Color(0xFFF2994A), size: 24),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(step, style: const TextStyle(color: Color(0xFFF2994A), fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(description, style: const TextStyle(color: Colors.white60, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}

class StepLine extends StatelessWidget {
  const StepLine({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 40,
      margin: const EdgeInsets.only(left: 24),
      color: Colors.white10,
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({super.key, required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1613),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF2994A).withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFFF2994A)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Colors.white60, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StoreButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const StoreButton({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2420),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
