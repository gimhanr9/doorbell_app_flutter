import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doorbell/screens/profile/selection_dialog.dart';
import 'package:flutter_doorbell/utils/color_file.dart';
import 'package:image_picker/image_picker.dart';

class AddVisitorScreen extends StatefulWidget {
  const AddVisitorScreen({Key? key}) : super(key: key);

  @override
  State<AddVisitorScreen> createState() => _AddVisitorScreenState();
}

class _AddVisitorScreenState extends State<AddVisitorScreen> {
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
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: const <Widget>[
                  Text(
                    "Add Visitor",
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
                  Image.network(
                    'https://img.icons8.com/fluency/344/image.png',
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
                  inputField("First Name", false, (fname) {
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
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  inputField("Last Name", false, (lname) {
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
                    style: const TextStyle(fontSize: 12, color: Colors.red),
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

  pickFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => visitorImage = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  pickFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => visitorImage = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
