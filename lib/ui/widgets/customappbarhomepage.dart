import 'package:bankofquestion_fix/serverside/userService.dart';
import 'package:bankofquestion_fix/ui/quize.dart';
import 'package:flutter/material.dart';

class CustomAppBarHomePage extends StatefulWidget
    implements PreferredSizeWidget {
  final onsubitted;
  CustomAppBarHomePage({this.onsubitted});

  double height;
  Orientation orientation;
  @override
  State<StatefulWidget> createState() => CustomAppBarHomePageState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(400);
}

class CustomAppBarHomePageState extends State<CustomAppBarHomePage> {
  bool showsearchfield = false;
  @override
  Widget build(BuildContext context) {
    widget.height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    widget.orientation = MediaQuery.of(context).orientation;
    return Material(
        child: showsearchfield == false
            ? Container(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? widget.height / 8
                        : widget.height / 6,
                width: width,
                padding: EdgeInsets.only(left: 15, top: 25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.orange[200], Colors.pinkAccent]),
                ),
                child: _searchicon())
            : WillPopScope(
                child: Container(
                    height: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? widget.height / 8
                        : widget.height / 6,
                    width: width,
                    color: Colors.grey,
                    padding: EdgeInsets.all(20),
                    child: Center(child: textfield())),
                onWillPop: _onwillpop));
  }

  Widget _searchicon() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: _onpressed,
      ),
    );
  }

  Widget textfield() {
    return TextField(
      autofocus: true,
      cursorHeight: 30,
      onSubmitted: widget.onsubitted,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
          icon: IconButton(
            icon: Icon(Icons.search),
            onPressed: null,
          ),
          border: InputBorder.none,
          hintText: "جستجو...",
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
    );
  }

  Future<bool> _onwillpop() async {
    setState(() {
      showsearchfield = !showsearchfield;
    });
  }

  void _onpressed() {
    setState(() {
      showsearchfield = !showsearchfield;
    });
  }
}
