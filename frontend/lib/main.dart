import 'package:flutter/material.dart';
import 'package:report_ease/signin.dart';
import 'package:report_ease/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Widget _startWidget = const Signin();

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      final List<String> tokenParts = token.split('.');
      if (tokenParts.length != 3) {
        return;
      }

      final String payload = _decodeBase64(tokenParts[1]);
      final Map<String, dynamic> payloadMap = json.decode(payload);

      if (payloadMap.containsKey('exp')) {
        final int currentTimeInSeconds =
            DateTime.now().millisecondsSinceEpoch ~/ 1000;
        final int expirationTimeInSeconds = payloadMap['exp'];

        if (currentTimeInSeconds < expirationTimeInSeconds) {
          setState(() {
            _startWidget = const Dashboard();
          });
        }
      }
    }
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    while (output.length % 4 != 0) {
      output += '=';
    }
    return utf8.decode(base64Url.decode(output));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: _startWidget,
    );
  }
}
