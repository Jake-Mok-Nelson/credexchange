# credexchange
One time sharing of credentials

## Description

I'm creating this project because I'm tired of using a variety of unreliable and complex processes for the transfer of credentials from one person to another.

## Instructions for Use

### Transferring to someone else

1. Open https://credexchange.web.app
2. Select the "Upload" tab.
3. Type in a credential that you'd like to transfer to another person and select "Upload".
4. Record the output ID and password; both of these are required for receiving.
5. Hand over the ID and password to the other person.

### Receiving from someone else

1. Open https://credexchange.web.app
2. Select the "Download" tab.
3. Enter the ID and the Password that you received from the other person.
4. Copy the returned credential; it is permanently deleted from the database at this point.

## How does it work

When the user presses the "Upload" button a few things happen:
1. A new random password is genereted.
2. The random password is used to encrypt the credential on the client.
3. Once the credential is encrypted locally, it is uploaded to the server.

This means that there is no practical way to decrypt the password as decryption would always appear to work but you would never know if you had the real credential.

The password being generated randomly at upload time reduced the likelyhood of brute-force or guessing.

To download the credential you need to know **both** the ID of the credential and it's password.

Decryption occurs on the client side also.

## Build & Release

### Frontend

> cd ./frontend

> flutter build web

### Backend

Note: Google auth and firebase auth may be required for the first deployment.

> firebase deploy

## Future Improvements

- Currently some values (like paths to functions and paths to the website for CORS) are static; these should be parameterised.
- The frontend could use some indication that the application is busy once the call to the backend has been made.
- I currently get an alert in Slack when people upload and download credentials (I don't see the content); this should be moved a proper analytics system if this is used.
- Change the verb of the "Upload" button to "Transfer" or "Store".
- Add a maximum time that a credential can live.
- Publish an API for the backend.
  - Replace the two separate functions for uploading and downloading with a single function that handles different HTTP methods correctly.
  - CLI to store and receive creds conveneiently.
