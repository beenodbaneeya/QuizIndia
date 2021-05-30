import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_india/ui/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

//import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_quizforkid/services/auth.dart';
//import 'package:flutter_quizforkid/wrapper.dart';
//import 'package:provider/provider.dart';
//
//import 'models/user.dart';
//
//void main() async {
//  WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp();
//  runApp(MyApp());
//}
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return StreamProvider<CustomUser>.value(
//      value: AuthService().user,
//      child: MaterialApp(
//        debugShowCheckedModeBanner: false,
//        home: Wrapper(),
//      ),
//    );
//  }
//}
//
