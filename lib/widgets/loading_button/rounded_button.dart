import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const CustomRoundedButton(
      {Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style:
          ElevatedButton.styleFrom(shape: const StadiumBorder(), elevation: 0),
      onPressed: () {
        onPressed();
      },
      child: Text(text),
    );
  }
}
