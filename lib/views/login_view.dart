import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/firebase_options.dart';
import 'package:my_notes/views/main_view.dart';
import 'package:my_notes/views/register_view.dart';
import 'package:my_notes/widgets/page_title.dart';


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
    const pageTitle = PageTitle('Sign in');
    return Scaffold(
      appBar: AppBar(
        title: pageTitle,
        toolbarHeight: pageTitle.getHeight(),
      ),
      body: 
      FutureBuilder(
        future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,),
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.done:
              return Container(
                margin: EdgeInsetsGeometry.all(40.0),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 25.0,
                    children: [
                      TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 18.0),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Enter your email',
                      ),
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      ),
                    TextField(
                      controller: _password,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 18.0),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Enter your password'
                      ),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      ),
                      TextButton(
                        onPressed: () {
                          log('Forgot my password!');
                        },
                        style: ButtonStyle(
                          overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0),
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('Forgot your password?', style: TextStyle(color: Colors.black87,)),
                        ),
                      ),
                      TextButton(
                        onPressed: loginUser,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.redAccent),
                          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                            minimumSize: WidgetStateProperty.all<Size>(
                            const Size.fromHeight(48), // set button height
                            ),
                            padding: WidgetStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(vertical: 14.0),
                            ),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            ),
                          ),
                        child:  const Text('Sign in', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                      ),
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
                          child: const Text('Sign up', style: TextStyle(color: Colors.redAccent,)),
                          onPressed: () => {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const RegisterView(),
                            ),
                          )
                        },)
                      ],
                      ),
                      const SizedBox(height: 5.0,),
                        Row(
                        children: [
                          Expanded(
                          child: Divider(
                            color: Colors.grey[400],
                            thickness: 1,
                          ),
                          ),
                          Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            'OR',
                            style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            ),
                          ),
                          ),
                          Expanded(
                          child: Divider(
                            color: Colors.grey[400],
                            thickness: 1,
                          ),
                          ),
                        ],
                        ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            log('Attempting to sign in with Google', name: 'LoginView');
                            final provider = GoogleAuthProvider();
                            final auth = await FirebaseAuth.instance.signInWithPopup(provider);
                            log('User signed in with Google: ${auth.user?.email}');
                          } catch (e) {
                            log('Google sign-in failed: $e', name: 'LoginView');
                          }
                        },
                        icon: Image.asset(
                          'assets/google_logo.png',
                          height: 24,
                          width: 24,
                        ),
                        label: const Text('Sign in with Google'),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
                          shadowColor: WidgetStateProperty.all(Colors.transparent),
                          foregroundColor: WidgetStateProperty.all<Color>(Colors.black87),
                          minimumSize: WidgetStateProperty.all<Size>(
                            const Size.fromHeight(48), // set button height
                            ),
                            side: WidgetStateProperty.all<BorderSide>(
                            const BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(vertical: 14.0),
                          ),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                          ),
                        ),
                      ),
                      ],
                  ),
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
    navigateToMainPage();
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

void navigateToMainPage() {
    Navigator.of(context).pushReplacement(
    MaterialPageRoute(
          builder: (context) => const MainView(),
        )
  );
}
}
