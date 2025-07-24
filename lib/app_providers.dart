// lib/app_providers.dart
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'presentation/common_providers/auth_provider.dart'; // Import AuthProvider

class AppProviders {
  static List<SingleChildWidget> get providers => [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    // Add other global providers here as they are created
  ];
}