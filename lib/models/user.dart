class User {
  String _username;
  String _password;
  String _name;
  String _lname;
  String _email;
  String _image;
  int _id;
  bool _issuperuser;
  bool _isstaff;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  String get image => _image;

  set image(String image) {
    _image = image;
  }

  bool get issuperuser => _issuperuser;

  set issuperuser(bool issuperuser) {
    _issuperuser = issuperuser;
  }

  bool get isstaff => _isstaff;

  set isstaff(bool isstaff) {
    _isstaff = isstaff;
  }

  String get name => _name;

  set name(String name) {
    _name = name;
  }

  String get lname => _lname;

  set lname(String lname) {
    _lname = lname;
  }

  String get email => _email;

  set email(String email) {
    _email = email;
  }

  String get username => _username;

  set username(String username) {
    _username = username;
  }

  String get password => _password;

  set password(String password) {
    _password = password;
  }

  User setdata(Map data) {
    User user = User();
    user._name = data['first_name'];
    user._lname = data['last_name'];
    user._username = data['username'];
    user._email = data['email'];
    user._isstaff = data['is_staff'];
    user._image = data['image'];
    user._issuperuser = data['is_superuser'];
    user._id = data['id'];
    return user;
  }
}
