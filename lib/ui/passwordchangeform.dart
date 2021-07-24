import 'package:bankofquestion_fix/serverside/userService.dart';

import 'package:bankofquestion_fix/utils/saveform.dart';
import 'package:flutter/material.dart';
import 'package:bankofquestion_fix/constants/constants.dart';
// import 'package:bankofquestion_fix/ui/widgets/custom_shape.dart';
import 'package:bankofquestion_fix/ui/widgets/responsive_ui.dart';
import 'package:bankofquestion_fix/ui/widgets/textformfield.dart';
import 'package:bankofquestion_fix/utils/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordChange extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PasswordChangeScreen(),
    );
  }
}

class PasswordChangeScreen extends StatefulWidget {
  @override
  _PasswordChange createState() => _PasswordChange();
}

class _PasswordChange extends State<PasswordChangeScreen>
    with SingleTickerProviderStateMixin {
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  Validator _validator;
  SavePasswordChange _saveForm;
  Animation<double> _animation;
  AnimationController _animationController;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
    _saveForm = SavePasswordChange();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    _validator = Validator();
    _animation = Tween(begin: 150.0, end: 100.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    return Material(
      child: Container(
        height: _height,
        width: _width,
        padding: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // clipShape(),
              // welcomeTextRow(),
              // signInTextRow(),
              form(),
              // forgetPassTextRow(),
              SizedBox(height: _height / 30),
              button(),
              // signUpTextRow(),
            ],
          ),
        ),
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
            passwordnewFormField(),
            SizedBox(height: _height / 40.0),
            passwordoldFormField(),
          ],
        ),
      ),
    );
  }

  Widget passwordnewFormField() {
    return directionality(CustomTextField(
      validator: _validator.validatePasswordnewchangeLength,
      save: _saveForm.savenewpassword,
      icon: Icons.lock_outline,
      obscureText: true,
      obscure: true,
      hint: FORM_NEW_PASSWORD,
    ));
  }

  Widget passwordoldFormField() {
    return directionality(CustomTextField(
      obscure: true,
      validator: _validator.validatePasswordoldchangeLength,
      save: _saveForm.saveoldpassword,
      textEditingController: passwordController,
      icon: Icons.lock_outline,
      obscureText: true,
      hint: FORM_OLD_PASSWORD,
    ));
  }

  Widget directionality(Widget child) {
    return Directionality(textDirection: TextDirection.rtl, child: child);
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
      child: Text(FORM_CHANGE_PASSWORD_BUTTON,
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 17 : 15))),
    );
  }

  void checkvalidate() async {
    if (_key.currentState.validate()) {
      _animationController.forward();
      _key.currentState.save();
      String response = await UserService().changepassword(
          _saveForm.passwords['newpassword'],
          _saveForm.passwords['oldpassword']);

      Future.delayed(Duration(seconds: 6), () {
        _animationController.stop();
        reactiontoresponserecived(response);
      });
    }
  }

  void reactiontoresponserecived(response) async {
    switch (response) {
      case "passwordchanged":
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove('token');
        Navigator.pushReplacementNamed(context, SIGN_IN);
        break;
      case "password is common":
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: directionality(Text(SINGUP_PASSWORD_COMMON))));
        break;
      case 'Old password is not correct':
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: directionality(Text("پسور نادرست است"))));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: directionality(Text(SERVER_NOT_RESPONSE_TEXT))));
    }
  }
}
