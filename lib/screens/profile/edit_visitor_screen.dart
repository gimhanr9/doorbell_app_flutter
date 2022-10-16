import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doorbell/api/profile_api.dart';
import 'package:flutter_doorbell/screens/login/login_screen.dart';
import 'package:flutter_doorbell/screens/profile/selection_dialog.dart';
import 'package:flutter_doorbell/utils/color_file.dart';
import 'package:flutter_doorbell/widgets/loading_button/circular_progress.dart';
import 'package:flutter_doorbell/widgets/loading_button/rounded_button.dart';
import 'package:flutter_doorbell/widgets/network_call_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditVisitorScreen extends StatefulWidget {
  final String fname;
  final String lname;
  final String imageUrl;
  const EditVisitorScreen(
      {Key? key,
      required this.fname,
      required this.lname,
      required this.imageUrl})
      : super(key: key);

  @override
  State<EditVisitorScreen> createState() => _EditVisitorScreenState();
}

class _EditVisitorScreenState extends State<EditVisitorScreen> {
  final ProfileApiClient profileApiClient = ProfileApiClient();
  bool isLoading = false;
  bool isAuthenticated = true;
  bool problem = false;
  String error = "";
  ButtonState state = ButtonState.init;
  File? visitorImage;
  List textfieldValues = [
    "", //fname
    "", //lname
  ];

  String errorFname = "";
  String errorLname = "";

  final _fnamekey = GlobalKey<FormState>();
  final _lnameKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width;
    final isInit = isAnimating || state == ButtonState.init;
    final isError = state == ButtonState.error;
    final isDone = state == ButtonState.completed;
    return Scaffold(
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
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                height: MediaQuery.of(context).size.height - 50,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: const <Widget>[
                        Text(
                          "Edit Visitor",
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
                    Stack(
                      children: <Widget>[
                        visitorImage != null
                            ? Image.file(
                                File(visitorImage!.path),
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                widget.imageUrl,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                        Positioned(
                            bottom: 1,
                            right: 1,
                            child: Container(
                              height: 40,
                              width: 40,
                              child: IconButton(
                                onPressed: () {
                                  showDialog(
                                    barrierColor: Colors.black26,
                                    context: context,
                                    builder: (context) {
                                      return SelectionDialog(
                                        selectCamera: () {
                                          pickFromCamera();
                                        },
                                        selectGallery: () {
                                          pickFromGallery();
                                        },
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.add_a_photo,
                                    color: Colors.white),
                              ),
                              decoration: const BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ))
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        inputField("First Name", widget.fname, false, (fname) {
                          if (fname.length == 0) {
                            setState(() {
                              errorFname = "Please enter a valid first name";
                            });
                            return '';
                          }
                          setState(() {
                            errorFname = '';
                          });
                          return null;
                        }, _fnamekey, 0),
                        Text(
                          errorFname != "" ? errorFname : "",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.red),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        inputField("Last Name", widget.lname, false, (lname) {
                          if (lname.length == 0) {
                            setState(() {
                              errorLname = "Please enter a valid first name";
                            });
                            return '';
                          }
                          setState(() {
                            errorLname = '';
                          });
                          return null;
                        }, _lnameKey, 1),
                        Text(
                          errorLname != "" ? errorLname : "",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.red),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              onEnd: () => setState(() {
                                    isAnimating = !isAnimating;
                                  }),
                              width:
                                  state == ButtonState.init ? buttonWidth : 70,
                              height: 60,
                              child: isInit
                                  ? CustomRoundedButton(
                                      enabled: true,
                                      text: 'Save',
                                      onPressed: () {
                                        editVisitor();
                                      },
                                    )
                                  : CustomCircularProgress(
                                      error: isError,
                                      done: isDone,
                                    )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ));
  }

  void sendToLogin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => const LoginScreen(),
    ));
  }

  Future<void> editVisitor() async {
    if (_fnamekey.currentState!.validate() &&
        _lnameKey.currentState!.validate()) {
      if (visitorImage != null) {
        setState(() {
          state = ButtonState.submitting;
        });
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? token = preferences.getString('userToken');
        token ??= "";
        dynamic res = await profileApiClient.addVisitor(
            token, visitorImage!, textfieldValues[0], textfieldValues[1]);

        if (res['error'] == null) {
          setState(() {
            state = ButtonState.completed;
          });
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              state = ButtonState.init;
              textfieldValues[0] = "";
              textfieldValues[1] = "";
            });
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Visitor details edited successfully'),
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Please pick an image of the visitor'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  Widget inputField(label, value, obscureText, FormFieldValidator validator,
      Key key, int position) {
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
            initialValue: value,
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

  pickFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => visitorImage = imageTemp);
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Error: Failed to pick image'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  pickFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => visitorImage = imageTemp);
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Error: Failed to pick image'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }
}
