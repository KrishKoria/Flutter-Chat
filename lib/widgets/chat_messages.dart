import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});
  @override
  Widget build(BuildContext context) {
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
          itemCount: snapshots.data!.docs.length,
          itemBuilder: (ctx, index) => Text(
            snapshots.data!.docs[index].data()['text'],
          ),
        );
      },
    );
  }
}
