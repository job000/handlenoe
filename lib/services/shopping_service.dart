import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart'; // Add this import
import '../models/shopping_list_model.dart';
import '../models/shopping_item_model.dart';

class ShoppingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ShoppingList>> getShoppingLists(String userId) async {
    final ownedListsSnapshot = await _db
        .collection('shoppingLists')
        .where('owner', isEqualTo: userId)
        .get();
    
    final sharedListsSnapshot = await _db
        .collection('shoppingLists')
        .where('sharedWith', arrayContains: userId)
        .get();
    
    final ownedLists = ownedListsSnapshot.docs.map((doc) => ShoppingList.fromDocument(doc)).toList();
    final sharedLists = sharedListsSnapshot.docs.map((doc) => ShoppingList.fromDocument(doc)).toList();

    return [...ownedLists, ...sharedLists];
  }

  Stream<List<ShoppingList>> getShoppingListsStream(String userId) {
    final ownedListsStream = _db
        .collection('shoppingLists')
        .where('owner', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ShoppingList.fromDocument(doc)).toList());
    
    final sharedListsStream = _db
        .collection('shoppingLists')
        .where('sharedWith', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ShoppingList.fromDocument(doc)).toList());

    return CombineLatestStream.list([ownedListsStream, sharedListsStream]).map((lists) => lists.expand((list) => list).toList());
  }

  Stream<QuerySnapshot> getItemsForListStream(String listId) {
    return _db.collection('shoppingLists').doc(listId).collection('items').snapshots();
  }

  Future<List<ShoppingItem>> getItemsForList(String listId) async {
    final snapshot = await _db.collection('shoppingLists').doc(listId).collection('items').get();
    return snapshot.docs.map((doc) => ShoppingItem.fromDocument(doc)).toList();
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
    if (userSnapshot.docs.isNotEmpty) {
      final userId = userSnapshot.docs.first.id;
      await _db.collection('shoppingLists').doc(listId).update({
        'sharedWith': FieldValue.arrayUnion([userId])
      });
    } else {
      throw Exception('User not found');
    }
  }

  Future<void> toggleNotifications(String listId, bool enable) async {
    await _db.collection('shoppingLists').doc(listId).update({
      'notificationsEnabled': enable
    });
  }
}
