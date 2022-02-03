import 'package:flutter/material.dart';

class Loading extends StatelessWidget{
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.all(5),
            child: const CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
        ),
      ],
    );;
  }

}