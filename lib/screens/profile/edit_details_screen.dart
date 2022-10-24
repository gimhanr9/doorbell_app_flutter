import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doorbell/api/profile_api.dart';
import 'package:flutter_doorbell/screens/login/login_screen.dart';
import 'package:flutter_doorbell/utils/color_file.dart';
import 'package:flutter_doorbell/widgets/loading_button/circular_progress.dart';
import 'package:flutter_doorbell/widgets/loading_button/rounded_button.dart';
import 'package:flutter_doorbell/widgets/network_call_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDetailsScreen extends StatefulWidget {
  final String name;
  final String email;
  const EditDetailsScreen({Key? key, required this.name, required this.email})
      : super(key: key);

  @override
  State<EditDetailsScreen> createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends State<EditDetailsScreen> {
  final ProfileApiClient profileApiClient = ProfileApiClient();
  bool isLoading = false;
  bool isAuthenticated = true;
  bool problem = false;
  String error = "";
  ButtonState state = ButtonState.init;
  List textfieldValues = [
    "", //name
    "", //email
  ];

  String errorEmail = "";
  String errorName = "";

  final _namekey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();

  bool isEmail(String input) => EmailValidator.validate(input);

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width;
    final isInit = isAnimating || state == ButtonState.init;
    final isError = state == ButtonState.error;
    final isDone = state == ButtonState.completed;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Profile"),
        backgroundColor: ColorFile.header,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: problem == true
          ? NetworkCallInfo(
              error: error,
              isLogin: isAuthenticated,
              onPressed: () {
                sendToLogin();
              },
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                height: MediaQuery.of(context).size.height - 50,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: const <Widget>[
                        Text(
                          "Edit your details",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        inputField("Name", widget.name, false, (name) {
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
                          style:
                              const TextStyle(fontSize: 12, color: Colors.red),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        inputField("Email", widget.email, false, (email) {
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
                          style:
                              const TextStyle(fontSize: 12, color: Colors.red),
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
                                  text: 'Save',
                                  onPressed: () {
                                    editDetails();
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

  void sendToLogin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => const LoginScreen(),
    ));
  }

  Future<void> editDetails() async {
    if (_namekey.currentState!.validate() &&
        _emailKey.currentState!.validate()) {
      setState(() {
        state = ButtonState.submitting;
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('userToken');
      token ??= "";
      dynamic res = await profileApiClient.editProfile(
          token, textfieldValues[0], textfieldValues[1]);

      if (res['error'] == null) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('userToken', res['data']);
        setState(() {
          state = ButtonState.completed;
        });
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            state = ButtonState.init;
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Changes saved successfully'),
          backgroundColor: Colors.green.shade400,
        ));
      } else {
        setState(() {
          state = ButtonState.error;
        });
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            state = ButtonState.init;
          });
        });
        if (res['message'] == "Authentication failed") {
          setState(() {
            problem = true;
            error = res['message'];
            isAuthenticated = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: ${res['message']}'),
            backgroundColor: Colors.red.shade300,
          ));
        }
      }
    }
  }

  Widget inputField(label, initialValue, obscureText,
      FormFieldValidator validator, Key key, int position) {
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
            initialValue: initialValue,
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
