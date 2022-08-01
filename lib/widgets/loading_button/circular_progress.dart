import 'package:flutter/material.dart';

class CustomCircularProgress extends StatelessWidget {
  final bool done;
  const CustomCircularProgress({Key? key, required this.done})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = done ? Colors.green : Colors.blue;
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: done
            ? const Icon(Icons.done, size: 50, color: Colors.white)
            : const CircularProgressIndicator(
                color: Colors.white,
              ),
      ),
    );
  }
}
