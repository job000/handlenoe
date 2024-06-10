class NotificationSettings {
  String userId;
  String listId;
  bool notificationsEnabled;

  NotificationSettings({
    required this.userId,
    required this.listId,
    required this.notificationsEnabled,
  });

  factory NotificationSettings.fromMap(Map<String, dynamic> data) {
    return NotificationSettings(
      userId: data['userId'],
      listId: data['listId'],
      notificationsEnabled: data['notificationsEnabled'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'listId': listId,
      'notificationsEnabled': notificationsEnabled,
    };
  }
}
