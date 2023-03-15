import 'package:flash_chat/components/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesStream extends StatelessWidget {
  MessagesStream({Key? key, this.userEmail}) : super(key: key);

  final _store = FirebaseFirestore.instance;
  final String? userEmail;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.collection('messages').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else {
          List<MessageBubble> messageBubbles = [];
          List<QueryDocumentSnapshot<Object?>> documents = snapshot.data!.docs;
          for(QueryDocumentSnapshot document in documents) {
            final message = document['text'];
            final sender = document['sender'];
            MessageBubble messageBubble = MessageBubble(sender: sender, message: message, isMe: sender == userEmail,);
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageBubbles,
            ),
          );
        }
    },
    );
  }
}
