import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../models/shopping_item_model.dart';
import '../providers/shopping_list_provider.dart';
import '../providers/auth_provider.dart';

class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;
  final String listId;

  const ShoppingItemTile({required this.item, required this.listId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context, listen: false);
    final user = authProvider.user;

    return Slidable(
      key: ValueKey(item.id),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: item.createdBy == user?.uid
                ? (context) {
                    shoppingListProvider.deleteItemFromList(listId, item.id);
                  }
                : null,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(item.name),
        trailing: Checkbox(
          value: item.isBought,
          onChanged: (value) {
            shoppingListProvider.updateItemInList(listId, item.copyWith(isBought: value ?? false));
          },
        ),
      ),
    );
  }
}
