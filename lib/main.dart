import 'package:circleslate/presentation/common_providers/conversation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:circleslate/presentation/common_providers/auth_provider.dart';
import 'package:circleslate/presentation/common_providers/availability_provider.dart';
import 'package:circleslate/presentation/routes/app_router.dart';
import 'package:circleslate/data/datasources/shared_pref/local/token_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tokenManager = TokenManager();
  final tokens = await tokenManager.getTokens().catchError((error) {
    debugPrint('Error loading tokens: $error');
    return null;
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) {
            final authProvider = AuthProvider();
            if (tokens != null) {
              authProvider.setTokens(tokens.accessToken, tokens.refreshToken);
              // Initialize user data after setting tokens
              Future.microtask(() => authProvider.initializeUserData());
            }
            return authProvider;
          },
        ),
        ChangeNotifierProvider<AvailabilityProvider>(
          create: (_) => AvailabilityProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ConversationProvider>(
          create: (context) => ConversationProvider(
            Provider.of<AuthProvider>(context, listen: false),
          ),
          update: (context, authProvider, conversationProvider) {
            return conversationProvider!;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'CircleSlate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
