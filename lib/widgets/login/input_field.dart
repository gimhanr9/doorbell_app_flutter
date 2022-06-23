import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final label;
  final hideText;
  const InputField({Key? key, required this.label, this.hideText = false})
      : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          obscureText: widget.hideText,
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400))),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
