import 'package:flutter/material.dart';

class CSKH extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.phone_in_talk, color: Colors.white,),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90),
        ),
      );
  }
}
