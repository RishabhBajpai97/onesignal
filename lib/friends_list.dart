import 'package:flutter/material.dart';
import 'package:onesignal/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({super.key});
  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  List userList = [];
  @override
  void initState(){
    getUsers();
    WidgetsFlutterBinding.ensureInitialized();
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId("a97f9aed-da4e-4961-b351-9e3073068021");
   notifications();

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
    super.initState();
  }

  Future notifications() async {
    await setId();
    // await checkExternalId();
  }

  Future<void> checkExternalId() async {
    var tags = await OneSignal.shared.getTags();
    print(tags);

    // Retrieve the external ID from the tags
    var externalId = tags['external_id'];
    print(externalId);

    // Check if the external ID is set
    if (externalId != null) {
      print("OneSignal external ID: $externalId");
    } else {
      print("OneSignal external ID is not set");
    }
  }

  Future setId() async {
    var prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");
    OneSignal.shared.setExternalUserId(id!);
  }

  void getUsers() async {
    var users = await ApiService().getUsers();
    setState(() {
      userList = users["users"];
    });
  }

  void sendNotification(String id, context) async {
    var responseId = await ApiService().sendNotification(id);
    await checkExternalId();
    SnackBar snackBar = SnackBar(content: Text("Notification sent to $id"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    print(responseId["id"]);
  }

  void logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("loggedIn", false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return userList[index]["name"] == ""
                  ? null
                  : Card(
                      child: ListTile(
                        title: Text("${userList[index]["name"]}"),
                        subtitle: Text("${userList[index]["id"]}"),
                        trailing: IconButton(
                            enableFeedback: false,
                            splashColor: Colors.transparent,
                            onPressed: () {
                              sendNotification(userList[index]["id"], context);
                            },
                            icon: Icon(Icons.notifications),
                            color: Colors.blue),
                      ),
                    );
            },
            itemCount: userList.length,
          ),
        ),
        TextButton(
            onPressed: () {
              logout();
              print("Logged Out");
              Navigator.of(context).pushReplacementNamed("/login");
            },
            child: const Text("Logout"))
      ],
    ));
  }
}
