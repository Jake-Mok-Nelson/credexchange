import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Instructions extends StatelessWidget {
  const Instructions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Text(
              '''
          This tool is designed to be a one way transfer of credentials between you and another party.
          The credential can be the contents of a small text file or just a password.
          The password is encrypted by you on the client (your device) at upload time. The password is not stored by this system.
          
          A generated ID and password are output from the upload which must be given to the receiver.

          A password will expire after a few days from upload or the moment it is downloaded.
          ''',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
