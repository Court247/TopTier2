import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toptier/gamelistpage.dart';
import 'createaccount.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  //this MultiProvider initializes the provider so that a new instance doesn't have to be created
  //throughout the app and all information can be accessed from anywhere
  @override

  /// This widget is the root of the application.
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TopTier Welcome',
      theme: ThemeData(
        brightness: Brightness.light,
        //primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormFieldState<String>> _email = GlobalKey();
  final GlobalKey<FormFieldState<String>> _pass = GlobalKey();
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

  //validates the user input to make sure it's not null
  submit() {
    final isValid = _email.currentState?.validate();
    final isValids = _pass.currentState?.validate();
    if (!isValid! || !isValids!) {
      return false;
    }
    _email.currentState?.save();
    _pass.currentState?.save();
    return true;
  }

  //gets the values from the user input make sure it's correct
  get values => {
        'Email': _email.currentState?.value,
        'Password': _pass.currentState?.value,
      };

  //login function that checks if the user is in the database
  Future<bool?> login() async {
    //the auth and db variables are used to access the firebase authentication and firestore
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    String message = '';

    //try catch block checks if the user is in the database and if not it will throw an error
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: _email.currentState!.value!,
        password: _pass.currentState!.value!,
      );

      User? user = userCredential.user;

      if (user != null) {
        print('Login Successful!');
        print(values);

        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code.toLowerCase() == 'user-not-found'.toLowerCase()) {
        print(e.code);
        message = 'No user found for that email.';
        print(e.code);
      } else if (e.code.toLowerCase() == 'wrong-password'.toLowerCase()) {
        print(e.code);

        message = 'Wrong password provided for that user.';
      } else if (e.code.toLowerCase() == 'invalid-email'.toLowerCase()) {
        print(e.code);

        message = 'Invalid email';
      } else if (e.code.toLowerCase() == 'too-many-requests'.toLowerCase()) {
        print(e.code);

        message = 'Too many requests';
      } else if (e.code.toLowerCase() == 'email-already-in-use'.toLowerCase()) {
        print(e.code);

        message = 'Email already in use';
      } else if (e.code.toLowerCase() == 'weak-password'.toLowerCase()) {
        print(e.code);

        message = 'The password provided is too weak.';
      } else if (e.code.toLowerCase() == 'invalid-credential'.toLowerCase()) {
        print(e.code);

        message = 'Invalid email or password.';
      } else if (e.code.toLowerCase() ==
          'network-request-failed'.toLowerCase()) {
        print(e.code);

        message = 'Network error.';
      } else if (e.code.toLowerCase() == 'invalid-credential'.toLowerCase()) {
        print(e.code);

        message = 'Invalid Credentials.';
      } else {
        print(e.code);

        message = 'Invalid email or password.';
      }

      //if user is not in the database then it will display an error message
      //via snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      //print('here: ${e.toString()}');
    }
    return null;
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
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                              (states) =>
                                  const Color.fromARGB(255, 255, 74, 134)),
                          textStyle: WidgetStateProperty.all(
                              const TextStyle(fontSize: 20, inherit: true)),
                          fixedSize:
                              WidgetStateProperty.all(const Size(100, 50))),
                      onPressed: () async {
                        if (submit() && await login.call() == true) {
                          if (mounted) {
                            //this will take the user to the option page
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TopTierGames()));
                          }
                        }
                      },
                      child: const Text('Login'),
                    ),
                    TextButton(
                      onPressed: () {
                        //this will take the user to the option page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CreateAccount()));
                      },
                      child: const Text(
                        'Create Account',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    )
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
