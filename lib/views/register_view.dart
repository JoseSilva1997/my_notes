import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
        backgroundColor: Colors.blue,)
        ,
      body: 
      FutureBuilder(
        future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,),
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.done:
              return Container(
                margin: EdgeInsetsGeometry.all(40),
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
                      onPressed: registerUser,
                      style: ButtonStyle(),
                      child:  const Text('Register'),
                    ),
                  ],
                ),
              );
          default:
            return const Text('Loading...');
          }
        }
      )
    );   
}

void registerUser() async {
    final email = _email.text;
    final password = _password.text;

    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, 
      password: password
      );
  }

}