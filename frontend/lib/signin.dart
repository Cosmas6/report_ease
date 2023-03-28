import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'package:report_ease/dashboard.dart';
import 'package:report_ease/signup.dart';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'user.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  final Logger logger = Logger('SignIn');
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future save() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var res = await http.post(Uri.parse("https://nodejs.tmwdp.co.ke/FlutterUserRoute/signin"),
          headers: <String, String>{
            'Content-Type': 'application/json;charSet=UTF-8'
          },
          body: jsonEncode(<String, String>{
            'email': user.email,
            'password': user.password
          }));

      developer.log(
        'Signin StatusCode',
        name: 'signin.statuscode.signin.dart',
        error: (res.statusCode),
      );

      var data = jsonDecode(res.body);

      if (!mounted) return;
      if (data['token'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        if (!mounted) return;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
      } else {
        setState(() {
          _isLoading = false;
        });

        String errorMessage = data['error'] ?? 'Failed to sign in';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e, stackTrace) {
      setState(() {
        _isLoading = false;
      });
      developer.log('Error in save function',
          name: 'signin.save', error: e, stackTrace: stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  User user = User('', '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
      key: _formKey,
      child: Column(
        key: const Key('column'),
        children: [
          SizedBox(
            child: SvgPicture.asset(
              'images/top.svg',
              fit: BoxFit.cover,
              width: 400,
              height: 150,
            ),
          ),
          Text(
            'Sign in',
            style: GoogleFonts.pacifico(
                fontWeight: FontWeight.bold, fontSize: 50, color: Colors.blue),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                key: const ValueKey('email-field'),
                controller: _emailController,
                onChanged: (value) {
                  user.email = value;
                },
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Enter Something';
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}")
                      .hasMatch(value!)) {
                    return 'Enter valid email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'Enter Email',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.blue)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.blue)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.red)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.red))),
              )),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                key: const ValueKey('password-field'),
                controller: _passwordController,
                onChanged: (value) {
                  user.password = value;
                },
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Enter Something';
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Enter Password',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.blue)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.blue)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.red)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.red))),
              )),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                  height: 50,
                  width: 400,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 400,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0))),
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                await save();
                              } else {}
                            },
                            child: const Text(
                              "SIGN IN",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      if (_isLoading)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black38,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                        ),
                    ],
                  ))),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
            child: Row(children: [
              const Text(
                "Don't have an Account ? ",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Signup()));
                },
                child: const Text(
                  "Sign up",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              )
            ]),
          )
        ],
      ),
    )));
  }
}
