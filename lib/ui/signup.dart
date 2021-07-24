import 'dart:io';
import 'package:bankofquestion_fix/serverside/userService.dart';
import 'package:bankofquestion_fix/utils/saveform.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bankofquestion_fix/constants/constants.dart';
import 'package:bankofquestion_fix/ui/widgets/custom_shape.dart';
import 'package:bankofquestion_fix/ui/widgets/customappbar.dart';
import 'package:bankofquestion_fix/ui/widgets/responsive_ui.dart';
import 'package:bankofquestion_fix/ui/widgets/textformfield.dart';
import 'package:connectivity/connectivity.dart';
import 'package:bankofquestion_fix/utils/validator.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  Validator _validator;
  SaveFormUser _saveForm;
  File _image;
  var subscription;
  Animation<double> _animation;
  AnimationController _animationController;
  GlobalKey<FormState> _key = GlobalKey();
  ImagePicker picker;
  @override
  void initState() {
    super.initState();
    picker = ImagePicker();
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.88, child: CustomAppBar()),
                clipShape(),
                form(),
                // acceptTermsTextRow(),
                SizedBox(
                  height: _height / 35,
                ),
                button(),
                // infoTextRow(),
                // socialIconsRow(),
              ],
            ),
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
                  ? _height / 8
                  : (_medium ? _height / 7 : _height / 6.5),
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
                  ? _height / 12
                  : (_medium ? _height / 11 : _height / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: _height / 5.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0.0,
                  color: Colors.black26,
                  offset: Offset(1.0, 10.0),
                  blurRadius: 20.0),
            ],
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
              onTap: () {
                _getimage();
              },
              child: Icon(
                Icons.add_a_photo,
                size: _large ? 40 : (_medium ? 33 : 31),
                color: Colors.orange[200],
              )),
        ),
      ],
    );
  }

  Future _getimage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        //TODO
        print("image not added");
      }
    });
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: _height / 60.0),
            lastNameTextFormField(),
            SizedBox(height: _height / 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            usernameTextFormField(),
            SizedBox(height: _height / 60.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return directionality(CustomTextField(
      keyboardType: TextInputType.text,
      save: _saveForm.savename,
      icon: Icons.person,
      hint: FORM_NAME,
    ));
  }

  Widget lastNameTextFormField() {
    return directionality(CustomTextField(
      keyboardType: TextInputType.text,
      save: _saveForm.savelname,
      icon: Icons.person,
      hint: FORM_LNAME,
    ));
  }

  Widget usernameTextFormField() {
    return directionality(CustomTextField(
      validator: _validator.validateUserName,
      save: _saveForm.saveusername,
      icon: Icons.person,
      hint: FORM_USERNAME,
    ));
  }

  Widget emailTextFormField() {
    return directionality(CustomTextField(
      keyboardType: TextInputType.emailAddress,
      validator: _validator.validateEmail,
      save: _saveForm.saveemail,
      icon: Icons.email,
      hint: FORM_EMAIL,
    ));
  }

  Widget passwordTextFormField() {
    return directionality(CustomTextField(
      validator: _validator.validatePasswordLength,
      obscure: true,
      save: _saveForm.savepassword,
      obscureText: true,
      icon: Icons.lock,
      hint: FORM_PASSWORD,
    ));
  }

  Widget button() {
    return ElevatedButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.resolveWith(
              (states) => EdgeInsets.all(0.0)),
          textStyle: MaterialStateProperty.resolveWith(
              (states) => TextStyle(color: Colors.white)),
          elevation: MaterialStateProperty.resolveWith((states) => 0),
          shape: MaterialStateProperty.resolveWith((states) =>
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)))),
      onPressed: () {
        checkvalidate();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: _animationbuilder,
      ),
    );
  }

  Widget _animationbuilder(context, child) {
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
      child: Text(
        FORM_SIGNUP_TEXT,
        style: TextStyle(fontSize: _large ? 14 : (_medium ? 17 : 15)),
      ),
    );
  }

  void checkvalidate() async {
    if (_key.currentState.validate()) {
      _animationController.forward();

      _key.currentState.save();
      if (await checkconnection()) {
        Map response = await UserService().registeration(
            _saveForm.user.username,
            _saveForm.user.email,
            _saveForm.user.password,
            firstname: _saveForm.user.name,
            lastname: _saveForm.user.lname,
            image: _image);
        Future.delayed(Duration(seconds: 6), () {
          _animationController.stop();
          reactiontoresponserecived(response);
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

  reactiontoresponserecived(response) {
    switch (response['status']) {
      case "created":
        showDialog(
            context: context,
            builder: _dialogbuilder,
            barrierDismissible: false);
        break;
      case "user exist":
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: directionality(Text(SINGUP_USER_EXIST))));
        break;
      case "password is common":
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: directionality(Text(SINGUP_PASSWORD_COMMON))));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: directionality(Text(SERVER_NOT_RESPONSE_TEXT))));
    }
  }

  Widget _dialogbuilder(context) {
    return directionality(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      scrollable: true,
      elevation: 30,
      contentPadding: EdgeInsets.all(5),
      titlePadding: const EdgeInsets.all(8),
      title: Row(
        children: [
          Icon(
            Icons.check,
            color: Colors.green,
            size: 40,
          ),
          Text(
            SIGNUP_SUCCSESS_MESSEGE,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text(SIGNUP_SUCCSESS_DESCRIPTION),
      actions: [
        TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, "signin"),
            child: Container(
              width: 70,
              height: 30,
              child: Center(
                child: Text(
                  SIGNUP_SUCCSESS_BUTTON_TEXT,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(10)),
            ))
      ],
    ));
  }

  Widget directionality(Widget child) {
    return Directionality(textDirection: TextDirection.rtl, child: child);
  }
}
