import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  final bool enabled;
  final String text;
  final Function() onPressed;
  const CustomRoundedButton(
      {Key? key,
      required this.enabled,
      required this.text,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style:
          ElevatedButton.styleFrom(shape: const StadiumBorder(), elevation: 0),
      onPressed: !enabled
          ? null
          : (() {
              onPressed();
            }),
      child: Text(text),
    );
  }
}
