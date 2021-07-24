import 'dart:io';
import 'package:bankofquestion_fix/models/quize.dart';
import 'package:bankofquestion_fix/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

final String mainurl = "http://192.168.1.30:8000/api/accounts/";
final String mainquizeurl = "http://192.168.1.30:8000/quize/";
final String userurl = "http://192.168.1.30:8000/user/";

//multipart/form-data
class UserService {
  Dio dio;
  UserService() : dio = new Dio();

  Future updatequizestaff(int id, String title, String description,
      String category, File file) async {
    try {
      FormData formData;
      if (file != null) {
        formData = FormData.fromMap({
          "title": title,
          "text": description,
          "category": category,
          'file': await MultipartFile.fromFile(file.path, filename: file.path)
        });
      } else {
        formData = FormData.fromMap({
          "title": title,
          "text": description,
          "category": category,
        });
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      var response = await dio.put(mainquizeurl + "$id/",
          data: formData,
          options: Options(
              responseType: ResponseType.json,
              headers: {"Authorization": "Token $token"}));
      if (response.statusCode == 200) {
        dio.close();
        return {"status": 'updated'};
      }
    } on DioError catch (e) {
      if (e.response == null) {
        dio.close();
        return {"status": "server did not response"};
      }
    }
  }

  Future<bool> updateuserstaff(bool isstaff, String username, int id) async {
    try {
      FormData formData =
          FormData.fromMap({"is_staff": isstaff, "username": username});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      var response = await dio.put(userurl + "$id/",
          data: formData,
          options: Options(
              responseType: ResponseType.json,
              headers: {"Authorization": "Token $token"}));
      if (response.statusCode == 200) {
        return true;
      }
    } on DioError catch (e) {}
  }

  Future<List<User>> getallusers() async {
    List<User> list = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      var response = await dio.get(
        userurl,
        options: Options(
            responseType: ResponseType.json,
            headers: {"Authorization": "Token $token"}),
      );
      if (response.statusCode == 200) {
        if (response.data != null) {
          (response.data as List).forEach((map) {
            User user = User();
            user.id = map['id'];
            user.name = map['first_name'];
            user.lname = map['last_name'];
            user.username = map['username'];
            user.email = map['email'];
            user.isstaff = map['is_staff'];
            list.add(user);
          });
          dio.close();
          return list;
        }
      }
    } on DioError catch (e) {}
  }

