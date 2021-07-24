import 'package:bankofquestion_fix/models/user.dart';
import 'package:bankofquestion_fix/models/quize.dart';

class SaveFormUser {
  User _user = User();
  void savepassword(String pass) {
    _user.password = pass;
  }

  void saveemail(String email) {
    _user.email = email;
  }

  void saveusername(String username) {
    _user.username = username;
  }

  void savelname(String lname) {
    _user.lname = lname;
  }

  void savename(String name) {
    _user.name = name;
  }

  User get user => _user;
}

class SaveFormQuize {
  QuizeModel _quize = QuizeModel();

  void savetitle(String title) {
    _quize.title = title;
  }

  void savedescription(String description) {
    _quize.description = description;
  }

  void savetype(String type) {
    _quize.type = type;
  }

  QuizeModel get quize => _quize;
}

class SavePasswordChange {
  Map<String, String> password = {};
  void saveoldpassword(String oldpass) {
    password['oldpassword'] = oldpass;
  }

  void savenewpassword(String newpass) {
    password['newpassword'] = newpass;
  }

  Map<String, String> get passwords => password;
}
