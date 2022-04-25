import 'package:flutter/material.dart';
import 'package:note_app/const/colors.dart';

class MyButton extends StatelessWidget {
  final String lable;
  final Function()? onTap;
  const MyButton({Key? key, required this.lable, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryClr,
        ),
        child: Center(
          child: Text(
            lable,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
