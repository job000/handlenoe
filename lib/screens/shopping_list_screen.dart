import 'package:flutter/material.dart';
import 'package:handlenoe/models/shopping_list_model.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_list_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/shopping_list_tile.dart';
import '../widgets/empty_state_icon.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  void _addShoppingList(BuildContext context) {
    final nameController = TextEditingController();
    final focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Shopping List'),
            content: TextField(
              controller: nameController,
              focusNode: focusNode,
              autofocus: true,
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
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  final newList = ShoppingList(
                    id: '',
                    name: nameController.text,
                    owner: authProvider.user?.uid ?? '',
                    ownerEmail: authProvider.user?.email ?? '',
                    sharedWith: [],
                    notificationsEnabled: false,
                    items: [],
                  );
                  Provider.of<ShoppingListProvider>(context, listen: false).addShoppingList(newList);
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ).then((_) {
        // Ensure focus is requested after the dialog is shown
        focusNode.requestFocus();
      });
    });
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
      body: StreamBuilder<List<ShoppingList>>(
        stream: shoppingListProvider.getShoppingListsStream(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final shoppingLists = snapshot.data ?? [];
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
