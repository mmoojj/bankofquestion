import 'package:bankofquestion_fix/constants/constants.dart';
import 'package:bankofquestion_fix/models/user.dart';
import 'package:bankofquestion_fix/ui/passwordchangeform.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DrawerCostomize extends StatefulWidget {
  User user;
  DrawerCostomize({this.user});

  @override
  _DrawerCostomizeState createState() => _DrawerCostomizeState();
}

class _DrawerCostomizeState extends State<DrawerCostomize>
    with SingleTickerProviderStateMixin {
  bool isActivate = false;
  AnimationController _animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AnimatedPositioned(
        duration: Duration(milliseconds: 700),
        left: isActivate ? width / 2.3 : width - 40,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width - 40,
              height: height - 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 200, bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: widget.user.image != null
                                          ? NetworkImage(
                                              "http://192.168.1.30:8000" +
                                                  widget.user.image)
                                          : AssetImage(
                                              "assets/images/profileimage.png"),
                                      fit: BoxFit.fill)),
                            ),
                            Container(
                                width: 75,
                                height: 75,
                                child: CircularProgressIndicator(
                                  value: 0.8,
                                  valueColor: AlwaysStoppedAnimation(
                                    Color.fromRGBO(228, 100, 114, 0.4),
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: width / 2.4,
                          child: Text(
                            widget.user.name != null
                                ? widget.user.name
                                : widget.user.username,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: width / 2.4,
                          child: Text(
                            widget.user.lname != null ? widget.user.lname : "",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: width / 2.4,
                          child: Text(
                            widget.user.email,
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 2,
                    endIndent: 30,
                    indent: 220,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 200, top: 10),
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text("تنظیمات"),
                      onTap: () {
                        print("setting");

                        setState(() {
                          isActivate = !isActivate;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 200, top: 10),
                    child: ListTile(
                      leading: Icon(Icons.lock),
                      title: Text("تغییر رمز"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PasswordChange()));
                        setState(() {
                          isActivate = !isActivate;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 200, top: 10),
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text("خروج از حساب"),
                      onTap: _signout,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: Color(0xddFCD4DE),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(40), top: Radius.circular(40))),
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    isActivate = !isActivate;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: ClipPath(
                    clipper: CliperCostomise(),
                    child: Container(
                      alignment: Alignment.center,
                      width: 35,
                      height: 110,
                      color: Color(0xddFCD4DE),
                      child: AnimatedIcon(
                        icon: isActivate
                            ? AnimatedIcons.close_menu
                            : AnimatedIcons.menu_close,
                        progress: _animationController.view,
                      ),
                    ),
                  ),
                )),
          ],
        ));
  }

  _signout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.pushReplacementNamed(context, SIGN_IN);
  }
}

class CliperCostomise extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;
    Path path = Path();
    path.moveTo(width, 0);
    path.quadraticBezierTo(width, 8, width - 10, 16);
    path.quadraticBezierTo(0, width, 0, height / 2);
    path.quadraticBezierTo(0, height - width, width - 10, height - 16);
    path.quadraticBezierTo(width, height - 8, width, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
