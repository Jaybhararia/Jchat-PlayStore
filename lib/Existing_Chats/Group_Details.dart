import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/chat_screen.dart';

class Group_Details extends StatefulWidget {
  final String Group_Code;
  String Group_Description = "";

  Group_Details({required this.Group_Code, required this.Group_Description});

  @override
  State<Group_Details> createState() => _Group_DetailsState();
}

class _Group_DetailsState extends State<Group_Details> {
  final TextEditingController _groupNameController = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  void _renameGroup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rename Group'),
          content: TextField(
            controller: _groupNameController,
            decoration: InputDecoration(hintText: 'Enter new group name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // Perform renaming logic here with _groupNameController.text
                  _isEditing = false;
                  Navigator.of(context).pop();
                });
              },
              child: Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (!_isEditing) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Chat(stringmessage: widget.Group_Code),
                ),
              );
            }
          },
          onLongPress: () {
            setState(() {
              _isEditing = true;
              _groupNameController.text = widget.Group_Description;
            });
            _renameGroup(context);
          },
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xdd4b0082),
              ),
              child: ListTile(
                title: _isEditing
                    ? TextField(
                  controller: _groupNameController,
                  style: TextStyle(fontSize: 18),
                )
                    : Text(
                  "${widget.Group_Description} : ${widget.Group_Code}",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
