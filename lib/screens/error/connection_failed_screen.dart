import 'package:flutter/material.dart';

class ConnectionFailedScreen extends StatelessWidget {
  final VoidCallback? onReconnect;
  const ConnectionFailedScreen(this.onReconnect);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/connection_failed.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: MediaQuery.of(context).size.width * 0.3,
            right: MediaQuery.of(context).size.width * 0.3,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 13),
                    blurRadius: 25,
                    color: const Color(0xFF5666C2).withOpacity(0.17),
                  ),
                ],
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: const Color(0xFF68C581),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                onPressed: () {
                  onReconnect!;
                  Navigator.pop(context);
                },
                child: Text(
                  "retry".toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
