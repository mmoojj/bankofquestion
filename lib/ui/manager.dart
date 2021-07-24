import 'package:bankofquestion_fix/ui/widgets/quizepanelinfo.dart';
import 'package:bankofquestion_fix/ui/widgets/userpanelinfo.dart';
import 'package:flutter/material.dart';

class Manager extends StatefulWidget {
  @override
  _ManagerState createState() => _ManagerState();
}

class _ManagerState extends State<Manager> with SingleTickerProviderStateMixin {
  TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final appbar = SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: Color(0xffFCD4DE),
      bottom: TabBar(
        controller: _controller,
        tabs: [
          Text(
            "آزمون ها",
            style: TextStyle(color: Colors.black),
          ),
          Text("کاربران", style: TextStyle(color: Colors.black))
        ],
      ),
    );
    return NestedScrollView(
        headerSliverBuilder: (context, index) => [appbar],
        body: TabBarView(
          controller: _controller,
          children: [Quizepanelinfo(), Userpanelinfo()],
        ));
  }
}
