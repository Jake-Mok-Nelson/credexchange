import 'package:encryptor/encryptor.dart';
import 'package:flutter/material.dart';
import 'package:frontend/credentialService.dart';
import 'package:frontend/returnCredential.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RetrieveCredentialForm extends StatefulWidget {
  const RetrieveCredentialForm({Key? key}) : super(key: key);

  @override
  _RetrieveCredentialFormState createState() => _RetrieveCredentialFormState();
}

class _RetrieveCredentialFormState extends State<RetrieveCredentialForm> {
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();
  late Future<Credential> futureCredential;

  String _password = '';
  String _id = '';

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

    formWidget.add(
      TextFormField(
          key: _passKey,
          obscureText: true,
          decoration:
              const InputDecoration(hintText: 'ID', labelText: 'Enter ID'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter ID';
            } else {
              return null;
            }
          },
          onSaved: (value) {
            setState(() {
              _id = value.toString();
            });
          }),
    );

    formWidget.add(
      TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
              hintText: 'Enter Password', labelText: 'Enter Password'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter Password';
            } else {
              return null;
            }
          },
          onSaved: (value) {
            setState(() {
              _password = value.toString();
            });
          }),
    );

    Future<void> onPressedSubmit() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

        final data = {"id": _id};

        // Request the credential by passing the ID to retrieveCredential endpoint
        var uri = Uri.parse(
            'https://australia-southeast1-credexchange.cloudfunctions.net/retrieveCredential');

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
                  title: Text('Error'),
                  content: const Text(
                      'Error retrieving credential, confirm that ID is correct.'),
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
        // If response status is 200 then decode the response body
        if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);
          final credential = responseBody['credential'];

          // Decrypt the credential using the password
          final decrypted = Encryptor.decrypt(_password, credential);

          // If decrypted credential is not empty then navigate to ReturnCredential
          if (decrypted != '') {
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReturnCredential(
                  Credential: decrypted,
                ),
              ),
            );
          } else {
            // If decrypted credential is empty then show a snackbar
            const SnackBar(
              content: Text('Credential not found'),
            );
          }
        }
      }
    }

    formWidget.add(ElevatedButton(
        onPressed: onPressedSubmit, child: const Text('Retrieve')));

    return formWidget;
  }
}
