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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context, listen: false);
    final user = authProvider.user;

    return Slidable(
      key: ValueKey(shoppingList.id),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: shoppingList.owner == user?.uid
            ? [
                SlidableAction(
                  onPressed: (context) {
                    shoppingListProvider.deleteShoppingList(shoppingList.id);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ]
            : [],
      ),
      child: ListTile(
        title: Text(shoppingList.name),
        subtitle: Text(shoppingList.owner == user?.uid ? 'Owner' : 'Shared with you'),
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
