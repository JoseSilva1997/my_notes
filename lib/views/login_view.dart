import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/firebase_options.dart';
import 'package:my_notes/utils/log_util.dart';


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
        title: const Text('Login'),
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
                      onPressed: loginUser,
                      style: ButtonStyle(),
                      child:  const Text('Login'),
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

void loginUser() async {
  final email = _email.text;
  final password = _password.text;
  final auth;

  try {
    auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    LogUtil().log('User logged in: ${auth.user?.email}');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      LogUtil().log('No user found');
    } else if (e.code == 'wrong-password') {
      LogUtil().log('Wrong password');
    } else {
      LogUtil().log('Error: ${e.code}');
    }
  }
}

}
