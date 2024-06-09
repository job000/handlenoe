import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingItem {
  final String id;
  final String name;
  final bool isBought;
  final String createdBy;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.isBought,
    required this.createdBy,
  });

  factory ShoppingItem.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShoppingItem(
      id: doc.id,
      name: data['name'],
      isBought: data['isBought'],
      createdBy: data['createdBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isBought': isBought,
      'createdBy': createdBy,
    };
  }

  ShoppingItem copyWith({String? id, String? name, bool? isBought, String? createdBy}) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      isBought: isBought ?? this.isBought,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
