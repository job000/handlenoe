import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shopping_list_model.dart';
import '../models/shopping_item_model.dart';

class ShoppingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ShoppingList>> getShoppingLists(String userId) async {
    QuerySnapshot snapshot = await _db.collection('shoppingLists').where('owner', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => ShoppingList.fromDocument(doc)).toList();
  }

  Stream<QuerySnapshot> getShoppingListsStream(String userId) {
    return _db.collection('shoppingLists').where('owner', isEqualTo: userId).snapshots();
  }

  Future<void> addShoppingList(ShoppingList list) async {
    await _db.collection('shoppingLists').add(list.toMap());
  }

  Future<void> updateShoppingList(ShoppingList list) async {
    await _db.collection('shoppingLists').doc(list.id).update(list.toMap());
  }

  Future<void> deleteShoppingList(String listId) async {
    await _db.collection('shoppingLists').doc(listId).delete();
  }

  Future<void> addItemToList(String listId, ShoppingItem item) async {
    await _db.collection('shoppingLists').doc(listId).collection('items').add(item.toMap());
  }

  Future<void> updateItemInList(String listId, ShoppingItem item) async {
    await _db.collection('shoppingLists').doc(listId).collection('items').doc(item.id).update(item.toMap());
  }

  Future<void> deleteItemFromList(String listId, String itemId) async {
    await _db.collection('shoppingLists').doc(listId).collection('items').doc(itemId).delete();
  }

  Future<void> shareListWithUserByEmail(String listId, String email) async {
    final userSnapshot = await _db.collection('users').where('email', isEqualTo: email).get();
    if (userSnapshot.docs.isEmpty) {
      throw Exception('User not found');
    }
    final userId = userSnapshot.docs.first.id;

    await _db.collection('shoppingLists').doc(listId).update({
      'sharedWith': FieldValue.arrayUnion([userId]),
    });

    await _db.collection('users').doc(userId).update({
      'sharedLists': FieldValue.arrayUnion([listId]),
    });
  }

  Future<void> toggleNotifications(String listId, bool enable) async {
    DocumentReference listRef = _db.collection('shoppingLists').doc(listId);
    await listRef.update({'notificationsEnabled': enable});
  }

  Future<List<ShoppingItem>> getItemsForList(String listId) async {
    QuerySnapshot snapshot = await _db.collection('shoppingLists').doc(listId).collection('items').get();
    return snapshot.docs.map((doc) => ShoppingItem.fromDocument(doc)).toList();
  }

  Stream<QuerySnapshot> getItemsForListStream(String listId) {
    return _db.collection('shoppingLists').doc(listId).collection('items').snapshots();
  }
}
