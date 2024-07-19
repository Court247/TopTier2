import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'signin.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const CreateAccountPage(),
    );
  }
}

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final GlobalKey<FormFieldState<String>> _email = GlobalKey();
  final GlobalKey<FormFieldState<String>> _pass = GlobalKey();
  final GlobalKey<FormFieldState<String>> _user = GlobalKey();

  List<Color> colorings = [
    Colors.white,
    Colors.pink.shade50,
    Colors.pink.shade100,
    Colors.pink.shade300,
    Colors.pink
  ];

  /// How the text is going to look
  static const colorizing = TextStyle(
    fontSize: 60.0,
    fontFamily: 'Horizon',
  );

  static const accText = TextStyle(
    color: Colors.white,
    fontSize: 40.0,
    fontFamily: 'Horizon',
    shadows: [
      Shadow(
        blurRadius: 7.0,
        color: Colors.white,
        offset: Offset(0, 0),
      ),
    ],
  );

  success() {
    return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        'Account created successfully!',
        style: TextStyle(color: Colors.pinkAccent),
      ),
      backgroundColor: Colors.white,
    ));
  }

  get values => {
        'Email': _email.currentState?.value,
        'Password': _pass.currentState?.value,
        'Username': _user.currentState?.value
      };

  createUser() async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    final db = Provider.of<FirebaseFirestore>(context, listen: false);
    String message = '';
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: _email.currentState!.value!,
        password: _pass.currentState!.value!,
      );

      User? user = userCredential.user;
      user!.updateDisplayName(_user.currentState!.value!);

      if (userCredential.additionalUserInfo!.isNewUser) {
        print(values);
        db.collection('users').doc(user.uid).set({
          'username': _user.currentState!.value!,
          'email': _email.currentState!.value!,
          'uid': user.uid,
          'profileImage': '',
          'isAdmin': false,
        });
        success();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else {
        message = 'Invalid email or password.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      print(e);
    }
  }

  submit() {
    final isValid = _email.currentState?.validate();
    final isValids = _pass.currentState?.validate();
    final isValidss = _user.currentState?.validate();
    if (!isValid! || !isValids! || !isValidss!) {
      return false;
    }
    _user.currentState?.save();
    _pass.currentState?.save();
    _email.currentState?.save();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.pink,
              Colors.pink.shade200,
              Colors.pink.shade100,
              Colors.pink.shade50,
            ],
          )),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.white,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText('TopTier',
                          textStyle: colorizing, colors: colorings),
                    ],
                    isRepeatingAnimation: true,
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text('Create Account', style: accText),
                const SizedBox(height: 20.0),
                TextFormField(
                  key: _user,
                  decoration: const InputDecoration(
                    hintText: 'Username',
                    icon: Icon(Icons.person, color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  key: _email,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    icon: Icon(Icons.email, color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  key: _pass,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    icon: Icon(Icons.lock, color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.pinkAccent),
                            textStyle: MaterialStateProperty.all(
                                const TextStyle(fontSize: 20)),
                            fixedSize:
                                MaterialStateProperty.all(const Size(200, 50))),
                        onPressed: () async {
                          createUser();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        },
                        child: const Text('Create Account')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
