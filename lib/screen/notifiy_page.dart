import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifiPage extends StatelessWidget {
  final String? lable;
  const NotifiPage({required this.lable, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? Colors.grey[700] : Colors.white,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Get.isDarkMode ? Colors.white : Colors.grey,
            )),
        title: Text(
          lable!.split("|")[0],
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Get.isDarkMode ? Colors.white : Colors.grey[400],
          ),
          child: Center(
            child: Text(
              lable!.split("|")[1],
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Get.isDarkMode ? Colors.black : Colors.white,
                  fontSize: 30),
            ),
          ),
        ),
      ),
    );
  }
}
