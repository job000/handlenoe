import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/shopping_list_provider.dart';
import '../providers/auth_provider.dart';
import '../models/shopping_list_model.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({Key? key, required String listId}) : super(key: key);

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _selectedListId;

  void _shareList() async {
    if (_selectedListId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a list to share')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<ShoppingListProvider>(context, listen: false)
          .shareListWithUserByEmail(_selectedListId!, _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('List shared successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to share list')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);
    final userId = Provider.of<AuthProvider>(context).user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Share List'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  StreamBuilder<List<ShoppingList>>(
                    stream: shoppingListProvider.getShoppingListsStream(userId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final shoppingLists = snapshot.data ?? [];
                      return DropdownButton<String>(
                        hint: const Text('Select a list to share'),
                        value: _selectedListId,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedListId = newValue;
                          });
                        },
                        items: shoppingLists.map<DropdownMenuItem<String>>((ShoppingList list) {
                          return DropdownMenuItem<String>(
                            value: list.id,
                            child: Text(list.name),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'User Email',
                      hintText: 'Enter the email of the user to share with',
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: (_emailController.text.isNotEmpty)
                          ? FirebaseFirestore.instance
                              .collection('users')
                              .where('email', isGreaterThanOrEqualTo: _emailController.text)
                              .where('email', isLessThanOrEqualTo: '${_emailController.text}\uf8ff')
                              .snapshots()
                          : const Stream.empty(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final users = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return ListTile(
                              title: Text(user['email']),
                              onTap: () {
                                _emailController.text = user['email'];
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _shareList,
                    child: const Text('Share'),
                  ),
                ],
              ),
            ),
    );
  }
}
