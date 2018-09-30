// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
exports.sendAdminNotification = functions.https.onCall((data, context) => {
    const payload = {notification: {
            title: 'Ring Ring!',
            body: `This is the body`
        }
    };

    console.log('Sending notification to group: ', data["ownerID"]);
    admin.messaging().sendToTopic(data["ownerID"], payload)
        .then((response) => {
            return console.log('Successfully sent message:', response);
        })
        .catch((error) => {
            return console.log('Error sending message:', error);
        });
});
