import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingItem {
  final String id;
  final String name;
  final bool isBought;
  final String createdBy;
  final Timestamp createdAt; // Add this line

  ShoppingItem({
    required this.id,
    required this.name,
    required this.isBought,
    required this.createdBy,
    required this.createdAt, // Add this line
  });

  factory ShoppingItem.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShoppingItem(
      id: doc.id,
      name: data['name'],
      isBought: data['isBought'],
      createdBy: data['createdBy'],
      createdAt: data['createdAt'], // Add this line
    );
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> data, String documentId) {
    return ShoppingItem(
      id: documentId,
      name: data['name'],
      isBought: data['isBought'],
      createdBy: data['createdBy'],
      createdAt: data['createdAt'], // Add this line
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isBought': isBought,
      'createdBy': createdBy,
      'createdAt': createdAt, // Add this line
    };
  }

  ShoppingItem copyWith({
    String? id,
    String? name,
    bool? isBought,
    String? createdBy,
    Timestamp? createdAt, // Add this line
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      isBought: isBought ?? this.isBought,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt, // Add this line
    );
  }
}
