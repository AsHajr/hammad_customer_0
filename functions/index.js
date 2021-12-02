const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendPointsMassage = functions.database.ref("/users/{uId}/points")
    .onUpdate((change, context)=> {
      const newPoints = change.after.val();
      const oldPoints = change.before.val();
      const points = newPoints - oldPoints;
      const uId = context.params.uId;
      if (oldPoints >= newPoints) {
        return;
      }
      const payload = {
        notification: {
          title: "Hooray",
          body: `${points} added to your points`,
        },
      };
      const databaseRoot = change.before.ref.root;
      return databaseRoot.child("users/" + uId)
          .once("value")
          .then((snapshot) => {
            const fcmToken = snapshot.val().fcmToken;
            return admin.messaging().sendToDevice(fcmToken, payload);
          });
    });
