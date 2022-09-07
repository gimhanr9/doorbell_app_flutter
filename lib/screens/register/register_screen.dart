import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doorbell/api/auth_api.dart';
import 'package:flutter_doorbell/screens/home/home_screen.dart';
import 'package:flutter_doorbell/screens/login/login_screen.dart';
import 'package:flutter_doorbell/widgets/loading_button/circular_progress.dart';
import 'package:flutter_doorbell/widgets/loading_button/rounded_button.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

bool isAnimating = true;

enum ButtonState { init, submitting, completed, error }

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthApiClient authApiClient = AuthApiClient();
  ButtonState state = ButtonState.init;
  List textfieldValues = [
    "", //name
    "", //email
    "", //password
    "", //confirmPassword
  ];

  String errorEmail = "";
  String errorName = "";
  String errorPassword = "";
  String errorConfirmPassword = "";
  String deviceId = "";

  final _namekey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _confirmPasswordKey = GlobalKey<FormState>();

  bool isEmail(String input) => EmailValidator.validate(input);

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
                    "Sign up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create an account",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  inputField("Name", false, (name) {
                    if (name.length == 0) {
                      setState(() {
                        errorName = "Please enter a valid name";
                      });
                      return '';
                    }
                    setState(() {
                      errorName = '';
                    });
                    return null;
                  }, _namekey, 0),
                  Text(
                    errorName != "" ? errorName : "",
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                  }, _emailKey, 1),
                  Text(
                    errorEmail != "" ? errorEmail : "",
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                  }, _passwordKey, 2),
                  Text(
                    errorPassword != "" ? errorPassword : "",
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  inputField("Confirm Password", true, (cPassword) {
                    if (cPassword != textfieldValues[2]) {
                      setState(() {
                        errorConfirmPassword = "Passwords do not match";
                      });
                      return '';
                    }
                    setState(() {
                      errorConfirmPassword = '';
                    });
                    return null;
                  }, _confirmPasswordKey, 3),
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
                              handleRegister();
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
                  const Text("Already have an account?"),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const LoginScreen(),
                        ));
                      },
                      child: const Text(
                        " Login",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontSize: 16),
                      ))
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleRegister() async {
    if (_namekey.currentState!.validate() &&
        _emailKey.currentState!.validate() &&
        _passwordKey.currentState!.validate() &&
        _confirmPasswordKey.currentState!.validate()) {
      setState(() {
        state = ButtonState.submitting;
      });

      // await OneSignal.shared
      //     .getDeviceState()
      //     .then((value) => {deviceId = value!.userId;});

      dynamic res = await authApiClient.register(
          textfieldValues[0], textfieldValues[1], textfieldValues[2]);

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
                'Registration successful but could not create ID. Try logging in with the credentials.'),
            backgroundColor: Colors.red.shade300,
          ));
        });
        // setState(() {
        //   state = ButtonState.completed;
        // });
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //   builder: (BuildContext context) => const HomeScreen(),
        // ));
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
