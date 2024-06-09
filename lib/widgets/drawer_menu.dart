import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/shopping_list_provider.dart';
import '../screens/settings_screen.dart';
import '../screens/search_screen.dart';
import '../screens/share_screen.dart';
import '../screens/shopping_item_screen.dart';
import '../models/shopping_list_model.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);
    final user = authProvider.user;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'User'),
            accountEmail: Text(user?.email ?? 'Email'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user?.photoURL ?? 'https://example.com/default-avatar.png'),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share List'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShareScreen(listId: '')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Shopping Lists'),
          ),
          StreamBuilder(
            stream: shoppingListProvider.getShoppingListsStream(user?.uid ?? ''),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final shoppingLists = snapshot.data!.docs.map((doc) => ShoppingList.fromDocument(doc)).toList();
              return Column(
                children: shoppingLists.map((list) {
                  return ListTile(
                    title: Text(list.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShoppingItemScreen(list: list),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
