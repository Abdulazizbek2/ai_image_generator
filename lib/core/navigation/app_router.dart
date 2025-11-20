import 'package:go_router/go_router.dart';
import '../../features/image_generation/presentation/screens/prompt_screen.dart';
import '../../features/image_generation/presentation/screens/result_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'prompt',
      builder: (context, state) => const PromptScreen(),
    ),
    GoRoute(
      path: '/result',
      name: 'result',
      builder: (context, state) => const ResultScreen(),
    ),
  ],
);
