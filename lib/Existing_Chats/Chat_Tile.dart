import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jchat/Existing_Chats/Existing_Chat_List.dart';
import 'package:jchat/Screens/GroupCode.dart';
import 'Group_Details.dart';
import '../Screens/chat_screen.dart';

class Chat_Tile extends StatefulWidget {
  const Chat_Tile({Key? key}) : super(key: key);
  static String id = 'tile';

  @override
  State<Chat_Tile> createState() => _Chat_TileState();
}

class _Chat_TileState extends State<Chat_Tile> {
  TextEditingController _groupNameController = TextEditingController();
  bool _isEditing = false;
  bool _isRenaming = false;
  Group_Details? _renamingChatGroup;

  late Future<void> loadingChatGroups; // Future for loading chat groups

  @override
  void initState() {
    super.initState();
    loadingChatGroups = Existing_Chat_List().loadChatGroups(); // Start loading chat groups
  }

  void alert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey,
          title: Text('Information'),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'To update the group\'s name or provide a new name if it\'s currently empty, follow these steps:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '1. Long Press: Press and hold on the group you want to modify.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                '2. Group Name: If the group doesn\'t have a name yet, a text field will appear for you to enter a name.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                '3. Rename: If the group already has a name, a prompt will appear to edit the existing name.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'These steps allow you to easily manage the group names within the app.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Okay',
              ),
            )
          ],
        );
      },
    );
  }

  void _renameGroup(BuildContext context, Group_Details chatGroup) {
    _renamingChatGroup = chatGroup; // Set the chat group being renamed
    _groupNameController.text = chatGroup.Group_Description;
    setState(() {
      _isRenaming = true;
    });

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
        setState(() {
          _isRenaming = false;
        });
        Navigator.of(context).pop();
      },
    child: Text('Cancel'),
    ),
    TextButton(
    onPressed: () {
    // Rename the chat group and save the new name
    _renamingChatGroup!.Group_Description = _groupNameController.text;
    // Save the renamed chat group
    Existing_Chat_List().saveChatGroups();
    setState(() {
      _isRenaming = false;
    });
    Navigator.of(context).pop();
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
    return Scaffold(
      backgroundColor: Color(0xFF201b31),
      appBar: AppBar(
        backgroundColor: Color(0xFF39304d),
        title: Text('Existing Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            iconSize: 30,
            onPressed: (){
              alert();
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: loadingChatGroups,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while loading chat groups
            return Center(
              child: SpinKitChasingDots(
                color: Colors.red,
              ),
            );
          } else if (snapshot.hasError) {
            // Handle error if loading encounters an error
            return Center(
              child: Text('Error loading chat groups'),
            );
          } else {
            // Display the list of chat groups once loaded
            return ListView.builder(
              itemCount: Existing_Chat_List().existingchatlist.length,
              itemBuilder: (context, index) {
                final chatGroup = Existing_Chat_List().existingchatlist[index];

                return GestureDetector(
                  onTap: () {
                    if (!_isRenaming && !_isEditing) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat(stringmessage: chatGroup.Group_Code),
                        ),
                      );
                    }
                  },
                  onLongPress: () {
                    _renameGroup(context, chatGroup);
                  },
                  child: ListTile(
                    title: _isEditing || (_isRenaming && _renamingChatGroup == chatGroup)
                        ? TextField(controller: _groupNameController)
                        : Text(chatGroup.Group_Description),
                    subtitle: Text(chatGroup.Group_Code),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
