import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/firebase_options.dart';
import 'package:my_notes/views/register_view.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Login',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Comic Sans MS',
          ),
        ),
        backgroundColor: Colors.transparent,)
        ,
      body: 
      FutureBuilder(
        future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,),
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.done:
              return Container(
                margin: EdgeInsetsGeometry.all(40.0),
                child: Column(
                  spacing: 20,
                  children: [
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                    ),
                    enableSuggestions: false,
                    autocorrect: false,

                    keyboardType: TextInputType.emailAddress,
                    ),
                  TextField(
                    controller: _password,
                    decoration: InputDecoration(
                      hintText: 'Enter your password'
                    ),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    ),
                    TextButton(
                      onPressed: loginUser,
                      style: ButtonStyle(),
                      child:  const Text('Login'),
                    ),
                    Padding(padding: EdgeInsetsGeometry.all(20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      const Text('Not registered yet?'),
                      TextButton(
                        style: ButtonStyle(
                          overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0),
                          ),
                        ),
                        child: const Text('Register here!'),
                        onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegisterView(),
                          ),
                        )
                      },)
                    ],
                    ),],
                ),
              );
          default:
            return const Text('Loading...');
          }
        }
      )
    );   
}

void loginUser() async {
  final email = _email.text;
  final password = _password.text;

  try {
    log('Attempting to log in with email: $email and password: $password', name: 'LoginView');
    final auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    log('User logged in: ${auth.user?.email}');
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'user-not-found':
        log('No user found for that email.');
        break;
      case 'wrong-password':
        log('Wrong password provided for that user.');
        break;
      default:
        log('Error: ${e.message} (${e.code})');
    }
  } catch (e) {
    log('An unexpected error occurred: $e');
  }
}
}
