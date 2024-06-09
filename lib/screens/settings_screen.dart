import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/shopping_list_provider.dart';
import '../providers/auth_provider.dart';
import '../models/shopping_list_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);
    final userId = Provider.of<AuthProvider>(context).user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Enable Notifications for All Lists'),
              trailing: Switch(
                value: shoppingListProvider.shoppingLists.every((list) => list.notificationsEnabled),
                onChanged: (value) {
                  for (var list in shoppingListProvider.shoppingLists) {
                    shoppingListProvider.toggleNotifications(list.id, value);
                  }
                },
              ),
            ),
            const Divider(),
            Expanded(
              child: StreamBuilder<List<ShoppingList>>(
                stream: shoppingListProvider.getShoppingListsStream(userId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final shoppingLists = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: shoppingLists.length,
                    itemBuilder: (context, index) {
                      final list = shoppingLists[index];
                      return ListTile(
                        title: Text(list.name),
                        subtitle: Row(
                          children: [
                            const Text('Notifications: '),
                            Switch(
                              value: list.notificationsEnabled,
                              onChanged: (value) {
                                shoppingListProvider.toggleNotifications(list.id, value);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
