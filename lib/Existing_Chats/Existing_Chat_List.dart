import 'package:jchat/Existing_Chats/Group_Details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Existing_Chat_List{

  static final Existing_Chat_List _instance = Existing_Chat_List._internal();
  List<Group_Details> existingchatlist = [];

  factory Existing_Chat_List() {
    return _instance;
  }

  Existing_Chat_List._internal();

  Future<void> loadChatGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? chatGroupList = prefs.getStringList('chatGroups');

    if (chatGroupList != null) {
      existingchatlist = chatGroupList.map((groupData) {
        return _stringToGroup(groupData); // Convert string to Group_Details
      }).toList();
    }
  }

  Future<void> saveChatGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chatGroupList = existingchatlist.map((group) {
      return _groupToString(group); // Convert Group_Details to string
    }).toList();
    prefs.setStringList('chatGroups', chatGroupList);
  }

  // Conversion methods
  String _groupToString(Group_Details group) {
    return "${group.Group_Code}:${group.Group_Description}";
  }

  Group_Details _stringToGroup(String str) {
    List<String> parts = str.split(":");
    return Group_Details(
      Group_Code: parts[0],
      Group_Description: parts[1],
    );
  }

  void addGroup(Group_Details group) {
    existingchatlist.add(group);
    saveChatGroups(); // Save updated chat groups
  }

  List<Group_Details> display(){
    return existingchatlist;
  }

}