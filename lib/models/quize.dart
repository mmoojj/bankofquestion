class QuizeModel {
  int _id;
  String _type;
  String _title;
  String _description;
  String _urlfile;
  String _status;
  String _ownername;
  String _created_at;
  String get status => _status;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  set status(String status) {
    _status = status;
  }

  String get created_at => _created_at;

  set created_at(String created_at) {
    _created_at = created_at;
  }

  String get ownername => _ownername;

  set ownername(String ownername) {
    _ownername = ownername;
  }

  String get urlfile => _urlfile;

  set urlfile(String urlfile) {
    _urlfile = urlfile;
  }

  String get type => _type;
  set type(String type) {
    _type = type;
  }

  String get title => _title;

  set title(String title) {
    _title = title;
  }

  String get description => _description;

  set description(String description) {
    _description = description;
  }
}
