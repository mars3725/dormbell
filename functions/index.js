// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
exports.ringUser = functions.https.onCall((data, context) => {
    const payload = {notification: {
            title: 'Ring Ring!',
            body: `${data["ringerName"]} is here to see you`
        }
    };

    admin.messaging().sendToTopic(data["ownerID"], payload)
        .then((response) => {
            return console.log('Successfully sent message:', response);
        })
        .catch((error) => {
            return console.log('Error sending message:', error);
        });
});

exports.messageUser = functions.https.onCall((data, context) => {
    const payload = {notification: {
            title: 'Ring Ring!',
            body: `${data["ringerName"]} says "${data["message"]}"`
        }
    };

    admin.messaging().sendToTopic(data["ownerID"], payload)
        .then((response) => {
            return console.log('Successfully sent message:', response);
        })
        .catch((error) => {
            return console.log('Error sending message:', error);
        });
});
