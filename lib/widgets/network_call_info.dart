import 'package:flutter/material.dart';
import 'package:flutter_doorbell/widgets/loading_button/rounded_button.dart';

class NetworkCallInfo extends StatelessWidget {
  final String error;
  final bool isLogin;
  final Function()? onPressed;
  const NetworkCallInfo(
      {Key? key, required this.error, required this.isLogin, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
          size: 30.0,
        ),
        const SizedBox(height: 10),
        Text(
          error,
        ),
        const SizedBox(height: 10),
        Container(
            child: isLogin == false
                ? CustomRoundedButton(
                    enabled: true, text: "Login", onPressed: onPressed!)
                : null)
      ],
    );
  }
}
