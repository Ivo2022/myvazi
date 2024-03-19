import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Retrieve session_id from storage
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String sessionID = prefs.getString('session_id') ?? '';

            // Make network request with session_id
            String url = 'your_api_endpoint_here';
            Map<String, String> headers = {
              'Authorization': 'Bearer $sessionID'
            };
            http.Response response =
                await http.get(Uri.parse(url), headers: headers);

            // Handle response as needed
            if (response.statusCode == 200) {
              // Request was successful
              print('Request successful');
            } else {
              // Request failed
              print('Request failed with status code: ${response.statusCode}');
            }
          },
          child: Text('Make Network Request with Session ID'),
        ),
      ),
    );
  }
}
