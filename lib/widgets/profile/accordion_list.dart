import 'package:flutter/material.dart';
import 'package:flutter_doorbell/models/saved_visitor.dart';

class AccordionList extends StatefulWidget {
  final String title;
  const AccordionList({Key? key, required this.title}) : super(key: key);

  @override
  State<AccordionList> createState() => _AccordionListState();
}

class _AccordionListState extends State<AccordionList> {
  bool _showContent = false;
  late List visitors;

  @override
  void initState() {
    visitors = getSavedVisitors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text(widget.title),
          trailing: IconButton(
            icon: Icon(
                _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            onPressed: () {
              setState(() {
                _showContent = !_showContent;
              });
            },
          ),
        ),
        _showContent
            ? Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: visitors.length,
                      itemBuilder: (context, index) {
                        return makeCard(visitors[index]);
                      },
                    ),
                  )
                ],
              )
            : Container()
      ]),
    );
  }

  Card makeCard(SavedVisitor savedVisitor) => Card(
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(228, 247, 247, 247)),
          child: makeListCard(savedVisitor),
        ),
      );

  ListTile makeListCard(SavedVisitor savedVisitor) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
              border:
                  Border(right: BorderSide(width: 1.0, color: Colors.white24))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                savedVisitor.imageUrl,
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        title: Text(
          savedVisitor.fname + " " + savedVisitor.lname,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.more_vert_rounded,
            color: Colors.black, size: 30.0),
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) =>
          //             RecordingPlayer(recordingUrl: recording.url)));
        },
      );
}

List getSavedVisitors() {
  return [
    SavedVisitor(
      fname: "Sam",
      lname: "Curran",
      imageUrl:
          "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTB8fHxlbnwwfHx8fA%3D%3D&w=1000&q=80",
    )
  ];
}
