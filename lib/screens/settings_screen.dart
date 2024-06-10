import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_list_provider.dart';
import '../providers/theme_provider.dart';
import '../services/shopping_service.dart';
import '../models/notification_settings_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final firestoreService = Provider.of<ShoppingService>(context, listen: false);
    final userId = 'current_user_id'; // Get current user ID from auth provider

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
                value: shoppingListProvider.notificationsEnabled,
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
                    return StreamBuilder<NotificationSettings>(
                      stream: firestoreService.getNotificationSettings(userId, list.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        final settings = snapshot.data;

                        return SwitchListTile(
                          title: Text(list.name),
                          value: settings?.notificationsEnabled ?? false,
                          onChanged: (bool value) {
                            final newSettings = NotificationSettings(
                              userId: userId,
                              listId: list.id,
                              notificationsEnabled: value,
                            );
                            firestoreService.setNotificationSettings(newSettings);
                          },
                        );
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
