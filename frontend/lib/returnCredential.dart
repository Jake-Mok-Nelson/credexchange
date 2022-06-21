import 'package:flutter/material.dart';

class ReturnCredential extends StatelessWidget {
  const ReturnCredential({Key? key, required this.Credential})
      : super(key: key);
  final String Credential;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Receiver Details'),
      content: SelectableText(Credential),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
