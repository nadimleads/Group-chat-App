import 'package:chat_app/widgets/chat_massages.dart';
import 'package:chat_app/widgets/new_massage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    final notificationSettings = await fcm.requestPermission();
    notificationSettings.alert;

    fcm.subscribeToTopic('chat'); //for notify target device

    String? token = await fcm.getToken(); //for the address
    print(
      "🔐 Your FCM Token: $token",
    ); //you can sent it by HTTP or FireStoreSDK to a backend + add SHA signature for firebase as well
  }

  @override
  void initState() {
    super.initState();

    setupPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Fluttering', style: TextStyle(color: Colors.blueAccent)),
            Text('Up'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: Column(
        children: const [
          //
          Expanded(child: ChatMassages()),
          NewMassage(),
        ],
      ),
    );
  }
}
