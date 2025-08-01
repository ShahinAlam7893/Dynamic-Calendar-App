import 'package:circleslate/presentation/common_providers/availability_provider.dart';
import 'package:circleslate/presentation/features/event_management/view/create_edit_event_screen.dart';
import 'package:circleslate/presentation/features/event_management/view/event_details_screen.dart';
import 'package:circleslate/presentation/features/ride_request/view/ride_sharing_page.dart';
import 'package:circleslate/presentation/features/chat/view/chat_screen.dart';
import 'package:circleslate/presentation/features/event_management/view/upcoming_events_page.dart';
import 'package:circleslate/presentation/routes/app_router.dart';
import 'package:circleslate/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:circleslate/presentation/common_providers/auth_provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        // This is the missing provider!
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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