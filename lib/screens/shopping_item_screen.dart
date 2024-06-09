import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shopping_list_model.dart';
import '../models/shopping_item_model.dart';
import '../providers/shopping_list_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/shopping_item_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingItemScreen extends StatelessWidget {
  final ShoppingList list;

  const ShoppingItemScreen({required this.list, Key? key}) : super(key: key);

  void _addItem(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Item Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final newItem = ShoppingItem(
                  id: '',
                  name: nameController.text,
                  isBought: false,
                  createdBy: authProvider.user?.uid ?? '',
                );
                Provider.of<ShoppingListProvider>(context, listen: false).addItemToList(list.id, newItem);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(list.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addItem(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: shoppingListProvider.getItemsForListStream(list.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!.docs.map((doc) => ShoppingItem.fromDocument(doc)).toList();
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ShoppingItemTile(
                item: item,
                listId: list.id, // Added listId to the parameters
              );
            },
          );
        },
      ),
    );
  }
}
