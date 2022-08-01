import 'package:flutter/material.dart';

class CustomCircularProgress extends StatelessWidget {
  final bool error;
  final bool done;
  const CustomCircularProgress(
      {Key? key, required this.error, required this.done})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = error
        ? Colors.red
        : done
            ? Colors.green
            : Colors.blue;
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: error
            ? const Icon(Icons.error_outline_rounded,
                size: 50, color: Colors.white)
            : done
                ? const Icon(Icons.done, size: 50, color: Colors.white)
                : const CircularProgressIndicator(
                    color: Colors.white,
                  ),
      ),
    );
  }
}
