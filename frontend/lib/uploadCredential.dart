import 'package:flutter/material.dart';

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

    void onPressedSubmit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

        print("Credential: $_credential");
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Form Submitted')));
      }
    }

    formWidget.add(ElevatedButton(
        onPressed: onPressedSubmit, child: const Text('Upload')));

    return formWidget;
  }
}
