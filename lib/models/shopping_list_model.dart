import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shopping_item_model.dart';

class ShoppingList {
  final String id;
  final String name;
  final String owner;
  final List<String> sharedWith;
  final bool notificationsEnabled;
  List<ShoppingItem> items;

  ShoppingList({
    required this.id,
    required this.name,
    required this.owner,
    required this.sharedWith,
    required this.notificationsEnabled,
    required this.items,
  });

  factory ShoppingList.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ShoppingList(
      id: doc.id,
      name: data['name'] ?? '',
      owner: data['owner'] ?? '',
      sharedWith: List<String>.from(data['sharedWith'] ?? []),
      notificationsEnabled: data['notificationsEnabled'] ?? false,
      items: (data['items'] as List<dynamic>?)
          ?.map((item) => ShoppingItem.fromMap(item, ''))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'owner': owner,
      'sharedWith': sharedWith,
      'notificationsEnabled': notificationsEnabled,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}
