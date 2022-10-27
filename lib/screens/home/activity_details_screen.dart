import 'package:flutter/material.dart';

class ActivityDetails extends StatelessWidget {
  final String name;
  final String date;
  final String time;
  final String imageUrl;
  const ActivityDetails(
      {Key? key,
      required this.name,
      required this.date,
      required this.time,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            const Text(
              'Name : ',
            ),
            Text(
              name,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text(
              'Time : ',
            ),
            Text(
              date + " " + time,
            ),
          ],
        ),
        const SizedBox(height: 15),
        Image.network(
          imageUrl,
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
