import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_list_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool notificationsEnabled = shoppingListProvider.notificationsEnabled; // Get the actual state

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(); // Navigate back to the previous screen
        return false; // Prevent default behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Enable Notifications for All Lists'),
                value: notificationsEnabled,
                onChanged: (bool value) {
                  shoppingListProvider.toggleAllNotifications(value);
                },
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: themeProvider.isDarkMode,
                onChanged: (bool value) {
                  themeProvider.toggleTheme(value);
                },
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: shoppingListProvider.shoppingLists.length,
                  itemBuilder: (context, index) {
                    final list = shoppingListProvider.shoppingLists[index];
                    return SwitchListTile(
                      title: Text(list.name),
                      value: list.notificationsEnabled,
                      onChanged: (bool value) {
                        shoppingListProvider.toggleNotifications(list.id, value);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
