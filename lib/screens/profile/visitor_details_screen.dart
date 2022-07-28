import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_doorbell/utils/color_file.dart';

class VisitorDetailsScreen extends StatefulWidget {
  const VisitorDetailsScreen({Key? key}) : super(key: key);

  @override
  State<VisitorDetailsScreen> createState() => _VisitorDetailsScreenState();
}

class _VisitorDetailsScreenState extends State<VisitorDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 1,
        title: const Text('Visitor Details'),
        backgroundColor: ColorFile.header,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Hi Gimhan,",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(''),
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 50.0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1.0,
                            ),
                            color: const Color(0xff0095FF),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Center(
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1.0,
                            ),
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Center(
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
