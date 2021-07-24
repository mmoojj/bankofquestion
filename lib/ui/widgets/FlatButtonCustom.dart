import 'package:flutter/material.dart';

class Custom_flat_butt extends StatelessWidget {
  String text;
  Color color;
  final onpressed;
  Custom_flat_butt(
      {@required this.text, @required this.color, @required this.onpressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 15),
        child: TextButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) => color),
            ),
            onPressed: onpressed,
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            )));
  }
}
