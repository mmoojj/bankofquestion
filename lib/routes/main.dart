import 'package:bankofquestion_fix/routes/splashScreen.dart';
import 'package:bankofquestion_fix/ui/signin.dart';
import 'package:bankofquestion_fix/ui/signup.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "splashscreen",
      routes: {
        "splashscreen": (context) => SplashScreen(),
        "signup": (context) => SignUpScreen(),
        "signin": (context) => SignInPage(),
      },
    );
  }
}
