import 'package:bankofquestion_fix/constants/constants.dart';
import 'package:bankofquestion_fix/models/user.dart';
import 'package:bankofquestion_fix/routes/homepage.dart';
import 'package:bankofquestion_fix/serverside/userService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  var subscription;
  @override
  void initState() {
    super.initState();
    checklogin(context);
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("اینترنت خود را بررسی کنید"),
          duration: Duration(hours: 1),
          action: SnackBarAction(
            label: "تلاش دوباره",
            onPressed: () {
              checklogin(context);
            },
          ),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
      children: [
        Center(
          child: Image.asset(
            "assets/images/book.png",
            width: 300,
            height: 270,
          ),
        ),
        Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xddff80b3),
            Color(0xdde6ccff),
            Color(0xdde6ccff)
          ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            SPLASHSCREEN_TITLE,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 30),
          child: CircularProgressIndicator(),
        )
      ],
    ));
  }

  checklogin(context) {
    Future.delayed(Duration(seconds: 5), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      if (token != null) {
        if (await checkconnection()) {
          User _user = await UserService().tokenauth(token);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: HomePage(_user))));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("اینترنت خود را بررسی کنید"),
            duration: Duration(hours: 1),
            action: SnackBarAction(
              label: "تلاش دوباره",
              onPressed: () {
                checklogin(context);
              },
            ),
          ));
        }
      } else {
        Navigator.pushReplacementNamed(context, "signin");
      }
    });
  }

  Future<bool> checkconnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }
}
