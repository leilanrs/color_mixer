// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}
class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  String _userID = '';
  void doLogin() async {
    //later, we use web service here to check the user id and password
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user_id", _userID);
    main();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Login'),
      // ),
      body: Container(
        height: 500,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 20), 
            child: const Text("COLOR MIXER", style: const TextStyle(fontSize: 26),),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: ((value) {
                _userID = value;
              }),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                hintText: 'Enter valid username'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            //padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter secure password'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () {
                  doLogin();
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            )
          ),

        ]),
      )
    );
  }
}

