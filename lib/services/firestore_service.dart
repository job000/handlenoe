import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/shopping_list_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveShoppingList(ShoppingList shoppingList) {
    return _firestore
        .collection('shoppingLists')
        .doc(shoppingList.id)
        .set(shoppingList.toMap());
  }

  Stream<List<ShoppingList>> getShoppingLists() {
    return _firestore.collection('shoppingLists').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ShoppingList.fromDocument(doc)).toList());
  }

  Future<void> updateNotificationSetting(String listId, bool isEnabled) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    String userId = user.uid;

    DocumentReference listRef = _firestore.collection('shoppingLists').doc(listId);

    DocumentSnapshot listSnapshot = await listRef.get();

    if (!listSnapshot.exists) {
      throw Exception('List does not exist');
    }

    Map<String, dynamic> listData = listSnapshot.data() as Map<String, dynamic>;

    if (listData['owner']['ownerId'] == userId) {
      // Update owner's notification setting
      await listRef.update({
        'owner.notificationsEnabled': isEnabled,
      });
    } else {
      // Update shared user's notification setting
      List<dynamic> sharedWith = listData['sharedWith'];
      for (var i = 0; i < sharedWith.length; i++) {
        if (sharedWith[i]['ownerId'] == userId) {
          sharedWith[i]['notificationsEnabled'] = isEnabled;
        }
      }
      await listRef.update({'sharedWith': sharedWith});
    }
  }

  Future<void> shareListWithUser(String listId, String userEmail) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    DocumentReference listRef = _firestore.collection('shoppingLists').doc(listId);
    QuerySnapshot userSnapshot = await _firestore.collection('users').where('email', isEqualTo: userEmail).limit(1).get();

    if (userSnapshot.docs.isEmpty) {
      throw Exception('User with email $userEmail not found');
    }

    DocumentReference userRef = userSnapshot.docs.first.reference;
    Map<String, dynamic> userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot listSnapshot = await transaction.get(listRef);

      if (!listSnapshot.exists) {
        throw Exception('List does not exist');
      }

      Map<String, dynamic> listData = listSnapshot.data() as Map<String, dynamic>;

      if (listData['owner']['ownerId'] != user.uid) {
        throw Exception('Only the owner can share this list');
      }

      List<dynamic> sharedWith = listData['sharedWith'];
      sharedWith.add({
        'ownerId': userRef.id,
        'ownerEmail': userData['email'],
        'notificationsEnabled': false,
      });

      transaction.update(listRef, {
        'sharedWith': sharedWith,
      });
    });
  }

  Future<void> unshareListWithUser(String listId, String userId) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    DocumentReference listRef = _firestore.collection('shoppingLists').doc(listId);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot listSnapshot = await transaction.get(listRef);

      if (!listSnapshot.exists) {
        throw Exception('List does not exist');
      }

      Map<String, dynamic> listData = listSnapshot.data() as Map<String, dynamic>;

      if (listData['owner']['ownerId'] != user.uid) {
        throw Exception('Only the owner can unshare this list');
      }

      List<dynamic> sharedWith = listData['sharedWith'];
      sharedWith.removeWhere((user) => user['ownerId'] == userId);

      transaction.update(listRef, {
        'sharedWith': sharedWith,
      });
    });
  }

  Future<List<String>> getSharedUsers(String listId) async {
    DocumentSnapshot listSnapshot = await _firestore.collection('shoppingLists').doc(listId).get();

    if (!listSnapshot.exists) {
      throw Exception('List does not exist');
    }

    Map<String, dynamic> listData = listSnapshot.data() as Map<String, dynamic>;

    if (listData['sharedWith'] != null) {
      return List<String>.from(listData['sharedWith'].map((user) => user['ownerId']));
    } else {
      return [];
    }
  }
}
