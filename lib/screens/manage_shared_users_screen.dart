// ignore_for_file: unused_import, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handlenoe/services/firestore_service.dart';

class ManageSharedUsersScreen extends StatefulWidget {
  final String listId;

  ManageSharedUsersScreen({required this.listId});

  @override
  _ManageSharedUsersScreenState createState() => _ManageSharedUsersScreenState();
}

class _ManageSharedUsersScreenState extends State<ManageSharedUsersScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<String> _sharedUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSharedUsers();
  }

  Future<void> _fetchSharedUsers() async {
    try {
      List<String> sharedUsers = await _firestoreService.getSharedUsers(widget.listId);
      setState(() {
        _sharedUsers = sharedUsers;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching shared users: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _unshareList(String userId) async {
    try {
      await _firestoreService.unshareListWithUser(widget.listId, userId);
      _fetchSharedUsers();
    } catch (e) {
      print('Error unsharing list: $e');
    }
  }

  Future<void> _updateNotificationSetting(bool isEnabled) async {
    try {
      await _firestoreService.updateNotificationSetting(widget.listId, isEnabled);
      _fetchSharedUsers();
    } catch (e) {
      print('Error updating notification setting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Shared Users'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _sharedUsers.length,
              itemBuilder: (context, index) {
                String userId = _sharedUsers[index];
                return ListTile(
                  title: Text(userId),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () {
                          _updateNotificationSetting(true);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications_off),
                        onPressed: () {
                          _updateNotificationSetting(false);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _unshareList(userId);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
