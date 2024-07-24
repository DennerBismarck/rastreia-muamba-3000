import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/firebase_auth_service.dart';

class SignupCard extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _auth = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                controller: _emailController,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Senhaa'),
                controller: _passwordController,
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    bool signedUp = await _auth.createUserWithEmailAndPassword(email, password);
    if (signedUp) {
      Get.toNamed("/fasttrack");
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Failed to sign up.')),
      );
    }
  }
}
