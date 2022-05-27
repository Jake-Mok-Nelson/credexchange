import 'package:flutter/material.dart';

class RetrieveCredentialForm extends StatefulWidget {
  const RetrieveCredentialForm({Key? key}) : super(key: key);

  @override
  _RetrieveCredentialFormState createState() => _RetrieveCredentialFormState();
}

class _RetrieveCredentialFormState extends State<RetrieveCredentialForm> {
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();

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
              _password = value.toString();
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

    void onPressedSubmit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

        print("Password: $_password");
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Form Submitted')));
      }
    }

    formWidget.add(ElevatedButton(
        onPressed: onPressedSubmit, child: const Text('Retrieve')));

    return formWidget;
  }
}
