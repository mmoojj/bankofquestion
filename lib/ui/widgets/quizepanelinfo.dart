import 'package:bankofquestion_fix/models/quize.dart';
import 'package:bankofquestion_fix/routes/detailquize.dart';
import 'package:bankofquestion_fix/serverside/userService.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class Quizepanelinfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QuizepanelinfoState();
}

class QuizepanelinfoState extends State<Quizepanelinfo> {
  List<QuizeModel> listdata = [];

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
                child: Text("در حال حاضر هیچ آزمونی موجود نیست"),
              ),
      ],
    ));
  }

  Future<void> _refresh() async {
    if (await checkconnection()) {
      return UserService().getallquize().then((value) {
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

  Widget _itemBuilder(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: DetailQuize(
                title: listdata[index].title,
                description: listdata[index].description,
                urlfile: listdata[index].urlfile,
              ));
        }));
      },
      child: Column(
        children: [
          listtileview(index),
          SizedBox(
            height: 20,
          ),
          listtilefoater(index),
          Divider(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget listtilefoater(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              listdata[index].ownername != " "
                  ? Text(
                      listdata[index].ownername,
                      style: TextStyle(
                          color: Colors.white, backgroundColor: Colors.grey),
                    )
                  : Text("نویسنده مشخص نیست"),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  listdata[index].created_at,
                  style: TextStyle(
                      backgroundColor: Colors.blueAccent, color: Colors.white),
                ),
              )
            ],
          ),
        ),
        Column(
          children: [
            Text(listdata[index].type),
            Switch(
                value: listdata[index].status == 'd' ? false : true,
                onChanged: (changed) async {
                  if (changed) {
                    bool response = await UserService()
                        .updatestatus(listdata[index].id, 'p');
                    if (response) {
                      setState(() {
                        listdata[index].status = 'p';
                      });
                    }
                  } else {
                    bool response = await UserService()
                        .updatestatus(listdata[index].id, 'd');
                    if (response) {
                      setState(() {
                        listdata[index].status = 'd';
                      });
                    }
                  }
                })
          ],
        )
      ],
    );
  }

  Widget listtileview(int index) {
    return ListTile(
      title: Text(
        listdata[index].title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        listdata[index].description,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void initiallist() async {
    if (await checkconnection()) {
      UserService().getallquize().then((value) {
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
