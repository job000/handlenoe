import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shopping_list_model.dart';
import '../models/shopping_item_model.dart';
import '../services/shopping_service.dart';

class ShoppingListProvider with ChangeNotifier {
  final ShoppingService _shoppingService = ShoppingService();
  List<ShoppingList> _shoppingLists = [];
  bool _notificationsEnabled = false;

  List<ShoppingList> get shoppingLists => _shoppingLists;
  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> fetchShoppingLists(String userId) async {
    _shoppingLists = await _shoppingService.getShoppingLists(userId);
    for (var list in _shoppingLists) {
      list.items = await _shoppingService.getItemsForList(list.id);
    }
    notifyListeners();
  }

  Stream<List<ShoppingList>> getShoppingListsStream(String userId) {
    return _shoppingService.getShoppingListsStream(userId);
  }

  Stream<QuerySnapshot> getItemsForListStream(String listId) {
    return _shoppingService.getItemsForListStream(listId);
  }

  Future<void> addShoppingList(ShoppingList list) async {
    await _shoppingService.addShoppingList(list);
    notifyListeners();
  }

  Future<void> updateShoppingList(ShoppingList list) async {
    await _shoppingService.updateShoppingList(list);
    notifyListeners();
  }

  Future<void> deleteShoppingList(String listId) async {
    await _shoppingService.deleteShoppingList(listId);
    notifyListeners();
  }

  Future<void> addItemToList(String listId, ShoppingItem item) async {
    await _shoppingService.addItemToList(listId, item);
    notifyListeners();
  }

  Future<void> updateItemInList(String listId, ShoppingItem item) async {
    await _shoppingService.updateItemInList(listId, item);
    notifyListeners();
  }

  Future<void> deleteItemFromList(String listId, String itemId) async {
    await _shoppingService.deleteItemFromList(listId, itemId);
    notifyListeners();
  }

  Future<void> shareListWithUserByEmail(String listId, String email) async {
    await _shoppingService.shareListWithUserByEmail(listId, email);
    notifyListeners();
  }

  Future<void> toggleNotifications(String listId, bool enable) async {
    await _shoppingService.toggleNotifications(listId, enable);
    _notificationsEnabled = enable;
    notifyListeners();
  }

  bool notificationsEnabledForList(String listId) {
    final list = _shoppingLists.firstWhere(
      (list) => list.id == listId,
      orElse: () => ShoppingList(
        id: '', 
        name: '', 
        owner: '', 
        ownerEmail: '', // Add ownerEmail parameter here
        items: [], 
        sharedWith: [], 
        notificationsEnabled: false,
      ),
    );
    return list.notificationsEnabled;
  }
}
