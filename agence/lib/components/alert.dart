import 'package:flutter/material.dart';

showloading(context) {
  showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          shape: RoundedRectangleBorder(),
          title: Text(
            "Please Wait...",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
          ),
          content: Center(child: CircularProgressIndicator()),
        );
      });
}
