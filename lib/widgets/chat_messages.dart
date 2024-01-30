import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});
  @override
  Widget build(BuildContext context) {
    final authenicatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: false,
          )
          .snapshots(),
      builder: (ctx, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text("No Messages Found"),
          );
        }
        if (snapshots.hasError) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: const Text('An error occured'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(
            left: 13,
            right: 13,
            bottom: 40,
          ),
          reverse: true,
          itemCount: snapshots.data!.docs.length,
          itemBuilder: (ctx, index) {
            final chatMessage = snapshots.data!.docs[index].data();
            final nextChatMessage = index + 1 < snapshots.data!.docs.length
                ? snapshots.data!.docs[index + 1].data()
                : null;
            final currentMessageUserID = chatMessage['userId'];
            final nextMessageUserID =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = nextMessageUserID == currentMessageUserID;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authenicatedUser.uid == currentMessageUserID,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['userImage'],
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: authenicatedUser.uid == currentMessageUserID,
              );
            }
          },
        );
      },
    );
  }
}
