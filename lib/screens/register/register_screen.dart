import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doorbell/screens/login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  final _namekey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _confirmPasswordKey = GlobalKey<FormState>();

  bool isEmail(String input) => EmailValidator.validate(input);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
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
                    "Create an account, It's free ",
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
                    if (password.length < 8) {
                      setState(() {
                        errorPassword =
                            "Password should consist of at least 8 characters";
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
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: const Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    )),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {},
                  color: const Color(0xff0095FF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
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
