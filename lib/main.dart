import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz_marin/Screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  await Firebase.initializeApp();
  runApp(const Marina());
}

class Marina extends StatelessWidget {
  const Marina({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: SplashScreen());
  }
}
