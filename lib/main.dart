import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/shopping_list_provider.dart';
import 'providers/theme_provider.dart';
import 'services/shopping_service.dart';
import 'services/firebase_messaging_service.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseMessagingService = FirebaseMessagingService();
  await firebaseMessagingService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ShoppingListProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(create: (_) => ShoppingService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shopping List',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.user == null) {
                return const LoginScreen();
              } else {
                return MainScreen();
              }
            },
          ),
        );
      },
    );
  }
}
