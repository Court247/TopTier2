import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toptier/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'favoritesprovider.dart';
import 'userpreferences.dart';

main() async {
  //this is the firebase configuration
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/sensitive.env');

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: dotenv.env['API_KEY']!,
          appId: dotenv.env['APP_ID']!,
          messagingSenderId: dotenv.env['MESS_SEND_ID']!,
          projectId: dotenv.env['PROJECT_ID']!,
          storageBucket: dotenv.env['STORAGE_BUCKET']!));
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
  );
  UserPreferences userPreferences = UserPreferences();
  await userPreferences.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
        Provider<FirebaseAuth>(
          create: (context) => FirebaseAuth.instance,
        ),
        Provider<FirebaseFirestore>(
          create: (context) => FirebaseFirestore.instance,
        ),
        Provider<FirebaseStorage>(
          create: (context) => FirebaseStorage.instance,
        ),
        Provider<UserPreferences>(
          create: (context) => userPreferences,
        ),
      ],
      child: const TopTierHome(),
    ),
  );
}

/// Opening class that simply connects to the Home Page.
class TopTierHome extends StatelessWidget {
  const TopTierHome({super.key});
  @override

  /// This widget is the root of the application.
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TopTier Welcome',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TopTierHomePage(),
    );
  }
}

/// Parent class
class TopTierHomePage extends StatefulWidget {
  const TopTierHomePage({super.key});

  @override
  State<TopTierHomePage> createState() => _TopTierHomePageState();
}

/// Private child class that decorates the home page that allows user to access tier list.
class _TopTierHomePageState extends State<TopTierHomePage> {
  late final db;
  late final storage;
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

  @override
  void initState() {
    super.initState();
    db = Provider.of<FirebaseFirestore>(context, listen: false);
    storage = Provider.of<FirebaseStorage>(context, listen: false);
  }

  /// Documentation for [build]
  /// > * _`@param: [Widget]`_ - build
  ///
  /// > _`@returns: [Widget]`_
  ///
  /// Decoration of the TopTier homepage that shifts between two words
  /// and is a onTap executable that takes us to the next page.
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
                    ColorizeAnimatedText('Welcome!',
                        textStyle: colorizing, colors: colorings),
                    ColorizeAnimatedText('Press to SignIn',
                        textStyle: colorizing, colors: colorings)
                  ],
                  isRepeatingAnimation: true,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
