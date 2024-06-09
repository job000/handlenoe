import 'package:flutter/material.dart';
import '../models/shopping_item_model.dart';
import '../providers/shopping_list_provider.dart';
import 'package:provider/provider.dart';

class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;
  final String listId;
  final String currentUserId;
  final String listOwnerId;

  const ShoppingItemTile({
    required this.item,
    required this.listId,
    required this.currentUserId,
    required this.listOwnerId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: (currentUserId == item.createdBy || currentUserId == listOwnerId)
          ? DismissDirection.endToStart
          : DismissDirection.none,
      onDismissed: (direction) {
        Provider.of<ShoppingListProvider>(context, listen: false)
            .deleteItemFromList(listId, item.id);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        title: Text(item.name),
        trailing: Checkbox(
          value: item.isBought,
          onChanged: (bool? value) {
            Provider.of<ShoppingListProvider>(context, listen: false)
                .updateItemInList(listId, item.copyWith(isBought: value!));
          },
        ),
      ),
    );
  }
}
