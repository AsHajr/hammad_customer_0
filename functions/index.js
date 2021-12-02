const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendPointsMassage = functions
.database
.ref('/users/{position}')
.onUpdate((change)=> {

    const oldUser = change.before.val();
    const newUser = change.after.val();

    if(oldUser.points >= newUser.points){return;}

    const payload = {
        notification: {
            title: `${newUser.points} your points`,
            body:'hi',
            }
        };
        const databaseRoot = change.before.ref.root;
        return databaseRoot.child('users/'+ oldUser.uId).once('value')
        .then((snapshot)=>{
        const fcmToken = snapshot.val().fcmToken;
        return admin.messaging.sendToDevice(fcmToken, payload);
        });
    });


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
