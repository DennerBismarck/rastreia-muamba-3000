import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/firebase_auth_service.dart';

class SignupCard extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _auth = FirebaseAuthService();

  SignupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: _emailController,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'Senha'),
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: const Text('Registrar'),
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
      //Get.toNamed("/fasttrack");
      await _auth.signInWithEmailAndPassword(email, password);
      Get.toNamed("/mytrack");
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Failed to sign up.')),
      );
    }
  }
}
