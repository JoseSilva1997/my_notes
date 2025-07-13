import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/firebase_options.dart';
import 'package:my_notes/views/login_view.dart';
import 'package:my_notes/widgets/page_title.dart';
import 'package:my_notes/models/user_model.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _password = TextEditingController();
  late final TextEditingController _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
  final email = _email.text.trim();
  final password = _password.text;
  final confirmation = _confirmPassword.text;

  if (password != confirmation) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Passwords do not match.')),
    );
    return;
  }

  try {
    final userCredentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    log('User registered: $email', name: 'RegisterView');

    // Create a user profile in Firestore
    await addUserToFirestore(userCredentials);

  } on FirebaseAuthException catch (e) {
    String message;
    switch (e.code) {
      case 'weak-password':
        message = 'Weak password';
        break;
      case 'email-already-in-use':
        message = 'Email already in use';
        break;
      case 'invalid-email':
        message = 'Invalid email';
        break;
      default:
        message = 'Registration failed';
    }
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    log(message, name: 'RegisterView');
  }
}

  Future<void> addUserToFirestore(UserCredential userCredentials) async {
    // Create a user profile in Firestore
    final user = userCredentials.user;
    if (user != null) {
      final userProfile = UserProfile(
        id: user.uid,
        email: user.email ?? '',
      );
    await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .set(userProfile.toFirestore());
    }
  }

  @override
  Widget build(BuildContext context) {
    const pageTitle = PageTitle('Sign up');
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
                    TextField(
                      controller: _confirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 18.0),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Re-enter your password'
                      ),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      ),
                      SizedBox(height: 10.0,),
                      TextButton(
                        onPressed: registerUser,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.redAccent),
                          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                            minimumSize: WidgetStateProperty.all<Size>(
                              const Size.fromHeight(48),
                            ),
                            padding: WidgetStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(vertical: 14.0),
                            ),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              )
                            )
                        ),
                        child:  const Text('Sign up', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        const Text('Already have an account?'),
                        TextButton(
                          style: ButtonStyle(
                            overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                            padding: WidgetStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0),
                            ),
                          ),
                          child: const Text('Sign in', style: TextStyle(color: Colors.redAccent,)),
                          onPressed: () => {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginView(),
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
                        label: const Text('Sign up with Google'),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
                          shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
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
} 
