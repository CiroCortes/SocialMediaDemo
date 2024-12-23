import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:social_demo/views/auth/signup.dart';
import 'package:social_demo/views/home/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  String? email;
  String? password;

  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
        ),
      ),
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(12.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
              ),
              onChanged: (value) {
                email = value;
              },
              validator: ValidationBuilder().email().maxLength(50).build(),
            ),
            const SizedBox(
              height: 12.0,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
              onChanged: (value) {
                password = value;
              },
              validator: ValidationBuilder().maxLength(14).minLength(6).build(),
            ),
            const SizedBox(
              height: 12.0,
            ),
            SizedBox(
              height: 40.0,
              child: ElevatedButton(
                onPressed: () async {
                  if (key.currentState?.validate() ?? false) {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email!,
                        password: password!,
                      );
                      if (mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'wrong-password') {
                        print('The password is wrong');
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                child: const Text("Login"),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Signup(),
                  ),
                );
              },
              child: const Text("Create an account"),
            )
          ],
        ),
      ),
    );
  }
}
