import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Credential> fetchCredential(String id) async {
  final data = {"id": id};

  // Request the credential by passing the ID to retrieveCredential endpoint
  var uri = Uri.parse(
      'https://australia-southeast1-credexchange.cloudfunctions.net/retrieveCredential');
  final response = await http.post(
    uri,
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return Credential.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to retrieve credential');
  }
}

class Credential {
  final String id;
  final String credential;

  const Credential({
    required this.id,
    required this.credential,
  });

  factory Credential.fromJson(Map<String, dynamic> json) {
    return Credential(
      id: json['id'],
      credential: json['credential'],
    );
  }
}
