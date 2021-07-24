import 'package:bankofquestion_fix/models/user.dart';
import 'package:bankofquestion_fix/routes/homepage.dart';
import 'package:bankofquestion_fix/serverside/userService.dart';
import 'package:connectivity/connectivity.dart';
import 'package:bankofquestion_fix/utils/saveform.dart';
import 'package:flutter/material.dart';
import 'package:bankofquestion_fix/constants/constants.dart';
import 'package:bankofquestion_fix/ui/widgets/custom_shape.dart';
import 'package:bankofquestion_fix/ui/widgets/responsive_ui.dart';
import 'package:bankofquestion_fix/ui/widgets/textformfield.dart';
import 'package:bankofquestion_fix/utils/validator.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  Validator _validator;
  SaveFormUser _saveForm;
  Animation<double> _animation;
  AnimationController _animationController;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  var subscription;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        _animationController.reverse();
      } else if (_animationController.isDismissed) {
        _animationController.forward();
      }
    });
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
              checkvalidate();
            },
          ),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    _validator = Validator();
    _saveForm = SaveFormUser();
    _animation = Tween(
            begin:
                _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
            end: _large ? _width / 5.5 : (_medium ? _width / 5 : _width / 4.8))
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeIn));
    return Material(
      child: Container(
        height: _height,
        width: _width,
        padding: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              clipShape(),
              welcomeTextRow(),
              signInTextRow(),
              form(),
              forgetPassTextRow(),
              SizedBox(height: _height / 30),
              button(),
              signUpTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 4
                  : (_medium ? _height / 3.75 : _height / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 4.5
                  : (_medium ? _height / 4.25 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large
                  ? _height / 30
                  : (_medium ? _height / 25 : _height / 20)),
          child: Image.asset(
            'assets/images/login.png',
            height: _height / 3.5,
            width: _width / 3.5,
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 100, left: _width / 3),
      child: Row(
        children: <Widget>[
          Text(
            SIGNIN_WELLCOME_TEXT,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large ? 60 : (_medium ? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: _width / 3,
          ),
          Text(
            SIGNIN_TEXT,
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large ? 20 : (_medium ? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            usernameTextFormField(),
            SizedBox(height: _height / 40.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget usernameTextFormField() {
    return directionality(CustomTextField(
      validator: _validator.validateUserName,
      save: _saveForm.saveusername,
      icon: Icons.person,
      hint: FORM_USERNAME,
    ));
  }

  Widget passwordTextFormField() {
    return directionality(CustomTextField(
      obscure: true,
      validator: _validator.validatePasswordLength,
      save: _saveForm.savepassword,
      textEditingController: passwordController,
      icon: Icons.lock,
      obscureText: true,
      hint: FORM_PASSWORD,
    ));
  }

  Widget directionality(Widget child) {
    return Directionality(textDirection: TextDirection.rtl, child: child);
  }

  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Text(
              FORM_RESET_PASSWORD,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.orange[200]),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            FORM_FORGET_PASSWORD_TEXT,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 17 : 15)),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return ElevatedButton(
        style: ButtonStyle(
            textStyle: MaterialStateProperty.resolveWith(
                (states) => TextStyle(color: Colors.white)),
            elevation: MaterialStateProperty.resolveWith((states) => 0),
            shape: MaterialStateProperty.resolveWith((states) =>
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
            padding: MaterialStateProperty.resolveWith(
                (states) => EdgeInsets.all(0.0))),
        onPressed: () {
          checkvalidate();
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: _animationBuilder,
        ));
  }

  Widget _animationBuilder(context, child) {
    return Container(
      alignment: Alignment.center,
      width: _animation.value,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        gradient: LinearGradient(
          colors: <Color>[Colors.orange[200], Colors.pinkAccent],
        ),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Text(FORM_SIGNIN_BUTTON_ENTER,
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 17 : 15))),
    );
  }

  void checkvalidate() async {
    if (_key.currentState.validate()) {
      _animationController.forward();
      _key.currentState.save();
      if (await checkconnection()) {
        Map response = await UserService()
            .logedin(_saveForm.user.username, _saveForm.user.password);

        Future.delayed(Duration(seconds: 6), () {
          _animationController.stop();
          reactiontoresponserecived(response,
              data: response['status'] == "logedin" ? response['data'] : null);
        });
      } else {
        _animationController.stop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("اینترنت خود را بررسی کنید"),
          duration: Duration(hours: 1),
          action: SnackBarAction(
            label: "تلاش دوباره",
            onPressed: () {
              checkvalidate();
            },
          ),
        ));
      }
    }
  }

  Future<bool> checkconnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  reactiontoresponserecived(response, {data}) {
    switch (response['status']) {
      case "logedin":
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                directionality(HomePage(User().setdata(data)))));
        break;
      case "login failed":
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: directionality(Text(LOGIN_FAILED_TEXT))));
        break;
      case "Account is not activated":
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: directionality(Text(ACCOUNT_NOT_ACTIVATE_TEXT))));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: directionality(Text(SERVER_NOT_RESPONSE_TEXT))));
    }
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(SIGN_UP);
            },
            child: Text(
              FORM_SIGNUP_TEXT,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[200],
                  fontSize: _large ? 19 : (_medium ? 17 : 15)),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            FORM_NOT_HAVE_ACCOUNT_TEXT,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 16 : 15)),
          ),
        ],
      ),
    );
  }
}
