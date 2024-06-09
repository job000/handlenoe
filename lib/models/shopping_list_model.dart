import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingList {
  final String id;
  final String name;
  final String owner;
  final List<String> sharedWith;
  final bool notificationsEnabled;
  List<String> items;

  ShoppingList({
    required this.id,
    required this.name,
    required this.owner,
    required this.sharedWith,
    required this.notificationsEnabled,
    required this.items,
  });

  factory ShoppingList.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    return ShoppingList(
      id: doc.id,
      name: data?['name'] ?? '',
      owner: data?['owner'] ?? '',
      sharedWith: List<String>.from(data?['sharedWith'] ?? []),
      notificationsEnabled: data?['notificationsEnabled'] ?? false,
      items: List<String>.from(data?['items'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'owner': owner,
      'sharedWith': sharedWith,
      'notificationsEnabled': notificationsEnabled,
      'items': items,
    };
  }
}
