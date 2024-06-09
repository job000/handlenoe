// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shopping_list_model.dart';
import '../providers/shopping_list_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/shopping_list_tile.dart';
import '../widgets/empty_state_icon.dart';
import '../screens/shopping_item_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  void _addShoppingList(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Shopping List'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'List Name'),
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
                final newList = ShoppingList(
                  id: '',
                  name: nameController.text,
                  owner: Provider.of<AuthProvider>(context, listen: false).user?.uid ?? '',
                  sharedWith: [],
                  notificationsEnabled: false,
                  items: [], // Ensure items field is included
                );
                Provider.of<ShoppingListProvider>(context, listen: false).addShoppingList(newList);
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
    final userId = Provider.of<AuthProvider>(context).user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Lists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addShoppingList(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: shoppingListProvider.getShoppingListsStream(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final shoppingLists = snapshot.data!.docs.map((doc) => ShoppingList.fromDocument(doc)).toList();
          if (shoppingLists.isEmpty) {
            return const Center(child: EmptyStateIcon());
          }
          return ListView.builder(
            itemCount: shoppingLists.length,
            itemBuilder: (context, index) {
              final list = shoppingLists[index];
              return ShoppingListTile(
                shoppingList: list,
              );
            },
          );
        },
      ),
    );
  }
}