  Future registeration(String username, String email, String password,
      {String firstname: "", String lastname: "", File image}) async {
    try {
      FormData formdata = FormData.fromMap({
        "username": username,
        "email": email,
        "password": password,
        "first_name": firstname,
        "last_name": lastname,
        "image": image != null
            ? await MultipartFile.fromFile(image.path, filename: image.path)
            : null
      });

      var response = await dio.post(mainurl + "register/",
          data: formdata, options: Options(responseType: ResponseType.json));

      if (response.statusCode == 201) {
        //when user created
        dio.close();
        return {"status": "created"};
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.data['username'][0] ==
                'User with this username already exists.' ||
            e.response.data['email'][0] ==
                'User with this email already exists.') {
          dio.close();
          return {"status": "user exist"};
        } else if (e.response.data['password'][0] ==
                'This password is too common.' ||
            e.response.data['password'][1] ==
                'This password is entirely numeric.') {
          dio.close();
          return {"status": "password is common"};
        }
      } else {
        dio.close();
        return {"status": "server did not response"};
      }
    }
  }

  Future logedin(String username, String password) async {
    try {
      FormData formData =
          FormData.fromMap({"username": username, "password": password});
      var response = await dio.post(mainurl + "login/",
          data: formData, options: Options(responseType: ResponseType.json));

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", response.data['token']);
        dio.close();
        return {"status": "logedin", "data": response.data};
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.data['detail'] ==
            'Login failed wrong user credentials.') {
          dio.close();
          return {"status": "login failed"};
        } else if (e.response.data['detail'] == 'Account is not activated.') {
          dio.close();
          return {"status": "Account is not activated"};
        }
      } else {
        dio.close();
        return {"status": "server did not response"};
      }
    }
  }

  Future senddataquize(String title, String description, String category,
      File file, int owner) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    try {
      FormData formdata = FormData.fromMap({
        'title': title,
        'text': description,
        'category': category,
        'file': await MultipartFile.fromFile(file.path, filename: file.path),
        'owner': owner
      });
      var response = await dio.post(
        mainquizeurl,
        data: formdata,
        options: Options(
            responseType: ResponseType.json,
            headers: {"Authorization": "Token $token"}),
      );
      if (response.statusCode == 201) {
        //when user created
        dio.close();
        return {"status": "created"};
      }
    } on DioError catch (e) {
      if (e.response == null) {
        dio.close();
        return {"status": "server did not response"};
      }
    }
  }

  Future<List<QuizeModel>> getquizeforuseranaymos(
      {String searchitem: ""}) async {
    List<QuizeModel> list = [];
    try {
      var response = await dio.get(mainquizeurl + "get/?search=$searchitem");
      if (response.statusCode == 200) {
        if (response.data != null) {
          List data = response.data;
          data.forEach((map) {
            QuizeModel quize = QuizeModel();
            quize.title = map['title'];
            quize.description = map['text'];
            quize.ownername = map['owner'];
            quize.type = map['category'];
            quize.urlfile = map['file'];
            quize.created_at = map['date'];
            list.add(quize);
          });
          dio.close();
          return list;
        }
      }
    } on DioError catch (e) {}
  }

  Future tokenauth(String token) async {
    try {
      var response = await dio.get(
        mainurl + "profile/",
        options: Options(
            responseType: ResponseType.json,
            headers: {"Authorization": "Token $token"}),
      );
      if (response.statusCode == 200) {
        dio.close();
        return User().setdata(response.data);
      }
    } on DioError catch (e) {}
  }

  Future<String> changepassword(String newpass, String oldpass) async {
    FormData formData =
        FormData.fromMap({"old_password": oldpass, "new_password": newpass});

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.get('token');
    try {
      var response = await dio.put(mainurl + "change-password/",
          data: formData,
          options: Options(
              responseType: ResponseType.json,
              headers: {"Authorization": "Token $token"}));

      if (response.statusCode == 200) {
        dio.close();
        return "passwordchanged";
      }
    } on DioError catch (e) {
      if (e.response == null) {
        dio.close();
        return "server did not response";
      }
      if (e.response != null) {
        if ((e.response.data as Map).containsKey("new_password")) {
          dio.close();
          return "password is common";
        } else if ((e.response.data as Map).containsKey("old_password")) {
          dio.close();
          return "Old password is not correct";
        }
      }
    }
  }

  Future<List<QuizeModel>> getallquize() async {
    List<QuizeModel> list = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      var response = await dio.get(
        mainquizeurl,
        options: Options(
            responseType: ResponseType.json,
            headers: {"Authorization": "Token $token"}),
      );
      if (response.statusCode == 200) {
        if (response.data != null) {
          (response.data as List).forEach((map) {
            QuizeModel quize = QuizeModel();
            quize.id = map['pk'];
            quize.title = map['title'];
            quize.description = map['text'];
            quize.ownername = map['owner'];
            quize.type = map['category'];
            quize.urlfile = map['file'];
            quize.status = map['status'];
            quize.created_at = map['date'];
            list.add(quize);
          });
          dio.close();
          return list;
        }
      }
    } on DioError catch (e) {}
  }

  Future<bool> updatestatus(pk, status) async {
    try {
      FormData formData = FormData.fromMap({"status": status});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      var response = await dio.put(mainquizeurl + "$pk/",
          data: formData,
          options: Options(
              responseType: ResponseType.json,
              headers: {"Authorization": "Token $token"}));
      if (response.statusCode == 200) {
        return true;
      }
    } on DioError catch (e) {}
  }
}
