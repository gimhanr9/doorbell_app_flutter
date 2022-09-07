import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doorbell/api/auth_api.dart';
import 'package:flutter_doorbell/screens/forgot_password/forgot_password_screen.dart';
import 'package:flutter_doorbell/screens/home/home_screen.dart';
import 'package:flutter_doorbell/screens/register/register_screen.dart';
import 'package:flutter_doorbell/widgets/loading_button/circular_progress.dart';
import 'package:flutter_doorbell/widgets/loading_button/rounded_button.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isAnimating = true;

enum ButtonState { init, submitting, completed, error }

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthApiClient authApiClient = AuthApiClient();
  ButtonState state = ButtonState.init;
  List textfieldValues = [
    "", //email
    "", //password
  ];

  String errorEmail = "";
  String errorPassword = "";

  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isEmail(String input) => EmailValidator.validate(input);

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width;
    final isInit = isAnimating || state == ButtonState.init;
    final isError = state == ButtonState.error;
    final isDone = state == ButtonState.completed;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Login to your account",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        inputField("Email", false, (email) {
                          if (!isEmail(email)) {
                            setState(() {
                              errorEmail = "Please enter a valid email";
                            });
                            return '';
                          }
                          setState(() {
                            errorEmail = '';
                          });
                          return null;
                        }, _emailKey, 0),
                        Text(
                          errorEmail != "" ? errorEmail : "",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.red),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        inputField("Password", true, (password) {
                          if (password.length == 0) {
                            setState(() {
                              errorPassword = "Please enter the password";
                            });
                            return '';
                          }
                          setState(() {
                            errorPassword = '';
                          });
                          return null;
                        }, _passwordKey, 1),
                        Text(
                          errorPassword != "" ? errorPassword : "",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.red),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
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
                                  handleLogin();
                                },
                              )
                            : CustomCircularProgress(
                                error: isError,
                                done: isDone,
                              )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: const EdgeInsets.only(left: 3),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const ForgotPasswordScreen(),
                          ));
                        },
                        child: const Text(
                          "Forgot Password",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Don't have an account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const RegisterScreen(),
                          ));
                        },
                        child: const Text(
                          " Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleLogin() async {
    if (_emailKey.currentState!.validate() &&
        _passwordKey.currentState!.validate()) {
      setState(() {
        state = ButtonState.submitting;
      });
      dynamic res =
          await authApiClient.login(textfieldValues[0], textfieldValues[1]);

      if (res['error'] == null) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('userToken', res['data']);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(res['data']);
        OneSignal.shared.setExternalUserId(decodedToken['id']).then((results) {
          setState(() {
            state = ButtonState.completed;
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen(),
          ));
        }).catchError((error) {
          setState(() {
            state = ButtonState.error;
          });
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              state = ButtonState.init;
            });
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
                'Valid credentials but could not create ID. Try logging in again.'),
            backgroundColor: Colors.red.shade300,
          ));
        });
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
