import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:circleslate/presentation/common_providers/auth_provider.dart';
import 'package:circleslate/presentation/common_providers/availability_provider.dart';
import 'package:circleslate/presentation/routes/app_router.dart';
import 'package:circleslate/data/datasources/shared_pref/local/token_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved tokens before app starts
  final tokenManager = TokenManager();
  final tokens = await tokenManager.getTokens();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final authProvider = AuthProvider();
            if (tokens != null) {
              authProvider.setTokens(tokens.accessToken, tokens.refreshToken);
            }
            return authProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => AvailabilityProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

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
