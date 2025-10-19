import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/chat_bubble.dart';

class ChatMassages extends StatelessWidget {
  const ChatMassages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticateUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('chat')
              .orderBy(
                'createAt',
                descending: true, //true cz used reverse in the down
              )
              .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(child: Text('No Massages Found.'));
        }
        if (chatSnapshots.hasError) {
          return const Center(child: Text('Error, Please Wait...'));
        }

        final loadingMassage = chatSnapshots.data!.docs;

        return ListView.builder(
          reverse: true,
          padding: EdgeInsets.only(bottom: 40, left: 13, right: 13),
          itemCount: loadingMassage.length,
          itemBuilder: (ctx, index) {
            final chatMassage = loadingMassage[index].data();
            final nextChatMassage =
                index + 1 < loadingMassage.length
                    ? loadingMassage[index + 1].data()
                    : null;

            final currentMassageUserId = chatMassage['userId'];
            final nextMassageUserId =
                nextChatMassage != null ? nextChatMassage['userId'] : null;
            final nextUserIdIsSame = nextMassageUserId == currentMassageUserId;
            if (nextUserIdIsSame) {
              return MessageBubble.next(
                message: chatMassage['text'],
                isMe: authenticateUser.uid == currentMassageUserId,
              );
            } else {
              return MessageBubble.first(
                username: chatMassage['username'],
                userImage: 'NouserImage',
                message: chatMassage['text'],
                isMe: authenticateUser.uid == currentMassageUserId,
              );
            }
          },
        );
      },
    );
  }
}
