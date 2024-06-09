import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../models/shopping_list_model.dart';
import '../providers/shopping_list_provider.dart';
import '../providers/auth_provider.dart';
import '../screens/shopping_item_screen.dart';

class ShoppingListTile extends StatelessWidget {
  final ShoppingList shoppingList;

  const ShoppingListTile({required this.shoppingList, Key? key}) : super(key: key);

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context, listen: false);
    final user = authProvider.user;

    return Slidable(
      key: ValueKey(shoppingList.id),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.50,
        children: shoppingList.owner == user?.uid
            ? [
                SlidableAction(
                  onPressed: (context) {
                    shoppingListProvider.deleteShoppingList(shoppingList.id);
                    _showSnackBar(context, 'List deleted');
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  onPressed: (context) {
                    shoppingListProvider.toggleNotifications(
                        shoppingList.id, !shoppingList.notificationsEnabled);
                    _showSnackBar(
                        context,
                        shoppingList.notificationsEnabled
                            ? 'Notifications disabled'
                            : 'Notifications enabled');
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: shoppingList.notificationsEnabled
                      ? Icons.notifications_off
                      : Icons.notifications,
                  label: shoppingList.notificationsEnabled
                      ? 'Disable Notifications'
                      : 'Enable Notifications',
                ),
              ]
            : [
                SlidableAction(
                  onPressed: (context) {
                    shoppingListProvider.toggleNotifications(
                        shoppingList.id, !shoppingList.notificationsEnabled);
                    _showSnackBar(
                        context,
                        shoppingList.notificationsEnabled
                            ? 'Notifications disabled'
                            : 'Notifications enabled');
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: shoppingList.notificationsEnabled
                      ? Icons.notifications_off
                      : Icons.notifications,
                  label: shoppingList.notificationsEnabled
                      ? 'Disable Notifications'
                      : 'Enable Notifications',
                ),
              ],
      ),
      child: ListTile(
        title: Text(shoppingList.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(shoppingList.owner == user?.uid ? 'Owner: ${shoppingList.ownerEmail}' : 'Shared with you'),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShoppingItemScreen(list: shoppingList),
            ),
          );
        },
      ),
    );
  }
}
