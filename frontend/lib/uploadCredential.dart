import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:encryptor/encryptor.dart';
import 'package:frontend/returnDetails.dart';
import 'package:random_password_generator/random_password_generator.dart';
import 'package:http/http.dart' as http;

class UploadCredentialForm extends StatefulWidget {
  const UploadCredentialForm({Key? key}) : super(key: key);

  @override
  _UploadCredentialFormState createState() => _UploadCredentialFormState();
}

class _UploadCredentialFormState extends State<UploadCredentialForm> {
  final _formKey = GlobalKey<FormState>();

  String _credential = '';

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
        key: _formKey,
        child: ListView(
          children: getFormWidget(),
        ));
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = [];

    formWidget.add(TextFormField(
      minLines: 1,
      maxLines: 5, // allow user to enter 5 line in textfield
      keyboardType: TextInputType
          .multiline, // user keyboard will have a button to move cursor to next line

      decoration: const InputDecoration(
          labelText: 'Credential to store', hintText: 'Credential'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please type or paste a credential';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _credential = value.toString();
        });
      },
    ));

    Future<void> onPressedSubmit() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

        // Generate a password
        final password = RandomPasswordGenerator();
        final newPassword = password.randomPassword(
          letters: true,
          numbers: true,
          passwordLength: 20,
          specialChar: true,
          uppercase: true,
        );

        // Encrypt the credential using the generated password
        var encrypted = Encryptor.encrypt(newPassword, _credential);

        // Store credential for upload
        final data = {"credential": encrypted};

        // Upload credential via HTTP POST to the server
        var uri = Uri.parse(
            'https://australia-southeast1-credexchange.cloudfunctions.net/storeCredential');
        final response = await http.post(
          uri,
          body: json.encode(data),
          headers: {
            'Content-Type': 'application/json',
          },
        ).catchError((error) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text('Error uploading credential: $error'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        });

        // If response is 200 then navigate to ReceiverDetails
        if (response.statusCode == 200) {
          // Decode response body
          final responseBody = json.decode(response.body);

          // Get the ID from the decoded response body
          final ID = responseBody['id'];

          // If ID or newPassword is empty then show error message
          if (ID.isEmpty || newPassword.isEmpty) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text(
                      'Something went wrong, ID or Password is empty.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            // Navigate to ReceiverDetails
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecieverDetails(
                  ID: ID,
                  Password: newPassword,
                ),
              ),
            );
          }
        } else {
          // Show error in a Snackbar
          SnackBar(
            content: Text('Error: ${response.statusCode}'),
          );
        }
      }
    }

    formWidget.add(ElevatedButton(
        onPressed: onPressedSubmit, child: const Text('Upload')));

    return formWidget;
  }
}
