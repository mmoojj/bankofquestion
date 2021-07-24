import 'package:bankofquestion_fix/models/user.dart';

import 'package:bankofquestion_fix/ui/animations/floatingActionbutton.dart';
import 'package:bankofquestion_fix/ui/manager.dart';
import 'package:bankofquestion_fix/ui/quize.dart';

import 'package:bankofquestion_fix/constants/constants.dart';
import 'package:bankofquestion_fix/ui/widgets/drawerCostomize.dart';
import 'package:bankofquestion_fix/ui/widgets/staff.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  User user;
  HomePage(this.user);
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _courentselector = 0;
  AnimationController _floatactioncontroller;
  var size;
  @override
  void initState() {
    _floatactioncontroller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    final bottomNavLayout = [
      Stack(
        children: [
          Quize(),
          DrawerCostomize(user: widget.user),
        ],
      ),
      widget.user.issuperuser ? Manager() : Staff()
    ];
    return Scaffold(
      extendBody: true,
      body: _courentselector == 0 ? bottomNavLayout[0] : bottomNavLayout[1],
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: widget.user.isstaff || widget.user.issuperuser
          ? AnimatedBuilder(
              animation: _floatactioncontroller,
              builder: floatactionanimate,
            )
          : null,
      bottomNavigationBar: widget.user.isstaff || widget.user.issuperuser
          ? BottomAppBar(
              color: Color(0xddFCD4DE),
              shape: CircularNotchedRectangle(),
              notchMargin: 5,
              child: bottomnavbar(),
            )
          : null,
    );
  }

  Widget floatactionanimate(context, child) {
    return FloatingActionAnimate(
      controller: _floatactioncontroller,
      userid: widget.user.id,
    );
  }

  onItemTap(int value) {
    setState(() {
      _courentselector = value;
    });
  }

  Widget bottomnavbar() {
    return Container(
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => onItemTap(0),
            child: Column(
              children: [
                Icon(
                  Icons.home,
                  color: _courentselector == 0 ? Colors.blueAccent : null,
                ),
                Text(BOTTON_NAV_ITEM_HOME)
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onItemTap(1),
            child: Column(
              children: [
                Icon(Icons.group,
                    color: _courentselector == 1 ? Colors.blueAccent : null),
                Text(BOTTON_NAV_ITEM_USERS)
              ],
            ),
          )
        ],
      ),
    );
  }
}
