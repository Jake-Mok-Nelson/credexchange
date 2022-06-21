const functions = require("firebase-functions");
const admin = require('firebase-admin');
const { initializeApp } = require("firebase-admin");
const axios = require('axios');
const escapeHtml = require('escape-html');

// CORS Express middleware to enable CORS Requests.
const cors = require('cors')({
  origin: 'https://credexchange.web.app',
});
admin.initializeApp();

// Since this code will be running in the Cloud Functions environment
// we call initialize Firestore without any arguments because it
// detects authentication from the environment.
const firestore = admin.firestore();

exports.storeCredential = functions
    .region("australia-southeast1")
    .https.onRequest( (request, response) => {
        // [START usingMiddleware]
        // Enable CORS using the `cors` express middleware.
        cors(request, response, async () => {
          functions.logger.log('Request received', escapeHtml(request));
          const encryptedCred = escapeHtml(request.body.credential);
          // Get bytes of encryptedCred
          const encryptedCredBytes = Buffer.from(encryptedCred);
          if (encryptedCredBytes.length === 0) { 
              response.status(400).send('No credential provided');
          } else if (encryptedCredBytes.length > 102400) {
              response.status(400).send('Credential is too large');
          }

              // Get encrypted credential from firestore
          const writeResult = await admin.firestore().collection('credentials').add({credential:encryptedCred})
            .catch(error => {
                functions.logger.error(error);
                response.status(500).send("error storing credential");
            });
        
          // Return the credential ID
          response.json({result: `Credential with ID: ${writeResult.id} added.`, id: writeResult.id});
        });
    });

exports.retrieveCredential = functions
    .region("australia-southeast1")
    .https.onRequest((request, response) => {
        // [START usingMiddleware]
        // Enable CORS using the `cors` express middleware.
        cors(request, response, async () => {
          functions.logger.log('Request received', request);
          const credentialId = escapeHtml(request.body.id);
          
          // Retrive credential from firestore
          const readResult = await admin.firestore().collection('credentials').doc(credentialId).get().catch(error => {
              functions.logger.error(error);
              response.status(500).send("error retrieving credential");
          });

          admin.firestore().collection('credentials').doc(credentialId).delete().catch(error => {
              functions.logger.error(error);
              response.status(500).send();
          });
          
          // If it exists then return it
          response.status(200).json({credential: readResult.data().credential, id: credentialId});
        });
    });

exports.NotifyOfNewCred = functions
    .region("australia-southeast1")
    .firestore.document('/credentials/{documentId}')
    .onCreate((snap, context) => {
        return axios.post(
            functions.config().slack.webhook_url,
            {
              blocks: [
                {
                  type: 'section',
                  text: {
                    type: 'mrkdwn',
                    text: "New Credential Stored"
                  }
                },
                {
                  type: 'divider'
                },
                {
                  type: 'section',
                  text: {
                    type: 'mrkdwn',
                    text: "Debug: ID is " + snap.id,
                  }
                }
              ]
            }
          );
    });

exports.NotifyOfCredRemoved = functions
    .region("australia-southeast1")
    .firestore.document('/credentials/{documentId}')
    .onDelete((snap, context) => {
        return axios.post(
            functions.config().slack.webhook_url,
            {
              blocks: [
                {
                  type: 'section',
                  text: {
                    type: 'mrkdwn',
                    text: "Credential Removed"
                  }
                },
                {
                  type: 'divider'
                },
                {
                  type: 'section',
                  text: {
                    type: 'mrkdwn',
                    text: "Debug: ID is " + snap.id,
                  }
                }
              ]
            }
          );
    });
