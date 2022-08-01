import 'package:flutter/material.dart';
import 'package:flutter_doorbell/api/auth_api.dart';
import 'package:flutter_doorbell/screens/login/login_screen.dart';
import 'package:flutter_doorbell/widgets/loading_button/circular_progress.dart';
import 'package:flutter_doorbell/widgets/loading_button/rounded_button.dart';

bool isAnimating = true;

enum ButtonState { init, submitting, completed, error }

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final AuthApiClient authApiClient = AuthApiClient();
  ButtonState state = ButtonState.init;
  List textfieldValues = [
    "", //password
    "", //confirmPassword
  ];

  String errorPassword = "";
  String errorConfirmPassword = "";

  final _passwordKey = GlobalKey<FormState>();
  final _confirmPasswordKey = GlobalKey<FormState>();
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
                    "Reset Password",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter a strong password ",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  inputField("Password", true, (password) {
                    if (password.length < 6) {
                      setState(() {
                        errorPassword =
                            "Password should consist of at least 6 characters";
                      });
                      return '';
                    }
                    setState(() {
                      errorPassword = '';
                    });
                    return null;
                  }, _passwordKey, 0),
                  Text(
                    errorPassword != "" ? errorPassword : "",
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  inputField("Confirm Password", true, (cPassword) {
                    if (cPassword != textfieldValues[0]) {
                      setState(() {
                        errorConfirmPassword = "Passwords do not match";
                      });
                      return '';
                    }
                    setState(() {
                      errorConfirmPassword = '';
                    });
                    return null;
                  }, _confirmPasswordKey, 1),
                  Text(
                    errorConfirmPassword != "" ? errorConfirmPassword : "",
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                            enabled: true,
                            text: 'Login',
                            onPressed: () {
                              handleResetPassword();
                            },
                          )
                        : CustomCircularProgress(
                            error: isError,
                            done: isDone,
                          )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleResetPassword() async {
    if (_passwordKey.currentState!.validate() &&
        _confirmPasswordKey.currentState!.validate()) {
      setState(() {
        state = ButtonState.submitting;
      });
      dynamic res =
          await authApiClient.resetPassword(widget.email, textfieldValues[0]);

      if (res['error'] == null) {
        setState(() {
          state = ButtonState.completed;
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen(),
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

  Widget inputField(
      label, obscureText, FormFieldValidator validator, Key key, int position) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        Form(
          key: key,
          child: TextFormField(
            onChanged: ((value) {
              setState(() {
                textfieldValues[position] = value;
              });
            }),
            obscureText: obscureText,
            validator: validator,
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400))),
          ),
        ),
      ],
    );
  }
}
