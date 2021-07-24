import 'package:bankofquestion_fix/models/user.dart';

import 'package:bankofquestion_fix/serverside/userService.dart';
import 'package:connectivity/connectivity.dart';

import 'package:flutter/material.dart';

class Userpanelinfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserpanelinfoState();
}

class UserpanelinfoState extends State<Userpanelinfo> {
  List<User> listdata = [];

  @override
  void initState() {
    initiallist();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        listdata.isNotEmpty
            ? Expanded(
                child: RefreshIndicator(
                    child: ListView.builder(
                      itemBuilder: _itemBuilder,
                      itemCount: listdata.length,
                    ),
                    onRefresh: _refresh))
            : Center(
                child: Text("در حال حاضر هیچ کاربری موجود نیست"),
              ),
      ],
    ));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return ListTile(
      title: Text(listdata[index].username + "\n" + listdata[index].email),
      leading: Checkbox(
          value: listdata[index].isstaff,
          onChanged: (changed) async {
            if (changed) {
              bool response = await UserService().updateuserstaff(
                  true, listdata[index].username, listdata[index].id);
              if (response) {
                setState(() {
                  listdata[index].isstaff = changed;
                });
              }
            } else {
              bool response = await UserService().updateuserstaff(
                  false, listdata[index].username, listdata[index].id);
              if (response) {
                setState(() {
                  listdata[index].isstaff = changed;
                });
              }
            }
          }),
      subtitle: listdata[index].name != ""
          ? Text(listdata[index].name + " " + listdata[index].lname)
          : Text("نام کاربری موجود نیست"),
    );
  }

  Future<void> _refresh() async {
    if (await checkconnection()) {
      return UserService().getallusers().then((value) {
        setState(() {
          listdata = value;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("اینترنت خود را بررسی کنید"),
        duration: Duration(hours: 1),
        action: SnackBarAction(
          label: "تلاش دوباره",
          onPressed: () {
            _refresh();
          },
        ),
      ));
    }
  }

  void initiallist() async {
    if (await checkconnection()) {
      UserService().getallusers().then((value) {
        setState(() {
          listdata = value;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("اینترنت خود را بررسی کنید"),
        duration: Duration(hours: 1),
        action: SnackBarAction(
          label: "تلاش دوباره",
          onPressed: () {
            initiallist();
          },
        ),
      ));
    }
  }

  Future<bool> checkconnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }
}
