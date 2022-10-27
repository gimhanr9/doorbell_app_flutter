import 'package:flutter/material.dart';
import 'package:flutter_doorbell/widgets/loading_button/rounded_button.dart';

class LiveStreamingNew extends StatelessWidget {
  const LiveStreamingNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Click the following button to view the live stream on your browser!",
        ),
        const SizedBox(height: 10),
        // Container(CustomRoundedButton(
        //     enabled: true, text: "View live stream", onPressed: handleLogin()))
      ],
    );
  }

  // Future<void> handleLogin() async {

  //     dynamic res =
  //         await authApiClient.login(textfieldValues[0], textfieldValues[1]);

  //     if (res['error'] == null) {
  //       SharedPreferences preferences = await SharedPreferences.getInstance();
  //       preferences.setString('userToken', res['data']);

  //       await OneSignal.shared.getDeviceState().then((value) async {
  //         dynamic resu = await authApiClient.updateOneSignal(
  //             textfieldValues[0], value!.userId!);
  //         if (resu['error'] == null) {
  //           setState(() {
  //             state = ButtonState.completed;
  //           });
  //           Navigator.of(context).pushReplacement(MaterialPageRoute(
  //             builder: (BuildContext context) => const HomeScreen(),
  //           ));
  //         } else {
  //           setState(() {
  //             state = ButtonState.error;
  //           });
  //           Future.delayed(const Duration(seconds: 1), () {
  //             setState(() {
  //               state = ButtonState.init;
  //             });
  //           });

  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             content: const Text(
  //                 'Login successful but could not create ID. Try logging in again.'),
  //             backgroundColor: Colors.red.shade300,
  //           ));
  //         }
  //       }).catchError((error) {
  //         setState(() {
  //           state = ButtonState.error;
  //         });
  //         Future.delayed(const Duration(seconds: 1), () {
  //           setState(() {
  //             state = ButtonState.init;
  //           });
  //         });

  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: const Text(
  //               'Login successful but could not create ID. Try logging in again.'),
  //           backgroundColor: Colors.red.shade300,
  //         ));
  //       });
  //       print("all dsodssafsasdvdvdoneeeeeeeeeeeeeee");
  //       // await OneSignal.shared
  //       //     .setExternalUserId(decodedToken['id'])
  //       //     .then((results) {
  //       //   setState(() {
  //       //     state = ButtonState.completed;
  //       //   });
  //       //   Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       //     builder: (BuildContext context) => const HomeScreen(),
  //       //   ));
  //       // }).catchError((error) {
  //       //   setState(() {
  //       //     state = ButtonState.error;
  //       //   });
  //       //   Future.delayed(const Duration(seconds: 1), () {
  //       //     setState(() {
  //       //       state = ButtonState.init;
  //       //     });
  //       //   });

  //       //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       //     content: const Text(
  //       //         'Valid credentials but could not create ID. Try logging in again.'),
  //       //     backgroundColor: Colors.red.shade300,
  //       //   ));
  //       // });
  //     } else {
  //       setState(() {
  //         state = ButtonState.error;
  //       });
  //       await Future.delayed(const Duration(seconds: 1));
  //       setState(() {
  //         state = ButtonState.init;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Error: ${res['message']}'),
  //         backgroundColor: Colors.red.shade300,
  //       ));
  //     }
  //   }
  // }
}
