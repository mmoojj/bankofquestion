import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:bankofquestion_fix/serverside/userService.dart';
import 'package:bankofquestion_fix/ui/widgets/FlatButtonCustom.dart';
import 'package:bankofquestion_fix/ui/widgets/textformfield.dart';
import 'package:bankofquestion_fix/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:bankofquestion_fix/constants/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bankofquestion_fix/utils/saveform.dart';

class FloatingActionAnimate extends StatefulWidget {
  AnimationController controller;
  int userid;
  FloatingActionAnimate({this.controller, this.userid});

  @override
  _FloatingActionAnimateState createState() => _FloatingActionAnimateState();
}

class _FloatingActionAnimateState extends State<FloatingActionAnimate>
    with SingleTickerProviderStateMixin {
  Animation<Color> _animateColor;
  bool isactivefloatactionbutton = false;
  Animation<double> _animateIcon;
  Validator _validator;
  SaveFormQuize _saveFormQuize;
  String _ratingController;
  Animation<double> _animation;
  File _file;
  var subscription;
  GlobalKey<FormState> _formkey = GlobalKey();
  AnimationController _animationController;
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _validator = Validator();
    _saveFormQuize = SaveFormQuize();
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        _animationController.reverse();
      } else if (_animationController.isDismissed) {
        _animationController.forward();
      }
    });
    _animateIcon =
        Tween<double>(begin: 0.1, end: 1.0).animate(widget.controller);
    _animateColor =
        ColorTween(begin: Colors.blue, end: Colors.red).animate(CurvedAnimation(
      parent: widget.controller,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.easeOut,
      ),
    ));
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
              validator();
            },
          ),
        ));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animation = Tween<double>(
            begin: MediaQuery.of(context).size.width / 2.5,
            end: MediaQuery.of(context).size.width / 3.5)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeIn));

    return FloatingActionButton(
        backgroundColor: _animateColor.value,
        onPressed: animate,
        child: Transform.rotate(
          angle: .8 * _animateIcon.value,
          child: Icon(Icons.add),
        ));
  }

  animate() async {
    await widget.controller.forward();
    _showDialogtoCreatequize();
  }

  _showDialogtoCreatequize() {
    showDialog(
      context: context,
      builder: _dialogbuilder,
      barrierDismissible: false,
    );
  }

  Widget _dialogbuilder(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Builder(
        builder: (context) => AlertDialog(
          actions: [button()],
          backgroundColor: Color(0xffFCD4DE),
          scrollable: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: EdgeInsets.all(10),
          content: alertDialgoContent(),
        ),
      ),
    );
  }

  Widget alertDialgoContent() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Container(
        height: MediaQuery.of(context).size.height - 50,
        child: Stack(
          children: [
            Align(
              child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.controller.reverse();
                  }),
              alignment: Alignment.topRight,
            ),
            backgroundimageform(),
            Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  drapdown(),
                  quizetitleformfield(),
                  quizedescriptionformfield(),
                  quizefileformfield(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget quizefileformfield() {
    return Custom_flat_butt(
        color: Colors.lightBlueAccent,
        text: TEXT_FORM_FIELD_CHOSE,
        onpressed: () => chosefile());
  }

  chosefile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);
    if (result != null) {
      _file = File(result.files.first.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text('لطفا یک فایل انتخاب کنید'))));
    }
  }

  Widget quizetitleformfield() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormFieldCustom(
          text: TEXT_FORM_FIELD_TITLE,
          maxLength: 30,
          autofocus: false,
          obscure: false,
          validator: _validator.validatetitle,
          onsaved: _saveFormQuize.savetitle,
        ));
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
          validator();
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: _animationBuilder,
        ));
  }

  validator() async {
    if (_formkey.currentState.validate()) {
      if (_file != null) {
        _animationController.forward();
        _formkey.currentState.save();
        if (await checkconnection()) {
          senddata();
        } else {
          _animationController.stop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("اینترنت خود را بررسی کنید"),
            duration: Duration(hours: 1),
            action: SnackBarAction(
              label: "تلاش دوباره",
              onPressed: () {
                validator();
              },
            ),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text("فایل مور نظر خود را انتخاب کنید"))));
      }
    }
  }

  void senddata() async {
    Map response = await UserService().senddataquize(
        _saveFormQuize.quize.title,
        _saveFormQuize.quize.description,
        _saveFormQuize.quize.type,
        _file,
        widget.userid);
    Future.delayed(Duration(seconds: 6), () {
      _animationController.stop();
      reactiontoresponserecived(response);
    });
  }

  Future<bool> checkconnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  reactiontoresponserecived(response) {
    switch (response['status']) {
      case "created":
        _formkey.currentState.reset();
        break;
      case "server did not response":
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(SERVER_NOT_RESPONSE_TEXT))));
    }
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
      child: Text(SEND_QUIZE_BUTTON, style: TextStyle(fontSize: 15)),
    );
  }

  Widget quizedescriptionformfield() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: TextFormField(
            minLines: 5,
            maxLines: 7,
            validator: _validator.validatedescription,
            onSaved: _saveFormQuize.savedescription,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
                labelText: TEXT_FORM_FIELD_DESCRIPTION,
                labelStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                alignLabelWithHint: true,
                border: OutlineInputBorder()),
          ),
        ));
  }

  Widget backgroundimageform() {
    return Center(
        child: Opacity(
      opacity: 0.2,
      child: Image.asset(
        'assets/images/book.png',
        width: 150,
        height: 150,
      ),
    ));
  }

  Widget drapdown() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButtonFormField<String>(
          validator: _validator.validatedropdown,
          onSaved: _saveFormQuize.savetype,
          autofocus: true,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          items: [
            DROP_DOWN_FIELD_1,
            DROP_DOWN_FIELD_2,
            DROP_DOWN_FIELD_3,
            DROP_DOWN_FIELD_4,
            DROP_DOWN_FIELD_5,
            DROP_DOWN_FIELD_6,
          ]
              .map((label) => DropdownMenuItem(
                    child: Text(label.toString()),
                    value: label,
                  ))
              .toList(),
          hint: Text(DROP_DOWN_TITLE),
          onChanged: (value) {
            setState(() {
              _ratingController = value;
            });
          },
        ));
  }
}
