import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _newMessageController = TextEditingController();

  @override
  void dispose() {
    _newMessageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    if (_newMessageController.text.trim().isEmpty) {
      return;
    }
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    await FirebaseFirestore.instance.collection('chat').add(
      {
        'text': _newMessageController.text.trim(),
        'createdAt': Timestamp.now(),
        'userId': currentUser.uid,
        'username': userData.data()!['username'],
        'userImage': userData.data()!['imageUrl'],
      },
    );
    _newMessageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 1,
        bottom: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _newMessageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
