// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/shopping_list_screen.dart';
import '../widgets/drawer_menu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.user == null) {
          return const LoginScreen();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Shopping List App'),
            ),
            drawer:   DrawerMenu(), // Removed listId
            body: const ShoppingListScreen(),
          );
        }
      },
    );
  }
}
