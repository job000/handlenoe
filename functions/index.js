/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotification = functions.firestore
    .document("shoppingLists/{listId}/items/{itemId}")
    .onCreate(async (snap, context) => {
      const listId = context.params.listId;
      const newItem = snap.data();

      // Get the list document
      // eslint-disable-next-line max-len
      const listDoc = await admin.firestore().collection("shoppingLists").doc(listId).get();
      const listData = listDoc.data();

      // Get the owner and sharedWith users
      const owner = listData.owner;
      const sharedWith = listData.sharedWith || [];

      // Add the owner to the list of users to notify
      const usersToNotify = [owner, ...sharedWith];

      // Get the FCM tokens for these users
      const tokensPromises = usersToNotify.map(async (userId) => {
        const userDoc = await admin.firestore().collection("users").doc(userId).get();
        const userData = userDoc.data();
        return userData.fcmToken;
      });

      const tokens = await Promise.all(tokensPromises);

      // Filter out null or undefined tokens
      const validTokens = tokens.filter((token) => token != null);

      // Create the notification payload
      const payload = {
        notification: {
          title: "New Item Added",
          body: `A new item named "${newItem.name}" was added to your list.`,
        },
        data: {
          listId: listId,
        },
      };

      // Send the notification to all valid tokens
      if (validTokens.length > 0) {
        await admin.messaging().sendToDevice(validTokens, payload);
      }
    });
