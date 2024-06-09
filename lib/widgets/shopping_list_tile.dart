import 'package:flutter/material.dart';
import '../models/shopping_list_model.dart';

class ShoppingListTile extends StatelessWidget {
  final ShoppingList shoppingList;
  final VoidCallback onTap;

  const ShoppingListTile({
    required this.shoppingList,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(shoppingList.name),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
