import 'package:flutter/material.dart';

class VisitorDeleteSelectionDialog extends StatefulWidget {
  final Function() selectCamera;
  final Function() selectGallery;
  final String visitorName;
  const VisitorDeleteSelectionDialog(
      {Key? key,
      required this.selectCamera,
      required this.selectGallery,
      required this.visitorName})
      : super(key: key);

  @override
  State<VisitorDeleteSelectionDialog> createState() =>
      _VisitorDeleteSelectionDialogState();
}

class _VisitorDeleteSelectionDialogState
    extends State<VisitorDeleteSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          const Text(
            "Delete image",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Text('Confirm deletion of ${widget.visitorName}')),
          const SizedBox(height: 20),
          const Divider(
            height: 1,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              highlightColor: Colors.grey[200],
              onTap: () {
                widget.selectCamera();
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  "Confirm",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              highlightColor: Colors.grey[200],
              onTap: () {
                widget.selectGallery();
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
