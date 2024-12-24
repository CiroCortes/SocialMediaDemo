import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:social_demo/views/home/home.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // TODO : ensure that the username is unique befor registering

  String? username;
  String? email;
  String? password;

  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign Up",
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
                labelText: "Username",
              ),
              onChanged: (value) {
                username = value;
              },
              validator: ValidationBuilder().maxLength(10).build(),
            ),
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
                    //
                    print(email);
                    //
                    try {
                       UserCredential usercred =  await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email!,
                        password: password!,
                      );

                      if (usercred.user != null){
                          // add to database all data 
                          var data = {
                            'username' : username,
                            'email' : email,
                            'created_at': DateTime.now(),

                          };
                          await FirebaseFirestore.instance
                                .collection('users')
                                .doc(usercred.user!.uid)
                                .set(data);
                      }

                      if (mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                child: const Text("Sign Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
