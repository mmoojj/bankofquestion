import 'dart:io';

import 'package:bankofquestion_fix/constants/constants.dart';
import 'package:bankofquestion_fix/models/quize.dart';
import 'package:bankofquestion_fix/serverside/userService.dart';
import 'package:bankofquestion_fix/ui/widgets/FlatButtonCustom.dart';
import 'package:bankofquestion_fix/ui/widgets/textformfield.dart';
import 'package:bankofquestion_fix/utils/saveform.dart';
import 'package:bankofquestion_fix/utils/validator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UpdateStaffQuize extends StatefulWidget {
  QuizeModel quize;
  UpdateStaffQuize({this.quize});
  @override
  _UpdateStaffQuizeState createState() => _UpdateStaffQuizeState();
}

class _UpdateStaffQuizeState extends State<UpdateStaffQuize>
    with SingleTickerProviderStateMixin {
  String _ratingController;
  File _file;
  AnimationController _animationController;
  Animation<double> _animation;
  Validator _validator;
  var subscription;
  SaveFormQuize _saveFormQuize;
  GlobalKey<FormState> _formkey = GlobalKey();
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
              validation();
            },
          ),
        ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _animation = Tween<double>(
            begin: MediaQuery.of(context).size.width / 2.5,
            end: MediaQuery.of(context).size.width / 3.5)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeIn));
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                dropdown(),
                SizedBox(
                  height: 20,
                ),
                titleupdate(),
                SizedBox(
                  height: 20,
                ),
                descriptionupdate(),
                fileupdate(),
                SizedBox(
                  height: 20,
                ),
                button()
              ],
            )),
      )),
    );
  }

  Widget titleupdate() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormFieldCustom(
          text: TEXT_FORM_FIELD_TITLE,
          maxLength: 30,
          autofocus: false,
          obscure: false,
          value: widget.quize.title,
          validator: _validator.validatetitle,
          onsaved: _saveFormQuize.savetitle,
        ));
  }

  Widget descriptionupdate() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: TextFormField(
            initialValue: widget.quize.description,
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

  dropdown() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButtonFormField<String>(
          value: widget.quize.type,
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

  Widget fileupdate() {
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
          validation();
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: _animationBuilder,
        ));
  }

  validation() async {
    if (_formkey.currentState.validate()) {
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
              validation();
            },
          ),
        ));
      }
    }
  }

  void senddata() async {
    Map response = await UserService().updatequizestaff(
        widget.quize.id,
        _saveFormQuize.quize.title,
        _saveFormQuize.quize.description,
        _saveFormQuize.quize.type,
        _file);
    Future.delayed(Duration(seconds: 6), () {
      _animationController.stop();
      reactiontoresponserecived(response);
    });
  }

  reactiontoresponserecived(response) {
    switch (response['status']) {
      case "updated":
        Navigator.pop(context, "update");
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
      child: Text("ویرایش", style: TextStyle(fontSize: 18)),
    );
  }

  Future<bool> checkconnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }
}
