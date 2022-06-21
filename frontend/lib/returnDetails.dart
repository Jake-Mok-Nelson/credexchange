import 'package:flutter/material.dart';

class RecieverDetails extends StatelessWidget {
  const RecieverDetails({Key? key, required this.ID, required this.Password})
      : super(key: key);
  final String ID;
  final String Password;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Receiver Details'),
      content: SelectableText(
        '''
Please provide the following details for the receiver:

ID: $ID
Password: $Password
          ''',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
