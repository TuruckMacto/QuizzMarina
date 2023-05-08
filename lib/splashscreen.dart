import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_marin/Login/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6), () async{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.network(
                    "https://assets6.lottiefiles.com/packages/lf20_p7xwnulb.json",
                    alignment: Alignment.center,
                    width: 900,
                    height: 600,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (Platform.isIOS)
                    const CircularProgressIndicator(
                      color: Colors.blue,
                      backgroundColor: Colors.white,
                    )
                  else
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.grey,
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Cargando examenes....",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
