import 'package:flutter/material.dart';
import 'package:flutter_doorbell/api/auth_api.dart';
import 'package:flutter_doorbell/screens/login/login_screen.dart';
import 'package:flutter_doorbell/screens/reset_password/reset_password_screen.dart';
import 'package:flutter_doorbell/widgets/loading_button/circular_progress.dart';
import 'package:flutter_doorbell/widgets/loading_button/rounded_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

bool isAnimating = true;

enum ButtonState { init, submitting, completed, error }

class OTPInputScreen extends StatefulWidget {
  final String email;
  const OTPInputScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<OTPInputScreen> createState() => _OTPInputScreenState();
}

class _OTPInputScreenState extends State<OTPInputScreen> {
  final AuthApiClient authApiClient = AuthApiClient();
  ButtonState state = ButtonState.init;
  TextEditingController textEditingController = TextEditingController();
  String otpInput = "";
  bool enableContinue = false;
  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width;
    final isInit = isAnimating || state == ButtonState.init;
    final isError = state == ButtonState.error;
    final isDone = state == ButtonState.completed;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Text(
                    "Enter OTP",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter the 4-digit OTP you received through email ",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 50,
                      activeFillColor: Colors.white,
                    ),
                    controller: textEditingController,
                    onChanged: (value) {
                      setState(() {
                        if (value.length < 4) {
                          enableContinue = false;
                        } else {
                          enableContinue = true;
                        }
                        otpInput = value;
                      });
                    },
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 3, left: 3),
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    onEnd: () => setState(() {
                          isAnimating = !isAnimating;
                        }),
                    width: state == ButtonState.init ? buttonWidth : 70,
                    height: 60,
                    child: isInit
                        ? CustomRoundedButton(
                            enabled: enableContinue,
                            text: 'Continue',
                            onPressed: () {
                              handleCheckOTP();
                            },
                          )
                        : CustomCircularProgress(
                            error: isError,
                            done: isDone,
                          )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const LoginScreen(),
                        ));
                      },
                      child: const Text(
                        "Back to login",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleCheckOTP() async {
    setState(() {
      state = ButtonState.submitting;
    });
    dynamic res = await authApiClient.checkOtp(widget.email, otpInput);

    if (res['error'] == null) {
      setState(() {
        state = ButtonState.completed;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) =>
            ResetPasswordScreen(email: widget.email),
      ));
    } else {
      setState(() {
        state = ButtonState.error;
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        state = ButtonState.init;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['message']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }
}
